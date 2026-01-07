import 'package:flutter/material.dart';

/// Toss Font Weight System - Semantic Font Weight Tokens
///
/// Provides consistent font weight tokens that align with the
/// typography hierarchy defined in TossTextStyles.
///
/// Usage:
/// ```dart
/// Text('Hello', style: TossTextStyles.body.copyWith(
///   fontWeight: TossFontWeight.semibold,
/// ));
/// ```
///
/// Font Weight Scale (Inter font):
/// - w400: Regular (default for body text)
/// - w500: Medium (labels, captions)
/// - w600: Semibold (emphasis, buttons)
/// - w700: Bold (headings, important values)
/// - w800: Extra Bold (display, hero text)
class TossFontWeight {
  TossFontWeight._();

  // ==================== CORE WEIGHTS ====================

  /// Regular weight (400) - Default for body text
  /// Usage: TossTextStyles.body, bodyLarge, bodySmall, caption
  static const FontWeight regular = FontWeight.w400;

  /// Medium weight (500) - Slightly emphasized text
  /// Usage: TossTextStyles.label, subtle emphasis
  static const FontWeight medium = FontWeight.w500;

  /// Semibold weight (600) - Buttons, emphasized content
  /// Usage: TossTextStyles.bodyMedium, subtitle, labelSmall, button
  static const FontWeight semibold = FontWeight.w600;

  /// Bold weight (700) - Headings, important values
  /// Usage: TossTextStyles.h1-h4, titleLarge, titleMedium
  static const FontWeight bold = FontWeight.w700;

  /// Extra Bold weight (800) - Display text, hero sections
  /// Usage: TossTextStyles.display
  static const FontWeight extraBold = FontWeight.w800;

  // ==================== SEMANTIC ALIASES ====================
  // Named for specific use cases to improve code readability

  /// For body text emphasis (same as medium)
  static const FontWeight bodyEmphasis = medium;

  /// For label text (same as medium)
  static const FontWeight label = medium;

  /// For button text (same as semibold)
  static const FontWeight button = semibold;

  /// For card/list item titles (same as semibold)
  static const FontWeight title = semibold;

  /// For section headings (same as bold)
  static const FontWeight heading = bold;

  /// For numerical values that need emphasis (same as bold)
  static const FontWeight value = bold;

  /// For hero/display text (same as extraBold)
  static const FontWeight display = extraBold;
}
