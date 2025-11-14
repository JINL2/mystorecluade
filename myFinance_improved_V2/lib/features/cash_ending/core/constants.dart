// lib/features/cash_ending/core/constants.dart

/// Constants for Cash Ending feature
///
/// This file contains all magic strings, numbers, and enums
/// to improve type safety and maintainability.
class CashEndingConstants {
  // Private constructor to prevent instantiation
  CashEndingConstants._();

  // ============================================================================
  // RPC Function Names
  // ============================================================================

  /// RPC function for inserting cashier amount lines (cash ending)
  static const String rpcInsertCashierAmount = 'insert_cashier_amount_lines';

  /// RPC function for inserting bank balance
  static const String rpcInsertBankAmount = 'bank_amount_insert_v2';

  /// RPC function for inserting vault transaction
  static const String rpcInsertVaultAmount = 'vault_amount_insert';

  /// RPC function for getting location stock flow
  static const String rpcGetLocationStockFlow = 'get_location_stock_flow';

  // ============================================================================
  // Pagination Configuration
  // ============================================================================

  /// Default page size for pagination
  static const int defaultPageSize = 20;

  /// Default offset for pagination
  static const int defaultOffset = 0;

  // ============================================================================
  // Tab Indices
  // ============================================================================

  /// Cash tab index
  static const int cashTabIndex = 0;

  /// Bank tab index
  static const int bankTabIndex = 1;

  /// Vault tab index
  static const int vaultTabIndex = 2;

  // ============================================================================
  // Location Type String Values (for API compatibility)
  // ============================================================================

  /// Location type value for cash
  static const String locationTypeCash = 'cash';

  /// Location type value for bank
  static const String locationTypeBank = 'bank';

  /// Location type value for vault
  static const String locationTypeVault = 'vault';
}

// ============================================================================
// Enums
// ============================================================================

/// Location type enumeration
///
/// Provides type-safe location type handling with string value conversion.
enum LocationType {
  /// Cash location type
  cash(CashEndingConstants.locationTypeCash),

  /// Bank location type
  bank(CashEndingConstants.locationTypeBank),

  /// Vault location type
  vault(CashEndingConstants.locationTypeVault);

  /// Constructor with string value
  const LocationType(this.value);

  /// String value for API calls
  final String value;

  /// Convert string to LocationType enum
  ///
  /// Returns [LocationType.cash] if value doesn't match any type.
  static LocationType fromString(String value) {
    return LocationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LocationType.cash,
    );
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case LocationType.cash:
        return 'Cash';
      case LocationType.bank:
        return 'Bank';
      case LocationType.vault:
        return 'Vault';
    }
  }
}
