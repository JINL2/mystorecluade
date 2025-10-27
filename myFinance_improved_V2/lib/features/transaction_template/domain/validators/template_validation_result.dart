/// Template internal validation result
/// 
/// Used by TransactionTemplate.validate() method to return validation results
/// for internal business logic validation (data integrity, balance, structure)
class TemplateValidationResult {
  /// Whether the template passes all validation rules
  final bool isValid;
  
  /// List of validation error messages
  final List<String> errors;

  const TemplateValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Gets the first error message, if any
  String? get firstError => errors.isEmpty ? null : errors.first;
  
  /// Whether there are any validation errors
  bool get hasErrors => errors.isNotEmpty;
  
  /// Number of validation errors
  int get errorCount => errors.length;
}