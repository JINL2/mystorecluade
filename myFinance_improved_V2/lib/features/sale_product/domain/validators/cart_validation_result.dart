/// Cart validation result
///
/// Used to return validation results for cart operations
/// including business logic validation (stock availability, quantity limits)
class CartValidationResult {
  /// Whether the cart operation passes all validation rules
  final bool isValid;

  /// List of validation error messages
  final List<String> errors;

  /// List of validation warning messages
  final List<String> warnings;

  const CartValidationResult({
    required this.isValid,
    required this.errors,
    this.warnings = const [],
  });

  /// Factory for success case
  factory CartValidationResult.success() {
    return const CartValidationResult(
      isValid: true,
      errors: [],
      warnings: [],
    );
  }

  /// Factory for failure case
  factory CartValidationResult.failure(List<String> errors) {
    return CartValidationResult(
      isValid: false,
      errors: errors,
      warnings: [],
    );
  }

  /// Factory for success with warnings
  factory CartValidationResult.warning(List<String> warnings) {
    return CartValidationResult(
      isValid: true,
      errors: [],
      warnings: warnings,
    );
  }

  /// Gets the first error message, if any
  String? get firstError => errors.isEmpty ? null : errors.first;

  /// Gets the first warning message, if any
  String? get firstWarning => warnings.isEmpty ? null : warnings.first;

  /// Whether there are any validation errors
  bool get hasErrors => errors.isNotEmpty;

  /// Whether there are any validation warnings
  bool get hasWarnings => warnings.isNotEmpty;

  /// Number of validation errors
  int get errorCount => errors.length;

  /// Number of validation warnings
  int get warningCount => warnings.length;
}
