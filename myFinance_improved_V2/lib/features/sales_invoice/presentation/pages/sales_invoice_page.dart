import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/value_objects/invoice_period.dart';
import '../../domain/value_objects/invoice_sort_option.dart';
import '../../../sale_product/presentation/pages/sale_product_page.dart';
import '../modals/invoice_detail_modal.dart';
import '../providers/invoice_list_provider.dart';

class SalesInvoicePage extends ConsumerStatefulWidget {
  const SalesInvoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SalesInvoicePage> createState() => _SalesInvoicePageState();
}

class _SalesInvoicePageState extends ConsumerState<SalesInvoicePage> {
  final TextEditingController _searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Load invoices when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceListProvider.notifier).loadInvoices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Sales Invoice',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const SaleProductPage(),
            ),
          );
        },
        backgroundColor: TossColors.primary,
        child: const Icon(Icons.add, color: TossColors.white),
      ),
    );
  }

  Widget _buildBody() {
    final invoiceState = ref.watch(invoiceListProvider);

    if (invoiceState.isLoading && invoiceState.response == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
        ),
      );
    }

    if (invoiceState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            SizedBox(height: TossSpacing.space3),
            Text(
              'Error loading invoices',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              invoiceState.error!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space4),
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

    return RefreshIndicator(
      onRefresh: () => ref.read(invoiceListProvider.notifier).refresh(),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Search and Filter Section
            _buildSearchFilterSection(),

            // Invoice list grouped by date
            _buildInvoiceList(),

            // Pagination controls
            if (invoiceState.response != null) _buildPaginationControls(),

            // Bottom padding for FAB
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    final invoiceState = ref.watch(invoiceListProvider);

    return Column(
      children: [
        // Filter and Sort Controls
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Filter Section
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showFilterSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          size: 22,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            invoiceState.selectedPeriod.displayName,
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 20,
                color: TossColors.gray200,
              ),

              // Sort Section
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showSortSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 22,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            invoiceState.sortBy.displayName,
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (invoiceState.sortBy != InvoiceSortOption.date)
                          Icon(
                            invoiceState.sortAscending
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 16,
                            color: TossColors.primary,
                          ),
                        SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search Field
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space4,
          ),
          child: TossSearchField(
            controller: _searchController,
            hintText: 'Search by invoice number (e.g., IN2025...)',
            onChanged: (value) {
              ref.read(invoiceListProvider.notifier).updateSearch(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceList() {
    final invoiceState = ref.watch(invoiceListProvider);
    final groupedInvoices = invoiceState.groupedInvoices;

    if (groupedInvoices.isEmpty) {
      return Container(
        margin: EdgeInsets.all(TossSpacing.space4),
        padding: EdgeInsets.all(TossSpacing.space8),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.space3),
            Text(
              'No invoices found',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Create your first invoice to get started',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: groupedInvoices.entries.map((entry) {
        final dateKey = entry.key;
        final invoices = entry.value;

        return Container(
          margin: EdgeInsets.only(
            left: TossSpacing.space4,
            right: TossSpacing.space4,
            top: TossSpacing.space3,
          ),
          child: TossWhiteCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Date header
                Container(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: TossColors.gray100,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: TossColors.primary,
                        size: TossSpacing.iconSM,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        dateKey,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),

                // Invoice items
                ...invoices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final invoice = entry.value;
                  final isLast = index == invoices.length - 1;

                  return Column(
                    children: [
                      _buildInvoiceItem(invoice),
                      if (!isLast)
                        Divider(
                          height: 1,
                          color: TossColors.gray100,
                          indent: TossSpacing.space4,
                          endIndent: TossSpacing.space4,
                        ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInvoiceItem(Invoice invoice) {
    final currency = ref.watch(invoiceListProvider).response?.currency;
    return InkWell(
      onTap: () {
        // Show invoice detail modal
        InvoiceDetailModal.show(context, invoice, currency?.symbol);
      },
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Time
            SizedBox(
              width: 50,
              child: Text(
                invoice.timeString,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space3),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          invoice.invoiceNumber,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                      ),
                      if (invoice.amounts.totalAmount > 0) ...[
                        Text(
                          '${currency?.symbol ?? ''}${currencyFormat.format(invoice.amounts.totalAmount)}',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Row(
                    children: [
                      Text(
                        invoice.customer?.name ?? invoice.createdByName ?? 'Walk-in',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        '•',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        '${invoice.itemsSummary.itemCount} products',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: TossSpacing.space2),

            // Status icon
            if (invoice.isCompleted)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: TossColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: TossColors.success,
                ),
              )
            else if (invoice.isDraft)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: TossColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.schedule,
                  size: 16,
                  color: TossColors.warning,
                ),
              )
            else if (invoice.isCancelled)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: TossColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: TossColors.error,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final invoiceState = ref.watch(invoiceListProvider);
    final pagination = invoiceState.response?.pagination;

    if (pagination == null || pagination.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          IconButton(
            onPressed: pagination.hasPrev
                ? () => ref.read(invoiceListProvider.notifier).previousPage()
                : null,
            icon: const Icon(Icons.chevron_left),
            color: TossColors.primary,
            disabledColor: TossColors.gray400,
          ),

          // Page indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              'Page ${pagination.page} of ${pagination.totalPages}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Next button
          IconButton(
            onPressed: pagination.hasNext
                ? () => ref.read(invoiceListProvider.notifier).nextPage()
                : null,
            icon: const Icon(Icons.chevron_right),
            color: TossColors.primary,
            disabledColor: TossColors.gray400,
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    final invoiceState = ref.read(invoiceListProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Title
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Filter by Period',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Filter options
            for (final period in InvoicePeriod.values)
              _buildFilterOption(
                period.displayName,
                invoiceState.selectedPeriod == period,
                () => ref.read(invoiceListProvider.notifier).updatePeriod(period),
              ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  void _showSortSheet() {
    final invoiceState = ref.read(invoiceListProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Title
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Sort by',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Sort options
            for (final sortOption in InvoiceSortOption.values)
              _buildSortOption(
                sortOption.displayName,
                sortOption.icon,
                invoiceState.sortBy == sortOption,
                () => ref.read(invoiceListProvider.notifier).updateSort(sortOption),
              ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected, VoidCallback onTap) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray900,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    final invoiceState = ref.read(invoiceListProvider);

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray900,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected) ...[
                Icon(
                  invoiceState.sortAscending
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 16,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
