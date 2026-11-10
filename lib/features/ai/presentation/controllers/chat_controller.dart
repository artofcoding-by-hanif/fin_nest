import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/database/app_database.dart';
import '../../data/ai_preferences.dart';
import '../../data/ai_service.dart';
import '../../data/finance_context_loader.dart';

class ChatState {
  const ChatState({
    this.conversationId,
    this.sending = false,
    this.remaining,
    this.premium = false,
    this.lastError,
  });

  /// Null for a new, unsaved chat
  final int? conversationId;
  final bool sending;

  /// Messages left in the current period, once the server has told us
  final int? remaining;
  final bool premium;
  final AiException? lastError;

  ChatState copyWith({
    int? conversationId,
    bool? sending,
    int? remaining,
    bool? premium,
    AiException? lastError,
    bool clearError = false,
    bool clearConversation = false,
  }) => ChatState(
    conversationId: clearConversation ? null : conversationId ?? this.conversationId,
    sending: sending ?? this.sending,
    remaining: remaining ?? this.remaining,
    premium: premium ?? this.premium,
    lastError: clearError ? null : lastError ?? this.lastError,
  );
}

/// Drives one chat: saves messages locally, builds the finance summary,
/// calls the AI, and records replies or errors.
class ChatController extends AutoDisposeNotifier<ChatState> {
  AppDatabase get _db => GetIt.instance<AppDatabase>();

  /// Chat history sent with each request (oldest dropped first)
  static const historyLimit = 20;

  @override
  ChatState build() => const ChatState();

  void open(int conversationId) =>
      state = ChatState(conversationId: conversationId, remaining: state.remaining, premium: state.premium);

  void newChat() => state = state.copyWith(clearConversation: true, clearError: true);

  Future<void> send(String text) async {
    final question = text.trim();
    if (question.isEmpty || state.sending) return;

    var id = state.conversationId;
    id ??= await _db.aiChatDao.createConversation(question);
    state = state.copyWith(conversationId: id, sending: true, clearError: true);
    await _db.aiChatDao.addMessage(conversationId: id, fromUser: true, body: question);
    await _ask(id);
  }

  /// Retries after an error: drops the error message and asks again
  Future<void> retry(int errorMessageId) async {
    final id = state.conversationId;
    if (id == null || state.sending) return;
    await _db.aiChatDao.deleteMessage(errorMessageId);
    state = state.copyWith(sending: true, clearError: true);
    await _ask(id);
  }

  Future<void> _ask(int conversationId) async {
    try {
      final prefs = ref.read(aiPreferencesProvider);
      final context = await ref
          .read(financeContextLoaderProvider)
          .load(shareDescriptions: prefs.shareDescriptions);

      final saved = await _db.aiChatDao.getMessages(conversationId);
      final history = saved
          .where((m) => !m.isError)
          .map((m) => AiChatTurn(fromUser: m.fromUser, text: m.body))
          .toList();
      final trimmed = history.length > historyLimit
          ? history.sublist(history.length - historyLimit)
          : history;

      final result = await AiService.instance.chat(
        history: trimmed,
        financeContext: context,
      );
      await _db.aiChatDao.addMessage(
        conversationId: conversationId,
        fromUser: false,
        body: result.value,
      );
      state = state.copyWith(
        sending: false,
        remaining: result.remaining,
        premium: result.premium,
      );
    } on AiException catch (e) {
      await _db.aiChatDao.addMessage(
        conversationId: conversationId,
        fromUser: false,
        body: e.message,
        isError: true,
      );
      state = state.copyWith(
        sending: false,
        lastError: e,
        remaining: e.reason == AiFailure.quota ? 0 : null,
      );
    } catch (e) {
      const error = AiException('Something went wrong. Please try again.');
      await _db.aiChatDao.addMessage(
        conversationId: conversationId,
        fromUser: false,
        body: error.message,
        isError: true,
      );
      state = state.copyWith(sending: false, lastError: error);
    }
  }
}

final chatControllerProvider =
    NotifierProvider.autoDispose<ChatController, ChatState>(ChatController.new);

final chatMessagesProvider =
    StreamProvider.autoDispose.family<List<AiMessageEntity>, int>(
      (ref, id) => GetIt.instance<AppDatabase>().aiChatDao.watchMessages(id),
    );

final chatConversationsProvider =
    StreamProvider.autoDispose<List<AiConversationEntity>>(
      (ref) => GetIt.instance<AppDatabase>().aiChatDao.watchConversations(),
    );
