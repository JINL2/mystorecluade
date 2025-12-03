import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/invoice.dart';
import '../../../domain/repositories/invoice_repository.dart';
import '../../../domain/value_objects/invoice_period.dart';
import '../../../domain/value_objects/invoice_sort_option.dart';

part 'invoice_list_state.freezed.dart';

/// Invoice List Page State - UI state for invoice list page
///
/// Manages invoice list with pagination, filtering, sorting, and search
@freezed
class InvoiceListState with _$InvoiceListState {
  const InvoiceListState._(); // Private constructor for getters

  const factory InvoiceListState({
    @Default([]) List<Invoice> invoices,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    String? error,
    InvoicePageResult? response,
    @Default(InvoicePeriod.allTime) InvoicePeriod selectedPeriod,
    @Default(InvoiceSortOption.date) InvoiceSortOption sortBy,
    @Default(false) bool sortAscending,
    @Default('') String searchQuery,
    @Default(1) int currentPage,
  }) = _InvoiceListState;

  /// Check if more data can be loaded
  bool get canLoadMore =>
      response?.pagination.hasNext == true && !isLoadingMore;

  /// Get grouped invoices by date
  Map<String, List<Invoice>> get groupedInvoices {
    final grouped = <String, List<Invoice>>{};

    for (final invoice in invoices) {
      final dateKey = invoice.dateString;
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(invoice);
    }

    return grouped;
  }
}
