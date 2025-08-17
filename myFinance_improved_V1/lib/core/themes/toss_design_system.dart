/// Toss Design System - Master Reference
/// Complete design tokens and guidelines for MyFinance app
/// Based on Toss (토스) Korean fintech app
/// 
/// Last Updated: 2024
/// Version: 1.0.0

import 'package:flutter/material.dart';
import 'toss_colors.dart';
import 'toss_text_styles.dart';
import 'toss_spacing.dart';
import 'toss_border_radius.dart';
import 'toss_shadows.dart';
import 'toss_animations.dart';

/// Master design system class that provides all Toss design tokens
/// and guidelines in one place for easy reference and consistency
class TossDesignSystem {
  TossDesignSystem._();

  // ==================== DESIGN PRINCIPLES ====================
  
  /// Core design philosophy
  static const String philosophy = '''
  1. Minimalist & Clean - White-dominant with breathing space
  2. Trust & Clarity - Professional financial interface
  3. Single Focus - One primary action per screen
  4. Subtle Depth - Minimal shadows, use borders for definition
  5. Smooth Motion - 200-250ms animations, no bounce
  6. Consistent Grid - Strict 4px spacing system
  7. Strategic Color - Blue for CTAs, grayscale for UI
  ''';

  // ==================== BRAND IDENTITY ====================
  
  /// Primary brand color - Toss Blue
  static const Color brandColor = TossColors.primary;  // #0064FF
  
  /// Secondary brand color - Toss Dark
  static const Color brandSecondary = TossColors.secondary;  // #202632
  
  /// Success color - Toss Green
  static const Color brandSuccess = TossColors.success;  // #00C896
  
  /// Error color - Toss Red
  static const Color brandError = TossColors.error;  // #FF5847
  
  /// Warning color - Toss Orange
  static const Color brandWarning = TossColors.warning;  // #FF9500

  // ==================== LAYOUT CONSTANTS ====================
  
  /// Screen edge padding
  static const double screenPadding = TossSpacing.paddingXL;  // 24px
  
  /// Maximum content width for readability
  static const double maxContentWidth = 640.0;
  
  /// Standard card width
  static const double cardWidth = 480.0;
  
  /// Navigation bar height
  static const double navBarHeight = 64.0;
  
  /// App bar height
  static const double appBarHeight = 56.0;
  
  /// Bottom sheet handle size
  static const Size dragHandleSize = Size(40, 4);
  
  /// FAB size
  static const double fabSize = 56.0;
  
  /// Mini FAB size
  static const double miniFabSize = 40.0;

  // ==================== COMPONENT SIZES ====================
  
  /// Button specifications
  static const Map<String, double> buttonSizes = {
    'heightSmall': TossSpacing.buttonHeightSM,     // 32px
    'heightMedium': TossSpacing.buttonHeightMD,    // 40px
    'heightLarge': TossSpacing.buttonHeightLG,     // 48px ⭐
    'heightXL': TossSpacing.buttonHeightXL,        // 56px
    'minWidth': 64.0,
    'iconSize': TossSpacing.iconMD,                // 24px
  };
  
  /// Input field specifications
  static const Map<String, double> inputSizes = {
    'heightSmall': TossSpacing.inputHeightSM,      // 36px
    'heightMedium': TossSpacing.inputHeightMD,     // 44px
    'heightLarge': TossSpacing.inputHeightLG,      // 48px ⭐
    'heightXL': TossSpacing.inputHeightXL,         // 56px
    'borderWidth': 1.0,
    'focusBorderWidth': 2.0,
  };
  
  /// Icon sizes
  static const Map<String, double> iconSizes = {
    'xs': TossSpacing.iconXS,    // 16px
    'sm': TossSpacing.iconSM,    // 20px
    'md': TossSpacing.iconMD,    // 24px ⭐
    'lg': TossSpacing.iconLG,    // 32px
    'xl': TossSpacing.iconXL,    // 40px
  };

  // ==================== RESPONSIVE BREAKPOINTS ====================
  
  /// Screen size breakpoints
  static const Map<String, double> breakpoints = {
    'mobile': 360,      // Minimum mobile width
    'mobileLarge': 414, // Large mobile
    'tablet': 768,      // Tablet portrait
    'desktop': 1024,    // Desktop/tablet landscape
    'desktopLarge': 1440, // Large desktop
  };
  
  /// Responsive padding
  static double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpoints['tablet']!) return TossSpacing.paddingMD;  // 16px
    if (width < breakpoints['desktop']!) return TossSpacing.paddingLG; // 20px
    return TossSpacing.paddingXL;  // 24px
  }

  // ==================== ANIMATION SPECS ====================
  
  /// Standard animation configurations
  static const Map<String, Duration> animationDurations = {
    'instant': TossAnimations.instant,   // 50ms
    'quick': TossAnimations.quick,       // 100ms
    'fast': TossAnimations.fast,         // 150ms
    'normal': TossAnimations.normal,     // 200ms ⭐
    'medium': TossAnimations.medium,     // 250ms ⭐
    'slow': TossAnimations.slow,         // 300ms
    'slower': TossAnimations.slower,     // 400ms
  };
  
  /// Standard animation curves
  static const Map<String, Curve> animationCurves = {
    'standard': TossAnimations.standard,   // easeInOutCubic ⭐
    'enter': TossAnimations.enter,         // easeOutCubic ⭐
    'exit': TossAnimations.exit,           // easeInCubic
    'emphasis': TossAnimations.emphasis,   // fastOutSlowIn
    'linear': TossAnimations.linear,       // linear
  };

  // ==================== ELEVATION SYSTEM ====================
  
  /// Shadow elevations
  static const Map<String, List<BoxShadow>> elevations = {
    'none': TossShadows.none,             // No shadow
    'card': TossShadows.card,             // 4% opacity
    'hover': TossShadows.elevation2,      // 5% opacity
    'dropdown': TossShadows.dropdown,     // 6% opacity
    'modal': TossShadows.elevation4,      // 8% opacity
    'fab': TossShadows.fab,               // Colored shadow
  };

  // ==================== ACCESSIBILITY ====================
  
  /// Minimum touch target size (WCAG 2.1)
  static const double minTouchTarget = 44.0;
  
  /// Minimum contrast ratios
  static const Map<String, double> contrastRatios = {
    'normalText': 4.5,      // WCAG AA
    'largeText': 3.0,       // WCAG AA for large text
    'enhanced': 7.0,        // WCAG AAA
    'enhancedLarge': 4.5,   // WCAG AAA for large text
  };

  // ==================== HELPER METHODS ====================
  
  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpoints['tablet']!;
  }
  
  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpoints['tablet']! && width < breakpoints['desktop']!;
  }
  
  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpoints['desktop']!;
  }
  
  /// Get adaptive border radius
  static double getAdaptiveRadius(BuildContext context, double baseRadius) {
    return isTablet(context) ? baseRadius * 1.25 : baseRadius;
  }
  
  /// Get adaptive spacing
  static double getAdaptiveSpacing(BuildContext context, double baseSpacing) {
    if (isMobile(context)) return baseSpacing * 0.875;
    if (isTablet(context)) return baseSpacing;
    return baseSpacing * 1.125;
  }

  // ==================== QUICK BUILDERS ====================
  
  /// Build a standard Toss card
  static Widget buildCard({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(
        horizontal: TossSpacing.marginMD,
        vertical: TossSpacing.marginSM,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        border: Border.all(color: TossColors.border, width: 1),
        boxShadow: TossShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.card),
          child: Padding(
            padding: padding ?? EdgeInsets.all(TossSpacing.paddingMD),
            child: child,
          ),
        ),
      ),
    );
  }
  
  /// Build a standard divider
  static Widget buildDivider({
    double? height,
    double? indent,
    double? endIndent,
    Color? color,
  }) {
    return Divider(
      height: height ?? 1,
      thickness: 0.5,
      indent: indent ?? 0,
      endIndent: endIndent ?? 0,
      color: color ?? TossColors.divider,
    );
  }
  
  /// Build a loading shimmer
  static Widget buildShimmer({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: TossColors.shimmer,
        borderRadius: borderRadius ?? BorderRadius.circular(TossBorderRadius.md),
      ),
    );
  }

  // ==================== DEBUG HELPERS ====================
  
  /// Print all design tokens (for debugging)
  static void printDesignTokens() {
    debugPrint('''
    ╔════════════════════════════════════════╗
    ║     TOSS DESIGN SYSTEM TOKENS          ║
    ╠════════════════════════════════════════╣
    ║ Colors:                                ║
    ║   Primary: ${brandColor.value.toRadixString(16)}
    ║   Success: ${brandSuccess.value.toRadixString(16)}
    ║   Error: ${brandError.value.toRadixString(16)}
    ║                                        ║
    ║ Spacing:                               ║
    ║   Base unit: 4px                       ║
    ║   Default: ${TossSpacing.space4}px
    ║                                        ║
    ║ Animation:                             ║
    ║   Normal: ${animationDurations['normal']!.inMilliseconds}ms
    ║   Medium: ${animationDurations['medium']!.inMilliseconds}ms
    ║                                        ║
    ║ Typography:                            ║
    ║   Font: Inter                          ║
    ║   Body: 14px                           ║
    ║                                        ║
    ║ Border Radius:                         ║
    ║   Default: ${TossBorderRadius.md}px
    ║   Card: ${TossBorderRadius.card}px
    ╚════════════════════════════════════════╝
    ''');
  }
}