import 'package:flutter/material.dart';

/// Toss Design System - Official Color Palette
/// Based on Toss (토스) Korean fintech app's actual design patterns
/// 
/// Core Philosophy:
/// - Minimalist white-dominant interface
/// - Strategic use of Toss Blue (#0064FF)
/// - High contrast for financial clarity
/// - Trust through consistency
class TossColors {
  TossColors._();

  // ==================== BRAND COLORS ====================
  // Toss's signature blue - used strategically for CTAs
  static const Color primary = Color(0xFF0064FF);        // Toss Blue
  static const Color primaryLight = Color(0xFF4D94FF);   // Hover state
  static const Color primaryDark = Color(0xFF0050CC);    // Pressed state
  static const Color primarySurface = Color(0xFFF0F6FF); // Blue tinted bg
  
  // ==================== GRAYSCALE (MAIN UI) ====================
  // Refined grayscale for hierarchy and clarity
  static const Color white = Color(0xFFFFFFFF);          // Pure white
  static const Color gray50 = Color(0xFFF8F9FA);         // Lightest gray
  static const Color gray100 = Color(0xFFF1F3F5);        // Background
  static const Color gray200 = Color(0xFFE9ECEF);        // Border light
  static const Color gray300 = Color(0xFFDEE2E6);        // Border default
  static const Color gray400 = Color(0xFFCED4DA);        // Disabled
  static const Color gray500 = Color(0xFFADB5BD);        // Placeholder
  static const Color gray600 = Color(0xFF6C757D);        // Secondary text
  static const Color gray700 = Color(0xFF495057);        // Body text
  static const Color gray800 = Color(0xFF343A40);        // Heading
  static const Color gray900 = Color(0xFF212529);        // Primary text
  static const Color black = Color(0xFF000000);          // Pure black
  
  // Secondary brand color for subtle accents
  static const Color secondary = Color(0xFF202632);      // Toss Dark Gray
  
  // ==================== SEMANTIC COLORS ====================
  // Financial state indicators
  static const Color success = Color(0xFF00C896);        // Toss Green
  static const Color successLight = Color(0xFFE3FFF4);   // Success bg
  static const Color successDark = Color(0xFF00A67E);    // Success pressed
  
  static const Color error = Color(0xFFFF5847);          // Toss Red
  static const Color errorLight = Color(0xFFFFEFED);     // Error bg
  static const Color errorDark = Color(0xFFE63E2C);      // Error pressed
  
  static const Color warning = Color(0xFFFF9500);        // Toss Orange
  static const Color warningLight = Color(0xFFFFF4E6);   // Warning bg
  static const Color warningDark = Color(0xFFE68600);    // Warning pressed
  
  static const Color info = Color(0xFF0064FF);           // Same as primary
  static const Color infoLight = Color(0xFFF0F6FF);      // Info bg
  
  // ==================== FINANCIAL COLORS ====================
  static const Color profit = Color(0xFF00C896);         // Positive (green)
  static const Color loss = Color(0xFFFF5847);           // Negative (red)
  static const Color neutral = Color(0xFF6C757D);        // No change (gray)
  
  // ==================== SURFACE COLORS ====================
  static const Color background = Color(0xFFFFFFFF);     // Main bg
  static const Color backgroundGray = Color(0xFFF8F9FA); // Section bg
  static const Color surface = Color(0xFFFFFFFF);        // Card surface
  static const Color surfaceHover = Color(0xFFF8F9FA);   // Hover state
  static const Color surfacePressed = Color(0xFFF1F3F5); // Pressed state
  static const Color overlay = Color(0x8A000000);        // Modal overlay
  
  // ==================== BORDER & DIVIDER ====================
  static const Color border = Color(0xFFE9ECEF);         // Default border
  static const Color borderLight = Color(0xFFF1F3F5);    // Subtle border
  static const Color borderDark = Color(0xFFDEE2E6);     // Strong border
  static const Color divider = Color(0xFFE9ECEF);        // List divider
  
  // ==================== TEXT COLORS ====================
  static const Color textPrimary = Color(0xFF212529);    // Main text
  static const Color textSecondary = Color(0xFF6C757D);  // Secondary
  static const Color textTertiary = Color(0xFFADB5BD);   // Hint text
  static const Color textDisabled = Color(0xFFCED4DA);   // Disabled
  static const Color textInverse = Color(0xFFFFFFFF);    // On dark bg
  static const Color textLink = Color(0xFF0064FF);       // Links
  
  // ==================== SPECIAL PURPOSE ====================
  static const Color shimmer = Color(0xFFF1F3F5);        // Loading
  static const Color shimmerHighlight = Color(0xFFE9ECEF); // Loading anim
  static const Color shadow = Color(0x0A000000);         // 4% black
  static const Color focusRing = Color(0xFF0064FF);      // Focus indicator
  static const Color scrollbar = Color(0xFFCED4DA);      // Scrollbar
  static const Color transparent = Color(0x00000000);    // Fully transparent
}