// Presentation Extension: InvoiceStatus & PaymentStatus Display
// Provides display-related properties (color, icon) for status enums
// Keeps Domain layer pure by moving UI concerns to Presentation

import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../domain/enums/invoice_status.dart';

// Re-export domain types for convenience
export '../../domain/enums/invoice_status.dart';

/// Extension to provide UI display properties for InvoiceStatus
extension InvoiceStatusDisplay on InvoiceStatus {
  /// Get color for status (UI concern)
  Color get color {
    switch (this) {
      case InvoiceStatus.completed:
        return TossColors.success;
      case InvoiceStatus.draft:
        return TossColors.gray500;
      case InvoiceStatus.cancelled:
        return TossColors.error;
    }
  }

  /// Get icon for status (UI concern)
  IconData get icon {
    switch (this) {
      case InvoiceStatus.completed:
        return Icons.check_circle;
      case InvoiceStatus.draft:
        return Icons.edit;
      case InvoiceStatus.cancelled:
        return Icons.cancel;
    }
  }
}

/// Extension to provide UI display properties for PaymentStatus
extension PaymentStatusDisplay on PaymentStatus {
  /// Get color for payment status (UI concern)
  Color get color {
    switch (this) {
      case PaymentStatus.paid:
        return TossColors.success;
      case PaymentStatus.pending:
        return TossColors.warning;
      case PaymentStatus.partial:
        return TossColors.primary;
      case PaymentStatus.cancelled:
        return TossColors.error;
    }
  }

  /// Get icon for payment status (UI concern)
  IconData get icon {
    switch (this) {
      case PaymentStatus.paid:
        return Icons.check_circle;
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.partial:
        return Icons.payments;
      case PaymentStatus.cancelled:
        return Icons.cancel;
    }
  }
}
