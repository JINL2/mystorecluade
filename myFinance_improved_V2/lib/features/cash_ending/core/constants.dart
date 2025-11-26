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

  /// ✅ Universal Multi-Currency RPC (Cash, Vault, Bank)
  /// Supports multi-currency in one call with Entry-based workflow
  static const String rpcInsertAmountMultiCurrency = 'insert_amount_multi_currency';

  /// @Deprecated Legacy RPCs (kept for reference)
  @Deprecated('Use rpcInsertAmountMultiCurrency instead')
  static const String rpcInsertCashierAmount = 'insert_cashier_amount_lines';

  @Deprecated('Use rpcInsertAmountMultiCurrency instead')
  static const String rpcInsertBankAmount = 'bank_amount_insert_v2';

  @Deprecated('Use rpcInsertAmountMultiCurrency instead')
  static const String rpcInsertVaultAmount = 'vault_amount_insert_v3';

  @Deprecated('Use rpcInsertAmountMultiCurrency instead')
  static const String rpcVaultAmountRecount = 'vault_amount_recount';

  /// RPC function for getting location stock flow (UTC version)
  /// ✅ Uses created_at_utc and system_time_utc columns
  static const String rpcGetLocationStockFlow = 'get_location_stock_flow_utc';

  /// RPC function for getting cash location balance summary (Journal vs Real)
  /// ⚠️ OLD: Uses flow data from v_cash_location view
  @Deprecated('Use rpcGetBalanceSummaryV2 instead')
  static const String rpcGetBalanceSummary = 'get_cash_location_balance_summary';

  /// RPC function for getting cash location balance summary V2 (STOCK-BASED, UTC)
  /// ✅ Uses stock data from cash_amount_entries.balance_after
  /// ✅ Uses record_date_utc column
  static const String rpcGetBalanceSummaryV2 = 'get_cash_location_balance_summary_v2_utc';

  /// RPC function for getting multiple locations balance summary (UTC)
  /// ✅ Uses record_date_utc column
  static const String rpcGetMultipleBalanceSummary =
      'get_multiple_locations_balance_summary_utc';

  /// RPC function for getting company-wide balance summary (UTC)
  /// ✅ Uses record_date_utc column
  static const String rpcGetCompanyBalanceSummary =
      'get_company_balance_summary_utc';

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

/// Vault transaction type enumeration
///
/// Defines the type of vault transaction for RPC parameter formatting
enum VaultTransactionType {
  /// IN: Deposit (debit)
  vaultIn('in'),

  /// OUT: Withdrawal (credit)
  vaultOut('out'),

  /// RECOUNT: Stock adjustment (quantity)
  recount('recount');

  /// Constructor with string value
  const VaultTransactionType(this.value);

  /// String value for API calls
  final String value;

  /// Convert string to VaultTransactionType enum
  static VaultTransactionType fromString(String value) {
    return VaultTransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VaultTransactionType.recount,
    );
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case VaultTransactionType.vaultIn:
        return 'In';
      case VaultTransactionType.vaultOut:
        return 'Out';
      case VaultTransactionType.recount:
        return 'Recount';
    }
  }
}

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
