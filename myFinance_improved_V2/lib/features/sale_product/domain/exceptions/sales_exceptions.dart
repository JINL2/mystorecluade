/// Base exception for sales domain
abstract class SalesException implements Exception {
  final String message;
  final String? code;

  const SalesException(this.message, [this.code]);

  @override
  String toString() => 'SalesException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception when validation fails
class ValidationException extends SalesException {
  const ValidationException(String message)
      : super(message, 'VALIDATION_ERROR');
}
