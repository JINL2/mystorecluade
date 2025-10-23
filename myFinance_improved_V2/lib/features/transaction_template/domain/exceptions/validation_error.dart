/// Represents a single validation error for a specific field
/// 
/// Used to capture detailed information about validation failures
/// including the field name, value, rule that failed, and error message.
class ValidationError {
  /// The name of the field that failed validation
  final String fieldName;
  
  /// The value that failed validation (as string for serialization)
  final String fieldValue;
  
  /// The validation rule that failed
  final String validationRule;
  
  /// Human-readable error message
  final String message;

  const ValidationError({
    required this.fieldName,
    required this.fieldValue,
    required this.validationRule,
    required this.message,
  });

  /// Converts the validation error to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'fieldName': fieldName,
      'fieldValue': fieldValue,
      'validationRule': validationRule,
      'message': message,
    };
  }

  /// Creates a ValidationError from a map
  factory ValidationError.fromMap(Map<String, dynamic> map) {
    return ValidationError(
      fieldName: map['fieldName'] as String,
      fieldValue: map['fieldValue'] as String,
      validationRule: map['validationRule'] as String,
      message: map['message'] as String,
    );
  }

  @override
  String toString() {
    return 'ValidationError(fieldName: $fieldName, rule: $validationRule, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationError &&
        other.fieldName == fieldName &&
        other.fieldValue == fieldValue &&
        other.validationRule == validationRule &&
        other.message == message;
  }

  @override
  int get hashCode {
    return fieldName.hashCode ^
        fieldValue.hashCode ^
        validationRule.hashCode ^
        message.hashCode;
  }
}