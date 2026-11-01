import 'package:url_launcher/url_launcher.dart';

/// Result of attempting to launch an external action.
enum LaunchResult { success, notAvailable, failed }

/// Launches the system phone dialer and WhatsApp conversations.
///
/// Never places calls or sends messages automatically - the user must
/// confirm the action in the destination app.
class ExternalActionLauncher {
  ExternalActionLauncher._();

  static Future<LaunchResult> callNumber(String normalizedPhone) async {
    final uri = Uri(scheme: 'tel', path: normalizedPhone);
    try {
      final launched = await launchUrl(uri);
      return launched ? LaunchResult.success : LaunchResult.notAvailable;
    } catch (_) {
      return LaunchResult.failed;
    }
  }

  /// Opens a WhatsApp conversation for [normalizedPhone]. The number must
  /// already include a country code; digits only (no '+') are used in the
  /// wa.me URL per WhatsApp's documented format.
  static Future<LaunchResult> openWhatsApp(
    String normalizedPhone, {
    String? prefilledMessage,
  }) async {
    final digitsOnly = normalizedPhone.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return LaunchResult.failed;

    final query = prefilledMessage != null && prefilledMessage.isNotEmpty
        ? '?text=${Uri.encodeComponent(prefilledMessage)}'
        : '';
    final uri = Uri.parse('https://wa.me/$digitsOnly$query');

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return launched ? LaunchResult.success : LaunchResult.notAvailable;
    } catch (_) {
      return LaunchResult.failed;
    }
  }
}
