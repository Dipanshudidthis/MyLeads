import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks whether the user has seen the data protection notice on first launch.
/// This ensures users are aware their data survives uninstall/reinstall only if
/// they have Android Auto Backup enabled or manually export their data.
final firstLaunchProvider = StateNotifierProvider<FirstLaunchNotifier, bool>((ref) {
  return FirstLaunchNotifier();
});

class FirstLaunchNotifier extends StateNotifier<bool> {
  FirstLaunchNotifier() : super(false) {
    _init();
  }

  static const _key = 'has_seen_data_protection_notice';

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool(_key) ?? true;
    } catch (_) {
      state = true;
    }
  }

  Future<void> markAsSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, true);
      state = true;
    } catch (_) {}
  }
}
