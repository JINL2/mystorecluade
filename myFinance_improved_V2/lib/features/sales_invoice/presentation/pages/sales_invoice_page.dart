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
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../../sale_product/presentation/pages/sale_product_page.dart';
import '../../domain/entities/invoice.dart';
import '../extensions/invoice_period_extension.dart';
import '../providers/invoice_list_provider.dart';
import '../providers/states/invoice_list_state.dart';
import '../widgets/invoice_list/invoice_list_item.dart';

class SalesInvoicePage extends ConsumerStatefulWidget {
  const SalesInvoicePage({super.key});

  @override
  ConsumerState<SalesInvoicePage> createState() => _SalesInvoicePageState();
}

class _SalesInvoicePageState extends ConsumerState<SalesInvoicePage> {
  final ScrollController _scrollController = ScrollController();

  // Sort option
  _SortOption? _currentSort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceListProvider.notifier).loadInvoices();
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
          // TODO: Implement search navigation
          HapticFeedback.lightImpact();
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
    // Apply local sorting
    List<Invoice> displayInvoices = _applyLocalSort(invoiceState.invoices);

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
            delegate: _FilterHeaderDelegate(
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
                _buildFilterPill('Amount', 'Paid · Sub-total · Discount'),
                const SizedBox(width: 8),
                _buildFilterPill('Payment', 'Cash · Bank · Vault'),
                const SizedBox(width: 8),
                _buildFilterPill('Status', 'Completed · Cancelled'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text
          Text(
            'Total invoice: ${invoiceState.invoices.length} invoices · Total money: ${_formatCurrency(_calculateTotalAmount(invoiceState.invoices))}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
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

  Widget _buildFilterPill(String title, String subtitle) {
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
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
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
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: TossColors.gray600,
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
      _showPeriodFilterSheet();
    } else {
      // For other filters, show placeholder
      TossBottomSheet.show<void>(
        context: context,
        title: filterType,
        content: Center(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Filter by $filterType coming soon',
              style: TossTextStyles.body.copyWith(color: TossColors.gray600),
            ),
          ),
        ),
      );
    }
  }

  void _showPeriodFilterSheet() {
    final invoiceState = ref.read(invoiceListProvider);

    TossBottomSheet.show<void>(
      context: context,
      title: 'Filter by Period',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: InvoicePeriod.values.map((period) {
            final isSelected = invoiceState.selectedPeriod == period;
            return ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              title: Text(
                period.displayName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: TossColors.primary, size: 20)
                  : null,
              onTap: () {
                ref.read(invoiceListProvider.notifier).updatePeriod(period);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSortOptionsSheet() {
    TossBottomSheet.show<void>(
      context: context,
      title: 'Sort By',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('Date (Newest)', _SortOption.dateDesc),
            _buildSortOption('Date (Oldest)', _SortOption.dateAsc),
            _buildSortOption('Amount (High to Low)', _SortOption.amountDesc),
            _buildSortOption('Amount (Low to High)', _SortOption.amountAsc),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, _SortOption option) {
    final isSelected = _currentSort == option;
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: TossColors.primary, size: 20)
          : null,
      onTap: () {
        setState(() {
          if (_currentSort == option) {
            _currentSort = null;
          } else {
            _currentSort = option;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  List<Invoice> _applyLocalSort(List<Invoice> invoices) {
    if (_currentSort == null) return invoices;

    final sorted = List<Invoice>.from(invoices);

    switch (_currentSort!) {
      case _SortOption.dateAsc:
        sorted.sort((a, b) => a.saleDate.compareTo(b.saleDate));
      case _SortOption.dateDesc:
        sorted.sort((a, b) => b.saleDate.compareTo(a.saleDate));
      case _SortOption.amountAsc:
        sorted.sort((a, b) => a.amounts.totalAmount.compareTo(b.amounts.totalAmount));
      case _SortOption.amountDesc:
        sorted.sort((a, b) => b.amounts.totalAmount.compareTo(a.amounts.totalAmount));
    }

    return sorted;
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

/// Sticky header delegate for filters
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final InvoiceListState invoiceState;
  final void Function(String) onFilterTap;

  _FilterHeaderDelegate({
    required this.invoiceState,
    required this.onFilterTap,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
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
                _buildFilterPill(context, 'Time', invoiceState.selectedPeriod.displayName),
                const SizedBox(width: 8),
                _buildFilterPill(context, 'Amount', 'Paid · Sub-total · Discount'),
                const SizedBox(width: 8),
                _buildFilterPill(context, 'Payment', 'Cash · Bank · Vault'),
                const SizedBox(width: 8),
                _buildFilterPill(context, 'Status', 'Completed · Cancelled'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text
          Text(
            'Total invoice: ${invoiceState.invoices.length} invoices · Total money: ${_formatCurrency(_calculateTotalAmount())}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
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

  Widget _buildFilterPill(BuildContext context, String title, String subtitle) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onFilterTap(title),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
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
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalAmount() {
    return invoiceState.invoices.fold(0.0, (sum, invoice) => sum + invoice.amounts.totalAmount);
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// Sort options for invoice list
enum _SortField { date, amount }

enum _SortDirection { asc, desc }

class _SortOption {
  final _SortField field;
  final _SortDirection direction;

  const _SortOption(this.field, this.direction);

  static const dateAsc = _SortOption(_SortField.date, _SortDirection.asc);
  static const dateDesc = _SortOption(_SortField.date, _SortDirection.desc);
  static const amountAsc = _SortOption(_SortField.amount, _SortDirection.asc);
  static const amountDesc = _SortOption(_SortField.amount, _SortDirection.desc);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SortOption && field == other.field && direction == other.direction;

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;
}
