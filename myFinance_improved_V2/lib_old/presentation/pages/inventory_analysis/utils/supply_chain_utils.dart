import 'package:flutter/material.dart';
import '../models/supply_chain_models.dart';
import '../../../../core/themes/toss_colors.dart';

/// Shared utility functions for Supply Chain Analytics
/// Prevents code duplication across widgets
class SupplyChainUtils {
  SupplyChainUtils._();

  /// Get English label for supply chain stage
  static String getStageEnglishLabel(SupplyChainStage stage) {
    switch (stage) {
      case SupplyChainStage.order:
        return 'Order';
      case SupplyChainStage.send:
        return 'Send';
      case SupplyChainStage.receive:
        return 'Receive';
      case SupplyChainStage.sell:
        return 'Sell';
    }
  }

  /// Get color for supply chain stage
  static Color getStageColor(SupplyChainStage stage) {
    switch (stage) {
      case SupplyChainStage.order:
        return TossColors.primary;
      case SupplyChainStage.send:
        return TossColors.warning;
      case SupplyChainStage.receive:
        return TossColors.success;
      case SupplyChainStage.sell:
        return TossColors.info;
    }
  }

  /// Get English label for user role
  static String getPersonaEnglishLabel(UserRole role) {
    switch (role) {
      case UserRole.ceo:
        return 'CEO';
      case UserRole.purchasingManager:
        return 'Purchasing Manager';
      case UserRole.storeManager:
        return 'Store Manager';
      case UserRole.analyst:
        return 'Analyst';
    }
  }

  /// Format currency values with appropriate units
  static String formatCurrency(double value) {
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}