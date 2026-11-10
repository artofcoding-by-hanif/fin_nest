import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The user's AI privacy choices, stored on the device
class AiPreferences {
  const AiPreferences({
    this.loaded = false,
    this.consentGiven = false,
    this.enabled = true,
    this.shareDescriptions = true,
  });

  /// False until read from storage (avoids flashing the consent sheet)
  final bool loaded;

  /// The user accepted the "what we send" explanation
  final bool consentGiven;

  /// Master switch; when off no data is sent and AI entry points hide
  final bool enabled;

  /// Include recent transaction descriptions; when off only totals are sent
  final bool shareDescriptions;

  /// AI may be used right now without asking first
  bool get ready => loaded && consentGiven && enabled;

  AiPreferences copyWith({
    bool? loaded,
    bool? consentGiven,
    bool? enabled,
    bool? shareDescriptions,
  }) => AiPreferences(
    loaded: loaded ?? this.loaded,
    consentGiven: consentGiven ?? this.consentGiven,
    enabled: enabled ?? this.enabled,
    shareDescriptions: shareDescriptions ?? this.shareDescriptions,
  );
}

class AiPreferencesNotifier extends Notifier<AiPreferences> {
  static const _consentKey = 'ai_consent_given';
  static const _enabledKey = 'ai_enabled';
  static const _descriptionsKey = 'ai_share_descriptions';

  @override
  AiPreferences build() {
    _load();
    return const AiPreferences();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AiPreferences(
      loaded: true,
      consentGiven: prefs.getBool(_consentKey) ?? false,
      enabled: prefs.getBool(_enabledKey) ?? true,
      shareDescriptions: prefs.getBool(_descriptionsKey) ?? true,
    );
  }

  Future<void> giveConsent({required bool shareDescriptions}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
    await prefs.setBool(_enabledKey, true);
    await prefs.setBool(_descriptionsKey, shareDescriptions);
    state = state.copyWith(
      consentGiven: true,
      enabled: true,
      shareDescriptions: shareDescriptions,
    );
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
    state = state.copyWith(enabled: value);
  }

  Future<void> setShareDescriptions(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_descriptionsKey, value);
    state = state.copyWith(shareDescriptions: value);
  }
}

final aiPreferencesProvider =
    NotifierProvider<AiPreferencesNotifier, AiPreferences>(
      AiPreferencesNotifier.new,
    );
