import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../subscription/data/subscription_service.dart';

/// Why an AI call failed, so the UI can react (e.g. open the paywall)
enum AiFailure { unavailable, quota, premiumRequired, invalid, notVerified, network }

/// User-facing AI failure; [message] is safe to show as-is
class AiException implements Exception {
  const AiException(this.message, {this.reason = AiFailure.unavailable});

  final String message;
  final AiFailure reason;

  /// The user hit a limit that Premium raises or unlocks
  bool get wantsUpgrade =>
      reason == AiFailure.quota || reason == AiFailure.premiumRequired;

  @override
  String toString() => message;
}

/// One message in a chat history
class AiChatTurn {
  const AiChatTurn({required this.fromUser, required this.text});

  final bool fromUser;
  final String text;

  Map<String, Object?> toJson() => {'role': fromUser ? 'user' : 'model', 'text': text};
}

/// Result of a quota-counted call: the payload plus the remaining allowance
class AiResult<T> {
  const AiResult(this.value, {required this.remaining, required this.premium});

  final T value;

  /// Requests left in the current period for this feature
  final int remaining;
  final bool premium;
}

/// Talks to FinNest's AI Cloud Functions (asia-south1).
///
/// The Gemini key lives only on the server. The app signs in anonymously,
/// App Check proves it's a genuine build, and each request carries the
/// (already redacted) finance context built on the device.
class AiService {
  AiService._();

  static final AiService instance = AiService._();

  static const _region = 'asia-south1';
  static const _timeout = Duration(seconds: 130);

  bool get isAvailable => FirebaseBootstrap.isReady;

  FirebaseFunctions get _functions =>
      FirebaseFunctions.instanceFor(region: _region);

  Future<AiResult<String>> chat({
    required List<AiChatTurn> history,
    Map<String, Object?>? financeContext,
  }) async {
    final data = await _call('aiChat', {
      'financeContext': financeContext,
      'messages': history.map((m) => m.toJson()).toList(),
    });
    final reply = data['reply'];
    if (reply is! String || reply.isEmpty) {
      throw const AiException('The assistant sent an empty reply.');
    }
    return _result(data, reply);
  }

  /// Personalised suggestions; each map follows the server's INSIGHTS_SCHEMA
  Future<AiResult<List<Map<String, Object?>>>> insights(
    Map<String, Object?> financeContext,
  ) async {
    final data = await _call('aiInsights', {'financeContext': financeContext});
    final list = data['suggestions'];
    if (list is! List) {
      throw const AiException('The assistant sent unreadable suggestions.');
    }
    return _result(
      data,
      list.map((e) => Map<String, Object?>.from(e as Map)).toList(),
    );
  }

  /// Review of [month] ("YYYY-MM"); follows the server's REPORT_SCHEMA
  Future<AiResult<Map<String, Object?>>> monthlyReport({
    required Map<String, Object?> financeContext,
    required String month,
  }) async {
    final data = await _call('aiMonthlyReport', {
      'financeContext': financeContext,
      'month': month,
    });
    final report = data['report'];
    if (report is! Map) {
      throw const AiException('The assistant sent an unreadable report.');
    }
    return _result(data, Map<String, Object?>.from(report));
  }

  /// Best category name from [categories] for [description], or null
  Future<AiResult<String?>> categorize({
    required String description,
    required bool isIncome,
    required List<String> categories,
  }) async {
    final data = await _call('aiCategorize', {
      'description': description,
      'type': isIncome ? 'income' : 'expense',
      'categories': categories,
    });
    final category = data['category'];
    return _result(data, category is String ? category : null);
  }

  /// Flags AI output as harmful, offensive or wrong (Play AI-content policy).
  /// [kind]: chat, suggestion or report. [reason]: harmful, offensive,
  /// inaccurate or other.
  Future<void> report({
    required String kind,
    required String reason,
    required String content,
    String? note,
  }) async {
    await _call('reportAiContent', {
      'kind': kind,
      'reason': reason,
      'content': content,
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    });
  }

  AiResult<T> _result<T>(Map<String, dynamic> data, T value) => AiResult(
    value,
    remaining: (data['remaining'] as num?)?.toInt() ?? 0,
    premium: data['premium'] == true,
  );

  Future<Map<String, dynamic>> _call(
    String name,
    Map<String, Object?> payload,
  ) async {
    if (!isAvailable) {
      throw const AiException(
        'AI features are not set up in this build yet.',
        reason: AiFailure.unavailable,
      );
    }

    try {
      await FirebaseIdentity.ensureSignedIn();
      // The server checks Premium by this uid, so purchases must be linked to it
      await SubscriptionService.instance.identify().catchError((_) {});
      final result = await _functions
          .httpsCallable(name, options: HttpsCallableOptions(timeout: _timeout))
          .call(payload);
      // Platform channels deliver Map<Object?, Object?>
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      debugPrint('AI call $name failed: ${e.code} ${e.message}');
      throw _mapFunctionsError(e);
    } on FirebaseAuthException catch (e) {
      debugPrint('AI sign-in failed: ${e.code} ${e.message}');
      throw const AiException(
        'Could not connect to the assistant. Check your internet connection.',
        reason: AiFailure.network,
      );
    }
  }

  AiException _mapFunctionsError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'resource-exhausted':
        return AiException(
          e.message ?? 'AI limit reached.',
          reason: AiFailure.quota,
        );
      case 'failed-precondition':
        return AiException(
          e.message ?? 'This is a Premium feature.',
          reason: AiFailure.premiumRequired,
        );
      case 'invalid-argument':
        return AiException(
          e.message ?? 'The request was not valid.',
          reason: AiFailure.invalid,
        );
      case 'unauthenticated':
      case 'permission-denied':
        return const AiException(
          'This app build is not verified for AI features yet.',
          reason: AiFailure.notVerified,
        );
      case 'not-found':
      case 'unimplemented':
        return const AiException(
          "This feature isn't available right now. Please update the app or try again later.",
        );
      case 'deadline-exceeded':
        return const AiException(
          'The assistant took too long to answer. Please try again.',
        );
      case 'unavailable':
        return AiException(
          e.message ?? 'The assistant is unavailable right now.',
          reason: AiFailure.network,
        );
      default:
        return AiException(e.message ?? 'Something went wrong. Please try again.');
    }
  }
}
