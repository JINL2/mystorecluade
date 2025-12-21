class ValidationResult {
  final bool isValid;
  final List<String> errors;
  
  const ValidationResult({
    required this.isValid,
    required this.errors,
  });
  
  /// Get first error message for display
  String? get firstError => errors.isNotEmpty ? errors.first : null;
  
  /// Get formatted error list
  String get formattedErrors => errors.join('\n');
}