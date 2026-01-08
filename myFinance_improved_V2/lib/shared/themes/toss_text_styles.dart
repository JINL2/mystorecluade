import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Toss Typography System - Simplified & Optimized
///
/// Based on actual usage analysis:
/// - 14 core styles (down from 20)
/// - Clear hierarchy: display → h1-h4 → body variants → labels → caption
/// - 4px vertical rhythm maintained
///
/// Font: Inter (primary), JetBrains Mono (numbers)
class TossTextStyles {
  TossTextStyles._();

  // Font families
  static const String fontFamily = 'Inter';
  static const String fontFamilyKR = 'Pretendard';  // Korean font
  static const String fontFamilyMono = 'JetBrains Mono';  // Numbers

  // ==================== DISPLAY & HEADINGS ====================
  // Hierarchy: display (32) → h1 (28) → h2 (24) → h3 (20) → h4 (18)

  /// Display - Hero sections, splash screens (32px)
  /// Usage: 17 places
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    height: 1.25,  // 40px line height
  );

  /// H1 - Page titles, main headers (28px)
  /// Usage: 39 places
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.286,  // 36px line height
  );

  /// H2 - Section headers (24px)
  /// Usage: 78 places
  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.333,  // 32px line height
  );

  /// H3 - Subsection headers, card group titles (20px)
  /// Usage: 210 places - most used heading
  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,  // 28px line height
  );

  /// H4 - Card titles, list item headers (18px)
  /// Usage: 104 places
  static TextStyle get h4 => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.333,  // 24px line height
  );

  // ==================== TITLE STYLES ====================
  // For specific UI patterns between h4 and body

  /// Title Large - Navigation headers, tab labels (17px)
  /// Usage: 25 places
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.412,  // 24px line height
  );

  /// Title Medium - Emphasized labels, "Today Revenue" style (15px)
  /// Usage: 47 places
  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.333,  // 20px line height
  );

  /// Subtitle - List item titles, transaction names (16px, semibold)
  /// Usage: For 16px text that needs emphasis
  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.375,  // 22px line height
  );

  // ==================== BODY TEXT ====================
  // Primary content text styles

  /// Body - Default text for all content (14px, regular)
  /// Usage: 1,233 places - most used style
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.429,  // 20px line height
  );

  /// Body Large - Emphasized body text (14px, same as body)
  /// Usage: 169 places
  /// Note: Same size as body, use when semantic distinction needed
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.429,  // 20px line height
  );

  /// Body Medium - Semibold body for emphasis (14px, semibold)
  /// Usage: 111 places
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.429,  // 20px line height
  );

  /// Body Small - Secondary text, comparisons (13px)
  /// Usage: 276 places
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.385,  // 18px line height
  );

  // ==================== LABELS & CAPTIONS ====================
  // UI elements, form labels, helper text

  /// Label - Form labels, UI element text (12px, medium)
  /// Usage: 75 places
  static TextStyle get label => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.333,  // 16px line height
  );

  /// Label Small - Chips, badges, small UI (11px)
  /// Usage: 44 places
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.02,
    height: 1.455,  // 16px line height
  );

  /// Caption - Helper text, metadata, timestamps (12px, regular)
  /// Usage: 941 places - 2nd most used
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    height: 1.333,  // 16px line height
  );

  /// Small - Tiny text, legal, footnotes (11px)
  /// Usage: 87 places
  static TextStyle get small => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.02,
    height: 1.455,  // 16px line height
  );

  /// Micro - Smallest text, badges, timestamps (10px)
  /// Usage: Chip labels, micro badges
  static TextStyle get micro => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.02,
    height: 1.4,  // 14px line height
  );

  /// Small Section Title - Section labels like "Cash Location" (12px, gray)
  /// Usage: Form section headers, card section labels
  static TextStyle get smallSectionTitle => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    height: 1.333,  // 16px line height
    color: const Color(0xFF6B7280),  // gray600
  );

  // ==================== SPECIAL STYLES ====================

  /// Amount - Financial numbers with monospace font (20px)
  /// Usage: 3 places (special purpose)
  static TextStyle get amount => GoogleFonts.jetBrainsMono(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.2,  // 24px line height
  );

  /// Button - CTA text, button labels (14px, semibold)
  /// Usage: 22 places
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.02,
    height: 1.429,  // 20px line height
  );

  // ==================== DEPRECATED ALIASES ====================
  // These will be removed in future versions

  /// @deprecated Use [h1] instead - identical style
  @Deprecated('Use h1 instead. Will be removed in next major version.')
  static TextStyle get headlineLarge => h1;

  /// @deprecated Use [label] instead
  @Deprecated('Use label instead. Will be removed in next major version.')
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.429,
  );

  /// @deprecated Use [caption] with fontWeight: FontWeight.w600 instead
  @Deprecated('Use caption.copyWith(fontWeight: FontWeight.w600) instead.')
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.01,
    height: 1.333,
  );
}
