import '../entities/sales_product.dart';

/// Invoice calculator for business logic calculations
///
/// Contains all calculation logic related to invoices, prices, and totals.
/// This ensures calculation logic is consistent across the application.
class InvoiceCalculator {
  InvoiceCalculator._();

  /// Calculate total amount from products and quantities
  ///
  /// Parameters:
  /// - [products]: List of sales products
  /// - [quantities]: Map of product ID to quantity
  ///
  /// Returns: Total amount (sum of price * quantity for all products)
  static double calculateTotalAmount(
    List<SalesProduct> products,
    Map<String, int> quantities,
  ) {
    return products.fold(0.0, (total, product) {
      final quantity = quantities[product.productId] ?? 0;
      final price = product.sellingPrice ?? 0.0;
      return total + (price * quantity);
    });
  }

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
