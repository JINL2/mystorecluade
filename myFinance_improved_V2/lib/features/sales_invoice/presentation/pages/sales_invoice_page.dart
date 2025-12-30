// lib/features/sales_invoice/presentation/pages/sales_invoice_page.dart
//
// Sales Invoice Page - Main page for sales invoice management
// Refactored following Clean Architecture 2025 - Single Responsibility Principle
//
// Extracted widgets:
// - InvoiceFilterSection: Filter pills and summary
// - InvoiceErrorState: Error display with retry
// - InvoiceEmptyState: Empty state display
// - InvoiceDateSeparator: Date grouping headers
// - InvoiceFloatingButton: FAB for new invoice

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../sale_product/presentation/pages/sale_product_page.dart';
import '../../domain/entities/invoice.dart';
import '../providers/invoice_list_provider.dart';
import '../providers/states/invoice_list_state.dart';
import '../widgets/invoice_list/filter_bottom_sheets.dart';
import '../widgets/invoice_list/filter_header_delegate.dart';
import '../widgets/invoice_list/invoice_date_separator.dart';
import '../widgets/invoice_list/invoice_empty_state.dart';
import '../widgets/invoice_list/invoice_error_state.dart';
import '../widgets/invoice_list/invoice_filter_section.dart';
import '../widgets/invoice_list/invoice_floating_button.dart';
import '../widgets/invoice_list/invoice_list_item.dart';
import '../widgets/invoice_list/invoice_sort_options.dart';
import '../widgets/invoice_list/sort_bottom_sheet.dart';
import 'invoice_search_page.dart';

class SalesInvoicePage extends ConsumerStatefulWidget {
  const SalesInvoicePage({super.key});

  @override
  ConsumerState<SalesInvoicePage> createState() => _SalesInvoicePageState();
}

class _SalesInvoicePageState extends ConsumerState<SalesInvoicePage> {
  final ScrollController _scrollController = ScrollController();
  InvoiceSortOption? _currentSort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeInvoices());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeInvoices() {
    final notifier = ref.read(invoiceListNotifierProvider.notifier);
    notifier.clearCashLocationFilter();
    notifier.clearStatusFilter();
    notifier.loadInvoices();
    notifier.loadCashLocations();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final invoiceState = ref.read(invoiceListNotifierProvider);
      if (invoiceState.canLoadMore && !invoiceState.isLoadingMore) {
        ref.read(invoiceListNotifierProvider.notifier).loadNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceState = ref.watch(invoiceListNotifierProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(invoiceState),
      floatingActionButton: InvoiceFloatingButton(
        onPressed: _navigateToSaleProduct,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: TossColors.gray900, size: 22),
      ),
      title: Text(
        'Invoice',
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _navigateToSearch();
          },
          icon: const Icon(Icons.search, color: TossColors.gray900, size: 22),
          splashRadius: 20,
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _showSortOptionsSheet();
          },
          icon: const Icon(Icons.swap_vert, color: TossColors.gray900, size: 22),
          splashRadius: 20,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody(InvoiceListState invoiceState) {
    final displayInvoices = invoiceState.filteredInvoices;

    // Empty state
    if (displayInvoices.isEmpty && !invoiceState.isLoading) {
      return Column(
        children: [
          InvoiceFilterSection(
            invoiceState: invoiceState,
            onFilterTap: _showFilterBottomSheet,
          ),
          const Expanded(child: InvoiceEmptyState()),
        ],
      );
    }

    // Loading state
    if (invoiceState.isLoading && displayInvoices.isEmpty) {
      return Column(
        children: [
          InvoiceFilterSection(
            invoiceState: invoiceState,
            onFilterTap: _showFilterBottomSheet,
          ),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
              ),
            ),
          ),
        ],
      );
    }

    // Error state
    if (invoiceState.error != null && displayInvoices.isEmpty) {
      return InvoiceErrorState(
        error: invoiceState.error!,
        onRetry: () => ref.read(invoiceListNotifierProvider.notifier).loadInvoices(),
      );
    }

    // Invoice list
    return RefreshIndicator(
      onRefresh: () => ref.read(invoiceListNotifierProvider.notifier).refresh(),
      color: TossColors.primary,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: FilterHeaderDelegate(
              invoiceState: invoiceState,
              onFilterTap: _showFilterBottomSheet,
            ),
          ),
          _buildInvoiceList(displayInvoices),
          if (invoiceState.isLoadingMore) _buildLoadingMoreIndicator(),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(List<Invoice> invoices) {
    final groupedInvoices = _groupInvoicesByDate(invoices);
    final entries = groupedInvoices.entries.toList();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space1, TossSpacing.space3, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildListItem(index, entries),
          childCount: _calculateTotalItemCount(invoices),
        ),
      ),
    );
  }

  Widget? _buildListItem(int index, List<MapEntry<DateTime, List<Invoice>>> entries) {
    int currentIndex = 0;
    for (final entry in entries) {
      // Date separator
      if (index == currentIndex) {
        return Padding(
          padding: EdgeInsets.only(top: currentIndex == 0 ? 0 : 20, bottom: 2),
          child: InvoiceDateSeparator(date: entry.key),
        );
      }
      currentIndex++;

      // Invoice items
      for (final invoice in entry.value) {
        if (index == currentIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space4),
            child: InvoiceListItem(
              invoice: invoice,
              onRefundPressed: _handleRefund,
            ),
          );
        }
        currentIndex++;
      }
    }
    return null;
  }

  Widget _buildLoadingMoreIndicator() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Navigation
  // ============================================================================

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const InvoiceSearchPage()),
    );
  }

  void _navigateToSaleProduct() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const SaleProductPage()),
    );
  }

  // ============================================================================
  // Bottom Sheets
  // ============================================================================

  void _showFilterBottomSheet(String filterType) {
    switch (filterType) {
      case 'Time':
        InvoiceFilterBottomSheets.showPeriodFilter(context, ref);
      case 'Cash Location':
        InvoiceFilterBottomSheets.showCashLocationFilter(context, ref);
      case 'Status':
        InvoiceFilterBottomSheets.showStatusFilter(context, ref);
      default:
        InvoiceFilterBottomSheets.showGenericFilter(context, filterType);
    }
  }

  void _showSortOptionsSheet() {
    InvoiceSortBottomSheet.show(
      context,
      ref,
      currentSort: _currentSort,
      onSortChanged: (newSort) => setState(() => _currentSort = newSort),
    );
  }

  // ============================================================================
  // Refund Handling
  // ============================================================================

  Future<void> _handleRefund(Invoice invoice) async {
    _showLoadingDialog();

    try {
      final result = await ref.read(invoiceListNotifierProvider.notifier).refundInvoice(
        invoice: invoice,
      );

      if (mounted) Navigator.of(context).pop();

      if (result.success) {
        _showRefundSuccessDialog(invoice, result.totalAmountRefunded);
      } else {
        _showErrorDialog('Refund Failed', result.errorMessage ?? 'Could not process refund');
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _showErrorDialog('Refund Failed', e.toString().replaceAll('Exception:', '').trim());
    }
  }

  void _showLoadingDialog() {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
        ),
      ),
    );
  }

  void _showRefundSuccessDialog(Invoice invoice, double totalRefunded) {
    if (!mounted) return;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final currency = ref.read(invoiceListNotifierProvider).response?.currency;
    final symbol = currency?.symbol ?? '';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TossDialog.success(
        title: 'Refund Successful',
        subtitle: '$symbol${formatter.format(totalRefunded)}',
        message: 'Invoice ${invoice.invoiceNumber} has been refunded',
        primaryButtonText: 'Done',
        onPrimaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: title,
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  Map<DateTime, List<Invoice>> _groupInvoicesByDate(List<Invoice> invoices) {
    final grouped = <DateTime, List<Invoice>>{};

    for (final invoice in invoices) {
      final dateKey = DateTime(
        invoice.saleDate.year,
        invoice.saleDate.month,
        invoice.saleDate.day,
      );
      grouped.putIfAbsent(dateKey, () => []).add(invoice);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return {for (final key in sortedKeys) key: grouped[key]!};
  }

  int _calculateTotalItemCount(List<Invoice> invoices) {
    final grouped = _groupInvoicesByDate(invoices);
    return grouped.entries.fold(0, (count, entry) => count + 1 + entry.value.length);
  }
}
