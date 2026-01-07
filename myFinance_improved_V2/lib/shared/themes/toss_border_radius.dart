/// Toss Border Radius System
/// Clean, modern corners following Toss design
/// 
/// Key Principle: Subtle roundness for approachability
/// while maintaining professional appearance
class TossBorderRadius {
  TossBorderRadius._();

  // ==================== RADIUS VALUES ====================
  static const double none = 0.0;      // Sharp corners
  static const double xs = 4.0;        // Minimal rounding
  static const double sm = 6.0;        // Small elements (chips)
  static const double md = 8.0;        // Default radius ⭐
  static const double lg = 12.0;       // Cards, containers ⭐
  static const double xl = 16.0;       // Large cards, modals
  static const double xxl = 20.0;      // Bottom sheets top
  static const double xxxl = 24.0;     // Special large elements
  static const double full = 999.0;    // Fully circular
  
  // ==================== COMPONENT SPECIFIC ====================
  
  // Buttons
  static const double button = 8.0;           // Standard button
  static const double buttonSmall = 6.0;      // Small button
  static const double buttonLarge = 10.0;     // Large button
  static const double buttonPill = 999.0;     // Pill button
  
  // Input fields
  static const double input = 8.0;            // Text input ⭐
  static const double inputSmall = 6.0;       // Small input
  static const double inputLarge = 10.0;      // Large input
  
  // Cards & containers
  static const double card = 12.0;            // Card radius ⭐
  static const double cardSmall = 8.0;        // Small card
  static const double cardLarge = 16.0;       // Large card
  
  // Dialogs & sheets
  static const double dialog = 16.0;          // Dialog/modal
  static const double bottomSheet = 20.0;     // Bottom sheet
  static const double dropdown = 8.0;         // Dropdown menu
  
  // Special elements
  static const double chip = 6.0;             // Chip/tag
  static const double badge = 4.0;            // Badge
  static const double avatar = 999.0;         // Avatar (circular)
  static const double thumbnail = 8.0;        // Image thumbnail
  static const double dragHandle = 2.0;       // Bottom sheet drag handle
  static const double indicator = 2.0;        // Progress/rank indicators
  
  // ==================== RESPONSIVE RADIUS ====================
  
  // Adaptive radius based on screen size
  static double adaptive(double baseRadius, {bool isTablet = false}) {
    return isTablet ? baseRadius * 1.25 : baseRadius;
  }
  
  // Corner-specific radius (for asymmetric rounding)
  static const double topRadius = 20.0;       // Top corners only
  static const double bottomRadius = 0.0;     // Bottom corners only
}