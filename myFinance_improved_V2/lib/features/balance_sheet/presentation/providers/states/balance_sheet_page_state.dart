import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/value_objects/date_range.dart';

part 'balance_sheet_page_state.freezed.dart';

/// Balance Sheet Page State - UI state for balance sheet page
///
/// Manages tab selection, date range, and loading states
/// for both Balance Sheet and Income Statement tabs.
///
/// Note: Store selection (selectedStoreId) is managed in App State (appStateProvider.storeChoosen)
/// since it's a global app-level setting that affects multiple features.
@freezed
class BalanceSheetPageState with _$BalanceSheetPageState {
  const factory BalanceSheetPageState({
    // Tab state
    @Default(0) int selectedTabIndex, // 0: Balance Sheet, 1: Income Statement

    // Date selection
    required DateRange dateRange,

    // Loading states
    @Default(false) bool isLoadingBalanceSheet,
    @Default(false) bool isLoadingIncomeStatement,
    @Default(false) bool isLoadingStores,
    @Default(false) bool isLoadingCurrency,

    // Error states
    String? balanceSheetError,
    String? incomeStatementError,

    // Data loaded flags
    @Default(false) bool hasBalanceSheetData,
    @Default(false) bool hasIncomeStatementData,
  }) = _BalanceSheetPageState;

  const BalanceSheetPageState._();

  /// Create initial state with current month
  factory BalanceSheetPageState.initial() {
    return BalanceSheetPageState(
      dateRange: DateRange.currentMonth(),
    );
  }

  /// Check if currently on Balance Sheet tab
  bool get isBalanceSheetTab => selectedTabIndex == 0;

  /// Check if currently on Income Statement tab
  bool get isIncomeStatementTab => selectedTabIndex == 1;

  /// Check if any loading is in progress
  bool get isAnyLoading =>
      isLoadingBalanceSheet ||
      isLoadingIncomeStatement ||
      isLoadingStores ||
      isLoadingCurrency;

  /// Check if current tab has error
  String? get currentTabError {
    if (isBalanceSheetTab) return balanceSheetError;
    if (isIncomeStatementTab) return incomeStatementError;
    return null;
  }

  /// Check if current tab has data
  bool get currentTabHasData {
    if (isBalanceSheetTab) return hasBalanceSheetData;
    if (isIncomeStatementTab) return hasIncomeStatementData;
    return false;
  }
}

/// Date Range Selection State - UI state for date picker
///
/// Tracks date range selection dialog state.
@freezed
class DateRangeSelectionState with _$DateRangeSelectionState {
  const factory DateRangeSelectionState({
    required DateTime startDate,
    required DateTime endDate,
    @Default(false) bool isValid,
    String? errorMessage,
  }) = _DateRangeSelectionState;

  const DateRangeSelectionState._();

  /// Create from DateRange
  factory DateRangeSelectionState.fromDateRange(DateRange dateRange) {
    return DateRangeSelectionState(
      startDate: dateRange.startDate,
      endDate: dateRange.endDate,
      isValid: dateRange.isValid,
    );
  }

  /// Convert to DateRange
  DateRange toDateRange() {
    return DateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

/// Store Selection State - UI state for store picker
///
/// Tracks store selection dialog state.
@freezed
class StoreSelectionState with _$StoreSelectionState {
  const factory StoreSelectionState({
    String? selectedStoreId, // null means Headquarters
    @Default([]) List<StoreOption> availableStores,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _StoreSelectionState;
}

/// Store option for selection
@freezed
class StoreOption with _$StoreOption {
  const factory StoreOption({
    required String storeId,
    required String storeName,
    String? storeCode,
  }) = _StoreOption;

  const StoreOption._();

  /// Create headquarters option
  factory StoreOption.headquarters() {
    return const StoreOption(
      storeId: '',
      storeName: 'Headquarters (All Stores)',
    );
  }
}
