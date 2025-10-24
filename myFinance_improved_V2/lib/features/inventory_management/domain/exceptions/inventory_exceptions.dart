// Domain Exceptions: Inventory Management
// Custom exceptions for inventory operations

/// Base exception for inventory domain
abstract class InventoryException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const InventoryException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'InventoryException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Product not found exception
class ProductNotFoundException extends InventoryException {
  ProductNotFoundException({
    required String productId,
  }) : super(
          message: 'Product not found',
          code: 'PRODUCT_NOT_FOUND',
          details: {'productId': productId},
        );
}

/// Invalid product data exception
class InvalidProductDataException extends InventoryException {
  InvalidProductDataException({
    required String field,
    required String reason,
  }) : super(
          message: 'Invalid product data',
          code: 'INVALID_PRODUCT_DATA',
          details: {'field': field, 'reason': reason},
        );
}

/// Duplicate SKU exception
class DuplicateSKUException extends InventoryException {
  DuplicateSKUException({
    required String sku,
  }) : super(
          message: 'SKU already exists',
          code: 'DUPLICATE_SKU',
          details: {'sku': sku},
        );
}

/// Insufficient stock exception
class InsufficientStockException extends InventoryException {
  InsufficientStockException({
    required String productId,
    required int requested,
    required int available,
  }) : super(
          message: 'Insufficient stock',
          code: 'INSUFFICIENT_STOCK',
          details: {
            'productId': productId,
            'requested': requested,
            'available': available,
          },
        );
}

/// Category not found exception
class CategoryNotFoundException extends InventoryException {
  CategoryNotFoundException({
    required String categoryId,
  }) : super(
          message: 'Category not found',
          code: 'CATEGORY_NOT_FOUND',
          details: {'categoryId': categoryId},
        );
}

/// Brand not found exception
class BrandNotFoundException extends InventoryException {
  BrandNotFoundException({
    required String brandId,
  }) : super(
          message: 'Brand not found',
          code: 'BRAND_NOT_FOUND',
          details: {'brandId': brandId},
        );
}

/// Connection exception
class InventoryConnectionException extends InventoryException {
  InventoryConnectionException({
    required super.message,
    super.details,
  }) : super(
          code: 'CONNECTION_ERROR',
        );
}

/// Repository exception
class InventoryRepositoryException extends InventoryException {
  InventoryRepositoryException({
    required super.message,
    super.code = 'REPOSITORY_ERROR',
    super.details,
  });
}

/// Validation exception
class InventoryValidationException extends InventoryException {
  InventoryValidationException({
    required super.message,
    required Map<String, String> errors,
  }) : super(
          code: 'VALIDATION_ERROR',
          details: errors,
        );
}

/// Permission denied exception
class InventoryPermissionDeniedException extends InventoryException {
  InventoryPermissionDeniedException({
    required String operation,
  }) : super(
          message: 'Permission denied',
          code: 'PERMISSION_DENIED',
          details: {'operation': operation},
        );
}
