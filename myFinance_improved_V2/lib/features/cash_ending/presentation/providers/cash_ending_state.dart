// lib/features/cash_ending/presentation/providers/cash_ending_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/store.dart';

part 'cash_ending_state.freezed.dart';

/// Unified State for Cash Ending feature
///
/// Combines all sub-states into a single state using Freezed.
/// Follows the transaction_template pattern with separated concerns.
@freezed
class CashEndingState with _$CashEndingState {
  const factory CashEndingState({
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Page State - UI state for cash ending page
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    /// Current selected tab (0=cash, 1=bank, 2=vault)
    @Default(0) int currentTabIndex,

    /// Saving cash ending in progress
    @Default(false) bool isSaving,

    /// Error message to display
    String? errorMessage,

    /// Success message to display
    String? successMessage,

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Location Selection State
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    /// Selected store ID (null = headquarter)
    String? selectedStoreId,

    /// Selected cash location ID
    String? selectedCashLocationId,

    /// Selected bank location ID
    String? selectedBankLocationId,

    /// Selected vault location ID
    String? selectedVaultLocationId,

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Currency Selection State
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    /// Selected currency ID for cash tab
    String? selectedCashCurrencyId,

    /// Selected currency ID for bank tab
    String? selectedBankCurrencyId,

    /// Selected currency ID for vault tab
    String? selectedVaultCurrencyId,

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Data State - Available data lists
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    /// Available stores for the company
    @Default([]) List<Store> stores,

    /// Available cash locations
    @Default([]) List<Location> cashLocations,

    /// Available bank locations
    @Default([]) List<Location> bankLocations,

    /// Available vault locations
    @Default([]) List<Location> vaultLocations,

    /// Available currencies for the company
    @Default([]) List<Currency> currencies,

    /// Recent cash ending history for selected location
    @Default([]) List<CashEnding> recentCashEndings,

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Loading State - Loading states for each operation
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    /// Loading stores
    @Default(false) bool isLoadingStores,

    /// Loading cash locations
    @Default(false) bool isLoadingCashLocations,

    /// Loading bank locations
    @Default(false) bool isLoadingBankLocations,

    /// Loading vault locations
    @Default(false) bool isLoadingVaultLocations,

    /// Loading currencies
    @Default(false) bool isLoadingCurrencies,

    /// Loading recent cash endings
    @Default(false) bool isLoadingRecentEndings,
  }) = _CashEndingState;

  const CashEndingState._();

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Helper Getters
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Get current selected location based on tab
  String? get currentSelectedLocationId {
    switch (currentTabIndex) {
      case 0:
        return selectedCashLocationId;
      case 1:
        return selectedBankLocationId;
      case 2:
        return selectedVaultLocationId;
      default:
        return null;
    }
  }

  /// Get current selected currency based on tab
  String? get currentSelectedCurrencyId {
    switch (currentTabIndex) {
      case 0:
        return selectedCashCurrencyId;
      case 1:
        return selectedBankCurrencyId;
      case 2:
        return selectedVaultCurrencyId;
      default:
        return null;
    }
  }

  /// Check if any loading is in progress
  bool get isLoading =>
      isLoadingStores ||
      isLoadingCashLocations ||
      isLoadingBankLocations ||
      isLoadingVaultLocations ||
      isLoadingCurrencies ||
      isLoadingRecentEndings ||
      isSaving;
}
