import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/transaction_filter.dart';

part 'transaction_filter_state.freezed.dart';

/// Transaction Filter State - Filter configuration for transaction list
///
/// Manages filter criteria including date range, accounts, cash locations,
/// counterparties, and scope settings.
@freezed
class TransactionFilterState with _$TransactionFilterState {
  const TransactionFilterState._();

  const factory TransactionFilterState({
    /// Date range filter - from date
    DateTime? dateFrom,

    /// Date range filter - to date
    DateTime? dateTo,

    /// Single account filter
    String? accountId,

    /// Multiple accounts filter
    List<String>? accountIds,

    /// Cash location filter
    String? cashLocationId,

    /// Counterparty filter
    String? counterpartyId,

    /// Created by user filter
    String? createdBy,

    /// Transaction scope (company, branch, personal)
    @Default(TransactionScope.company) TransactionScope scope,
  }) = _TransactionFilterState;

  /// Initial state with no filters applied
  factory TransactionFilterState.initial() => const TransactionFilterState();

  /// Check if any filter is active
  bool get hasActiveFilter {
    return dateFrom != null ||
        dateTo != null ||
        accountId != null ||
        accountIds != null ||
        cashLocationId != null ||
        counterpartyId != null ||
        createdBy != null ||
        scope != TransactionScope.company;
  }

  /// Convert to domain TransactionFilter entity
  TransactionFilter toFilter() {
    return TransactionFilter(
      dateFrom: dateFrom,
      dateTo: dateTo,
      accountId: accountId,
      accountIds: accountIds,
      cashLocationId: cashLocationId,
      counterpartyId: counterpartyId,
      createdBy: createdBy,
      scope: scope,
    );
  }

  /// Create from domain TransactionFilter entity
  factory TransactionFilterState.fromFilter(TransactionFilter filter) {
    return TransactionFilterState(
      dateFrom: filter.dateFrom,
      dateTo: filter.dateTo,
      accountId: filter.accountId,
      accountIds: filter.accountIds,
      cashLocationId: filter.cashLocationId,
      counterpartyId: filter.counterpartyId,
      createdBy: filter.createdBy,
      scope: filter.scope,
    );
  }
}

/// Filter Options State - Available filter options
///
/// Provides lists of available accounts, cash locations, counterparties
/// for populating filter UI dropdowns.
@freezed
class FilterOptionsState with _$FilterOptionsState {
  const factory FilterOptionsState({
    @Default([]) List<Map<String, dynamic>> accounts,
    @Default([]) List<Map<String, dynamic>> cashLocations,
    @Default([]) List<Map<String, dynamic>> counterparties,
    @Default([]) List<Map<String, dynamic>> journalTypes,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _FilterOptionsState;

  /// Initial state
  factory FilterOptionsState.initial() => const FilterOptionsState();

  /// Loading state
  factory FilterOptionsState.loading() => const FilterOptionsState(
        isLoading: true,
      );

  /// Loaded state with options
  factory FilterOptionsState.loaded({
    required List<Map<String, dynamic>> accounts,
    required List<Map<String, dynamic>> cashLocations,
    required List<Map<String, dynamic>> counterparties,
    required List<Map<String, dynamic>> journalTypes,
  }) =>
      FilterOptionsState(
        accounts: accounts,
        cashLocations: cashLocations,
        counterparties: counterparties,
        journalTypes: journalTypes,
        isLoading: false,
      );

  /// Error state
  factory FilterOptionsState.error(String message) => FilterOptionsState(
        errorMessage: message,
        isLoading: false,
      );
}
