/// Pure domain entity for transaction filtering
/// Represents the filter criteria for querying transactions
class TransactionFilter {
  final TransactionScope scope;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? accountId;
  final List<String>? accountIds;
  final String? cashLocationId;
  final String? counterpartyId;
  final String? journalType;
  final String? createdBy;
  final String? searchQuery;
  final int limit;
  final int offset;

  const TransactionFilter({
    this.scope = TransactionScope.store,
    this.dateFrom,
    this.dateTo,
    this.accountId,
    this.accountIds,
    this.cashLocationId,
    this.counterpartyId,
    this.journalType,
    this.createdBy,
    this.searchQuery,
    this.limit = 50,
    this.offset = 0,
  });

  /// Create a copy with updated values
  TransactionFilter copyWith({
    TransactionScope? scope,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? accountId,
    List<String>? accountIds,
    String? cashLocationId,
    String? counterpartyId,
    String? journalType,
    String? createdBy,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    return TransactionFilter(
      scope: scope ?? this.scope,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      accountId: accountId ?? this.accountId,
      accountIds: accountIds ?? this.accountIds,
      cashLocationId: cashLocationId ?? this.cashLocationId,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      journalType: journalType ?? this.journalType,
      createdBy: createdBy ?? this.createdBy,
      searchQuery: searchQuery ?? this.searchQuery,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  /// Check if any filters are active
  bool get hasActiveFilters {
    return dateFrom != null ||
        dateTo != null ||
        accountId != null ||
        (accountIds != null && accountIds!.isNotEmpty) ||
        cashLocationId != null ||
        counterpartyId != null ||
        journalType != null ||
        createdBy != null;
  }
}

/// Transaction scope enum
enum TransactionScope {
  store,   // Show only current store transactions
  company  // Show all stores in company
}

/// Filter options entity - available values for filtering
class FilterOptions {
  final List<FilterOption> stores;
  final List<FilterOption> accounts;
  final List<FilterOption> cashLocations;
  final List<FilterOption> counterparties;
  final List<FilterOption> journalTypes;
  final List<FilterOption> users;

  const FilterOptions({
    this.stores = const [],
    this.accounts = const [],
    this.cashLocations = const [],
    this.counterparties = const [],
    this.journalTypes = const [],
    this.users = const [],
  });
}

/// Individual filter option
class FilterOption {
  final String id;
  final String name;
  final int transactionCount;

  const FilterOption({
    required this.id,
    required this.name,
    this.transactionCount = 0,
  });
}
