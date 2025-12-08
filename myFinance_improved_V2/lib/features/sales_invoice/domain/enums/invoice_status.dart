/// Invoice status enum
///
/// Represents the lifecycle status of an invoice.
/// Note: UI display properties (color, icon) are in presentation/extensions/invoice_status_extension.dart
enum InvoiceStatus {
  completed('completed', 'Completed'),
  draft('draft', 'Draft'),
  cancelled('cancelled', 'Cancelled');

  const InvoiceStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Create InvoiceStatus from string value
  static InvoiceStatus fromString(String value) {
    return InvoiceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => InvoiceStatus.completed,
    );
  }
}

/// Payment status enum
///
/// Represents the payment status of an invoice.
/// Note: UI display properties (color, icon) are in presentation/extensions/invoice_status_extension.dart
enum PaymentStatus {
  paid('paid', 'Paid'),
  pending('pending', 'Pending'),
  partial('partial', 'Partial'),
  cancelled('cancelled', 'Cancelled');

  const PaymentStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  /// Create PaymentStatus from string value
  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}
