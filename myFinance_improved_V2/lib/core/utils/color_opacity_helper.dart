import 'package:flutter/material.dart';
import '../../shared/themes/toss_colors.dart';

/// Helper class for handling color opacity without pixel rendering errors
class ColorOpacityHelper {
  ColorOpacityHelper._();

  /// Apply opacity to a color with pixel-perfect rendering
  /// Uses Color.alphaBlend for better sub-pixel rendering than withValues() or withOpacity()
  static Color withOpacity(Color color, double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Opacity must be between 0.0 and 1.0');
    
    // For full opacity, return original color
    if (opacity == 1.0) return color;
    
    // For zero opacity, return transparent
    if (opacity == 0.0) return TossColors.transparent;
    
    // Use withValues for proper alpha channel handling
    // This avoids the precision loss issues of withOpacity
    return color.withValues(alpha: opacity);
  }

  /// Blend a color with a background for pixel-perfect rendering
  /// This is the preferred method for overlays and semi-transparent elements
  static Color alphaBlend(Color foreground, Color background, double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Opacity must be between 0.0 and 1.0');
    
    // Create foreground with opacity
    final colorWithAlpha = foreground.withValues(alpha: opacity);
    
    // Blend with background for pixel-perfect result
    return Color.alphaBlend(colorWithAlpha, background);
  }

  /// Calculate the actual RGB values for a color with opacity over white background
  /// This provides the most accurate pixel rendering
  static Color flattenOnWhite(Color color, double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Opacity must be between 0.0 and 1.0');
    
    // Calculate flattened RGB values
    final r = (color.red * opacity + 255 * (1 - opacity)).round();
    final g = (color.green * opacity + 255 * (1 - opacity)).round();
    final b = (color.blue * opacity + 255 * (1 - opacity)).round();
    
    return Color.fromARGB(255, r, g, b);
  }

  /// Calculate the actual RGB values for a color with opacity over any background
  static Color flatten(Color foreground, Color background, double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Opacity must be between 0.0 and 1.0');
    
    // Calculate flattened RGB values
    final r = (foreground.red * opacity + background.red * (1 - opacity)).round();
    final g = (foreground.green * opacity + background.green * (1 - opacity)).round();
    final b = (foreground.blue * opacity + background.blue * (1 - opacity)).round();
    
    return Color.fromARGB(255, r, g, b);
  }
}