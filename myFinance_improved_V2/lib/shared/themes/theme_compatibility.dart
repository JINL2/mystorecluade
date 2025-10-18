import 'package:flutter/material.dart';
import 'toss_colors.dart';
import 'toss_text_styles.dart';
import 'toss_spacing.dart';
import 'toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Theme compatibility layer for gradual migration
/// Provides fallback values and migration helpers
class ThemeCompatibility {
  ThemeCompatibility._();
  
  // Feature flags for gradual rollout
  static bool useNewColors = false;
  static bool useNewTextStyles = false;
  static bool useNewSpacing = false;
  static bool useNewBorderRadius = false;
  
  /// Map of legacy hardcoded colors to theme colors
  static final Map<int, Color> _legacyColorMap = {
    0xFF0064FF: TossColors.primary,
    0xFFFFFFFF: TossColors.white,
    0xFF000000: TossColors.black,
    0xFFF8F9FA: TossColors.gray50,
    0xFFF1F3F5: TossColors.gray100,
    0xFFE9ECEF: TossColors.gray200,
    0xFFDEE2E6: TossColors.gray300,
    0xFFCED4DA: TossColors.gray400,
    0xFFADB5BD: TossColors.gray500,
    0xFF6C757D: TossColors.gray600,
    0xFF495057: TossColors.gray700,
    0xFF343A40: TossColors.gray800,
    0xFF212529: TossColors.gray900,
    0xFF00C896: TossColors.success,
    0xFFFF5847: TossColors.error,
    0xFFFF9500: TossColors.warning,
  };
  
  /// Get color with fallback to legacy value
  static Color getColor(Color? legacyColor, Color themeColor) {
    if (!useNewColors && legacyColor != null) {
      return legacyColor;
    }
    return themeColor;
  }
  
  /// Map legacy color to theme color
  static Color mapLegacyColor(int colorValue) {
    return _legacyColorMap[colorValue] ?? Color(colorValue);
  }
  
  /// Map Material color to Toss color
  static Color mapMaterialColor(MaterialColor materialColor) {
    if (materialColor == TossColors.primary) return TossColors.primary;
    if (materialColor == TossColors.error) return TossColors.error;
    if (materialColor == TossColors.success) return TossColors.success;
    if (materialColor == TossColors.warning) return TossColors.warning;
    if (materialColor == TossColors.gray500) return TossColors.gray500;
    return TossColors.gray900;
  }
  
  /// Get text style with migration support
  static TextStyle getTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    if (!useNewTextStyles) {
      // Return legacy style
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    }
    
    // Map to closest Toss text style
    return _mapToTossTextStyle(fontSize, fontWeight);
  }
  
  /// Map legacy text style to Toss text style
  static TextStyle _mapToTossTextStyle(double? fontSize, FontWeight? fontWeight) {
    // Map based on font size and weight
    if (fontSize == null) return TossTextStyles.body;
    
    if (fontSize >= 28) return TossTextStyles.h1;
    if (fontSize >= 24) return TossTextStyles.h2;
    if (fontSize >= 20) return TossTextStyles.h3;
    if (fontSize >= 18) return TossTextStyles.h4;
    if (fontSize >= 16) return TossTextStyles.bodyLarge;
    if (fontSize >= 14) return TossTextStyles.body;
    if (fontSize >= 13) return TossTextStyles.bodySmall;
    if (fontSize >= 12) {
      if (fontWeight == FontWeight.w500 || fontWeight == FontWeight.w600) {
        return TossTextStyles.label;
      }
      return TossTextStyles.caption;
    }
    return TossTextStyles.small;
  }
  
  /// Get spacing with 4px grid alignment
  static double getSpacing(double legacyValue) {
    if (!useNewSpacing) {
      return legacyValue;
    }
    
    // Round to nearest 4px grid value
    final gridValue = (legacyValue / 4).round() * 4;
    return gridValue.toDouble();
  }
  
  /// Map legacy spacing to Toss spacing constant
  static double mapToTossSpacing(double value) {
    if (value <= 0) return TossSpacing.space0;
    if (value <= 4) return TossSpacing.space1;
    if (value <= 8) return TossSpacing.space2;
    if (value <= 12) return TossSpacing.space3;
    if (value <= 16) return TossSpacing.space4;
    if (value <= 20) return TossSpacing.space5;
    if (value <= 24) return TossSpacing.space6;
    if (value <= 28) return TossSpacing.space7;
    if (value <= 32) return TossSpacing.space8;
    if (value <= 36) return TossSpacing.space9;
    if (value <= 40) return TossSpacing.space10;
    if (value <= 48) return TossSpacing.space12;
    if (value <= 56) return TossSpacing.space14;
    if (value <= 64) return TossSpacing.space16;
    if (value <= 80) return TossSpacing.space20;
    return TossSpacing.space24;
  }
  
  /// Get EdgeInsets with spacing grid alignment
  static EdgeInsets getEdgeInsets({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      final spacing = getSpacing(all);
      return EdgeInsets.all(spacing);
    }
    
    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal != null ? getSpacing(horizontal) : 0,
        vertical: vertical != null ? getSpacing(vertical) : 0,
      );
    }
    
    return EdgeInsets.only(
      left: left != null ? getSpacing(left) : 0,
      top: top != null ? getSpacing(top) : 0,
      right: right != null ? getSpacing(right) : 0,
      bottom: bottom != null ? getSpacing(bottom) : 0,
    );
  }
  
  /// Get border radius with component-aware mapping
  static double getBorderRadius(double legacyValue, {String? componentType}) {
    if (!useNewBorderRadius) {
      return legacyValue;
    }
    
    // Component-specific mapping
    if (componentType != null) {
      switch (componentType) {
        case 'button':
          return TossBorderRadius.button;
        case 'card':
          return TossBorderRadius.card;
        case 'input':
          return TossBorderRadius.input;
        case 'chip':
          return TossBorderRadius.chip;
        case 'dialog':
          return TossBorderRadius.dialog;
        case 'bottomSheet':
          return TossBorderRadius.bottomSheet;
      }
    }
    
    // Map to nearest standard value
    return _mapToTossBorderRadius(legacyValue);
  }
  
  /// Map legacy radius to Toss border radius
  static double _mapToTossBorderRadius(double value) {
    if (value <= 0) return TossBorderRadius.none;
    if (value <= 4) return TossBorderRadius.xs;
    if (value <= 6) return TossBorderRadius.sm;
    if (value <= 10) return TossBorderRadius.md;
    if (value <= 14) return TossBorderRadius.lg;
    if (value <= 18) return TossBorderRadius.xl;
    if (value <= 22) return TossBorderRadius.xxl;
    if (value <= 26) return TossBorderRadius.xxxl;
    if (value >= 100) return TossBorderRadius.full;
    return TossBorderRadius.md;
  }
  
  /// Validate if a color is from the theme
  static bool isThemeColor(Color color) {
    // Check if color matches any Toss color
    return color == TossColors.primary ||
           color == TossColors.white ||
           color == TossColors.black ||
           color == TossColors.gray50 ||
           color == TossColors.gray100 ||
           color == TossColors.gray200 ||
           color == TossColors.gray300 ||
           color == TossColors.gray400 ||
           color == TossColors.gray500 ||
           color == TossColors.gray600 ||
           color == TossColors.gray700 ||
           color == TossColors.gray800 ||
           color == TossColors.gray900 ||
           color == TossColors.success ||
           color == TossColors.error ||
           color == TossColors.warning ||
           color == TossColors.info;
  }
  
  /// Check if a TextStyle uses theme styles
  static bool isThemeTextStyle(TextStyle style) {
    // This would check if the style matches any TossTextStyles
    // For simplicity, checking if fontSize matches known values
    final fontSize = style.fontSize;
    if (fontSize == null) return false;
    
    return fontSize == 32 || // display
           fontSize == 28 || // h1
           fontSize == 24 || // h2
           fontSize == 20 || // h3
           fontSize == 18 || // h4
           fontSize == 16 || // bodyLarge
           fontSize == 14 || // body
           fontSize == 13 || // bodySmall
           fontSize == 12 || // caption/label
           fontSize == 11;   // small
  }
  
  /// Gradually enable features based on rollout percentage
  static void enableFeaturesForUser(String userId, Map<String, int> rolloutPercentages) {
    final userHash = userId.hashCode.abs();
    final maxHash = 0xFFFFFFFF;
    
    // Check each feature rollout
    rolloutPercentages.forEach((feature, percentage) {
      final threshold = (percentage * maxHash / 100).round();
      final isEnabled = userHash < threshold;
      
      switch (feature) {
        case 'colors':
          useNewColors = isEnabled;
          break;
        case 'textStyles':
          useNewTextStyles = isEnabled;
          break;
        case 'spacing':
          useNewSpacing = isEnabled;
          break;
        case 'borderRadius':
          useNewBorderRadius = isEnabled;
          break;
      }
    });
  }
  
  /// Migration helper to suggest replacements
  static String? getSuggestedReplacement(String code) {
    // Color replacements
    if (code.contains('TossColors.primary')) {
      return code.replaceAll('TossColors.primary', 'TossColors.primary');
    }
    if (code.contains('TossColors.primary')) {
      return code.replaceAll('TossColors.primary', 'TossColors.primary');
    }
    if (code.contains('TossColors.error')) {
      return code.replaceAll('TossColors.error', 'TossColors.error');
    }
    if (code.contains('TossColors.success')) {
      return code.replaceAll('TossColors.success', 'TossColors.success');
    }
    if (code.contains('TossColors.warning')) {
      return code.replaceAll('TossColors.warning', 'TossColors.warning');
    }
    if (code.contains('TossColors.gray500')) {
      return code.replaceAll('TossColors.gray500', 'TossColors.gray500');
    }
    if (code.contains('TossColors.white')) {
      return code.replaceAll('TossColors.white', 'TossColors.white');
    }
    if (code.contains('TossColors.black')) {
      return code.replaceAll('TossColors.black', 'TossColors.black');
    }
    
    // TextStyle replacements
    if (code.contains('fontSize: 16') && code.contains('fontWeight: FontWeight.w600')) {
      return 'TossTextStyles.h4';
    }
    if (code.contains('fontSize: 14') && code.contains('fontWeight: FontWeight.w400')) {
      return 'TossTextStyles.body';
    }
    
    // EdgeInsets replacements
    final edgeInsetsPattern = RegExp(r'EdgeInsets\.(all|symmetric|only)\((\d+(?:\.\d+)?)\)');
    if (edgeInsetsPattern.hasMatch(code)) {
      return code.replaceAllMapped(edgeInsetsPattern, (match) {
        final value = double.parse(match.group(2)!);
        final tossSpacing = mapToTossSpacing(value);
        final spacingName = _getSpacingName(tossSpacing);
        return 'EdgeInsets.${match.group(1)}($spacingName)';
      });
    }
    
    // BorderRadius replacements
    final borderRadiusPattern = RegExp(r'BorderRadius\.circular\((\d+(?:\.\d+)?)\)');
    if (borderRadiusPattern.hasMatch(code)) {
      return code.replaceAllMapped(borderRadiusPattern, (match) {
        final value = double.parse(match.group(1)!);
        final tossRadius = _mapToTossBorderRadius(value);
        final radiusName = _getBorderRadiusName(tossRadius);
        return 'BorderRadius.circular($radiusName)';
      });
    }
    
    return null;
  }
  
  /// Get spacing constant name from value
  static String _getSpacingName(double value) {
    if (value == TossSpacing.space0) return 'TossSpacing.space0';
    if (value == TossSpacing.space1) return 'TossSpacing.space1';
    if (value == TossSpacing.space2) return 'TossSpacing.space2';
    if (value == TossSpacing.space3) return 'TossSpacing.space3';
    if (value == TossSpacing.space4) return 'TossSpacing.space4';
    if (value == TossSpacing.space5) return 'TossSpacing.space5';
    if (value == TossSpacing.space6) return 'TossSpacing.space6';
    if (value == TossSpacing.space7) return 'TossSpacing.space7';
    if (value == TossSpacing.space8) return 'TossSpacing.space8';
    if (value == TossSpacing.space9) return 'TossSpacing.space9';
    if (value == TossSpacing.space10) return 'TossSpacing.space10';
    if (value == TossSpacing.space12) return 'TossSpacing.space12';
    if (value == TossSpacing.space14) return 'TossSpacing.space14';
    if (value == TossSpacing.space16) return 'TossSpacing.space16';
    if (value == TossSpacing.space20) return 'TossSpacing.space20';
    if (value == TossSpacing.space24) return 'TossSpacing.space24';
    return 'TossSpacing.space4';
  }
  
  /// Get border radius constant name from value
  static String _getBorderRadiusName(double value) {
    if (value == TossBorderRadius.none) return 'TossBorderRadius.none';
    if (value == TossBorderRadius.xs) return 'TossBorderRadius.xs';
    if (value == TossBorderRadius.sm) return 'TossBorderRadius.sm';
    if (value == TossBorderRadius.md) return 'TossBorderRadius.md';
    if (value == TossBorderRadius.lg) return 'TossBorderRadius.lg';
    if (value == TossBorderRadius.xl) return 'TossBorderRadius.xl';
    if (value == TossBorderRadius.xxl) return 'TossBorderRadius.xxl';
    if (value == TossBorderRadius.xxxl) return 'TossBorderRadius.xxxl';
    if (value == TossBorderRadius.full) return 'TossBorderRadius.full';
    return 'TossBorderRadius.md';
  }
}