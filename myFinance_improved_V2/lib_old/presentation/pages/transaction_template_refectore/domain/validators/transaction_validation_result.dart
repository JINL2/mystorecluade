/// Transaction internal validation result
/// 
/// Used by Transaction.validate() method to return validation results
/// for internal business logic validation (amount, status, data integrity)
class TransactionValidationResult {
  /// Whether the transaction passes all validation rules
  final bool isValid;
  
  /// List of validation error messages
  final List<String> errors;

  const TransactionValidationResult({
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