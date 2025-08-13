import 'package:flutter/material.dart';

/// Toss-style color system with OKLCH-based colors
class TossColors {
  // Private constructor
  TossColors._();

  // Brand Colors (Toss Blue)
  static const Color primary = Color(0xFF0066FF);      // Toss signature blue
  static const Color primaryLight = Color(0xFF4D94FF);
  static const Color primaryDark = Color(0xFF0052CC);

  // Error (from your OKLCH)
  static const Color error = Color(0xFFEF4444);        // oklch(0.6368 0.2078 25.3313)

  // Background
  static const Color background = Color(0xFFFFFFFF);   // Pure white
  static const Color surface = Color(0xFFFBFBFB);      // Slight gray

  // Gray Scale (Toss-style)
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);

  // Semantic Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Financial Indicators
  static const Color profit = Color(0xFF22C55E);
  static const Color loss = Color(0xFFEF4444);
  static const Color neutral = Color(0xFF737373);

  // Special
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E5E5);
  static const Color link = Color(0xFF3B82F6);
}