import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Toss Typography System - Based on 4px Grid
/// Font: Inter (primary), SF Pro (iOS), Roboto (Android)
/// 
/// Design Principles:
/// - Bold contrast for hierarchy
/// - Generous line-height for readability
/// - Consistent 4px vertical rhythm
class TossTextStyles {
  TossTextStyles._();

  // Font families
  static const String fontFamily = 'Inter';
  static const String fontFamilyKR = 'Pretendard';  // Korean font
  static const String fontFamilyMono = 'JetBrains Mono';  // Numbers

  // ==================== DISPLAY & HEADINGS ====================
  
  // Display - Hero sections (32px/40px)
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,  // Extra bold for impact
    letterSpacing: -0.02,
    height: 1.25,  // 40px line height
  );

  // H1 - Page titles (28px/36px)
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,  // Bold
    letterSpacing: -0.01,
    height: 1.286,  // 36px line height
  );

  // H2 - Section headers (24px/32px)
  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,  // Bold
    letterSpacing: -0.01,
    height: 1.333,  // 32px line height
  );

  // H3 - Subsection headers (20px/28px)
  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,  // Semibold
    letterSpacing: 0,
    height: 1.4,  // 28px line height
  );

  // H4 - Card titles (18px/24px)
  static TextStyle get h4 => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,  // Semibold
    letterSpacing: 0,
    height: 1.333,  // 24px line height
  );

  // ==================== BODY TEXT ====================
  
  // Body Large - Important content (16px/24px)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0,
    height: 1.5,  // 24px line height
  );

  // Body - Default text (14px/20px)
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0,
    height: 1.429,  // 20px line height
  );

  // Body Small - Secondary text (13px/18px)
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0,
    height: 1.385,  // 18px line height
  );

  // ==================== UI LABELS ====================
  
  // Button - CTA text (14px/20px)
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,  // Semibold
    letterSpacing: 0.02,
    height: 1.429,  // 20px line height
  );

  // Label Large - Form labels (14px/20px)
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,  // Medium
    letterSpacing: 0,
    height: 1.429,  // 20px line height
  );

  // Label - UI labels (12px/16px)
  static TextStyle get label => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,  // Medium
    letterSpacing: 0.01,
    height: 1.333,  // 16px line height
  );

  // Caption - Helper text (12px/16px)
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0.01,
    height: 1.333,  // 16px line height
  );

  // Small - Tiny text (11px/16px)
  static TextStyle get small => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0.02,
    height: 1.455,  // 16px line height
  );

  // Micro - Ultra small text (10px/12px)
  static TextStyle get micro => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0.03,
    height: 1.2,  // 12px line height
  );

  // Tiny - Very small text (9px/12px)  
  static TextStyle get tiny => GoogleFonts.inter(
    fontSize: 9,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0.03,
    height: 1.333,  // 12px line height
  );

  // Mini - Smallest readable text (8px/12px)
  static TextStyle get mini => GoogleFonts.inter(
    fontSize: 8,
    fontWeight: FontWeight.w400,  // Regular
    letterSpacing: 0.04,
    height: 1.5,  // 12px line height
  );

  // Subtitle - Between body and heading (15px/20px)
  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,  // Medium
    letterSpacing: 0,
    height: 1.333,  // 20px line height
  );

  // Hero - Large display text (48px/52px)
  static TextStyle get hero => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w800,  // Extra bold
    letterSpacing: -0.03,
    height: 1.083,  // 52px line height
  );

  // ==================== FINANCIAL STYLES ====================
  
  // Amount - Money display (20px/24px) - Keep for financial numbers
  static TextStyle get amount => GoogleFonts.jetBrainsMono(
    fontSize: 20,
    fontWeight: FontWeight.w600,  // Semibold
    letterSpacing: -0.01,
    height: 1.2,  // 24px line height
  );

  // ==================== SPECIAL STYLES ====================
  // (Removed unused link and code styles)
}