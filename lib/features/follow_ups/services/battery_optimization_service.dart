import 'package:flutter/services.dart';

/// Checks and requests exemption from Android's battery optimization, which
/// can otherwise silently kill scheduled alarms before they fire.
class BatteryOptimizationService {
  BatteryOptimizationService._();

  static const _channel = MethodChannel('leads_import/battery');

  static Future<bool> isIgnoringBatteryOptimizations() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      return result ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Opens the system dialog asking the user to exempt this app from
  /// battery optimization. No-op if already exempted.
  static Future<void> requestIgnoreBatteryOptimizations() async {
    try {
      await _channel.invokeMethod('requestIgnoreBatteryOptimizations');
    } catch (_) {
      // Ignore - not all OEMs support this intent.
    }
  }
}
