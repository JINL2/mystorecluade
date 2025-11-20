import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Extension on BuildContext for easy theme access
extension ThemeExtensions on BuildContext {
  /// Get current theme
  ThemeData get theme => Theme.of(this);
  
  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Get text theme
  TextTheme get textTheme => theme.textTheme;
  
  /// Check if dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get screen size
  Size get screenSize => mediaQuery.size;
  
  /// Get safe area padding
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  
  /// Get keyboard height
  double get keyboardHeight => mediaQuery.viewInsets.bottom;
  
  /// Check if keyboard is visible
  bool get isKeyboardVisible => keyboardHeight > 0;
  
  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;
  
  /// Get text scale factor
  double get textScaleFactor => mediaQuery.textScaleFactor;
  
  /// Check device type
  bool get isMobile => screenSize.width < 600;
  bool get isTablet => screenSize.width >= 600 && screenSize.width < 1200;
  bool get isDesktop => screenSize.width >= 1200;
  
  /// Get responsive value based on screen size
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

/// Extension for Toss theme colors
extension TossColorExtensions on BuildContext {
  /// Primary colors
  Color get primaryColor => TossColors.primary;
  Color get primarySurfaceColor => TossColors.primarySurface;
  
  /// Grayscale colors
  Color get whiteColor => TossColors.white;
  Color get blackColor => TossColors.black;
  Color get gray50Color => TossColors.gray50;
  Color get gray100Color => TossColors.gray100;
  Color get gray200Color => TossColors.gray200;
  Color get gray300Color => TossColors.gray300;
  Color get gray400Color => TossColors.gray400;
  Color get gray500Color => TossColors.gray500;
  Color get gray600Color => TossColors.gray600;
  Color get gray700Color => TossColors.gray700;
  Color get gray800Color => TossColors.gray800;
  Color get gray900Color => TossColors.gray900;
  
  /// Semantic colors
  Color get successColor => TossColors.success;
  Color get successLightColor => TossColors.successLight;
  Color get errorColor => TossColors.error;
  Color get errorLightColor => TossColors.errorLight;
  Color get warningColor => TossColors.warning;
  Color get warningLightColor => TossColors.warningLight;
  Color get infoColor => TossColors.info;
  Color get infoLightColor => TossColors.infoLight;
  
  /// Financial colors
  Color get profitColor => TossColors.profit;
  Color get lossColor => TossColors.loss;
  
  /// Surface colors
  Color get backgroundColor => TossColors.background;
  Color get surfaceColor => TossColors.surface;
  Color get overlayColor => TossColors.overlay;
  
  /// Border colors
  Color get borderColor => TossColors.border;
  Color get borderLightColor => TossColors.borderLight;
  
  /// Text colors
  Color get textPrimaryColor => TossColors.textPrimary;
  Color get textSecondaryColor => TossColors.textSecondary;
  Color get textTertiaryColor => TossColors.textTertiary;
  Color get textInverseColor => TossColors.textInverse;
  
  /// Special colors
  Color get shimmerColor => TossColors.shimmer;
  Color get shadowColor => TossColors.shadow;
  Color get transparentColor => TossColors.transparent;
}

/// Extension for Toss text styles
extension TossTextExtensions on BuildContext {
  /// Display & Headings
  TextStyle get displayStyle => TossTextStyles.display;
  TextStyle get h1Style => TossTextStyles.h1;
  TextStyle get h2Style => TossTextStyles.h2;
  TextStyle get h3Style => TossTextStyles.h3;
  TextStyle get h4Style => TossTextStyles.h4;
  
  /// Body text
  TextStyle get bodyLargeStyle => TossTextStyles.bodyLarge;
  TextStyle get bodyStyle => TossTextStyles.body;
  TextStyle get bodySmallStyle => TossTextStyles.bodySmall;
  
  /// UI Labels
  TextStyle get buttonStyle => TossTextStyles.button;
  TextStyle get labelLargeStyle => TossTextStyles.labelLarge;
  TextStyle get labelStyle => TossTextStyles.label;
  TextStyle get captionStyle => TossTextStyles.caption;
  TextStyle get smallStyle => TossTextStyles.small;
  
  /// Financial
  TextStyle get amountStyle => TossTextStyles.amount;
  
  /// Apply color to text style
  TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  /// Apply weight to text style
  TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  /// Apply size to text style
  TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}

/// Extension for Toss spacing
extension TossSpacingExtensions on BuildContext {
  /// Base spacing values
  double get space0 => TossSpacing.space0;
  double get space1 => TossSpacing.space1;
  double get space2 => TossSpacing.space2;
  double get space3 => TossSpacing.space3;
  double get space4 => TossSpacing.space4;
  double get space5 => TossSpacing.space5;
  double get space6 => TossSpacing.space6;
  double get space7 => TossSpacing.space7;
  double get space8 => TossSpacing.space8;
  double get space9 => TossSpacing.space9;
  double get space10 => TossSpacing.space10;
  double get space12 => TossSpacing.space12;
  double get space14 => TossSpacing.space14;
  double get space16 => TossSpacing.space16;
  double get space20 => TossSpacing.space20;
  double get space24 => TossSpacing.space24;
  
  /// Component padding
  double get paddingXS => TossSpacing.paddingXS;
  double get paddingSM => TossSpacing.paddingSM;
  double get paddingMD => TossSpacing.paddingMD;
  double get paddingLG => TossSpacing.paddingLG;
  double get paddingXL => TossSpacing.paddingXL;
  
  /// Component margins
  double get marginXS => TossSpacing.marginXS;
  double get marginSM => TossSpacing.marginSM;
  double get marginMD => TossSpacing.marginMD;
  double get marginLG => TossSpacing.marginLG;
  double get marginXL => TossSpacing.marginXL;
  
  /// Gaps
  double get gapXS => TossSpacing.gapXS;
  double get gapSM => TossSpacing.gapSM;
  double get gapMD => TossSpacing.gapMD;
  double get gapLG => TossSpacing.gapLG;
  double get gapXL => TossSpacing.gapXL;
  
  /// Icon sizes
  double get iconXS => TossSpacing.iconXS;
  double get iconSM => TossSpacing.iconSM;
  double get iconMD => TossSpacing.iconMD;
  double get iconLG => TossSpacing.iconLG;
  double get iconXL => TossSpacing.iconXL;
  
  /// Button heights
  double get buttonHeightSM => TossSpacing.buttonHeightSM;
  double get buttonHeightMD => TossSpacing.buttonHeightMD;
  double get buttonHeightLG => TossSpacing.buttonHeightLG;
  double get buttonHeightXL => TossSpacing.buttonHeightXL;
  
  /// Input heights
  double get inputHeightSM => TossSpacing.inputHeightSM;
  double get inputHeightMD => TossSpacing.inputHeightMD;
  double get inputHeightLG => TossSpacing.inputHeightLG;
  double get inputHeightXL => TossSpacing.inputHeightXL;
  
  /// Responsive spacing
  double responsiveSpacing(double baseSpacing) {
    if (isMobile) return baseSpacing * 0.875;
    if (isTablet) return baseSpacing;
    return baseSpacing * 1.125;
  }
  
  /// Create EdgeInsets with spacing
  EdgeInsets edgeInsets({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }
    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    }
    return EdgeInsets.only(
      left: left ?? 0,
      top: top ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0,
    );
  }
}

/// Extension for Toss border radius
extension TossBorderRadiusExtensions on BuildContext {
  /// Base radius values
  double get radiusNone => TossBorderRadius.none;
  double get radiusXS => TossBorderRadius.xs;
  double get radiusSM => TossBorderRadius.sm;
  double get radiusMD => TossBorderRadius.md;
  double get radiusLG => TossBorderRadius.lg;
  double get radiusXL => TossBorderRadius.xl;
  double get radiusXXL => TossBorderRadius.xxl;
  double get radiusXXXL => TossBorderRadius.xxxl;
  double get radiusFull => TossBorderRadius.full;
  
  /// Component specific radius
  double get buttonRadius => TossBorderRadius.button;
  double get buttonSmallRadius => TossBorderRadius.buttonSmall;
  double get buttonLargeRadius => TossBorderRadius.buttonLarge;
  double get buttonPillRadius => TossBorderRadius.buttonPill;
  
  double get inputRadius => TossBorderRadius.input;
  double get inputSmallRadius => TossBorderRadius.inputSmall;
  double get inputLargeRadius => TossBorderRadius.inputLarge;
  
  double get cardRadius => TossBorderRadius.card;
  double get cardSmallRadius => TossBorderRadius.cardSmall;
  double get cardLargeRadius => TossBorderRadius.cardLarge;
  
  double get dialogRadius => TossBorderRadius.dialog;
  double get bottomSheetRadius => TossBorderRadius.bottomSheet;
  double get dropdownRadius => TossBorderRadius.dropdown;
  
  double get chipRadius => TossBorderRadius.chip;
  double get badgeRadius => TossBorderRadius.badge;
  double get avatarRadius => TossBorderRadius.avatar;
  double get thumbnailRadius => TossBorderRadius.thumbnail;
  
  /// Responsive radius
  double responsiveRadius(double baseRadius) {
    return isTablet ? baseRadius * 1.25 : baseRadius;
  }
  
  /// Create BorderRadius
  BorderRadius borderRadius(double radius) {
    return BorderRadius.circular(radius);
  }
  
  /// Create BorderRadius with different corners
  BorderRadius borderRadiusOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }
}

/// Extension for Toss shadows
extension TossShadowExtensions on BuildContext {
  /// Shadow elevations
  List<BoxShadow> get shadowNone => TossShadows.none;
  List<BoxShadow> get shadow1 => TossShadows.elevation1;
  List<BoxShadow> get shadow2 => TossShadows.elevation2;
  List<BoxShadow> get shadow3 => TossShadows.elevation3;
  List<BoxShadow> get shadow4 => TossShadows.elevation4;
  
  /// Component shadows
  List<BoxShadow> get cardShadow => TossShadows.card;
  List<BoxShadow> get buttonShadow => TossShadows.button;
  List<BoxShadow> get bottomSheetShadow => TossShadows.bottomSheet;
  List<BoxShadow> get fabShadow => TossShadows.fab;
  List<BoxShadow> get dropdownShadow => TossShadows.dropdown;
  List<BoxShadow> get navbarShadow => TossShadows.navbar;
  
  /// Special shadows
  List<BoxShadow> get insetShadow => TossShadows.inset;
  List<BoxShadow> get glowShadow => TossShadows.glow;
  Shadow get textShadow => TossShadows.textShadow;
  
  /// Custom shadow
  List<BoxShadow> customShadow({
    double opacity = 0.04,
    Offset offset = const Offset(0, 2),
    double blurRadius = 8,
    double spreadRadius = 0,
    Color? color,
  }) {
    return TossShadows.custom(
      opacity: opacity,
      offset: offset,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      color: color,
    );
  }
}

/// Extension for Toss animations
extension TossAnimationExtensions on BuildContext {
  /// Animation durations
  Duration get instantDuration => TossAnimations.instant;
  Duration get quickDuration => TossAnimations.quick;
  Duration get fastDuration => TossAnimations.fast;
  Duration get normalDuration => TossAnimations.normal;
  Duration get mediumDuration => TossAnimations.medium;
  Duration get slowDuration => TossAnimations.slow;
  Duration get slowerDuration => TossAnimations.slower;
  
  /// Animation curves
  Curve get standardCurve => TossAnimations.standard;
  Curve get enterCurve => TossAnimations.enter;
  Curve get exitCurve => TossAnimations.exit;
  Curve get emphasisCurve => TossAnimations.emphasis;
  Curve get linearCurve => TossAnimations.linear;
  Curve get accelerateCurve => TossAnimations.accelerate;
  Curve get decelerateCurve => TossAnimations.decelerate;
  Curve get sharpCurve => TossAnimations.sharp;
}

/// Extension for Toss icons
extension TossIconExtensions on BuildContext {
  /// Navigation icons
  IconData get backIcon => TossIcons.back;
  IconData get forwardIcon => TossIcons.forward;
  IconData get closeIcon => TossIcons.close;
  IconData get menuIcon => TossIcons.menu;
  IconData get moreIcon => TossIcons.more;
  IconData get moreVertIcon => TossIcons.moreVert;
  
  /// User & Account
  IconData get personIcon => TossIcons.person;
  IconData get personFilledIcon => TossIcons.personFilled;
  IconData get accountIcon => TossIcons.account;
  IconData get accountFilledIcon => TossIcons.accountFilled;
  IconData get lockIcon => TossIcons.lock;
  IconData get lockFilledIcon => TossIcons.lockFilled;
  
  /// Finance & Business
  IconData get walletIcon => TossIcons.wallet;
  IconData get bankIcon => TossIcons.bank;
  IconData get receiptIcon => TossIcons.receipt;
  IconData get currencyIcon => TossIcons.currency;
  IconData get businessIcon => TossIcons.business;
  IconData get storeIcon => TossIcons.store;
  IconData get storeFilledIcon => TossIcons.storeFilled;
  
  /// Status & Feedback
  IconData get checkIcon => TossIcons.check;
  IconData get checkCircleIcon => TossIcons.checkCircle;
  IconData get errorIcon => TossIcons.error;
  IconData get errorOutlineIcon => TossIcons.errorOutline;
  IconData get infoIcon => TossIcons.info;
  IconData get infoFilledIcon => TossIcons.infoFilled;
  IconData get warningIcon => TossIcons.warning;
  IconData get warningFilledIcon => TossIcons.warningFilled;
  
  /// Common actions
  IconData get addIcon => TossIcons.add;
  IconData get removeIcon => TossIcons.remove;
  IconData get editIcon => TossIcons.edit;
  IconData get editFilledIcon => TossIcons.editFilled;
  IconData get deleteIcon => TossIcons.delete;
  IconData get deleteFilledIcon => TossIcons.deleteFilled;
  
  /// Helper methods
  IconData getIcon(IconData outlined, IconData filled, bool isSelected) {
    return TossIcons.getIcon(outlined, filled, isSelected);
  }
  
  IconData getStoreIcon(String? storeType) {
    return TossIcons.getStoreIcon(storeType);
  }
  
  IconData getStatusIcon(bool isSuccess) {
    return TossIcons.getStatusIcon(isSuccess);
  }
}

/// Widget extension for theme consistency checking
extension ThemeConsistencyExtensions on Widget {
  /// Wrap widget with theme consistency checker in debug mode
  Widget withThemeCheck() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return this; // No checking in release mode
    }
    
    return Builder(
      builder: (context) {
        // Perform theme consistency check
        _checkThemeConsistency(context);
        return this;
      },
    );
  }
  
  void _checkThemeConsistency(BuildContext context) {
    // This would be implemented to check for hardcoded values
    // and report them via the theme provider
  }
}

/// Extension for Consumer widgets to access theme easily
extension ConsumerThemeExtensions on WidgetRef {
  /// Watch theme mode changes
  ThemeMode get themeMode {
    return watch(themeModeProvider);
  }
  
  /// Watch text scale factor
  double get textScale {
    return watch(textScaleProvider);
  }
  
  /// Check if feature is enabled
  bool isFeatureEnabled(String feature) {
    final flags = watch(featureFlagsProvider);
    return flags[feature] ?? false;
  }
}

// Mock providers - these would be imported from theme_provider.dart
final themeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.light);
final textScaleProvider = Provider<double>((ref) => 1.0);
final featureFlagsProvider = Provider<Map<String, bool>>((ref) => {});