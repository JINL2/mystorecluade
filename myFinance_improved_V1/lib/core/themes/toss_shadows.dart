import 'package:flutter/material.dart';
import 'toss_colors.dart';
import 'package:myfinance_improved/core/themes/index.dart';

/// Toss Shadow System - Ultra-subtle depth
/// Based on Toss's minimal shadow approach
/// 
/// Design Philosophy:
/// - Almost imperceptible shadows (2-4% opacity)
/// - Create depth through borders and colors, not shadows
/// - Shadows only for floating elements
class TossShadows {
  TossShadows._();

  // ==================== ELEVATION LEVELS ====================
  // Toss uses extremely subtle shadows
  
  // No shadow (flat)
  static const List<BoxShadow> none = [];

  // Level 1 - Barely visible (cards on background)
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: TossColors.shadow, // 4% black
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Level 2 - Subtle lift (hover state)
  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Level 3 - Noticeable (dropdowns, popovers)
  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Level 4 - Prominent (modals, dialogs)
  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // ==================== COMPONENT SHADOWS ====================
  
  // Card shadow - Ultra subtle
  static const List<BoxShadow> card = [
    BoxShadow(
      color: TossColors.shadow, // 4% black
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Button shadow - Only on hover/press
  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x0D0064FF), // 5% primary color
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Bottom sheet - Upward shadow
  static const List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      offset: Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Floating action button
  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x1A0064FF), // 10% primary
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Dropdown menu
  static const List<BoxShadow> dropdown = [
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Navigation bar (top or bottom)
  static const List<BoxShadow> navbar = [
    BoxShadow(
      color: TossColors.shadow, // 4% black
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  // ==================== SPECIAL EFFECTS ====================
  
  // Inner shadow (inset)
  static const List<BoxShadow> inset = [
    BoxShadow(
      color: TossColors.shadow, // 4% black
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: -1,
    ),
  ];

  // Glow effect (for focus states)
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x330064FF), // 20% primary
      offset: Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 2,
    ),
  ];

  // Text shadow (for overlays)
  static const Shadow textShadow = Shadow(
    color: Color(0x33000000), // 20% black
    offset: Offset(0, 1),
    blurRadius: 2,
  );

  // ==================== DYNAMIC SHADOWS ====================
  
  // Create custom shadow with opacity
  static List<BoxShadow> custom({
    double opacity = 0.04,
    Offset offset = const Offset(0, 2),
    double blurRadius = 8,
    double spreadRadius = 0,
    Color? color,
  }) {
    return [
      BoxShadow(
        color: color ?? TossColors.black.withValues(alpha: opacity),
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ];
  }
}