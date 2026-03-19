/// All user-facing strings for SquadBizz.
/// Centralised here so nothing is hardcoded in UI code.
class AppStrings {
  AppStrings._();

  // ── App ──
  static const String appName = 'SquadBizz';
  static const String appTagline = 'Your squad, one place.';
  static const String appVersion = 'SquadBizz v1.0.0';

  // ── Splash ──
  static const String splashLoading = 'Loading...';

  // ── Onboarding ──
  static const String onboardingTitle1 = 'Create Your Squad';
  static const String onboardingSubtitle1 =
      'Make rooms for your friend groups, trips, flatmates, or any crew.';

  static const String onboardingTitle2 = 'Decide Together';
  static const String onboardingSubtitle2 =
      'Create polls and let everyone vote on what matters.';

  static const String onboardingTitle3 = 'Split Without Drama';
  static const String onboardingSubtitle3 =
      'Track shared expenses and settle up easily inside your room.';

  static const String next = 'Next';
  static const String skip = 'Skip';
  static const String getStarted = 'Get Started';

  // ── Registration ──
  static const String createAccount = 'Create Account';
  static const String fullName = 'Full Name';
  static const String fullNameHint = 'Enter your full name';
  static const String email = 'Email';
  static const String emailHint = 'Enter your email address';
  static const String password = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String confirmPassword = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String phoneNumber = 'Phone Number';
  static const String sendOtp = 'Send OTP';
  static const String orDivider = 'OR';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String registerWithEmail = 'Register with Email';
  static const String registerWithPhone = 'Register with Phone';

  // ── Login ──
  static const String login = 'Login';
  static const String loginSubtitle = 'Welcome back to SquadBizz!';
  static const String loginWithEmail = 'Login with Email';
  static const String loginWithPhone = 'Login with Phone';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String register = 'Register';
  static const String incorrectCredentials = 'Incorrect email or password.';
  static const String userNotFound = 'No account found. Please register first.';

  // ── Forgot Password ──
  static const String resetPassword = 'Reset Password';
  static const String resetPasswordSubtitle =
      'Enter your email and we\'ll send you a link to reset your password.';
  static const String sendResetLink = 'Send Reset Link';
  static const String resetLinkSent =
      'Password reset link sent! Check your email.';

  // ── OTP ──
  static const String otpVerification = 'OTP Verification';
  static const String otpSubtitle = 'Enter the 6-digit code sent to';
  static const String verifyOtp = 'Verify OTP';
  static const String resendOtp = 'Resend OTP';
  static const String didntReceiveCode = "Didn't receive the code? ";
  static const String resendIn = 'Resend in';

  // ── Dashboard ──
  static const String rooms = 'Rooms';
  static const String activity = 'Activity';
  static const String balances = 'Balances';
  static const String profile = 'Profile';

  // ── Rooms Tab ──
  static const String createRoom = 'Create Room';
  static const String joinRoom = 'Join Room';
  static const String yourRooms = 'Your Rooms';
  static const String noRoomsYet = 'No rooms yet. Create or join one!';
  static const String members = 'members';
  static const String activePolls = 'active polls';
  static const String pending = 'pending';

  // ── Activity Tab ──
  static const String noActivityYet = 'No recent activity yet.';

  // ── Balances Tab ──
  static const String myBalances = 'My Balances';
  static const String youAreOwed = 'You are owed';
  static const String youOwe = 'You owe';
  static const String netBalance = 'Net Balance';
  static const String settleUp = 'Settle Up';
  static const String noBalancesYet = 'No balances to show.';

  // ── Profile Tab ──
  static const String editProfile = 'Edit Profile';
  static const String notifications = 'Notifications';
  static const String inviteAFriend = 'Invite a Friend';
  static const String aboutSquadBizz = 'About SquadBizz';
  static const String logout = 'Logout';
  static const String logoutConfirm = 'Are you sure you want to log out?';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';

  // ── Profile Setup ──
  static const String setupProfile = 'Set Up Your Profile';
  static const String setupProfileSubtitle =
      'Tell us your name to get started.';
  static const String continueText = 'Continue';

  // ── Validation ──
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String invalidPhone = 'Please enter a valid phone number';

  // ── Errors ──
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Please check your internet connection.';
  static const String emailAlreadyInUse = 'This email is already registered.';
  static const String invalidOtp = 'Invalid OTP. Please try again.';
  static const String otpExpired = 'OTP has expired. Please request a new one.';

  // ── Success ──
  static const String accountCreated = 'Account created successfully!';
  static const String otpSent = 'OTP sent successfully!';
  static const String otpVerified = 'Phone verified successfully!';
}
