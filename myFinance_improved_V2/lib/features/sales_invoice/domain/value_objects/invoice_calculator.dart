/// Invoice calculator for business logic calculations
///
/// Contains all calculation logic related to invoices, prices, and totals.
/// This ensures calculation logic is consistent across the application.
class InvoiceCalculator {
  InvoiceCalculator._();

  /// Calculate total with discount and tax
  ///
  /// Parameters:
  /// - [subtotal]: Original subtotal amount
  /// - [discountPercentage]: Discount as percentage (0-100)
  /// - [discountAmount]: Fixed discount amount
  /// - [taxAmount]: Tax amount to add
  ///
  /// Returns: Final total after discount and tax
  static double calculateFinalTotal({
    required double subtotal,
    double discountPercentage = 0,
    double discountAmount = 0,
    double taxAmount = 0,
  }) {
    final percentageDiscount = subtotal * discountPercentage / 100;
    final discounted = subtotal - percentageDiscount - discountAmount;
    return discounted + taxAmount;
  }

  /// Calculate discount amount from percentage
  static double calculateDiscountAmount(double subtotal, double percentage) {
    return subtotal * percentage / 100;
  }

  /// Calculate tax amount from rate
  static double calculateTaxAmount(double amount, double taxRate) {
    return amount * taxRate / 100;
  }
}
