import 'package:equatable/equatable.dart';
import 'invoice_period.dart';
import 'invoice_sort_option.dart';

/// Invoice filter value object
class InvoiceFilter extends Equatable {
  final InvoicePeriod period;
  final InvoiceSortOption sortBy;
  final bool sortAscending;
  final String? searchQuery;
  final int page;
  final int limit;
  // Server-side sorting parameters for get_invoice_page_v3
  final String? dateFilter; // 'newest' or 'oldest'
  final String? amountFilter; // 'high' or 'low' (takes priority over dateFilter)

  const InvoiceFilter({
    this.period = InvoicePeriod.allTime,
    this.sortBy = InvoiceSortOption.date,
    this.sortAscending = false,
    this.searchQuery,
    this.page = 1,
    this.limit = 20,
    this.dateFilter,
    this.amountFilter,
  });

  InvoiceFilter copyWith({
    InvoicePeriod? period,
    InvoiceSortOption? sortBy,
    bool? sortAscending,
    String? searchQuery,
    int? page,
    int? limit,
    String? dateFilter,
    String? amountFilter,
    bool clearAmountFilter = false,
  }) {
    return InvoiceFilter(
      period: period ?? this.period,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      dateFilter: dateFilter ?? this.dateFilter,
      amountFilter: clearAmountFilter ? null : (amountFilter ?? this.amountFilter),
    );
  }

  @override
  List<Object?> get props => [
        period,
        sortBy,
        sortAscending,
        searchQuery,
        page,
        limit,
        dateFilter,
        amountFilter,
      ];
}
