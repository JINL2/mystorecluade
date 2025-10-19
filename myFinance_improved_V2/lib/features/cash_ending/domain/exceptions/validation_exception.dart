// lib/features/cash_ending/domain/exceptions/validation_exception.dart

/// Exception thrown when validation fails
/// Used by value objects and domain logic
class ValidationException implements Exception {
  final String message;
  final String? field;

  const ValidationException(this.message, {this.field});

  @override
  String toString() {
    if (field != null) {
      return 'ValidationException [$field]: $message';
    }
    return 'ValidationException: $message';
  }
}
