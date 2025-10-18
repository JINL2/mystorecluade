// lib/features/auth/domain/value_objects/validation_result.dart

/// Validation result value object.
///
/// Used by entities and validators to return validation results.
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  const ValidationResult({
    required this.isValid,
    required this.errors,
  });

  factory ValidationResult.valid() {
    return const ValidationResult(isValid: true, errors: []);
  }

  factory ValidationResult.invalid(List<String> errors) {
    return ValidationResult(isValid: false, errors: errors);
  }

  String get firstError => errors.isNotEmpty ? errors.first : '';

  String get allErrors => errors.join(', ');

  @override
  String toString() {
    if (isValid) return 'Valid';
    return 'Invalid: ${errors.join(', ')}';
  }
}
