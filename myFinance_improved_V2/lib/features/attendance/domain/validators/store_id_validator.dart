/// Store ID Validator
///
/// Validates store ID format (UUID) according to business rules.
/// This is Domain logic and should not be in Presentation layer.
class StoreIdValidator {
  StoreIdValidator._();

  /// UUID v4 format regex pattern
  static final _uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  /// Validates if the provided store ID is in valid UUID format
  ///
  /// Returns true if valid, false otherwise
  static bool isValid(String storeId) {
    if (storeId.isEmpty) return false;
    return _uuidRegex.hasMatch(storeId);
  }

  /// Validates and throws exception if invalid
  ///
  /// Throws [ArgumentError] if store ID is invalid
  static void validate(String storeId) {
    if (!isValid(storeId)) {
      throw ArgumentError('Invalid store ID format. Expected UUID format.');
    }
  }

  /// Validates and returns error message if invalid
  ///
  /// Returns null if valid, error message string if invalid
  static String? validateWithMessage(String storeId) {
    if (storeId.isEmpty) {
      return 'Store ID cannot be empty';
    }
    if (!_uuidRegex.hasMatch(storeId)) {
      return 'Invalid store ID format. Expected UUID format.';
    }
    return null;
  }
}
