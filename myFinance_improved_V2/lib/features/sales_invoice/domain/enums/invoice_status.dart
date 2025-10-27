import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';

/// Invoice status enum
///
/// Represents the lifecycle status of an invoice.
enum InvoiceStatus {
  completed('completed', 'Completed'),
  draft('draft', 'Draft'),
  cancelled('cancelled', 'Cancelled');

  const InvoiceStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Get color for status
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

  /// Create InvoiceStatus from string value
  static InvoiceStatus fromString(String value) {
    return InvoiceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => InvoiceStatus.completed,
    );
  }

  /// Get icon for status
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

/// Payment status enum
///
/// Represents the payment status of an invoice.
enum PaymentStatus {
  paid('paid', 'Paid'),
  pending('pending', 'Pending'),
  partial('partial', 'Partial'),
  cancelled('cancelled', 'Cancelled');

  const PaymentStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Get color for payment status
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

  /// Create PaymentStatus from string value
  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }

  /// Get icon for payment status
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
