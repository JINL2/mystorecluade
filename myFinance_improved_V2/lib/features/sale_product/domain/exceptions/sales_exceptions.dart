/// Base exception for sales domain
abstract class SalesException implements Exception {
  final String message;
  final String? code;

  const SalesException(this.message, [this.code]);

  @override
  String toString() => 'SalesException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception when no company or store is selected
class NoCompanyOrStoreSelectedException extends SalesException {
  const NoCompanyOrStoreSelectedException()
      : super('Please select a company and store first', 'NO_COMPANY_STORE');
}

/// Exception when products failed to load
class ProductsLoadFailedException extends SalesException {
  const ProductsLoadFailedException([String? message])
      : super(message ?? 'Failed to load products', 'LOAD_FAILED');
}

/// Exception when product is out of stock
class ProductOutOfStockException extends SalesException {
  final String productId;

  const ProductOutOfStockException(this.productId)
      : super('Product is out of stock', 'OUT_OF_STOCK');
}

/// Exception when insufficient stock
class InsufficientStockException extends SalesException {
  final String productId;
  final int requested;
  final int available;

  const InsufficientStockException({
    required this.productId,
    required this.requested,
    required this.available,
  }) : super(
          'Insufficient stock: requested $requested, available $available',
          'INSUFFICIENT_STOCK',
        );
}

/// Exception when validation fails
class ValidationException extends SalesException {
  const ValidationException(String message)
      : super(message, 'VALIDATION_ERROR');
}
