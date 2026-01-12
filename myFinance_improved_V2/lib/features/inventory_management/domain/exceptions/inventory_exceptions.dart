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

/// Attribute exception for attribute creation/update errors
class InventoryAttributeException extends InventoryException {
  final String errorCode;

  InventoryAttributeException({
    required super.message,
    required this.errorCode,
    super.details,
  }) : super(code: errorCode);

  bool get isDuplicateName => errorCode == 'DUPLICATE_ATTRIBUTE_NAME';
  bool get isDuplicateOptionValue => errorCode == 'DUPLICATE_OPTION_VALUE';
  bool get isInvalidOptionsFormat => errorCode == 'INVALID_OPTIONS_FORMAT';
}

