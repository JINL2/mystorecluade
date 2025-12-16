import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_detail.dart';
import '../providers/invoice_detail_provider.dart';

/// Invoice Detail Modal
///
/// Displays invoice details in a bottom sheet modal with the following features:
/// - Quick summary with total amount and status
/// - Customer information
/// - Items list with product details
/// - Payment information
/// - Store information
/// - Created by information
/// - Refund action for completed invoices
class InvoiceDetailModal extends ConsumerStatefulWidget {
  final Invoice invoice;
  final String? currencySymbol;
  final void Function(Invoice invoice)? onRefundPressed;

  const InvoiceDetailModal({
    super.key,
    required this.invoice,
    this.currencySymbol,
    this.onRefundPressed,
  });

  /// Show invoice detail modal
  static void show(
    BuildContext context,
    Invoice invoice,
    String? currencySymbol, {
    void Function(Invoice invoice)? onRefundPressed,
  }) {
    HapticFeedback.lightImpact();

    TossBottomSheet.showWithBuilder<void>(
      context: context,
      heightFactor: 0.85,
      builder: (context) => InvoiceDetailModal(
        invoice: invoice,
        currencySymbol: currencySymbol,
        onRefundPressed: onRefundPressed,
      ),
    );
  }

  @override
  ConsumerState<InvoiceDetailModal> createState() => _InvoiceDetailModalState();
}

class _InvoiceDetailModalState extends ConsumerState<InvoiceDetailModal> {
  @override
  void initState() {
    super.initState();
    // Load invoice detail when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceDetailProvider.notifier).loadDetail(widget.invoice.invoiceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(invoiceDetailProvider);
    final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final symbol = widget.currencySymbol ?? '';

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.invoice.invoiceNumber,
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(widget.invoice.saleDate),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: TossColors.gray100),

          // Content
          Expanded(
            child: detailState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : detailState.error != null
                    ? _buildErrorState(detailState.error!)
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        child: Column(
                          children: [
                            // Quick Summary
                            _buildQuickSummary(currencyFormat, symbol),

                            const SizedBox(height: TossSpacing.space4),

                            // Customer Info
                            _buildInfoCard(
                              icon: Icons.person,
                              title: 'Customer',
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detailState.detail?.customerName ??
                                        widget.invoice.customer?.name ??
                                        'Walk-in Customer',
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: TossColors.gray900,
                                    ),
                                  ),
                                  if (detailState.detail?.customerPhone != null ||
                                      widget.invoice.customer?.phone != null) ...[
                                    const SizedBox(height: TossSpacing.space1),
                                    Text(
                                      detailState.detail?.customerPhone ??
                                          widget.invoice.customer!.phone!,
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: TossSpacing.space3),

                            // Items Section
                            if (detailState.detail != null) ...[
                              _buildItemsSection(detailState.detail!, currencyFormat, symbol),
                              const SizedBox(height: TossSpacing.space3),
                            ] else ...[
                              // Fallback to summary if detail not loaded
                              _buildInfoCard(
                                icon: Icons.shopping_cart,
                                title: 'Items',
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${widget.invoice.itemsSummary.itemCount} products',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray900,
                                      ),
                                    ),
                                    Text(
                                      'Qty: ${widget.invoice.itemsSummary.totalQuantity}',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: TossSpacing.space3),
                            ],

                            // Payment Info
                            _buildInfoCard(
                              icon: Icons.payment,
                              title: 'Payment',
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    detailState.detail?.paymentMethod ?? widget.invoice.paymentMethod,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space2,
                                      vertical: TossSpacing.space1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.invoice.isPaid
                                          ? TossColors.success.withValues(alpha: 0.1)
                                          : TossColors.warning.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                    ),
                                    child: Text(
                                      detailState.detail?.paymentStatus ?? widget.invoice.paymentStatus,
                                      style: TossTextStyles.caption.copyWith(
                                        color: widget.invoice.isPaid
                                            ? TossColors.success
                                            : TossColors.warning,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: TossSpacing.space3),

                            // Store Info
                            _buildInfoCard(
                              icon: Icons.store,
                              title: 'Store',
                              content: Text(
                                detailState.detail?.storeName ?? widget.invoice.storeName,
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                ),
                              ),
                            ),

                            // Created By Info
                            if (detailState.detail?.createdByName != null ||
                                widget.invoice.createdByName != null) ...[
                              const SizedBox(height: TossSpacing.space3),
                              _buildCreatedByCard(detailState.detail),
                            ],

                            const SizedBox(height: TossSpacing.space4),
                          ],
                        ),
                      ),
          ),

          // Refund Button (only for completed invoices)
          if (widget.invoice.isCompleted && widget.onRefundPressed != null)
            _buildRefundButton(context, currencyFormat, symbol),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: TossColors.error),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load details',
              style: TossTextStyles.body.copyWith(color: TossColors.gray900),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            TextButton(
              onPressed: () {
                ref.read(invoiceDetailProvider.notifier).loadDetail(widget.invoice.invoiceId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(InvoiceDetail detail, NumberFormat formatter, String symbol) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 18,
                    color: TossColors.primary,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        '${detail.itemCount} products • Qty: ${detail.totalQuantity}',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: TossColors.gray200),
          // Items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detail.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: TossColors.gray200),
            itemBuilder: (context, index) {
              final item = detail.items[index];
              return _buildItemRow(item, formatter, symbol);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(InvoiceDetailItem item, NumberFormat formatter, String symbol) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            child: Container(
              width: 48,
              height: 48,
              color: TossColors.gray100,
              child: item.productImage != null && item.productImage!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.productImage!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: Icon(Icons.inventory_2, size: 24, color: TossColors.gray400),
                      ),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(Icons.inventory_2, size: 24, color: TossColors.gray400),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.inventory_2, size: 24, color: TossColors.gray400),
                    ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: TossSpacing.space1),
                if (item.sku != null || item.barcode != null)
                  Text(
                    item.sku ?? item.barcode ?? '',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                if (item.brandName != null || item.categoryName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      [item.brandName, item.categoryName]
                          .where((e) => e != null)
                          .join(' • '),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Quantity and price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$symbol${formatter.format(item.totalPrice)}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                'x${item.quantity} @ $symbol${formatter.format(item.unitPrice)}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedByCard(InvoiceDetail? detail) {
    final name = detail?.createdByName ?? widget.invoice.createdByName;
    final email = detail?.createdByEmail ?? widget.invoice.createdByEmail;
    final profileImage = detail?.createdByProfileImage;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          // Profile image or icon
          if (profileImage != null && profileImage.isNotEmpty)
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: profileImage,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: TossColors.primary,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: TossColors.primary,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: TossColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 18,
                color: TossColors.primary,
              ),
            ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created By',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  name ?? 'Unknown',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                if (email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundButton(
    BuildContext context,
    NumberFormat formatter,
    String symbol,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showRefundConfirmation(context, formatter, symbol);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.error,
            foregroundColor: TossColors.white,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.replay, size: 20),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Refund',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRefundConfirmation(
    BuildContext context,
    NumberFormat formatter,
    String symbol,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.replay,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            const Text('Refund Invoice'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to refund this invoice?',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Column(
                children: [
                  Text(
                    'Refund Amount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    '$symbol${formatter.format(widget.invoice.amounts.totalAmount)}',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Invoice: ${widget.invoice.invoiceNumber}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              widget.onRefundPressed?.call(widget.invoice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.error,
              foregroundColor: TossColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
            ),
            child: const Text('Refund'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSummary(NumberFormat formatter, String symbol) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (widget.invoice.isCompleted) {
      statusColor = TossColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Completed';
    } else if (widget.invoice.isDraft) {
      statusColor = TossColors.warning;
      statusIcon = Icons.schedule;
      statusText = 'Draft';
    } else if (widget.invoice.isCancelled) {
      statusColor = TossColors.error;
      statusIcon = Icons.cancel;
      statusText = 'Cancelled';
    } else {
      statusColor = TossColors.gray600;
      statusIcon = Icons.info;
      statusText = widget.invoice.status;
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withValues(alpha: 0.05),
            TossColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    '$symbol${formatter.format(widget.invoice.amounts.totalAmount)}',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.primary,
                    ),
                  ),
                  // Total Cost (if available)
                  if (widget.invoice.amounts.totalCost > 0) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        Text(
                          'Cost: ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        Text(
                          '$symbol${formatter.format(widget.invoice.amounts.totalCost)}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Row(
                  children: [
                    Icon(
                      statusIcon,
                      size: 18,
                      color: statusColor,
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    Text(
                      statusText,
                      style: TossTextStyles.body.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (widget.invoice.amounts.discountAmount > 0 || widget.invoice.amounts.taxAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            const Divider(height: 1, color: TossColors.gray200),
            const SizedBox(height: TossSpacing.space3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountDetail(
                  'Subtotal',
                  '$symbol${formatter.format(widget.invoice.amounts.subtotal)}',
                ),
                if (widget.invoice.amounts.taxAmount > 0)
                  _buildAmountDetail(
                    'Tax',
                    '$symbol${formatter.format(widget.invoice.amounts.taxAmount)}',
                  ),
                if (widget.invoice.amounts.discountAmount > 0)
                  _buildAmountDetail(
                    'Discount',
                    '-$symbol${formatter.format(widget.invoice.amounts.discountAmount)}',
                    color: TossColors.success,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountDetail(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: TossColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: TossColors.primary,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
