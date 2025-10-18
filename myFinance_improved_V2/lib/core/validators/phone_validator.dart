/// Phone number validation utility
/// Shared across the application to ensure consistent phone validation
class PhoneValidator {
  /// Phone number regex pattern
  /// Supports formats like:
  /// - +1 (555) 123-4567
  /// - (555) 123-4567
  /// - 555-123-4567
  /// - 5551234567
  /// - +82 10-1234-5678
  static final RegExp phoneRegex = RegExp(
    r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$',
  );

  /// Validate phone number format
  /// Returns true if phone matches the expected format
  static bool isValid(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return false;
    }
    return phoneRegex.hasMatch(phone.trim());
  }

  /// Validate phone number with custom error message
  /// Returns null if valid, error message if invalid
  static String? validate(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return null; // Optional field
    }
    if (!isValid(phone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
