// Presentation Page: Sales Invoice
// Main page for sales invoice management with Clean Architecture

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../sale_product/presentation/pages/sale_product_page.dart';
import '../../domain/entities/invoice.dart';
import '../extensions/invoice_period_extension.dart';
import '../providers/invoice_list_provider.dart';
import '../providers/states/invoice_list_state.dart';
import '../widgets/invoice_list/filter_bottom_sheets.dart';
import '../widgets/invoice_list/filter_header_delegate.dart';
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

  // Sort option
  InvoiceSortOption? _currentSort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceListProvider.notifier).loadInvoices();
      ref.read(invoiceListProvider.notifier).loadCashLocations();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final invoiceState = ref.read(invoiceListProvider);
      if (invoiceState.canLoadMore && !invoiceState.isLoadingMore) {
        ref.read(invoiceListProvider.notifier).loadNextPage();
      }
    }
  }

  Future<void> _handleRefund(Invoice invoice) async {
    if (mounted) {
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

    try {
      final result = await ref.read(invoiceListProvider.notifier).refundInvoice(
        invoice: invoice,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }

      if (result.success) {
        if (mounted) {
          final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);
          final currency = ref.read(invoiceListProvider).response?.currency;
          final symbol = currency?.symbol ?? '';

          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => TossDialog.success(
              title: 'Refund Successful',
              subtitle: '$symbol${formatter.format(result.totalAmountRefunded)}',
              message: 'Invoice ${invoice.invoiceNumber} has been refunded',
              primaryButtonText: 'Done',
              onPrimaryPressed: () => Navigator.of(context).pop(),
            ),
          );
        }
      } else {
        if (mounted) {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Refund Failed',
              message: result.errorMessage ?? 'Could not process refund',
              primaryButtonText: 'OK',
              onPrimaryPressed: () => Navigator.of(context).pop(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Refund Failed',
            message: e.toString().replaceAll('Exception:', '').trim(),
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceState = ref.watch(invoiceListProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(invoiceState),
      floatingActionButton: _buildFloatingAddButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: TossColors.gray900,
          size: 22,
        ),
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
        _buildAppBarIconButton(Icons.search, () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const InvoiceSearchPage(),
            ),
          );
        }),
        _buildAppBarIconButton(Icons.swap_vert, () {
          HapticFeedback.lightImpact();
          _showSortOptionsSheet();
        }),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildAppBarIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: TossColors.gray900,
        size: 22,
      ),
      splashRadius: 20,
    );
  }

  Widget _buildBody(InvoiceListState invoiceState) {
    // Cash location and status filter applied (sorting is now server-side)
    List<Invoice> displayInvoices = invoiceState.filteredInvoices;

    if (displayInvoices.isEmpty && !invoiceState.isLoading) {
      return Column(
        children: [
          _buildFilterSection(invoiceState),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'No invoices found',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'Create your first invoice to get started',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (invoiceState.isLoading && displayInvoices.isEmpty) {
      return Column(
        children: [
          _buildFilterSection(invoiceState),
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

    if (invoiceState.error != null && displayInvoices.isEmpty) {
      return _buildErrorState(invoiceState.error!);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(invoiceListProvider.notifier).refresh(),
      color: TossColors.primary,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Sticky filter section
          SliverPersistentHeader(
            pinned: true,
            delegate: FilterHeaderDelegate(
              invoiceState: invoiceState,
              onFilterTap: (filter) {
                _showFilterBottomSheet(filter);
              },
            ),
          ),
          // Invoice list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Group invoices by date
                  final groupedInvoices = _groupInvoicesByDate(displayInvoices);
                  final entries = groupedInvoices.entries.toList();

                  // Calculate which item we're rendering
                  int currentIndex = 0;
                  for (final entry in entries) {
                    // Date separator
                    if (index == currentIndex) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: currentIndex == 0 ? 0 : 20,
                          bottom: 2,
                        ),
                        child: _buildDateSeparator(entry.key),
                      );
                    }
                    currentIndex++;

                    // Invoice items for this date
                    for (final invoice in entry.value) {
                      if (index == currentIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
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
                },
                childCount: _calculateTotalItemCount(displayInvoices),
              ),
            ),
          ),
          // Loading More Indicator
          if (invoiceState.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(InvoiceListState invoiceState) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterPill('Time', invoiceState.selectedPeriod.displayName),
                const SizedBox(width: 8),
                _buildFilterPill(
                  'Cash Location',
                  invoiceState.selectedCashLocation?.name ?? 'All Locations',
                  isActive: invoiceState.selectedCashLocation != null,
                ),
                const SizedBox(width: 8),
                _buildFilterPill(
                  'Status',
                  invoiceState.statusDisplayText,
                  isActive: invoiceState.selectedStatus != null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text with bold numbers
          RichText(
            text: TextSpan(
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
              children: [
                const TextSpan(text: 'Total invoice: '),
                TextSpan(
                  text: '${invoiceState.invoices.length} invoices',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const TextSpan(text: ' · Total money: '),
                TextSpan(
                  text: _formatCurrency(_calculateTotalAmount(invoiceState.invoices)),
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String title, String subtitle, {bool isActive = false}) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          _showFilterBottomSheet(title);
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border: isActive ? Border.all(color: TossColors.primary, width: 1) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isActive ? TossColors.primary : TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w400,
                      color: isActive ? TossColors.primary : TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isActive ? TossColors.primary : TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final dayName = dayNames[date.weekday - 1];
    final monthName = monthNames[date.month - 1];

    return Text(
      '$dayName, ${date.day} $monthName ${date.year}',
      style: TossTextStyles.caption.copyWith(
        fontWeight: FontWeight.w400,
        color: TossColors.gray600,
      ),
    );
  }

  Widget _buildFloatingAddButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const SaleProductPage(),
          ),
        );
      },
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: TossColors.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: 24,
          color: TossColors.white,
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: TossColors.error,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Error loading invoices',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            error,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TossSpacing.space4),
          ElevatedButton(
            onPressed: () {
              ref.read(invoiceListProvider.notifier).loadInvoices();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(String filterType) {
    if (filterType == 'Time') {
      InvoiceFilterBottomSheets.showPeriodFilter(context, ref);
    } else if (filterType == 'Cash Location') {
      InvoiceFilterBottomSheets.showCashLocationFilter(context, ref);
    } else if (filterType == 'Status') {
      InvoiceFilterBottomSheets.showStatusFilter(context, ref);
    } else {
      InvoiceFilterBottomSheets.showGenericFilter(context, filterType);
    }
  }

  void _showSortOptionsSheet() {
    InvoiceSortBottomSheet.show(
      context,
      ref,
      currentSort: _currentSort,
      onSortChanged: (newSort) {
        setState(() {
          _currentSort = newSort;
        });
      },
    );
  }

  Map<DateTime, List<Invoice>> _groupInvoicesByDate(List<Invoice> invoices) {
    final grouped = <DateTime, List<Invoice>>{};

    for (final invoice in invoices) {
      final dateKey = DateTime(
        invoice.saleDate.year,
        invoice.saleDate.month,
        invoice.saleDate.day,
      );
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(invoice);
    }

    // Sort by date descending
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedMap = <DateTime, List<Invoice>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }

    return sortedMap;
  }

  int _calculateTotalItemCount(List<Invoice> invoices) {
    final grouped = _groupInvoicesByDate(invoices);
    int count = 0;
    for (final entry in grouped.entries) {
      count++; // Date separator
      count += entry.value.length; // Invoice items
    }
    return count;
  }

  double _calculateTotalAmount(List<Invoice> invoices) {
    return invoices.fold(0.0, (sum, invoice) => sum + invoice.amounts.totalAmount);
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
