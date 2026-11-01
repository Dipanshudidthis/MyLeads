import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_preferences_service.dart';

/// Must be overridden in main() after [AppPreferencesService.create] resolves.
final appPreferencesServiceProvider = Provider<AppPreferencesService>((ref) {
  throw UnimplementedError('appPreferencesServiceProvider must be overridden');
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ref.read(appPreferencesServiceProvider).getThemeMode();
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref.read(appPreferencesServiceProvider).setThemeMode(mode);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class DefaultCountryCodeNotifier extends Notifier<String?> {
  @override
  String? build() {
    return ref.read(appPreferencesServiceProvider).getDefaultCountryCode();
  }

  Future<void> setCode(String? code) async {
    state = code;
    await ref.read(appPreferencesServiceProvider).setDefaultCountryCode(code);
  }
}

final defaultCountryCodeProvider =
    NotifierProvider<DefaultCountryCodeNotifier, String?>(
  DefaultCountryCodeNotifier.new,
);

class DuplicatePolicyNotifier extends Notifier<DuplicatePolicy> {
  @override
  DuplicatePolicy build() {
    return ref.read(appPreferencesServiceProvider).getDuplicatePolicy();
  }

  Future<void> setPolicy(DuplicatePolicy policy) async {
    state = policy;
    await ref.read(appPreferencesServiceProvider).setDuplicatePolicy(policy);
  }
}

final duplicatePolicyProvider =
    NotifierProvider<DuplicatePolicyNotifier, DuplicatePolicy>(
  DuplicatePolicyNotifier.new,
);
