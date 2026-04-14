/// Application-wide constants for SquadBizz.
///
/// Never hardcode magic numbers or durations in UI code — reference them here.
class AppConstants {
  AppConstants._();

  // ── API & Backend ──
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;

  // ── Pagination ──
  static const int pageSize = 20;
  static const int initialPage = 0;

  // ── Auth ──
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;

  // ── Room ──
  static const int maxRoomNameLength = 40;
  static const int maxRoomDescLength = 120;
  static const int roomCodeLength = 6;

  // ── UI ──
  static const double borderRadius = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 20.0;
  static const double borderRadiusPill = 100.0;

  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 36.0;

  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double avatarSize = 36.0;

  // ── Animations ──
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration snackDuration = Duration(seconds: 3);

  // ── Spacing ──
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ── Screen padding ──
  static const double screenPaddingH = 24.0;
  static const double screenPaddingV = 16.0;
}
