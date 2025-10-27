import '../entities/invoice.dart';

/// Invoice validator for business rules validation
///
/// Validates invoice data against business rules and constraints.
class InvoiceValidator {
  const InvoiceValidator();

  /// Validates invoice entity
  ///
  /// Returns: InvoiceValidationResult with validation status and errors
  InvoiceValidationResult validate(Invoice invoice) {
    final errors = <String>[];

    // Validate invoice number
    if (invoice.invoiceNumber.isEmpty) {
      errors.add('Invoice number cannot be empty');
    }

    // Validate sale date
    final now = DateTime.now();
    if (invoice.saleDate.isAfter(now)) {
      errors.add('Sale date cannot be in the future');
    }

    // Validate status
    final validStatuses = ['completed', 'draft', 'cancelled'];
    if (!validStatuses.contains(invoice.status)) {
      errors.add('Invalid invoice status: ${invoice.status}');
    }

    // Validate amounts
    if (invoice.amounts.totalAmount < 0) {
      errors.add('Total amount cannot be negative');
    }

    if (invoice.amounts.taxAmount < 0) {
      errors.add('Tax amount cannot be negative');
    }

    if (invoice.amounts.discountAmount < 0) {
      errors.add('Discount amount cannot be negative');
    }

    // Validate items summary
    if (invoice.itemsSummary.itemCount <= 0) {
      errors.add('Invoice must have at least one item');
    }

    if (invoice.itemsSummary.totalQuantity <= 0) {
      errors.add('Total quantity must be greater than 0');
    }

    return InvoiceValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validates invoice items for creation
  ///
  /// Parameters:
  /// - [items]: Map of product IDs to quantities
  ///
  /// Returns: InvoiceValidationResult with validation status and errors
  InvoiceValidationResult validateItems(Map<String, int> items) {
    final errors = <String>[];

    // Validate items not empty
    if (items.isEmpty) {
      errors.add('Invoice must have at least one item');
    }

    // Validate each item
    items.forEach((productId, quantity) {
      if (productId.isEmpty) {
        errors.add('Product ID cannot be empty');
      }

      if (quantity <= 0) {
        errors.add('Quantity must be greater than 0 for product: $productId');
      }
    });

    return InvoiceValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// Invoice validation result
class InvoiceValidationResult {
  final bool isValid;
  final List<String> errors;

  const InvoiceValidationResult({
    required this.isValid,
    required this.errors,
  });
}
