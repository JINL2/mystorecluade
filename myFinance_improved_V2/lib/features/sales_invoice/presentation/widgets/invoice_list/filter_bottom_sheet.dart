import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../extensions/invoice_period_extension.dart';
import '../../providers/invoice_list_provider.dart';

/// Bottom sheet for filtering invoices by period
class FilterBottomSheet {
  FilterBottomSheet._();

  static void show(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.read(invoiceListProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
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
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),

            // Title
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Filter by Period',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Filter options
            for (final period in InvoicePeriod.values)
              _FilterOption(
                title: period.displayName,
                isSelected: invoiceState.selectedPeriod == period,
                onTap: () {
                  ref.read(invoiceListProvider.notifier).updatePeriod(period);
                  Navigator.pop(context);
                },
              ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
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
                const Icon(
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
}
