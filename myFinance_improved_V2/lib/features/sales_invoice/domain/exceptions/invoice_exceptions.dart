/// Base exception for invoice feature
class InvoiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  InvoiceException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'InvoiceException: $message';
}

/// Exception for network/server errors
class InvoiceNetworkException extends InvoiceException {
  InvoiceNetworkException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'InvoiceNetworkException: $message';
}

/// Exception for data parsing errors
class InvoiceDataException extends InvoiceException {
  InvoiceDataException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'InvoiceDataException: $message';
}

/// Exception for not found errors
class InvoiceNotFoundException extends InvoiceException {
  InvoiceNotFoundException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'InvoiceNotFoundException: $message';
}

/// Exception for validation errors
class InvoiceValidationException extends InvoiceException {
  InvoiceValidationException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'InvoiceValidationException: $message';
}

/// Exception for business logic errors
class InvoiceBusinessException extends InvoiceException {
  InvoiceBusinessException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'InvoiceBusinessException: $message';
}
