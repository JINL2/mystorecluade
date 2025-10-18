// lib/features/auth/domain/validators/email_validator.dart

/// Email validator for validating email addresses.
///
/// This validator contains all email validation business rules.
/// It is a pure Dart class with no dependencies on Flutter or external packages.
class EmailValidator {
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  /// Validate email format
  ///
  /// Returns `true` if the email is valid, `false` otherwise.
  static bool isValid(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validate email and return error message if invalid
  ///
  /// Returns `null` if valid, or an error message string if invalid.
  /// This is useful for form validation.
  static String? validate(String email) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      return 'Email is required';
    }

    if (!isValid(trimmed)) {
      return 'Invalid email format';
    }

    return null; // Valid
  }

  /// Validate email exists in database (async check)
  ///
  /// This is used during signup to check if email is already registered.
  /// The [checkExists] function should query the database.
  static Future<String?> validateUnique(
    String email,
    Future<bool> Function(String) checkExists,
  ) async {
    // First check basic validation
    final basicError = validate(email);
    if (basicError != null) return basicError;

    // Then check uniqueness
    final exists = await checkExists(email.trim());
    if (exists) {
      return 'Email already exists';
    }

    return null; // Valid and unique
  }

  /// Extract domain from email
  ///
  /// Example: "user@example.com" → "example.com"
  static String? extractDomain(String email) {
    if (!isValid(email)) return null;

    final parts = email.trim().split('@');
    if (parts.length != 2) return null;

    return parts[1];
  }

  /// Extract username from email
  ///
  /// Example: "user@example.com" → "user"
  static String? extractUsername(String email) {
    if (!isValid(email)) return null;

    final parts = email.trim().split('@');
    if (parts.length != 2) return null;

    return parts[0];
  }

  /// Check if email is from a specific domain
  ///
  /// Example: `isFromDomain("user@example.com", "example.com")` → true
  static bool isFromDomain(String email, String domain) {
    final emailDomain = extractDomain(email);
    return emailDomain?.toLowerCase() == domain.toLowerCase();
  }
}
