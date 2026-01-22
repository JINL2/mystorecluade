import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';
import '../../domain/entities/purchase_order.dart';
import '../providers/po_providers.dart';
import '../widgets/po_list_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class PODetailPage extends ConsumerStatefulWidget {
  final String poId;

  const PODetailPage({super.key, required this.poId});

  @override
  ConsumerState<PODetailPage> createState() => _PODetailPageState();
}

class _PODetailPageState extends ConsumerState<PODetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(poDetailProvider.notifier).load(widget.poId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(poDetailProvider);

    return TossScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/purchase-order');
            }
          },
        ),
        title: Text(state.po?.poNumber ?? 'PO Detail'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PODetailState state) {
    if (state.isLoading) {
      return const TossLoadingView();
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(state.error!, style: TossTextStyles.bodyMedium),
            TossButton.textButton(
              text: 'Retry',
              onPressed: () =>
                  ref.read(poDetailProvider.notifier).load(widget.poId),
            ),
          ],
        ),
      );
    }

    final po = state.po;
    if (po == null) {
      return const Center(child: Text('PO not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status & Progress
          _buildStatusSection(po),
          const SizedBox(height: TossSpacing.space5),

          // Basic Info
          _buildBasicInfoSection(po),
          const SizedBox(height: TossSpacing.space5),

          // Buyer Info
          _buildBuyerSection(po),
          const SizedBox(height: TossSpacing.space5),

          // Shipping Info
          _buildShippingSection(po),
          const SizedBox(height: TossSpacing.space5),

          // Items
          _buildItemsSection(po),
          const SizedBox(height: TossSpacing.space5),

          // Totals
          _buildTotalsSection(po),
          const SizedBox(height: TossSpacing.space5),

          // Notes
          if (po.notes != null) _buildNotesSection(po),

          const SizedBox(height: TossSpacing.space5),

          // Cancel Order Button - only show if order can be cancelled
          if (po.canCancel) _buildCancelOrderButton(po),

          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }

  Widget _buildCancelOrderButton(PurchaseOrder po) {
    return SizedBox(
      width: double.infinity,
      child: TossButton.destructive(
        text: 'Cancel Order',
        onPressed: () => _showCancelConfirmDialog(po),
      ),
    );
  }

  Future<void> _showCancelConfirmDialog(PurchaseOrder po) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text(
          'Are you sure you want to cancel order ${po.poNumber}?\n\n'
          'This will also cancel all linked shipments and sessions.',
        ),
        actions: [
          TossButton.textButton(
            text: 'No',
            onPressed: () => Navigator.pop(context, false),
          ),
          TossButton.textButton(
            text: 'Yes, Cancel',
            textColor: TossColors.error,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Provider's isLoading state will show loading UI
      final result = await ref.read(poDetailProvider.notifier).closeOrder();

      if (mounted) {
        if (result != null && result['success'] == true) {
          final data = result['data'] as Map<String, dynamic>?;
          final message = result['message'] as String? ?? 'Order cancelled';

          TossToast.success(context, message);

          // Refresh list
          ref.read(poListProvider.notifier).refresh();

          // Navigate back if order is cancelled
          if (data?['new_status'] == 'cancelled') {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/purchase-order');
            }
          }
        } else {
          final error = ref.read(poDetailProvider).error;
          TossToast.error(context, error ?? 'Failed to cancel order');
        }
      }
    }
  }

  Widget _buildStatusSection(PurchaseOrder po) {
    return TradeSimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              POStatusChip(status: po.status),
              const Spacer(),
              if (po.requiredShipmentDateUtc != null) ...[
                Icon(
                  Icons.local_shipping_outlined,
                  size: TossSpacing.iconSM2,
                  color: _getShipmentDateColor(po.requiredShipmentDateUtc!),
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  'Ship by ${DateFormat('MMM dd').format(po.requiredShipmentDateUtc!)}',
                  style: TossTextStyles.caption.copyWith(
                    color: _getShipmentDateColor(po.requiredShipmentDateUtc!),
                  ),
                ),
              ],
            ],
          ),
          if (po.shippedPercent > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildShipmentProgress(po.shippedPercent),
          ],
        ],
      ),
    );
  }

  Color _getShipmentDateColor(DateTime date) {
    final diff = date.difference(DateTime.now()).inDays;
    if (diff < 0) return TossColors.error;
    if (diff <= 7) return TossColors.warning;
    return TossColors.gray600;
  }

  Widget _buildShipmentProgress(double percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipment Progress',
              style:
                  TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        ClipRRect(
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: TossColors.gray200,
            valueColor: const AlwaysStoppedAnimation<Color>(TossColors.primary),
            minHeight: TossSpacing.space2,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(PurchaseOrder po) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Basic Information'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            children: [
              _InfoRow(label: 'PO Number', value: po.poNumber),
              if (po.piNumber != null)
                _InfoRow(label: 'From PI', value: po.piNumber!),
              if (po.buyerPoNumber != null)
                _InfoRow(label: 'Buyer PO #', value: po.buyerPoNumber!),
              if (po.orderDateUtc != null)
                _InfoRow(
                  label: 'Order Date',
                  value: DateFormat('MMM dd, yyyy').format(po.orderDateUtc!),
                ),
              if (po.incotermsCode != null)
                _InfoRow(
                  label: 'Incoterms',
                  value:
                      '${po.incotermsCode}${po.incotermsPlace != null ? ' - ${po.incotermsPlace}' : ''}',
                ),
              if (po.paymentTermsCode != null)
                _InfoRow(
                  label: 'Payment Terms',
                  value: po.paymentTermsCode!,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBuyerSection(PurchaseOrder po) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Buyer'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                po.buyerName ?? 'Unknown Buyer',
                style: TossTextStyles.bodyLarge
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              if (po.buyerInfo != null && po.buyerInfo!.isNotEmpty) ...[
                const SizedBox(height: TossSpacing.space2),
                Text(
                  _formatBuyerInfo(po.buyerInfo!),
                  style: TossTextStyles.bodyMedium
                      .copyWith(color: TossColors.gray600),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatBuyerInfo(Map<String, dynamic> buyerInfo) {
    final parts = <String>[];
    if (buyerInfo['address'] != null) parts.add(buyerInfo['address'].toString());
    if (buyerInfo['city'] != null) parts.add(buyerInfo['city'].toString());
    if (buyerInfo['country'] != null) parts.add(buyerInfo['country'].toString());
    return parts.join(', ');
  }

  Widget _buildShippingSection(PurchaseOrder po) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Shipping'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Column(
            children: [
              if (po.requiredShipmentDateUtc != null)
                _InfoRow(
                  label: 'Required Shipment Date',
                  value: DateFormat('MMM dd, yyyy')
                      .format(po.requiredShipmentDateUtc!),
                ),
              _InfoRow(
                label: 'Partial Shipment',
                value: po.partialShipmentAllowed ? 'Allowed' : 'Not Allowed',
              ),
              _InfoRow(
                label: 'Transshipment',
                value: po.transshipmentAllowed ? 'Allowed' : 'Not Allowed',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(PurchaseOrder po) {
    // Get exchange rate data
    final exchangeRateAsync = ref.watch(tradeExchangeRateProvider(po.companyId));

    return exchangeRateAsync.when(
      loading: () => _buildItemsSectionContent(po, null),
      error: (_, __) => _buildItemsSectionContent(po, null),
      data: (exchangeRateData) => _buildItemsSectionContent(po, exchangeRateData),
    );
  }

  Widget _buildItemsSectionContent(PurchaseOrder po, TradeExchangeRateData? exchangeRateData) {
    // Use base currency from exchange rate data
    final currencyCode = exchangeRateData?.baseCurrencyCode ?? 'VND';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TradeSectionHeader(title: 'Items', badge: '${po.items.length}'),
        const SizedBox(height: TossSpacing.space2),
        ...po.items.map((item) => _POItemCard(
              item: item,
              currencyCode: currencyCode,
            )),
      ],
    );
  }

  Widget _buildTotalsSection(PurchaseOrder po) {
    // Get exchange rate data
    final exchangeRateAsync = ref.watch(tradeExchangeRateProvider(po.companyId));

    return exchangeRateAsync.when(
      loading: () => _buildTotalsSectionContent(po, null),
      error: (_, __) => _buildTotalsSectionContent(po, null),
      data: (exchangeRateData) => _buildTotalsSectionContent(po, exchangeRateData),
    );
  }

  Widget _buildTotalsSectionContent(PurchaseOrder po, TradeExchangeRateData? exchangeRateData) {
    // Use base currency from exchange rate data
    final currencyCode = exchangeRateData?.baseCurrencyCode ?? 'VND';

    return TradeSimpleCard(
      child: TradeDualCurrencyInfoRow(
        label: 'Total',
        primaryCurrency: currencyCode,
        primaryAmount: po.totalAmount,
        secondaryCurrency: null,
        secondaryAmount: null,
        highlight: true,
      ),
    );
  }

  Widget _buildNotesSection(PurchaseOrder po) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TradeSectionHeader(title: 'Notes'),
        const SizedBox(height: TossSpacing.space2),
        TradeSimpleCard(
          child: Text(po.notes!, style: TossTextStyles.bodyMedium),
        ),
      ],
    );
  }

}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                TossTextStyles.bodyMedium.copyWith(color: TossColors.gray600),
          ),
          Text(
            value,
            style: TossTextStyles.bodyMedium.copyWith(
              color: valueColor ?? TossColors.gray900,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _POItemCard extends StatelessWidget {
  final POItem item;
  final String currencyCode;

  const _POItemCard({
    required this.item,
    required this.currencyCode,
  });

  String _formatAmount(double amount) {
    final noDecimalCurrencies = ['VND', 'KRW', 'JPY', 'IDR'];
    if (noDecimalCurrencies.contains(currencyCode)) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final hasShipped = item.shippedQuantity > 0;
    final remainingQty = item.quantity - item.shippedQuantity;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            item.description,
            style:
                TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          if (item.sku != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              'SKU: ${item.sku}',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
          ],
          const SizedBox(height: TossSpacing.space2),

          // Quantity & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat('#,##0.##').format(item.quantity)} ${item.unit ?? 'PCS'}',
                style:
                    TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
              ),
              Text(
                'per $currencyCode ${_formatAmount(item.unitPrice)}',
                style:
                    TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
              ),
            ],
          ),

          // Shipped quantity info
          if (hasShipped) ...[
            const SizedBox(height: TossSpacing.space2),
            Row(
              children: [
                const Icon(Icons.local_shipping,
                    size: TossSpacing.iconXS, color: TossColors.success),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  'Shipped: ${NumberFormat('#,##0.##').format(item.shippedQuantity)}',
                  style:
                      TossTextStyles.caption.copyWith(color: TossColors.success),
                ),
                if (remainingQty > 0) ...[
                  const Text(' | ', style: TextStyle(color: TossColors.gray400)),
                  Text(
                    'Remaining: ${NumberFormat('#,##0.##').format(remainingQty)}',
                    style: TossTextStyles.caption
                        .copyWith(color: TossColors.warning),
                  ),
                ],
              ],
            ),
          ],

          const SizedBox(height: TossSpacing.space2),

          // Line total
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$currencyCode ${_formatAmount(item.totalAmount)}',
                style: TossTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
