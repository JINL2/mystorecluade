import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Toss Typography System - Centralized Size Buckets
/// 
/// STRATEGY: 
/// All FontSizes are defined ONCE in the "New Core".
/// The public getters simply point to these core styles.
/// No `copyWith(fontSize: ...)` is allowed in the public layer.
class TossTextStyles {
  TossTextStyles._();

  // ==================== 1. THE NEW CORE (Single Source of Truth) ====================
  // If you change these, the entire app updates.

  /// The 32px Bucket
  static TextStyle get _heading32 => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02,
    height: 1.25,
  );

  /// The 28px Bucket (H1)
  /// CHANGE THIS ONE PLACE -> Updates all H1s and 28px text
  static TextStyle get _heading28 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.28,
  );

  /// The 24px Bucket (H2)
  static TextStyle get _heading24 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.33,
  );

  /// The 20px Bucket (H3, Amount)
  static TextStyle get _heading20 => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600, // Slightly bolder for small headers
    letterSpacing: 0,
    height: 1.4,
  );

  /// The 18px Bucket (H4)
  static TextStyle get _heading18 => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  /// The 16px Bucket (Subtitle, Titles)
  static TextStyle get _text16 => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4, // Generous height for reading
  );

  /// The 14px Bucket (Body, Buttons)
  static TextStyle get _text14 => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.43,
  );

  /// The 12px Bucket (Captions, Labels)
  static TextStyle get _text12 => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    height: 1.33,
  );

  // ==================== 2. THE LEGACY ADAPTER (Pointer Layer) ====================
  // These just point to the buckets above. NO font sizes defined here.

  // --- Headings ---
  
  static TextStyle get display => _heading32;

  /// Points to the 28px bucket
  static TextStyle get h1 => _heading28;

  /// Points to the 24px bucket
  static TextStyle get h2 => _heading24;

  /// Points to the 20px bucket
  static TextStyle get h3 => _heading20;

  /// Points to the 18px bucket
  static TextStyle get h4 => _heading18;

  // --- Titles ---

  // All these old confusing sizes now point to the clean 16px bucket
  static TextStyle get titleLarge => _text16;  // Was 17px
  static TextStyle get titleMedium => _text16; // Was 15px
  static TextStyle get subtitle => _text16;    // Was 16px

  // --- Body ---

  static TextStyle get body => _text14;
  static TextStyle get bodyLarge => _text14;   // Was 14px duplicate
  
  // Example of using the bucket but adding a small tweak (weight)
  static TextStyle get bodyMedium => _text14.copyWith(fontWeight: FontWeight.w600);

  static TextStyle get bodySmall => _text12;   // Was 13px, snapped to 12

  // --- Labels ---

  static TextStyle get label => _text12.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get labelSmall => _text12.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get caption => _text12;
  static TextStyle get small => _text12;
  static TextStyle get micro => _text12;

  // --- Special ---

  static TextStyle get smallSectionTitle => _text12.copyWith(
    fontWeight: FontWeight.w500,
    color: const Color(0xFF6B7280),
  );

  static TextStyle get button => _text14.copyWith(fontWeight: FontWeight.w600);

  // --- Semantic Text Styles (for specific UI contexts) ---

  /// Title text - 14px, w600, gray900 (for card headers, section titles)
  static TextStyle get cardTitle => bodyMedium;

  /// Secondary text - 12px, gray500 (for hints, subtitles, exchange rates)
  static TextStyle get secondaryText => _text12.copyWith(
    color: const Color(0xFF6B7280),
  );

  /// Body gray - 14px, gray600 (for secondary body text)
  static TextStyle get bodySecondary => _text14.copyWith(
    color: const Color(0xFF4B5563),
  );

  /// Body gray500 - 14px, gray500 (for placeholder/hint text)
  static TextStyle get bodyTertiary => _text14.copyWith(
    color: const Color(0xFF6B7280),
  );

  /// Total label - 16px, w600, gray900 (for total/subtotal labels)
  static TextStyle get totalLabel => _text16.copyWith(
    fontWeight: FontWeight.w600,
    color: const Color(0xFF111827),
  );

  /// Total value - 16px, w600, gray900 (for total/subtotal values)
  static TextStyle get totalValue => _text16.copyWith(
    fontWeight: FontWeight.w600,
    color: const Color(0xFF111827),
  );

  /// Denomination value - 14px, w600, gray900 (for denomination amounts)
  static TextStyle get denominationValue => _text14.copyWith(
    fontWeight: FontWeight.w600,
    color: const Color(0xFF111827),
  );

  /// Denomination label - 14px, gray700 (for denomination labels)
  static TextStyle get denominationLabel => _text14.copyWith(
    color: const Color(0xFF374151),
  );

  /// Amount zero - 14px, gray400 (for zero/empty amounts)
  static TextStyle get amountZero => _text14.copyWith(
    color: const Color(0xFF9CA3AF),
  );

  /// Sheet title - 20px, w600, gray900 (for bottom sheet headers)
  static TextStyle get sheetTitle => _heading20.copyWith(
    color: const Color(0xFF111827),
  );

  /// List item title - 14px, w500, gray900 (for selectable list items)
  static TextStyle get listItemTitle => _text14.copyWith(
    fontWeight: FontWeight.w500,
    color: const Color(0xFF111827),
  );

  /// List item subtitle - 12px, gray600 (for list item descriptions)
  static TextStyle get listItemSubtitle => _text12.copyWith(
    color: const Color(0xFF4B5563),
  );

  /// Empty state - 14px, gray500 (for empty state messages)
  static TextStyle get emptyState => _text14.copyWith(
    color: const Color(0xFF6B7280),
  );

  /// Link text - 14px, w600, primary (for clickable links)
  static TextStyle get linkText => _text14.copyWith(
    fontWeight: FontWeight.w600,
    color: const Color(0xFF3B82F6),
  );

  /// Input text - 14px, w600, gray900 (for input field values)
  static TextStyle get inputValue => _text14.copyWith(
    fontWeight: FontWeight.w600,
    color: const Color(0xFF111827),
  );

  /// Input hint - 14px, gray400 (for input placeholders)
  static TextStyle get inputHint => _text14.copyWith(
    color: const Color(0xFF9CA3AF),
  );

  /// Grid header - 12px, gray500 (for table/grid headers)
  static TextStyle get gridHeader => _text12.copyWith(
    color: const Color(0xFF6B7280),
  );

  // For amount, we swap the Font Family but keep the size logic if we wanted,
  // but usually Amount is unique enough to define on its own.
  static TextStyle get amount => GoogleFonts.jetBrainsMono(
    fontSize: 20, 
    fontWeight: FontWeight.w600, 
    letterSpacing: -0.5, 
    height: 1.2,
  );

  // --- Deprecated ---

  @Deprecated('Use h1')
  static TextStyle get headlineLarge => h1; // Also points to _heading28 indirectly
  
  @Deprecated('Use label')
  static TextStyle get labelLarge => body;

  @Deprecated('Use caption')
  static TextStyle get labelMedium => caption;
}