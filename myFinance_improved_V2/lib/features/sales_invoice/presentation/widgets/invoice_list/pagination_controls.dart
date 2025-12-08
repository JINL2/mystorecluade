import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/invoice_list_provider.dart';

/// Pagination controls for invoice list
class PaginationControls extends ConsumerWidget {
  const PaginationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.watch(invoiceListProvider);
    final pagination = invoiceState.response?.pagination;

    if (pagination == null || pagination.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
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
            padding: const EdgeInsets.symmetric(
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
}
