import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import '../models/counter_party_models.dart';

/// MINIMAL Counter Party Type Colors - True Toss Design Philosophy
/// 
/// Design Principle: "Purposeful Color, Not Decorative Color"
/// - Single accent color (Toss Blue) for primary importance
/// - Neutral gray scale for visual hierarchy without noise
/// - Colors serve function, not decoration
/// 
/// This creates a calm, professional, trust-building interface
class CounterPartyColors {
  CounterPartyColors._();

  // MINIMAL Toss Design: Single accent color + consistent neutral gray
  // Follows Toss principle: purposeful color, not decorative color
  static const Color myCompany = TossColors.primary;       // Toss Blue (primary action)
  static const Color teamMember = TossColors.gray600;      // Consistent Gray
  static const Color supplier = TossColors.gray600;        // Consistent Gray
  static const Color employee = TossColors.gray600;        // Consistent Gray
  static const Color customer = TossColors.gray600;        // Consistent Gray
  static const Color other = TossColors.gray600;           // Consistent Gray
  
  /// Get color for a specific counter party type
  static Color getTypeColor(CounterPartyType type) {
    switch (type) {
      case CounterPartyType.myCompany:
        return myCompany;
      case CounterPartyType.teamMember:
        return teamMember;
      case CounterPartyType.supplier:
        return supplier;
      case CounterPartyType.employee:
        return employee;
      case CounterPartyType.customer:
        return customer;
      case CounterPartyType.other:
        return other;
    }
  }
  
  /// Get icon for a specific counter party type
  /// Uses consistent outlined icons for better visual coherence
  static IconData getTypeIcon(CounterPartyType type) {
    switch (type) {
      case CounterPartyType.myCompany:
        return Icons.business_outlined;
      case CounterPartyType.teamMember:
        return Icons.group_outlined;
      case CounterPartyType.supplier:
        return Icons.local_shipping_outlined;
      case CounterPartyType.employee:
        return Icons.badge_outlined;
      case CounterPartyType.customer:
        return Icons.people_outlined;
      case CounterPartyType.other:
        return Icons.category_outlined;
    }
  }
}