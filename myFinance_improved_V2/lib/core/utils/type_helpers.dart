// lib/core/utils/type_helpers.dart

/// Type conversion helpers for safely handling dynamic types
///
/// These utilities help prevent runtime errors when working with
/// Map<String, dynamic> from JSON/Database responses.
class TypeHelpers {
  TypeHelpers._(); // Private constructor - utility class

  /// Safely convert dynamic to bool
  ///
  /// Handles:
  /// - null → defaultValue
  /// - bool → as-is
  /// - String 'true'/'false' → bool
  /// - num (0 = false, non-zero = true)
  static bool toBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase().trim();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
      return defaultValue;
    }
    if (value is num) return value != 0;
    return defaultValue;
  }

  /// Safely convert dynamic to int
  static int toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is bool) return value ? 1 : 0;
    return defaultValue;
  }

  /// Safely convert dynamic to double
  static double toDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Safely convert dynamic to String
  static String toStringValue(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// Safely check if string is not empty
  static bool isNotEmptyString(dynamic value) {
    if (value == null) return false;
    if (value is! String) return false;
    return value.trim().isNotEmpty;
  }

  /// Safely check if value is greater than 0
  static bool isPositive(dynamic value) {
    if (value == null) return false;
    if (value is num) return value > 0;
    if (value is String) {
      final parsed = num.tryParse(value);
      return parsed != null && parsed > 0;
    }
    return false;
  }
}
