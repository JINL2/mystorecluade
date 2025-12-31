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
