import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/value_objects/invoice_filter.dart';
import '../../domain/value_objects/invoice_period.dart';
import '../../domain/value_objects/invoice_sort_option.dart';
import 'invoice_providers.dart';
import 'states/invoice_list_state.dart';

/// Account IDs for journal entries
/// These are fixed account IDs for the refund journal entry
const String _salesRevenueAccountId = 'e45e7d41-7fda-43a1-ac55-9779f3e59697';
const String _cashAccountId = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';
const String _cogsAccountId = '90565fe4-5bfc-4c5e-8759-af9a64e98cae';
const String _inventoryAccountId = '8babc1b3-47b4-4982-8f50-099ab9cdcaf9';

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

  /// Refund invoice
  ///
  /// This method:
  /// 1. Calls the inventory refund RPC to process the refund
  /// 2. Creates a journal entry for the refund (debit: sales, credit: cash)
  /// 3. Refreshes the invoice list
  Future<RefundResult> refundInvoice({
    required Invoice invoice,
    String? notes,
  }) async {
    debugPrint('🔄 [Refund] Starting refund for invoice: ${invoice.invoiceNumber}');
    debugPrint('🔄 [Refund] Invoice ID: ${invoice.invoiceId}');
    debugPrint('🔄 [Refund] Total Amount: ${invoice.amounts.totalAmount}');
    debugPrint('🔄 [Refund] Total Cost: ${invoice.amounts.totalCost}');
    debugPrint('🔄 [Refund] Cash Location: ${invoice.cashLocation?.cashLocationId ?? "NULL"}');
    debugPrint('🔄 [Refund] Cash Location Name: ${invoice.cashLocation?.locationName ?? "NULL"}');

    final appState = _ref.read(appStateProvider);
    final userId = appState.userId;
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    debugPrint('🔄 [Refund] User ID: $userId');
    debugPrint('🔄 [Refund] Company ID: $companyId');
    debugPrint('🔄 [Refund] Store ID: $storeId');

    if (userId.isEmpty) {
      debugPrint('❌ [Refund] Error: User not logged in');
      throw Exception('User not logged in');
    }

    if (companyId.isEmpty || storeId.isEmpty) {
      debugPrint('❌ [Refund] Error: Company or store not selected');
      throw Exception('Company or store not selected');
    }

    // 1. Process the inventory refund
    debugPrint('📤 [Refund] Step 1: Calling inventory_refund_invoice_v2 RPC...');
    final result = await _repository.refundInvoice(
      invoiceIds: [invoice.invoiceId],
      userId: userId,
      notes: notes,
    );
    debugPrint('📥 [Refund] Step 1 Result: success=${result.success}, refunded=${result.totalAmountRefunded}');
    if (!result.success) {
      debugPrint('❌ [Refund] Step 1 Failed: ${result.errorMessage}');
    }

    // 2. If refund successful, create journal entry (cash location is optional)
    debugPrint('🔄 [Refund] Step 2: Checking journal entry conditions...');
    debugPrint('🔄 [Refund] - result.success: ${result.success}');

    if (result.success) {
      debugPrint('📤 [Refund] Step 2: Calling insert_journal_with_everything_utc RPC...');
      debugPrint('📤 [Refund] Journal Params:');
      debugPrint('📤 [Refund] - companyId: $companyId');
      debugPrint('📤 [Refund] - storeId: $storeId');
      debugPrint('📤 [Refund] - userId: $userId');
      debugPrint('📤 [Refund] - amount: ${invoice.amounts.totalAmount}');
      debugPrint('📤 [Refund] - cashLocationId: ${invoice.cashLocation?.cashLocationId ?? "NULL (will be excluded)"}');
      debugPrint('📤 [Refund] - cashAccountId: $_cashAccountId');
      debugPrint('📤 [Refund] - salesAccountId: $_salesRevenueAccountId');
      debugPrint('📤 [Refund] - cogsAccountId: $_cogsAccountId');
      debugPrint('📤 [Refund] - inventoryAccountId: $_inventoryAccountId');
      debugPrint('📤 [Refund] - totalCost: ${invoice.amounts.totalCost}');

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
        debugPrint('✅ [Refund] Step 2: Journal entries created successfully (Refund + COGS Reversal)');
      } catch (e) {
        // Log journal entry error but don't fail the refund
        // The inventory refund was already successful
        debugPrint('❌ [Refund] Step 2 Failed: $e');
      }
    } else {
      debugPrint('⚠️ [Refund] Step 2: Skipped - refund was not successful');
    }

    // 3. Refresh the invoice list after refund
    if (result.success) {
      debugPrint('🔄 [Refund] Step 3: Refreshing invoice list...');
      await refresh();
      debugPrint('✅ [Refund] Step 3: Invoice list refreshed');
    }

    debugPrint('✅ [Refund] Complete');
    return result;
  }
}

/// Invoice list provider
final invoiceListProvider = StateNotifierProvider<InvoiceListNotifier, InvoiceListState>((ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return InvoiceListNotifier(repository, ref);
});
