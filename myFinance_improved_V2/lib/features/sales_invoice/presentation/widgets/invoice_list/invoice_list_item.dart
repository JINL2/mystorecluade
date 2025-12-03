import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';
import '../../modals/invoice_detail_modal.dart';
import '../../providers/invoice_list_provider.dart';

/// Individual invoice list item
class InvoiceListItem extends ConsumerWidget {
  final Invoice invoice;
  final void Function(Invoice invoice)? onRefundPressed;

  const InvoiceListItem({
    super.key,
    required this.invoice,
    this.onRefundPressed,
  });

  static final _currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(invoiceListProvider).response?.currency;

    return InkWell(
      onTap: () {
        InvoiceDetailModal.show(
          context,
          invoice,
          currency?.symbol,
          onRefundPressed: onRefundPressed,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
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
            const SizedBox(width: TossSpacing.space3),

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
                          '${currency?.symbol ?? ''}${_currencyFormat.format(invoice.amounts.totalAmount)}',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Row(
                    children: [
                      Text(
                        invoice.customer?.name ?? invoice.createdByName ?? 'Walk-in',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        '•',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
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

            const SizedBox(width: TossSpacing.space2),

            // Status icon
            _buildStatusIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (invoice.isCompleted) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: TossColors.success.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          size: 16,
          color: TossColors.success,
        ),
      );
    } else if (invoice.isDraft) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: TossColors.warning.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.schedule,
          size: 16,
          color: TossColors.warning,
        ),
      );
    } else if (invoice.isCancelled) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: TossColors.error.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: 16,
          color: TossColors.error,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
