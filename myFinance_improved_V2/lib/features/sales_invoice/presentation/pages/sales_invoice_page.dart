import 'package:flutter/material.dart';
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
import '../widgets/invoice_list/invoice_list_section.dart';
import '../widgets/invoice_list/search_filter_section.dart';

class SalesInvoicePage extends ConsumerStatefulWidget {
  const SalesInvoicePage({super.key});

  @override
  ConsumerState<SalesInvoicePage> createState() => _SalesInvoicePageState();
}

class _SalesInvoicePageState extends ConsumerState<SalesInvoicePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceListProvider.notifier).loadInvoices();
    });
    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load next page when near bottom (200px threshold)
      final invoiceState = ref.read(invoiceListProvider);
      if (invoiceState.canLoadMore && !invoiceState.isLoadingMore) {
        ref.read(invoiceListProvider.notifier).loadNextPage();
      }
    }
  }

  Future<void> _handleRefund(Invoice invoice) async {
    // Show loading indicator
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

      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (result.success) {
        // Show success dialog
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
        // Show error dialog
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
      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show error dialog
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
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
        ),
      );
    }

    if (invoiceState.error != null) {
      return _buildErrorState(invoiceState.error!);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(invoiceListProvider.notifier).refresh(),
      color: TossColors.primary,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SearchFilterSection(searchController: _searchController),
            InvoiceListSection(
              onRefundPressed: _handleRefund,
            ),
            // Loading indicator for infinite scroll
            if (invoiceState.isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                  ),
                ),
              ),
            const SizedBox(height: 80),
          ],
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
}
