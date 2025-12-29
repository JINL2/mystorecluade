// lib/features/sales_invoice/presentation/modals/components/quick_summary_card.dart
//
// Quick summary card extracted from invoice_detail_modal.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';

/// Quick summary card showing total amount and status
class QuickSummaryCard extends StatelessWidget {
  final Invoice invoice;
  final String currencySymbol;
  final NumberFormat? formatter;

  const QuickSummaryCard({
    super.key,
    required this.invoice,
    required this.currencySymbol,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = formatter ?? NumberFormat.currency(symbol: '', decimalDigits: 0);
    final symbol = currencySymbol;

    final (statusColor, statusIcon, statusText) = _getStatusInfo();

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
                    '$symbol${currencyFormat.format(invoice.amounts.totalAmount)}',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.primary,
                    ),
                  ),
                  // Total Cost (if available)
                  if (invoice.amounts.totalCost > 0) ...[
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
                          '$symbol${currencyFormat.format(invoice.amounts.totalCost)}',
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
              _StatusBadge(
                color: statusColor,
                icon: statusIcon,
                text: statusText,
              ),
            ],
          ),

          // Amount breakdown (discount, tax)
          if (invoice.amounts.discountAmount > 0 || invoice.amounts.taxAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            const Divider(height: 1, color: TossColors.gray200),
            const SizedBox(height: TossSpacing.space3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AmountDetail(
                  label: 'Subtotal',
                  value: '$symbol${currencyFormat.format(invoice.amounts.subtotal)}',
                ),
                if (invoice.amounts.taxAmount > 0)
                  _AmountDetail(
                    label: 'Tax',
                    value: '$symbol${currencyFormat.format(invoice.amounts.taxAmount)}',
                  ),
                if (invoice.amounts.discountAmount > 0)
                  _AmountDetail(
                    label: 'Discount',
                    value: '-$symbol${currencyFormat.format(invoice.amounts.discountAmount)}',
                    color: TossColors.success,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  (Color, IconData, String) _getStatusInfo() {
    if (invoice.isCompleted) {
      return (TossColors.success, Icons.check_circle, 'Completed');
    } else if (invoice.isDraft) {
      return (TossColors.warning, Icons.schedule, 'Draft');
    } else if (invoice.isCancelled) {
      return (TossColors.error, Icons.cancel, 'Cancelled');
    } else {
      return (TossColors.gray600, Icons.info, invoice.status);
    }
  }
}

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const _StatusBadge({
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: TossSpacing.space1),
          Text(
            text,
            style: TossTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Amount detail widget
class _AmountDetail extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _AmountDetail({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
