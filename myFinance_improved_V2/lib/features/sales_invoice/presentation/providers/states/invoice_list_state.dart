import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/cash_location.dart';
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
    // Cash location filter
    @Default([]) List<CashLocation> cashLocations,
    @Default(false) bool isLoadingCashLocations,
    CashLocation? selectedCashLocation,
    // Status filter: null = All, 'completed', 'refunded'
    String? selectedStatus,
    // Server-side sorting for get_invoice_page_v3
    String? dateFilter, // 'newest' or 'oldest'
    String? amountFilter, // 'high' or 'low' (takes priority)
  }) = _InvoiceListState;

  /// Check if more data can be loaded
  bool get canLoadMore =>
      response?.pagination.hasNext == true && !isLoadingMore;

  /// Get invoices filtered by selected cash location and status
  List<Invoice> get filteredInvoices {
    var result = invoices;

    // Filter by cash location
    if (selectedCashLocation != null) {
      result = result
          .where(
            (invoice) =>
                invoice.cashLocation?.cashLocationId ==
                selectedCashLocation!.id,
          )
          .toList();
    }

    // Filter by status
    if (selectedStatus != null) {
      result = result
          .where((invoice) => invoice.status == selectedStatus)
          .toList();
    }

    return result;
  }

  /// Get display text for selected status
  String get statusDisplayText {
    switch (selectedStatus) {
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Refunded';
      default:
        return 'All';
    }
  }

  /// Get grouped invoices by date (with cash location filter applied)
  Map<String, List<Invoice>> get groupedInvoices {
    final grouped = <String, List<Invoice>>{};

    for (final invoice in filteredInvoices) {
      final dateKey = invoice.dateString;
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(invoice);
    }

    return grouped;
  }
}
