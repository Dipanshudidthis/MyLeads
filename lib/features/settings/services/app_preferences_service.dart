import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How duplicate leads should be handled by default during import.
enum DuplicatePolicy { askEachTime, skipDuplicates, importAnyway }

/// Thin wrapper around [SharedPreferences] for lightweight app settings.
class AppPreferencesService {
  AppPreferencesService(this._prefs);

  static const _keyThemeMode = 'theme_mode';
  static const _keyCountryCode = 'default_country_code';
  static const _keyDuplicatePolicy = 'duplicate_policy';

  final SharedPreferences _prefs;

  static Future<AppPreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferencesService(prefs);
  }

  ThemeMode getThemeMode() {
    final value = _prefs.getString(_keyThemeMode);
    return ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_keyThemeMode, mode.name);

  /// Default country calling code without a leading '+', e.g. "91".
  String? getDefaultCountryCode() => _prefs.getString(_keyCountryCode);

  Future<void> setDefaultCountryCode(String? code) async {
    if (code == null || code.isEmpty) {
      await _prefs.remove(_keyCountryCode);
    } else {
      await _prefs.setString(_keyCountryCode, code);
    }
  }

  DuplicatePolicy getDuplicatePolicy() {
    final value = _prefs.getString(_keyDuplicatePolicy);
    return DuplicatePolicy.values.firstWhere(
      (p) => p.name == value,
      orElse: () => DuplicatePolicy.askEachTime,
    );
  }

  Future<void> setDuplicatePolicy(DuplicatePolicy policy) =>
      _prefs.setString(_keyDuplicatePolicy, policy.name);
}
