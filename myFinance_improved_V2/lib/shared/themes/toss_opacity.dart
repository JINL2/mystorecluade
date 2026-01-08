/// Toss Opacity System - Standardized Opacity Values
///
/// Provides consistent opacity tokens for overlays, backgrounds,
/// and state changes across the app.
///
/// Usage:
/// ```dart
/// color.withValues(alpha: TossOpacity.subtle)
/// color.withValues(alpha: TossOpacity.hover)
/// ```
class TossOpacity {
  TossOpacity._();

  // ==================== STATE OPACITY ====================
  // Used for interactive state changes

  /// Subtle overlay - Very light backgrounds (5%)
  /// Usage: Subtle background tints, light overlays
  static const double subtle = 0.05;

  /// Hover state - Interactive hover feedback (8%)
  /// Usage: Button hover, list item hover
  static const double hover = 0.08;

  /// Light overlay - Standard light background (10%)
  /// Usage: Badge backgrounds, light tints
  static const double light = 0.10;

  /// Pressed state - Touch/click feedback (12%)
  /// Usage: Button pressed, active states
  static const double pressed = 0.12;

  /// Medium overlay - Badge/tag backgrounds (15%)
  /// Usage: Status badges, chips, tags
  static const double medium = 0.15;

  /// Strong overlay - Emphasized backgrounds (20%)
  /// Usage: Selected states, focus rings
  static const double strong = 0.20;

  /// Heavy overlay - Dark overlays (30%)
  /// Usage: Disabled states, modal backdrops (light)
  static const double heavy = 0.30;

  /// Overlay - Standard overlay backgrounds (10%)
  /// Usage: Chip backgrounds, overlay tints
  static const double overlay = 0.10;

  // ==================== SEMANTIC OPACITY ====================
  // Named for specific use cases

  /// Badge background opacity
  static const double badge = 0.10;

  /// Selected item background
  static const double selected = 0.08;

  /// Disabled element opacity
  static const double disabled = 0.38;

  /// Scrim/backdrop opacity
  static const double scrim = 0.50;

  /// Dark scrim for image viewers (60%)
  static const double darkScrim = 0.60;

  /// Dark overlay for fullscreen viewers (45%)
  static const double darkOverlay = 0.45;

  /// Secondary text on dark backgrounds (70%)
  static const double secondaryOnDark = 0.70;

  /// Modal backdrop opacity
  static const double modalBackdrop = 0.80;

  // ==================== TEXT OPACITY ====================
  // Based on Material Design text emphasis

  /// High emphasis text (87%)
  static const double textHigh = 0.87;

  /// Medium emphasis text (60%)
  static const double textMedium = 0.60;

  /// Disabled text (38%)
  static const double textDisabled = 0.38;
}
