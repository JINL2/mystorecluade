/// Toss Spacing System - Strict 4px Grid
/// Based on Toss's actual spacing implementation
/// 
/// Core Principle: All spacing is a multiple of 4px
/// This creates visual rhythm and consistency
class TossSpacing {
  TossSpacing._();

  // ==================== BASE SPACING (4px grid) ====================
  static const double space0 = 0.0;    // No spacing
  static const double space1 = 4.0;    // Minimum spacing
  static const double space2 = 8.0;    // Tight spacing (2x base)
  static const double space3 = 12.0;   // Small spacing (3x base)
  static const double space4 = 16.0;   // Default spacing (4x base) ⭐
  static const double space5 = 20.0;   // Medium spacing (5x base)
  static const double space6 = 24.0;   // Large spacing (6x base) ⭐
  static const double space7 = 28.0;   // Extra spacing (7x base)
  static const double space8 = 32.0;   // Section spacing (8x base)
  static const double space9 = 36.0;   // Content spacing (9x base)
  static const double space10 = 40.0;  // Block spacing (10x base)
  static const double space12 = 48.0;  // Container spacing (12x base)
  static const double space14 = 56.0;  // Large block (14x base)
  static const double space16 = 64.0;  // Page section (16x base)
  static const double space18 = 72.0;  // Extended spacing (18x base)
  static const double space20 = 80.0;  // Major section (20x base)
  static const double space24 = 96.0;  // Hero spacing (24x base)
  
  // Micro spacing (for borders and fine details)
  static const double micro = 1.0;     // 1px borders
  static const double tiny = 2.0;      // 2px fine spacing
  static const double minimal = 6.0;   // Between space1 and space2

  // ==================== COMPONENT SPACING ====================
  // Common spacing patterns in Toss components
  
  // Padding inside components
  static const double paddingXS = 8.0;   // Small buttons, chips
  static const double paddingSM = 12.0;  // Input fields
  static const double paddingMD = 16.0;  // Cards, list items ⭐
  static const double paddingLG = 20.0;  // Sections
  static const double paddingXL = 24.0;  // Page padding ⭐
  
  // Margins between components
  static const double marginXS = 4.0;    // Between inline elements
  static const double marginSM = 8.0;    // Between related items
  static const double marginMD = 16.0;   // Between components ⭐
  static const double marginLG = 24.0;   // Between sections
  static const double marginXL = 32.0;   // Between major sections
  
  // Gaps in flex layouts
  static const double gapXS = 4.0;       // Icon-text gap
  static const double gapSM = 8.0;       // Button content gap
  static const double gapMD = 12.0;      // Form field gap
  static const double gapLG = 16.0;      // Card content gap
  static const double gapXL = 24.0;      // Section gap
  
  // ==================== LAYOUT SPACING ====================
  
  // Screen padding (safe area)
  static const double screenPaddingMobile = 16.0;   // Mobile screens
  static const double screenPaddingTablet = 24.0;   // Tablet screens
  static const double screenPaddingDesktop = 32.0;  // Desktop screens
  
  // Content width constraints
  static const double contentMaxWidth = 640.0;      // Max content width
  static const double cardMaxWidth = 480.0;         // Max card width
  
  // ==================== SPECIAL SPACING ====================
  
  // Icon sizes (also follow 4px grid)
  static const double iconXS = 16.0;     // Small icons
  static const double iconSM = 20.0;     // Default icons
  static const double iconMD = 24.0;     // Medium icons ⭐
  static const double iconLG = 32.0;     // Large icons
  static const double iconXL = 40.0;     // Extra large
  
  // Button heights
  static const double buttonHeightSM = 32.0;   // Small button
  static const double buttonHeightMD = 40.0;   // Medium button
  static const double buttonHeightLG = 48.0;   // Large button ⭐
  static const double buttonHeightXL = 56.0;   // Extra large
  
  // Input field heights
  static const double inputHeightSM = 36.0;    // Small input
  static const double inputHeightMD = 44.0;    // Medium input
  static const double inputHeightLG = 48.0;    // Large input ⭐
  static const double inputHeightXL = 56.0;    // Extra large
}