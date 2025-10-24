import '../repositories/product_repository.dart';

/// Use case for creating a new sales invoice
///
/// Orchestrates invoice creation with validation and business rules.
/// Contains business logic for invoice creation process.
class CreateInvoiceUseCase {
  final ProductRepository _productRepository;

  const CreateInvoiceUseCase({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  /// Executes the create invoice use case
  ///
  /// Parameters:
  /// - [companyId]: Company ID
  /// - [storeId]: Store ID
  /// - [userId]: User ID creating the invoice
  /// - [saleDate]: Sale date
  /// - [items]: List of invoice items
  /// - [paymentMethod]: Payment method
  /// - [discountAmount]: Optional discount amount
  /// - [taxRate]: Optional tax rate
  /// - [notes]: Optional notes
  ///
  /// Returns: CreateInvoiceResult with success status and invoice details
  Future<CreateInvoiceResult> execute({
    required String companyId,
    required String storeId,
    required String userId,
    required DateTime saleDate,
    required List<InvoiceItem> items,
    required String paymentMethod,
    double? discountAmount,
    double? taxRate,
    String? notes,
  }) async {
    // Validate input parameters
    if (companyId.isEmpty) {
      throw ArgumentError('Company ID cannot be empty');
    }

    if (storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    if (items.isEmpty) {
      throw ArgumentError('Invoice must have at least one item');
    }

    if (paymentMethod.isEmpty) {
      throw ArgumentError('Payment method cannot be empty');
    }

    // Validate item quantities
    for (final item in items) {
      if (item.quantity <= 0) {
        throw ArgumentError('Item quantity must be greater than 0');
      }
    }

    // Create invoice via repository
    final result = await _productRepository.createInvoice(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      saleDate: saleDate,
      items: items,
      paymentMethod: paymentMethod,
      discountAmount: discountAmount,
      taxRate: taxRate,
      notes: notes,
    );

    return result;
  }
}
