/// Central configuration constants for the Pandit App.
/// Replace placeholder values with your actual keys before deploying.
class AppConfig {
  AppConfig._();

  // ── Razorpay ──────────────────────────────────────────────────────────────
  /// Your Razorpay Key ID from the Razorpay Dashboard.
  /// Use the test key (rzp_test_...) for development.
  static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY_ID';

  // ── Agora ─────────────────────────────────────────────────────────────────
  /// Your Agora App ID from https://console.agora.io
  static const String agoraAppId = 'YOUR_AGORA_APP_ID';

  /// Token server URL (optional — set to '' to use Agora without tokens
  /// for testing; always use tokens in production).
  static const String agoraTokenServerUrl = '';

  // ── App ───────────────────────────────────────────────────────────────────
  static const String appName = 'Pandit App';
  static const String supportEmail = 'support@panditapp.com';
}
