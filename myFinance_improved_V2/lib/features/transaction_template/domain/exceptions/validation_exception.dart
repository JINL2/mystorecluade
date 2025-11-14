import 'domain_exception.dart';
import 'validation_error.dart';

/// Exception thrown when validation fails
/// 
/// Used for validation-related errors such as:
/// - Entity validation failures
/// - Input parameter validation errors
/// - Business rule validation violations
/// - Data format validation failures
class ValidationException extends DomainException {
  const ValidationException(
    super.message, {
    super.errorCode,
    super.context,
    super.innerException,
  });

  /// Creates exception for required field validation
  factory ValidationException.requiredField(String fieldName) {
    return ValidationException(
      'Required field is missing or empty',
      errorCode: 'VALIDATION_REQUIRED_FIELD',
      context: {'fieldName': fieldName},
    );
  }

  /// Creates exception for invalid format validation
  factory ValidationException.invalidFormat(String fieldName, String expectedFormat) {
    return ValidationException(
      'Field has invalid format',
      errorCode: 'VALIDATION_INVALID_FORMAT',
      context: {
        'fieldName': fieldName,
        'expectedFormat': expectedFormat,
      },
    );
  }

  /// Creates exception for range validation failures
  factory ValidationException.outOfRange(String fieldName, dynamic value, dynamic min, dynamic max) {
    return ValidationException(
      'Field value is out of allowed range',
      errorCode: 'VALIDATION_OUT_OF_RANGE',
      context: {
        'fieldName': fieldName,
        'value': value,
        'min': min,
        'max': max,
      },
    );
  }

  /// Creates exception for multiple validation errors
  factory ValidationException.multipleErrors(List<String> errors) {
    return ValidationException(
      'Multiple validation errors occurred',
      errorCode: 'VALIDATION_MULTIPLE_ERRORS',
      context: {'errors': errors},
    );
  }

  /// Creates exception for multiple field validation errors
  factory ValidationException.multipleFields({
    required List<ValidationError> errors,
  }) {
    return ValidationException(
      'Multiple field validation errors occurred',
      errorCode: 'VALIDATION_MULTIPLE_FIELDS',
      context: {
        'errors': errors.map((e) => e.toMap()).toList(),
        'errorCount': errors.length,
        'fieldNames': errors.map((e) => e.fieldName).toList(),
      },
    );
  }

  /// Creates exception for business rule validation failures
  factory ValidationException.businessRule({
    required String ruleName,
    required String ruleDescription,
    Map<String, dynamic>? ruleContext,
  }) {
    return ValidationException(
      ruleDescription,
      errorCode: 'VALIDATION_BUSINESS_RULE',
      context: {
        'ruleName': ruleName,
        'ruleContext': ruleContext ?? {},
      },
    );
  }

  @override
  ValidationException copyWith({
    String? message,
    String? errorCode,
    Map<String, dynamic>? context,
    Exception? innerException,
  }) {
    return ValidationException(
      message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      context: context ?? this.context,
      innerException: innerException ?? this.innerException,
    );
  }
}