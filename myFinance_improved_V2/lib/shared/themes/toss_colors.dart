import 'package:flutter/material.dart';

/// Toss Design System - Refactored 2026
/// 
/// STRATEGY: 
/// - Replaced the complex 10-step gray scale with your "Simple 4" system.
/// - Integrated CSS variable logic (Foreground/Background) into Flutter.
/// - All legacy getters are preserved but mapped to the new simplified core.
class TossColors {
  TossColors._();

  // ==================== 1. THE NEW CORE (Your Simple CSS Theme) ====================
  // These are the "Source of Truth" based on your provided CSS.
  
  // --- The 4 Core Grays ---
  static const Color _lightGrey = Color(0xFFF5F6F7);   // Secondary BG
  static const Color _borderGrey = Color(0xFFF1F3F5);  // Borders
  static const Color _coolGrey = Color(0xFF6B7785);    // Secondary Text
  static const Color _charcoal = Color(0xFF212529);    // Main Text

  // --- Brand Colors (Converted hex alpha to ARGB) ---
  // #0a66ffe8 -> 0xE80A66FF (Primary)
  static const Color _brandBlue = Color(0xE80A66FF); 
  static const Color _accentBlue = Color(0xFFD1E8FF); // Accent

  // --- Semantic Colors ---å
  static const Color _successBase = Color(0xFF7DD3AE); // Pastel Green
  static const Color _successDark = Color(0xFF064E3B); // Dark Green (Foreground)
  
  // #d6453ae5 -> 0xE5D6453A
  static const Color _dangerBase = Color(0xE5D6453A);  // Red
  
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFFFAFBFC);       // Muted BG

  // ==================== 2. LEGACY ADAPTER (The Bridge) ====================
  // Mapping old complex names to the new simple core.

  // --- BRAND ---
  static const Color primary = _brandBlue;
  static const Color primarySurface = _accentBlue; // Mapped to new accent

  // --- GRAYSCALE (The Great Simplification) ---
  
  // Backgrounds map to White or Light Grey
  static const Color white = _white;
  static const Color gray50 = _muted;       // Was F8F9FA -> Now FAFBFC
  static const Color gray100 = _lightGrey;  // Was F1F3F5 -> Now F5F6F7

  // Borders map to your single "Border Grey"
  static const Color gray200 = _borderGrey;
  static const Color gray300 = _borderGrey; // Consolidated

  // Secondary Text maps to "Cool Grey"
  static const Color gray400 = _coolGrey;   // Consolidated
  static const Color gray500 = _coolGrey;
  static const Color gray600 = _coolGrey;

  // Primary Text maps to "Dark Charcoal"
  static const Color gray700 = _charcoal;
  static const Color gray800 = _charcoal;
  static const Color gray900 = _charcoal;   // Consolidated
  
  static const Color black = Color(0xFF000000);
  static const Color black87 = Color(0xDD000000);
  static const Color black54 = Color(0x5C000000); // 36% opacity black for overlays

  // --- SEMANTIC COLORS ---
  
  // Success
  static const Color success = _successBase;
  static const Color successLight = Color(0xFFE6F7F1); // Generated light var from _successBase
  
  // Error (Destructive)
  static const Color error = _dangerBase;
  static const Color errorLight = Color(0xFFFDEDEC);   // Generated light var from _dangerBase

  // Warning (Mapped to Danger as per your CSS)
  // Your CSS says: --warning: #d6453a (Same as destructive)
  static const Color warning = _dangerBase; 
  static const Color warningLight = errorLight; 

  // Info (Keep as Primary)
  static const Color info = _brandBlue;
  static const Color infoLight = _accentBlue;

  // --- FINANCIAL COLORS ---
  // Critical: For text (Profit/Loss), we use the darker "Foreground" variants 
  // to ensure readability against white backgrounds.
  
  static const Color profit = _successDark; // #064e3b (Readable Green)
  static const Color loss = _dangerBase;    // #d6453a (Readable Red)

  // --- SURFACE COLORS ---
  static const Color background = _white;
  static const Color surface = _white;
  static const Color overlay = Color(0x80000000);

  // --- BORDER & DIVIDER ---
  static const Color border = _borderGrey;
  static const Color borderLight = _muted;

  // --- TEXT COLORS ---
  static const Color textPrimary = _charcoal;   // #212529
  static const Color textSecondary = _coolGrey; // #6b7785
  static const Color textTertiary = _coolGrey;  // Consolidated
  static const Color textInverse = _white;

  // --- SPECIAL PURPOSE ---
  static const Color shimmer = _lightGrey;
  static const Color shadow = Color(0x0A000000);
  static const Color transparent = Color(0x00000000);

  // --- EXTENDED COLORS (Simplified Mappings) ---
  // We map these to the closest new logic or keep distinct if necessary.
  // Since your new theme is strict, we will try to route them to brand colors where possible,
  // but keep the specific hues for charts.

  // Purple (Kept for charts/AI)
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFEDE9FE);
  static const Color purpleSurface = Color(0xFFF5F3FF);
  static const Color purpleDark = Color(0xFF6366F1);
  static const Color violet = Color(0xFF8B5CF6);

  // Emerald/Teal (Mapped to Success)
  static const Color emerald = _successBase;
  static const Color emeraldLight = successLight;
  static const Color emeraldDark = _successDark;
  static const Color teal = Color(0xFF00BCD4);

  // Amber/Orange (Kept for charts)
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color amberDark = Color(0xFFD97706);

  // Red variants (Mapped to Danger)
  static const Color red = _dangerBase;
  static const Color redLight = errorLight;
  static const Color redLighter = errorLight;
  static const Color redDark = _dangerBase;
  static const Color redDarker = _dangerBase;

  // Categories (Kept distinct for charts)
  static const Color categoryPurple = purple;
  static const Color categoryOrange = amber;
  static const Color categoryGray = _coolGrey;
  static const Color categoryCyan = teal;

  // --- EXTENDED SEMANTIC SURFACES ---
  // Mapped to your "Muted" or "Accent" concepts
  
  static const Color yellowSurface = amberLight;
  static const Color yellowBorder = amber;
  static const Color yellowLight = amberLight;

  static const Color greenSurface = successLight;
  static const Color greenBorder = _successBase;
  static const Color greenDark = _successDark;

  static const Color blueSurface = _accentBlue;
  static const Color blueBorder = _accentBlue;
  static const Color blueText = _brandBlue;

  static const Color redSurface = errorLight;
  static const Color redBorder = _dangerBase;

  static const Color amberSurface = amberLight;
  static const Color amberBorder = amber;
  static const Color amberText = amberDark;
}