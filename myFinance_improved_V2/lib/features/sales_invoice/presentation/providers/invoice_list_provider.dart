import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/value_objects/invoice_filter.dart';
import '../../domain/value_objects/invoice_period.dart';
import '../../domain/value_objects/invoice_sort_option.dart';
import 'invoice_providers.dart';
import 'states/invoice_list_state.dart';

/// Invoice list state notifier
class InvoiceListNotifier extends StateNotifier<InvoiceListState> {
  final InvoiceRepository _repository;
  final Ref _ref;

  InvoiceListNotifier(this._repository, this._ref) : super(const InvoiceListState());

  /// Load invoices
  Future<void> loadInvoices() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appState = _ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Company or store not selected',
        );
        return;
      }

      final filter = InvoiceFilter(
        period: state.selectedPeriod,
        sortBy: state.sortBy,
        sortAscending: state.sortAscending,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
        page: state.currentPage,
      );

      final result = await _repository.getInvoices(
        companyId: companyId,
        storeId: storeId,
        filter: filter,
      );

      state = state.copyWith(
        isLoading: false,
        invoices: result.invoices,
        response: result,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update search query
  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    loadInvoices();
  }

  /// Update period filter
  void updatePeriod(InvoicePeriod period) {
    state = state.copyWith(selectedPeriod: period, currentPage: 1);
    loadInvoices();
  }

  /// Update sort option
  void updateSort(InvoiceSortOption sortOption) {
    final isSameSort = state.sortBy == sortOption;
    state = state.copyWith(
      sortBy: sortOption,
      sortAscending: isSameSort ? !state.sortAscending : false,
      currentPage: 1,
    );
    loadInvoices();
  }

  /// Next page
  void nextPage() {
    if (state.response?.pagination.hasNext ?? false) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      loadInvoices();
    }
  }

  /// Previous page
  void previousPage() {
    if (state.currentPage > 1) {
      state = state.copyWith(currentPage: state.currentPage - 1);
      loadInvoices();
    }
  }

  /// Refresh
  Future<void> refresh() async {
    state = state.copyWith(currentPage: 1);
    await loadInvoices();
  }
}

/// Invoice list provider
final invoiceListProvider = StateNotifierProvider<InvoiceListNotifier, InvoiceListState>((ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return InvoiceListNotifier(repository, ref);
});
