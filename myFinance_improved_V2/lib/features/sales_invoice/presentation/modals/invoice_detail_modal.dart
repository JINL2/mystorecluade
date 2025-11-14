import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../domain/entities/invoice.dart';

/// Invoice Detail Modal
///
/// Displays invoice details in a bottom sheet modal with the following features:
/// - Quick summary with total amount and status
/// - Customer information
/// - Items summary
/// - Payment information
/// - Store information
/// - Created by information
/// - Refund action for completed invoices
class InvoiceDetailModal extends StatelessWidget {
  final Invoice invoice;
  final String? currencySymbol;

  const InvoiceDetailModal({
    super.key,
    required this.invoice,
    this.currencySymbol,
  });

  /// Show invoice detail modal
  static void show(
    BuildContext context,
    Invoice invoice,
    String? currencySymbol,
  ) {
    HapticFeedback.lightImpact();

    TossBottomSheet.showWithBuilder<void>(
      context: context,
      heightFactor: 0.85,
      builder: (context) => InvoiceDetailModal(
        invoice: invoice,
        currencySymbol: currencySymbol,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final symbol = currencySymbol ?? '';

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
                        invoice.invoiceNumber,
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(invoice.saleDate),
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
            child: SingleChildScrollView(
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
                          invoice.customer?.name ?? 'Walk-in Customer',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                        if (invoice.customer?.phone != null) ...[
                          const SizedBox(height: TossSpacing.space1),
                          Text(
                            invoice.customer!.phone!,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space3),

                  // Items Summary
                  _buildInfoCard(
                    icon: Icons.shopping_cart,
                    title: 'Items',
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${invoice.itemsSummary.itemCount} products',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                          ),
                        ),
                        Text(
                          'Qty: ${invoice.itemsSummary.totalQuantity}',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space3),

                  // Payment Info
                  _buildInfoCard(
                    icon: Icons.payment,
                    title: 'Payment',
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          invoice.paymentMethod,
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
                            color: invoice.isPaid
                                ? TossColors.success.withValues(alpha: 0.1)
                                : TossColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                          ),
                          child: Text(
                            invoice.paymentStatus,
                            style: TossTextStyles.caption.copyWith(
                              color: invoice.isPaid
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
                      invoice.storeName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                  ),

                  if (invoice.createdByName != null) ...[
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoCard(
                      icon: Icons.person_outline,
                      title: 'Created By',
                      content: Text(
                        invoice.createdByName!,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSummary(NumberFormat formatter, String symbol) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (invoice.isCompleted) {
      statusColor = TossColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Completed';
    } else if (invoice.isDraft) {
      statusColor = TossColors.warning;
      statusIcon = Icons.schedule;
      statusText = 'Draft';
    } else if (invoice.isCancelled) {
      statusColor = TossColors.error;
      statusIcon = Icons.cancel;
      statusText = 'Cancelled';
    } else {
      statusColor = TossColors.gray600;
      statusIcon = Icons.info;
      statusText = invoice.status;
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
                    '$symbol${formatter.format(invoice.amounts.totalAmount)}',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.primary,
                    ),
                  ),
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

          if (invoice.amounts.discountAmount > 0 || invoice.amounts.taxAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            const Divider(height: 1, color: TossColors.gray200),
            const SizedBox(height: TossSpacing.space3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountDetail(
                  'Subtotal',
                  '$symbol${formatter.format(invoice.amounts.subtotal)}',
                ),
                if (invoice.amounts.taxAmount > 0)
                  _buildAmountDetail(
                    'Tax',
                    '$symbol${formatter.format(invoice.amounts.taxAmount)}',
                  ),
                if (invoice.amounts.discountAmount > 0)
                  _buildAmountDetail(
                    'Discount',
                    '-$symbol${formatter.format(invoice.amounts.discountAmount)}',
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
