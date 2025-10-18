/// UI Constants for MyFinance App
/// 
/// This file contains all hardcoded UI values extracted from homepage components
/// to maintain consistency and make changes easier to manage.
class UIConstants {
  UIConstants._();

  // ==================== APP BAR CONSTANTS ====================
  /// Standard app bar height following Material Design guidelines
  static const double appBarHeight = 56.0;
  
  /// Icon button splash radius for consistent touch feedback
  static const double iconButtonSplashRadius = 24.0;
  
  /// Standard app bar icon size
  static const double appBarIconSize = 24.0;
  
  /// Notification icon size
  static const double notificationIconSize = 26.0;

  // ==================== AVATAR & PROFILE CONSTANTS ====================
  /// Profile avatar radius in app bar
  static const double profileAvatarRadius = 18.0;
  
  /// Profile avatar size in app bar (diameter)
  static const double profileAvatarSize = 36.0;
  
  /// Small profile icon size for placeholders
  static const double profileIconSize = 20.0;
  
  /// Standard avatar sizes for consistent profile display
  static const double avatarSizeSmall = 40.0;
  static const double avatarSizeMedium = 60.0;
  static const double avatarSizeLarge = 80.0;
  static const double avatarSizeXLarge = 100.0;
  
  /// Profile image edit icon size
  static const double profileEditIconSize = 32.0;
  static const double profileEditIconInnerSize = 16.0;

  // ==================== CARD & CONTAINER CONSTANTS ====================
  /// Small border radius for compact elements
  static const double borderRadiusSmall = 8.0;
  
  /// Medium border radius for cards and buttons
  static const double borderRadiusMedium = 12.0;
  
  /// Large border radius for main containers
  static const double borderRadiusLarge = 16.0;
  
  /// Extra large border radius for modal sheets
  static const double borderRadiusXLarge = 20.0;
  
  /// Modal bottom sheet border radius
  static const double modalBorderRadius = 24.0;

  // ==================== FEATURE CARD CONSTANTS ====================
  /// Feature card icon container size
  static const double featureIconContainerSize = 40.0;
  
  /// Feature card icon size
  static const double featureIconSize = 24.0;
  
  /// Large feature icon container size for quick access
  static const double featureIconContainerLarge = 48.0;
  
  /// Compact feature icon container size for lists
  static const double featureIconContainerCompact = 32.0;
  
  /// Compact feature icon size for lists
  static const double featureIconCompact = 16.0;

  // ==================== GRID LAYOUT CONSTANTS ====================
  /// Quick actions grid columns
  static const int quickActionsColumns = 3;
  
  /// Quick actions grid aspect ratio
  static const double quickActionsAspectRatio = 1.3;
  
  /// Grid spacing between items
  static const double gridSpacing = 1.0;
  
  /// Standard grid aspect ratio
  static const double standardAspectRatio = 1.0;

  // ==================== POPUP & MODAL CONSTANTS ====================
  /// Popup menu offset from trigger
  static const double popupMenuOffset = 40.0;
  
  /// Modal bottom sheet height ratio
  static const double modalHeightRatio = 0.8;
  
  /// Feature list modal height ratio
  static const double featureListModalHeightRatio = 0.7;
  
  /// Modal drag handle width
  static const double modalDragHandleWidth = 40.0;
  
  /// Modal drag handle height
  static const double modalDragHandleHeight = 4.0;
  
  /// Modal drag handle border radius
  static const double modalDragHandleBorderRadius = 2.0;

  // ==================== ANIMATION CONSTANTS ====================
  /// Quick tap animation duration for micro-interactions
  static const int quickAnimationMs = 100;
  
  /// Standard animation duration for most transitions
  static const int standardAnimationMs = 200;
  
  /// Medium animation duration for page transitions
  static const int mediumAnimationMs = 250;
  
  /// Long animation duration for complex transitions
  static const int longAnimationMs = 500;
  
  /// Sync rotation animation duration
  static const int syncAnimationMs = 1000;
  
  /// Entry animation duration for page transitions
  static const int entryAnimationMs = 600;
  
  /// Number counter animation duration
  static const int numberCounterAnimationMs = 1200;
  
  /// Extended animation duration for entry sequences
  static const int extendedAnimationMs = 800;

  // ==================== TEXT SIZE CONSTANTS ====================
  /// Compact text size for dense layouts
  static const double textSizeCompact = 12.0;
  
  /// Small text size for captions
  static const double textSizeSmall = 13.0;
  
  /// Regular text size for body text
  static const double textSizeRegular = 14.0;
  
  /// Medium text size for emphasized text
  static const double textSizeMedium = 15.0;
  
  /// Large text size for headings
  static const double textSizeLarge = 16.0;

  // ==================== LAYOUT CONSTANTS ====================
  /// Standard content padding
  static const double contentPadding = 16.0;
  
  /// Compact content padding
  static const double contentPaddingCompact = 12.0;
  
  /// Large content padding
  static const double contentPaddingLarge = 20.0;
  
  /// Extra large content padding
  static const double contentPaddingXLarge = 24.0;

  // ==================== ANIMATION SCALE CONSTANTS ====================
  /// Scale down value for tap animations
  static const double tapScaleDown = 0.95;
  
  /// Scale down value for long press animations
  static const double longPressScaleDown = 0.9;
  
  /// Default scale value
  static const double scaleDefault = 1.0;

  // ==================== BADGE & INDICATOR CONSTANTS ====================
  /// Small badge size for notifications
  static const double badgeSize = 6.0;
  
  /// Loading indicator stroke width
  static const double loadingStrokeWidth = 2.0;

  // ==================== DIVIDER & SEPARATOR CONSTANTS ====================
  /// Category indicator bar width
  static const double categoryIndicatorWidth = 4.0;
  
  /// Category indicator bar height
  static const double categoryIndicatorHeight = 20.0;
  
  /// Standard border width
  static const double borderWidth = 1.0;

  // ==================== SHADOW & ELEVATION CONSTANTS ====================
  /// Card shadow blur radius
  static const double cardShadowBlur = 2.0;
  
  /// Card shadow offset
  static const double cardShadowOffset = 1.0;
  
  /// Card shadow spread
  static const double cardShadowSpread = 0.0;
  
  /// Modal shadow elevation
  static const double modalElevation = 4.0;

  // ==================== ICON SIZE VARIATIONS ====================
  /// Extra small icon size
  static const double iconSizeXS = 16.0;
  
  /// Small icon size
  static const double iconSizeSmall = 18.0;
  
  /// Medium icon size (default)
  static const double iconSizeMedium = 20.0;
  
  /// Large icon size
  static const double iconSizeLarge = 24.0;
  
  /// Extra large icon size
  static const double iconSizeXL = 32.0;
  
  /// Huge icon size for main features
  static const double iconSizeHuge = 48.0;

  // ==================== LINE HEIGHT CONSTANTS ====================
  /// Compact line height for dense text
  static const double lineHeightCompact = 1.2;
  
  /// Standard line height for body text
  static const double lineHeightStandard = 1.3;
  
  /// Relaxed line height for readable text
  static const double lineHeightRelaxed = 1.5;

  // ==================== CONTAINER SIZING ====================
  /// Loading placeholder container sizes
  static const double loadingContainerWidth = 50.0;
  static const double loadingContainerHeight = 12.0;
  static const double loadingContainerRadius = 6.0;
  
  /// Empty state icon size
  static const double emptyStateIconSize = 48.0;

  // ==================== LAYOUT DIMENSIONS ====================
  /// Hello section height
  static const double helloSectionHeight = 85.0;
  
  /// Maximum lines for feature names
  static const int featureNameMaxLines = 2;
  
  /// Maximum lines for single line text
  static const int singleLineMaxLines = 1;

  // ==================== TIME PICKER CONSTANTS ====================
  /// Time picker modal height ratio
  static const double timePickerHeightRatio = 0.75;
  
  /// Time picker digital display font size
  static const double timePickerDisplayFontSize = 48.0;
  
  /// Clock face number radius ratio
  static const double clockNumberRadiusRatio = 0.8;
  
  /// Clock face minute mark radius ratio
  static const double clockMinuteMarkRadiusRatio = 0.95;
  
  /// Clock hour hand length ratio
  static const double clockHourHandRatio = 0.5;
  
  /// Clock minute hand length ratio
  static const double clockMinuteHandRatio = 0.7;
  
  /// Clock hand stroke width multiplier
  static const double clockHandStrokeMultiplier = 2.0;
  
  /// Clock center dot radius multiplier
  static const double clockCenterDotMultiplier = 2.0;
  
  /// Clock selection indicator normal size multiplier
  static const double clockSelectionNormalMultiplier = 4.0;
  
  /// Clock selection indicator dragging size multiplier
  static const double clockSelectionDraggingMultiplier = 5.0;
  
  /// Time picker animation scale start
  static const double timePickerScaleStart = 0.8;
  
  /// Time picker animation scale end
  static const double timePickerScaleEnd = 1.0;
  
  // ==================== VALIDATION MESSAGES ====================
  /// Common validation messages
  static const String validationRequired = 'This field is required';
  static const String validationEmailInvalid = 'Please enter a valid email';
  static const String validationFirstNameRequired = 'First name is required';
  static const String validationLastNameRequired = 'Last name is required';
  
  // ==================== SUCCESS/ERROR MESSAGES ====================
  /// Standard feedback messages
  static const String messageProfileUpdated = 'Profile updated successfully';
  static const String messageProfileUpdateFailed = 'Failed to update profile';
  static const String messageImageUploadFailed = 'Failed to upload image';
  static const String messageImagePickFailed = 'Failed to pick image';
  
  // ==================== ACTION TEXT ====================
  /// Common action button text
  static const String actionSave = 'Save';
  static const String actionSaveChanges = 'Save Changes';
  static const String actionCancel = 'Cancel';
  static const String actionRetry = 'Retry';
  static const String actionClose = 'Close';
  static const String actionEdit = 'Edit';
  
  // ==================== IMAGE PICKER CONSTANTS ====================
  /// Image picker options
  static const String imageSourceCamera = 'Camera';
  static const String imageSourceGallery = 'Photo Library';
  static const String imagePickerTitle = 'Select Photo';
  
  /// Image constraints
  static const double imageMaxWidth = 512.0;
  static const double imageMaxHeight = 512.0;
  static const int imageQuality = 85;
  
  // ==================== SUBSCRIPTION CONSTANTS ====================
  /// Subscription plan names
  static const String planFree = 'Free';
  static const String planBasic = 'Basic';
  static const String planPremium = 'Premium';
  static const String planPro = 'Pro';
  
  /// Subscription statuses
  static const String statusActive = 'Active';
  static const String statusInactive = 'Inactive';
  static const String statusExpired = 'Expired';
  
  // ==================== FORM CONSTRAINTS ====================
  /// Input field sizing
  static const double inputFieldHeight = 48.0;
  static const double inputFieldBorderRadius = 12.0;
  static const double inputFieldPadding = 16.0;
  
  /// Button sizing
  static const double buttonHeight = 48.0;
  
  // ==================== SHEET & MODAL CONSTANTS ====================
  /// Bottom sheet specific constants
  static const double sheetHandleWidth = 36.0;
  static const double sheetHandleHeight = 4.0;
  static const double sheetBorderRadius = 20.0;
}