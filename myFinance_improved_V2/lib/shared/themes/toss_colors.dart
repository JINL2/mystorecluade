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
  static const Color primary = Color(0xFF0064FF);        // Toss Blue (436 uses)
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
  static const Color black87 = Color(0xDD000000);         // 87% opacity black
  static const Color black54 = Color(0x8A000000);         // 54% opacity black
  
  
  // ==================== SEMANTIC COLORS ====================
  // Financial state indicators
  static const Color success = Color(0xFF00C896);        // Toss Green
  static const Color successLight = Color(0xFFE3FFF4);   // Success bg
  
  static const Color error = Color(0xFFFF5847);          // Toss Red
  static const Color errorLight = Color(0xFFFFEFED);     // Error bg
  
  static const Color warning = Color(0xFFFF9500);        // Toss Orange
  static const Color warningLight = Color(0xFFFFF4E6);   // Warning bg
  
  static const Color info = Color(0xFF0064FF);           // Same as primary
  static const Color infoLight = Color(0xFFF0F6FF);      // Info bg
  
  // ==================== FINANCIAL COLORS ====================
  static const Color profit = Color(0xFF00C896);         // Positive (green) - same as success
  static const Color loss = Color(0xFFFF5847);           // Negative (red) - same as error
  
  // ==================== SURFACE COLORS ====================
  static const Color background = Color(0xFFFFFFFF);     // Main bg (white)
  static const Color surface = Color(0xFFFFFFFF);        // Card surface (white)
  static const Color overlay = Color(0x80000000);        // Modal overlay
  
  // ==================== BORDER & DIVIDER ====================
  static const Color border = Color(0xFFE9ECEF);         // Default border
  static const Color borderLight = Color(0xFFF1F3F5);    // Subtle border
  
  // ==================== TEXT COLORS ====================
  static const Color textPrimary = Color(0xFF212529);    // Main text
  static const Color textSecondary = Color(0xFF6C757D);  // Secondary
  static const Color textTertiary = Color(0xFFADB5BD);   // Hint text
  static const Color textInverse = Color(0xFFFFFFFF);    // On dark bg (white)
  
  // ==================== SPECIAL PURPOSE ====================
  static const Color shimmer = Color(0xFFF1F3F5);        // Loading
  static const Color shadow = Color(0x0A000000);         // 4% black
  static const Color transparent = Color(0x00000000);    // Fully transparent

  // ==================== EXTENDED COLORS ====================
  // Additional colors for reports, charts, and special UI elements

  // Purple palette (AI insights, special features)
  static const Color purple = Color(0xFF7C3AED);         // Primary purple
  static const Color purpleLight = Color(0xFFEDE9FE);    // Purple background
  static const Color purpleSurface = Color(0xFFF5F3FF);  // Purple surface
  static const Color purpleDark = Color(0xFF6366F1);     // Indigo variant
  static const Color violet = Color(0xFF8B5CF6);         // Violet variant

  // Emerald/Teal palette (Success variant)
  static const Color emerald = Color(0xFF10B981);        // Emerald green
  static const Color emeraldLight = Color(0xFFD1FAE5);   // Emerald background
  static const Color emeraldDark = Color(0xFF059669);    // Dark emerald
  static const Color teal = Color(0xFF00BCD4);           // Teal/Cyan

  // Amber/Orange palette (Warning variants)
  static const Color amber = Color(0xFFF59E0B);          // Amber
  static const Color amberLight = Color(0xFFFEF3C7);     // Amber background
  static const Color amberDark = Color(0xFFD97706);      // Dark amber

  // Red palette (Error variants)
  static const Color red = Color(0xFFDC2626);            // Standard red
  static const Color redLight = Color(0xFFFEE2E2);       // Red background
  static const Color redLighter = Color(0xFFFECACA);     // Lighter red bg
  static const Color redDark = Color(0xFFB91C1C);        // Dark red
  static const Color redDarker = Color(0xFF991B1B);      // Darker red text

  // Category colors (for charts, reports)
  static const Color categoryPurple = Color(0xFF9C27B0); // Purple category
  static const Color categoryOrange = Color(0xFFFF5722); // Orange category
  static const Color categoryGray = Color(0xFF607D8B);   // Gray category
  static const Color categoryCyan = Color(0xFF00BCD4);   // Cyan category

  // ==================== EXTENDED SEMANTIC SURFACES ====================
  // Additional surface/background colors for status states

  // Yellow/Warning extended palette
  static const Color yellowSurface = Color(0xFFFEFCE8);  // Light yellow surface
  static const Color yellowBorder = Color(0xFFFEF08A);   // Yellow border
  static const Color yellowLight = Color(0xFFFDE68A);    // Light yellow

  // Green/Success extended palette
  static const Color greenSurface = Color(0xFFF0FDF4);   // Light green surface
  static const Color greenBorder = Color(0xFFBBF7D0);    // Green border
  static const Color greenDark = Color(0xFF166534);      // Dark green text

  // Blue/Info extended palette
  static const Color blueSurface = Color(0xFFF0F9FF);    // Light blue surface
  static const Color blueBorder = Color(0xFFBAE6FD);     // Blue border
  static const Color blueText = Color(0xFF0284C7);       // Blue text

  // Red/Error extended palette (additional)
  static const Color redSurface = Color(0xFFFEF2F2);     // Light red surface
  static const Color redBorder = Color(0xFFFECACA);      // Red border (same as redLighter)

  // Amber extended palette (additional)
  static const Color amberSurface = Color(0xFFFEFCE8);   // Amber surface (same as yellowSurface)
  static const Color amberBorder = Color(0xFFFEF08A);    // Amber border (same as yellowBorder)
  static const Color amberText = Color(0xFF92400E);      // Amber dark text

}