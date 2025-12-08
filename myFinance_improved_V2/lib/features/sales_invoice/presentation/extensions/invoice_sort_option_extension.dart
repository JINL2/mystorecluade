// Presentation Extension: InvoiceSortOption Display
// Provides display-related properties (displayName, icon) for sort options
// Keeps Domain layer pure by moving UI concerns to Presentation

import 'package:flutter/material.dart';
import '../../domain/value_objects/invoice_sort_option.dart';

// Re-export domain type for convenience
export '../../domain/value_objects/invoice_sort_option.dart';

/// Extension to provide UI display properties for InvoiceSortOption
extension InvoiceSortOptionDisplay on InvoiceSortOption {
  /// Display name for UI
  String get displayName {
    switch (this) {
      case InvoiceSortOption.date:
        return 'Date';
      case InvoiceSortOption.invoiceId:
        return 'Invoice ID';
      case InvoiceSortOption.user:
        return 'Customer';
      case InvoiceSortOption.products:
        return 'Products';
      case InvoiceSortOption.amount:
        return 'Amount';
    }
  }

  /// Icon for UI
  IconData get icon {
    switch (this) {
      case InvoiceSortOption.date:
        return Icons.calendar_today;
      case InvoiceSortOption.invoiceId:
        return Icons.tag;
      case InvoiceSortOption.user:
        return Icons.person;
      case InvoiceSortOption.products:
        return Icons.inventory_2;
      case InvoiceSortOption.amount:
        return Icons.attach_money;
    }
  }
}
