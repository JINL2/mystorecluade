// Presentation Extension: CashLocation Display
// Provides display-related properties (displayName, displayType) for cash location
// Keeps Domain layer pure by moving UI concerns to Presentation

import '../../domain/entities/cash_location.dart';

// Re-export domain type for convenience
export '../../domain/entities/cash_location.dart';

/// Extension to provide UI display properties for CashLocation
extension CashLocationDisplay on CashLocation {
  /// Display name for UI - combines name with bank info if applicable
  String get displayName {
    if (type == 'bank' && bankName != null) {
      return '$name - $bankName';
    }
    return name;
  }

  /// Display type for UI - human readable type name
  String get displayType {
    switch (type) {
      case 'bank':
        return 'Bank';
      case 'cash':
        return 'Cash';
      case 'vault':
        return 'Vault';
      default:
        // Capitalize first letter for unknown types
        return type.isNotEmpty
            ? '${type[0].toUpperCase()}${type.substring(1)}'
            : 'Unknown';
    }
  }
}
