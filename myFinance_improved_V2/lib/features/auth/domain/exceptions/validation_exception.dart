// lib/features/auth/domain/exceptions/validation_exception.dart

/// Exception thrown when validation fails
class ValidationException implements Exception {
  final String message;
  final List<String> errors;
  final String? field;

  const ValidationException(
    this.message, {
    List<String>? errors,
    this.field,
  }) : errors = errors ?? const [];

  factory ValidationException.single(String error, {String? field}) {
    return ValidationException(
      error,
      errors: [error],
      field: field,
    );
  }

  factory ValidationException.multiple(List<String> errors, {String? field}) {
    return ValidationException(
      errors.join(', '),
      errors: errors,
      field: field,
    );
  }

  String get firstError => errors.isNotEmpty ? errors.first : message;

  @override
  String toString() {
    final fieldStr = field != null ? ' (field: $field)' : '';
    return 'ValidationException$fieldStr: ${errors.join(', ')}';
  }
}

/// Entity validation failed
class EntityValidationException extends ValidationException {
  final String entityName;

  const EntityValidationException({
    required this.entityName,
    required List<String> errors,
  }) : super(
          '$entityName validation failed',
          errors: errors,
        );

  @override
  String toString() {
    return 'EntityValidationException: $entityName - ${errors.join(', ')}';
  }
}
