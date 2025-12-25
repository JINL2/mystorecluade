import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../cash_location/domain/constants/account_ids.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/value_objects/invoice_filter.dart';
import '../../domain/value_objects/invoice_period.dart';
import '../../domain/value_objects/invoice_sort_option.dart';
import 'invoice_providers.dart';
import 'states/invoice_list_state.dart';

/// Account IDs for journal entries - using centralized AccountIds
const String _salesRevenueAccountId = AccountIds.salesRevenue;
const String _cashAccountId = AccountIds.cash;
const String _cogsAccountId = AccountIds.cogs;
const String _inventoryAccountId = AccountIds.inventory;

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
        dateFilter: state.dateFilter,
        amountFilter: state.amountFilter,
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

  /// Update server-side sorting (for get_invoice_page_v3)
  ///
  /// - dateFilter: 'newest' or 'oldest' (default: newest)
  /// - amountFilter: 'high' or 'low' (takes priority over dateFilter)
  void updateServerSort({String? dateFilter, String? amountFilter}) {
    state = state.copyWith(
      dateFilter: dateFilter,
      amountFilter: amountFilter,
      currentPage: 1,
    );
    loadInvoices();
  }

  /// Clear server-side sorting (reset to default)
  void clearServerSort() {
    state = state.copyWith(
      dateFilter: null,
      amountFilter: null,
      currentPage: 1,
    );
    loadInvoices();
  }

  /// Load cash locations for filter
  Future<void> loadCashLocations() async {
    if (state.isLoadingCashLocations) return;

    state = state.copyWith(isLoadingCashLocations: true);

    try {
      final appState = _ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty) {
        state = state.copyWith(isLoadingCashLocations: false);
        return;
      }

      final cashLocations = await _repository.getCashLocations(
        companyId: companyId,
        storeId: storeId,
      );

      debugPrint('💰 [CashLocations] Loaded ${cashLocations.length} cash locations');

      state = state.copyWith(
        isLoadingCashLocations: false,
        cashLocations: cashLocations,
      );
    } catch (e) {
      debugPrint('❌ [CashLocations] Error loading: $e');
      state = state.copyWith(isLoadingCashLocations: false);
    }
  }

  /// Update cash location filter
  void updateCashLocation(CashLocation? cashLocation) {
    state = state.copyWith(selectedCashLocation: cashLocation, currentPage: 1);
    loadInvoices();
  }

  /// Clear cash location filter
  void clearCashLocationFilter() {
    state = state.copyWith(selectedCashLocation: null, currentPage: 1);
    loadInvoices();
  }

  /// Update status filter (null = All, 'completed', 'refunded')
  void updateStatus(String? status) {
    state = state.copyWith(selectedStatus: status);
    // Note: Status filter is client-side only, no need to reload
  }

  /// Clear status filter
  void clearStatusFilter() {
    state = state.copyWith(selectedStatus: null);
  }

  /// Load next page (infinite scroll - appends data)
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.canLoadMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final appState = _ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(isLoadingMore: false);
        return;
      }

      final nextPage = state.currentPage + 1;
      final filter = InvoiceFilter(
        period: state.selectedPeriod,
        sortBy: state.sortBy,
        sortAscending: state.sortAscending,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
        page: nextPage,
        dateFilter: state.dateFilter,
        amountFilter: state.amountFilter,
      );

      final result = await _repository.getInvoices(
        companyId: companyId,
        storeId: storeId,
        filter: filter,
      );

      // Append new invoices to existing list
      final allInvoices = [...state.invoices, ...result.invoices];
      state = state.copyWith(
        isLoadingMore: false,
        invoices: allInvoices,
        response: result,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Refresh (reset to page 1)
  Future<void> refresh() async {
    state = state.copyWith(currentPage: 1, invoices: []);
    await loadInvoices();
  }

  /// Go to previous page
  Future<void> previousPage() async {
    if (state.currentPage <= 1) return;
    state = state.copyWith(currentPage: state.currentPage - 1, invoices: []);
    await loadInvoices();
  }

  /// Go to next page
  Future<void> nextPage() async {
    final pagination = state.response?.pagination;
    if (pagination == null || !pagination.hasNext) return;
    state = state.copyWith(currentPage: state.currentPage + 1, invoices: []);
    await loadInvoices();
  }

  /// Refund invoice using inventory_refund_invoice_v3 RPC
  Future<RefundResult> refundInvoice({
    required Invoice invoice,
    String? notes,
  }) async {
    final appState = _ref.read(appStateProvider);
    final userId = appState.userId;
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (userId.isEmpty) {
      throw Exception('User not logged in');
    }

    if (companyId.isEmpty || storeId.isEmpty) {
      throw Exception('Company or store not selected');
    }

    final result = await _repository.refundInvoice(
      invoiceIds: [invoice.invoiceId],
      userId: userId,
      notes: notes,
    );

    if (result.success) {
      try {
        final journalRepository = _ref.read(salesJournalRepositoryProvider);

        await journalRepository.createRefundJournalEntry(
          companyId: companyId,
          storeId: storeId,
          userId: userId,
          amount: invoice.amounts.totalAmount,
          description: 'Refund for Invoice ${invoice.invoiceNumber}',
          lineDescription: 'Invoice ${invoice.invoiceNumber} refund',
          cashLocationId: invoice.cashLocation?.cashLocationId,
          cashAccountId: _cashAccountId,
          salesAccountId: _salesRevenueAccountId,
          cogsAccountId: _cogsAccountId,
          inventoryAccountId: _inventoryAccountId,
          totalCost: invoice.amounts.totalCost,
        );
      } catch (_) {
        // Journal entry error doesn't fail the refund
      }

      await refresh();
    }

    return result;
  }
}

/// Invoice list provider
final invoiceListProvider = StateNotifierProvider<InvoiceListNotifier, InvoiceListState>((ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return InvoiceListNotifier(repository, ref);
});
