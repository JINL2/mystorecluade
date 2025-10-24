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

  const InvoiceFilter({
    this.period = InvoicePeriod.allTime,
    this.sortBy = InvoiceSortOption.date,
    this.sortAscending = false,
    this.searchQuery,
    this.page = 1,
    this.limit = 20,
  });

  InvoiceFilter copyWith({
    InvoicePeriod? period,
    InvoiceSortOption? sortBy,
    bool? sortAscending,
    String? searchQuery,
    int? page,
    int? limit,
  }) {
    return InvoiceFilter(
      period: period ?? this.period,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
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
      ];
}
