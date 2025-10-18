// lib/features/auth/domain/validators/name_validator.dart

/// Name validator for validating first name, last name, company name, etc.
class NameValidator {
  static const int minLength = 2;
  static const int maxLength = 50;

  /// Validate name (first name, last name, etc.)
  static String? validate(String name, {String fieldName = 'Name'}) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return '$fieldName is required';
    }

    if (trimmed.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (trimmed.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    // Check for invalid characters (only letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(trimmed)) {
      return '$fieldName can only contain letters, spaces, hyphens and apostrophes';
    }

    return null; // Valid
  }

  /// Validate company/store name (less strict than person name)
  static String? validateBusinessName(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'Business name is required';
    }

    if (trimmed.length < minLength) {
      return 'Business name must be at least $minLength characters';
    }

    if (trimmed.length > 100) {
      return 'Business name must be less than 100 characters';
    }

    // Allow more characters for business names (letters, numbers, spaces, common symbols)
    if (!RegExp(r"^[a-zA-Z0-9\s\-'&.,()]+$").hasMatch(trimmed)) {
      return 'Business name contains invalid characters';
    }

    return null; // Valid
  }

  /// Check if name is valid (boolean check)
  static bool isValid(String name) {
    return validate(name) == null;
  }
}
