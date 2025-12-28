import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../trade_shared/presentation/services/trade_pdf_service.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';
import '../../domain/entities/purchase_order.dart';
import '../providers/po_providers.dart';
import '../widgets/po_list_item.dart';

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
        actions: [
          if (state.po != null && state.po!.isEditable)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push('/purchase-order/${widget.poId}/edit'),
            ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, state.po),
            itemBuilder: (context) => [
              if (state.po?.canConfirm == true)
                const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
              if (state.po?.canStartProduction == true)
                const PopupMenuItem(
                    value: 'start_production', child: Text('Start Production')),
              if (state.po?.canMarkReadyToShip == true)
                const PopupMenuItem(
                    value: 'ready_to_ship', child: Text('Mark Ready to Ship')),
              if (state.po?.canShip == true)
                const PopupMenuItem(value: 'ship', child: Text('Mark Shipped')),
              if (state.po?.canComplete == true)
                const PopupMenuItem(
                    value: 'complete', child: Text('Mark Completed')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'share_pdf', child: Text('Share PDF')),
              const PopupMenuItem(value: 'print', child: Text('Print')),
              if (state.po?.piId != null)
                PopupMenuItem(
                  value: 'view_pi',
                  child: Text('View PI (${state.po!.piNumber ?? 'PI'})'),
                ),
              const PopupMenuDivider(),
              if (state.po?.canCancel == true)
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancel', style: TextStyle(color: Colors.orange)),
                ),
              if (state.po?.isEditable == true)
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PODetailState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
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
            TextButton(
              onPressed: () =>
                  ref.read(poDetailProvider.notifier).load(widget.poId),
              child: const Text('Retry'),
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

          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
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
                  size: 16,
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
            minHeight: 8,
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
              _InfoRow(label: 'Currency', value: po.currencyCode),
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
              _InfoRow(label: 'Version', value: 'v${po.version}'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TradeSectionHeader(title: 'Items', badge: '${po.items.length}'),
        const SizedBox(height: TossSpacing.space2),
        ...po.items
            .map((item) => _POItemCard(item: item, currencyCode: po.currencyCode)),
      ],
    );
  }

  Widget _buildTotalsSection(PurchaseOrder po) {
    return TradeSimpleCard(
      child: Column(
        children: [
          _InfoRow(
            label: 'Total',
            value: '${po.currencyCode} ${_formatAmount(po.totalAmount)}',
            isBold: true,
          ),
        ],
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

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }

  Future<void> _handleMenuAction(String action, PurchaseOrder? po) async {
    if (po == null) return;

    switch (action) {
      case 'confirm':
        await ref.read(poDetailProvider.notifier).confirm();
        if (mounted) {
          ref.read(poListProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PO confirmed')),
          );
        }
        break;

      case 'start_production':
        await ref.read(poDetailProvider.notifier).startProduction();
        if (mounted) {
          ref.read(poListProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Production started')),
          );
        }
        break;

      case 'ready_to_ship':
        await ref.read(poDetailProvider.notifier).markReadyToShip();
        if (mounted) {
          ref.read(poListProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marked as ready to ship')),
          );
        }
        break;

      case 'ship':
        await ref.read(poDetailProvider.notifier).markShipped();
        if (mounted) {
          ref.read(poListProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marked as shipped')),
          );
        }
        break;

      case 'complete':
        await ref.read(poDetailProvider.notifier).complete();
        if (mounted) {
          ref.read(poListProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PO completed')),
          );
        }
        break;

      case 'cancel':
        final reason = await _showCancelDialog();
        if (reason != null) {
          await ref.read(poDetailProvider.notifier).cancel(reason: reason);
          if (mounted) {
            ref.read(poListProvider.notifier).refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PO cancelled')),
            );
          }
        }
        break;

      case 'view_pi':
        if (po.piId != null) {
          context.push('/proforma-invoice/${po.piId}');
        }
        break;

      case 'share_pdf':
        await _generateAndSharePdf(po);
        break;

      case 'print':
        await _printPdf(po);
        break;

      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete PO?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirm == true) {
          final success =
              await ref.read(poFormProvider.notifier).delete(po.poId);
          if (mounted && success) {
            context.go('/purchase-order');
          }
        }
        break;
    }
  }

  Future<String?> _showCancelDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel PO'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this PO?'),
            const SizedBox(height: TossSpacing.space3),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Cancel PO',
                style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndSharePdf(PurchaseOrder po) async {
    // Show loading indicator
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final pdfBytes = await TradePdfService.generatePurchaseOrderPdf(po);

      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        await TradePdfService.sharePdf(pdfBytes, 'PO_${po.poNumber}.pdf');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }

  Future<void> _printPdf(PurchaseOrder po) async {
    // Show loading indicator
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final pdfBytes = await TradePdfService.generatePurchaseOrderPdf(po);

      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        await TradePdfService.printPdf(pdfBytes);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to print PDF: $e')),
        );
      }
    }
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

  const _POItemCard({required this.item, required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    final hasShipped = item.shippedQuantity > 0;
    final remainingQty = item.quantity - item.shippedQuantity;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.white,
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
                '@ $currencyCode ${NumberFormat('#,##0.00').format(item.unitPrice)}',
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
                    size: 14, color: TossColors.success),
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
                '$currencyCode ${NumberFormat('#,##0.00').format(item.totalAmount)}',
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
