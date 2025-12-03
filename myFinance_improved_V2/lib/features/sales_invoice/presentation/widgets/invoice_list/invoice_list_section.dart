import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../domain/entities/invoice.dart';
import '../../providers/invoice_list_provider.dart';
import 'invoice_list_item.dart';

/// Invoice list section grouped by date
class InvoiceListSection extends ConsumerWidget {
  const InvoiceListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.watch(invoiceListProvider);
    final groupedInvoices = invoiceState.groupedInvoices;

    if (groupedInvoices.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: groupedInvoices.entries.map((entry) {
        final dateKey = entry.key;
        final invoices = entry.value;

        return _buildDateGroup(context, ref, dateKey, invoices);
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Column(
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
    );
  }

  Widget _buildDateGroup(
    BuildContext context,
    WidgetRef ref,
    String dateKey,
    List<Invoice> invoices,
  ) {
    return Container(
      margin: const EdgeInsets.only(
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
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  const SizedBox(width: TossSpacing.space2),
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
                  InvoiceListItem(invoice: invoice),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      color: TossColors.gray100,
                      indent: TossSpacing.space4,
                      endIndent: TossSpacing.space4,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
