/// Authentication UI Constants
/// 
/// This file contains all hardcoded values from auth pages extracted to maintain
/// consistency and make changes easier to manage across all authentication flows.
class AuthConstants {
  AuthConstants._();

  // ==================== ANIMATION CONSTANTS ====================
  
  /// Password reveal animation duration
  static const int passwordRevealAnimationMs = 600;
  
  /// Button pulse animation duration
  static const int buttonPulseAnimationMs = 1200;
  
  /// Success animation duration
  static const int successAnimationMs = 800;
  
  /// Quick feedback animation duration
  static const int quickFeedbackAnimationMs = 200;
  
  /// Standard transition animation duration
  static const int standardTransitionAnimationMs = 400;
  
  /// API delay for database consistency
  static const int apiDelayMs = 500;

  // ==================== ANIMATION VALUES ====================
  
  /// Fade animation begin value
  static const double fadeBegin = 0.0;
  
  /// Fade animation end value
  static const double fadeEnd = 1.0;
  
  /// Button pulse begin scale
  static const double pulseScaleBegin = 1.0;
  
  /// Button pulse end scale
  static const double pulseScaleEnd = 1.02;
  
  /// Success animation begin scale
  static const double successScaleBegin = 0.0;
  
  /// Success animation end scale
  static const double successScaleEnd = 1.0;
  
  /// Slide animation vertical offset
  static const double slideOffset = 0.3;

  // ==================== ICON SIZE CONSTANTS ====================
  
  /// Tiny icon size for indicators
  static const double iconSizeTiny = 12.0;
  
  /// Small icon size for validation checkmarks
  static const double iconSizeSmall = 14.0;
  
  /// Standard icon size for UI elements
  static const double iconSizeStandard = 16.0;
  
  /// Medium icon size for buttons
  static const double iconSizeMedium = 18.0;
  
  /// Large icon size for important actions
  static const double iconSizeLarge = 20.0;
  
  /// Extra large icon size for primary actions
  static const double iconSizeXL = 24.0;
  
  /// Hero icon size for main features
  static const double iconSizeHero = 28.0;
  
  /// Massive icon size for illustrations
  static const double iconSizeMassive = 32.0;
  
  /// Display icon size for welcome screens
  static const double iconSizeDisplay = 40.0;
  
  /// Giant icon size for main illustrations
  static const double iconSizeGiant = 48.0;
  
  /// Success icon size for completion states
  static const double iconSizeSuccess = 60.0;

  // ==================== CONTAINER SIZE CONSTANTS ====================
  
  /// Small circular container size
  static const double containerSizeSmall = 40.0;
  
  /// Standard circular container size
  static const double containerSizeStandard = 56.0;
  
  /// Medium circular container size
  static const double containerSizeMedium = 80.0;
  
  /// Large circular container size
  static const double containerSizeLarge = 100.0;
  
  /// Extra large circular container size
  static const double containerSizeXL = 120.0;

  // ==================== BORDER RADIUS CONSTANTS ====================
  
  /// Tiny border radius for small elements
  static const double borderRadiusTiny = 4.0;
  
  /// Small border radius for compact elements
  static const double borderRadiusSmall = 8.0;
  
  /// Standard border radius for most elements
  static const double borderRadiusStandard = 12.0;
  
  /// Large border radius for cards
  static const double borderRadiusLarge = 16.0;
  
  /// Extra large border radius for major containers
  static const double borderRadiusXL = 20.0;
  
  /// Modal border radius for sheets
  static const double borderRadiusModal = 24.0;

  // ==================== TEXT SIZE CONSTANTS ====================
  
  /// Tiny text size for micro labels
  static const double textSizeTiny = 10.0;
  
  /// Mini text size for small indicators
  static const double textSizeMini = 11.0;
  
  /// Body large text size for important content
  static const double textSizeBodyLarge = 16.0;

  // ==================== VALIDATION CONSTRAINTS ====================
  
  /// Minimum length for first and last names
  static const int nameMinLength = 2;
  
  /// Minimum password length
  static const int passwordMinLength = 6;
  
  /// Strong password minimum length
  static const int strongPasswordLength = 8;
  
  /// Business code minimum length
  static const int businessCodeMinLength = 6;
  
  /// Business code maximum length  
  static const int businessCodeMaxLength = 12;

  // ==================== SPACING CONSTANTS ====================
  
  /// Micro spacing for tight layouts
  static const double spacingMicro = 4.0;
  
  /// Tiny spacing for compact elements
  static const double spacingTiny = 8.0;
  
  /// Standard spacing for general use
  static const double spacingStandard = 12.0;
  
  /// Large spacing for separation
  static const double spacingLarge = 20.0;
  
  /// Content padding for main containers
  static const double contentPadding = 24.0;
  
  /// Section spacing for major divisions
  static const double sectionSpacing = 40.0;
  
  /// Hero section spacing
  static const double heroSpacing = 60.0;

  // ==================== OPACITY CONSTANTS ====================
  
  /// Light overlay opacity
  static const double overlayOpacityLight = 0.05;
  
  /// Medium overlay opacity
  static const double overlayOpacityMedium = 0.08;
  
  /// Standard overlay opacity
  static const double overlayOpacityStandard = 0.1;
  
  /// Strong overlay opacity
  static const double overlayOpacityStrong = 0.2;
  
  /// Emphasis overlay opacity
  static const double overlayOpacityEmphasis = 0.3;

  // ==================== BORDER WIDTH CONSTANTS ====================
  
  /// Thin border width
  static const double borderWidthThin = 0.5;
  
  /// Standard border width
  static const double borderWidthStandard = 1.0;

  // ==================== LINE HEIGHT CONSTANTS ====================
  
  /// Standard line height for auth content
  static const double lineHeightStandard = 1.4;
  
  /// Relaxed line height for descriptions
  static const double lineHeightRelaxed = 1.5;

  // ==================== GESTURE ANIMATION CONSTANTS ====================
  
  /// Tap scale down value
  static const double tapScaleDown = 0.95;
  
  /// Long press scale down value
  static const double longPressScaleDown = 0.9;

  // ==================== SUCCESS STATE CONSTANTS ====================
  
  /// Password strength levels
  static const int passwordStrengthWeak = 1;
  static const int passwordStrengthFair = 2;
  static const int passwordStrengthGood = 3;
  static const int passwordStrengthStrong = 4;
  static const int passwordStrengthVeryStrong = 5;
  
  /// Password strength total possible score
  static const int passwordStrengthMaxScore = 5;

  // ==================== TRUST INDICATOR CONSTANTS ====================
  
  /// Trust badge horizontal padding
  static const double trustBadgePaddingHorizontal = 12.0;
  
  /// Trust badge vertical padding
  static const double trustBadgePaddingVertical = 8.0;
  
  /// Trust badge border radius
  static const double trustBadgeBorderRadius = 20.0;

  // ==================== FORM FIELD CONSTANTS ====================
  
  /// Standard input field height
  static const double inputFieldHeight = 48.0;
  
  /// Input field border radius
  static const double inputFieldBorderRadius = 12.0;
  
  /// Input field internal padding
  static const double inputFieldPadding = 16.0;

  // ==================== MODAL CONSTANTS ====================
  
  /// Modal height ratio for bottom sheets
  static const double modalHeightRatio = 0.85;
  
  /// Modal drag handle width
  static const double modalDragHandleWidth = 40.0;
  
  /// Modal drag handle height
  static const double modalDragHandleHeight = 4.0;

  // ==================== ERROR MESSAGES ====================
  
  /// Name validation error message
  static const String errorNameRequired = 'Required';
  
  /// Email validation error message
  static const String errorEmailRequired = 'Please enter your email';
  
  /// Email format error message
  static const String errorEmailInvalid = 'Please enter a valid email address';
  
  /// Password validation error message
  static const String errorPasswordRequired = 'Please enter a password';
  
  /// Password length error message
  static const String errorPasswordMinLength = 'Password must be at least 6 characters';
  
  /// Password match error message
  static const String errorPasswordMismatch = 'Passwords do not match';
  
  /// Business code validation error message
  static const String errorBusinessCodeRequired = 'Please enter the business code';
  
  /// Business code length error message
  static const String errorBusinessCodeLength = 'Code must be between 6-12 characters';

  // ==================== SUCCESS MESSAGES ====================
  
  /// Account created success message
  static const String successAccountCreated = 'Account created successfully!';
  
  /// Welcome back message
  static const String successWelcomeBack = 'Welcome back to Storebase!';
  
  /// Business created success message
  static const String successBusinessCreated = 'Business Created!';
  
  /// Store created success message
  static const String successStoreCreated = 'Store Created Successfully!';
  
  /// Business joined success message
  static const String successBusinessJoined = 'Successfully Joined!';

  // ==================== BUTTON TEXT CONSTANTS ====================
  
  /// Create account button text
  static const String buttonCreateAccount = 'Create account';
  
  /// Sign in button text
  static const String buttonSignIn = 'Sign in securely';
  
  /// Join business button text
  static const String buttonJoinBusiness = 'Join Business';
  
  /// Create business button text
  static const String buttonCreateBusiness = 'Create Business';
  
  /// Create store button text
  static const String buttonCreateStore = 'Create Store';
  
  /// Go to dashboard button text
  static const String buttonGoToDashboard = 'Go to Dashboard';
  
  /// Create another store button text
  static const String buttonCreateAnotherStore = 'Create Another Store';
  
  /// Skip for now button text
  static const String buttonSkipForNow = 'Skip for now';

  // ==================== LOADING TEXT CONSTANTS ====================
  
  /// Creating account loading text
  static const String loadingCreatingAccount = 'Creating account...';
  
  /// Signing in loading text
  static const String loadingSigningIn = 'Signing in...';
  
  /// Verifying code loading text
  static const String loadingVerifyingCode = 'Verifying code...';
  
  /// Creating business loading text
  static const String loadingCreatingBusiness = 'Creating business...';
  
  /// Creating store loading text
  static const String loadingCreatingStore = 'Creating store...';

  // ==================== PLACEHOLDER TEXT CONSTANTS ====================
  
  /// Email placeholder
  static const String placeholderEmail = 'your@company.com';
  
  /// Business email placeholder
  static const String placeholderBusinessEmail = 'business@example.com';
  
  /// Password placeholder
  static const String placeholderPassword = 'Enter your secure password';
  
  /// Confirm password placeholder
  static const String placeholderConfirmPassword = 'Re-enter your password';
  
  /// First name placeholder
  static const String placeholderFirstName = 'John';
  
  /// Last name placeholder
  static const String placeholderLastName = 'Smith';
  
  /// Business code placeholder
  static const String placeholderBusinessCode = 'Enter business code';
  
  /// Store name placeholder
  static const String placeholderStoreName = 'e.g., Main Store, Downtown Branch';
  
  /// Store address placeholder
  static const String placeholderStoreAddress = '123 Main Street, City, State, ZIP';
  
  /// Store phone placeholder
  static const String placeholderStorePhone = '+1 (555) 123-4567';

  // ==================== LABEL TEXT CONSTANTS ====================
  
  /// Business email label
  static const String labelBusinessEmail = 'Business Email';
  
  /// Password label
  static const String labelPassword = 'Password';
  
  /// Confirm password label
  static const String labelConfirmPassword = 'Confirm Password';
  
  /// First name label
  static const String labelFirstName = 'First Name';
  
  /// Last name label
  static const String labelLastName = 'Last Name';
  
  /// Name label
  static const String labelName = 'Name';
  
  /// Business code label
  static const String labelBusinessCode = 'Business Code';
  
  /// Store name label
  static const String labelStoreName = 'Store Name';
  
  /// Store address label
  static const String labelStoreAddress = 'Store Address';
  
  /// Store phone label
  static const String labelStorePhone = 'Store Phone';
  
  /// Optional label
  static const String labelOptional = 'Optional';

  // ==================== HELPER TEXT CONSTANTS ====================
  
  /// Store name helper text
  static const String helperStoreName = 'This will be displayed to your employees';
  
  /// Store address helper text
  static const String helperStoreAddress = 'Used for location-based features';
  
  /// Store phone helper text
  static const String helperStorePhone = 'Contact number for this location';
  
  /// Business code helper text
  static const String helperBusinessCode = 'Ask your employer or manager for the business code to join your company';
  
  /// Secure login helper text
  static const String helperSecureLogin = 'Secure Login';
}