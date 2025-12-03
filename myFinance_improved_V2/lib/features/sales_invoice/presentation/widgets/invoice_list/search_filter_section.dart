import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_search_field.dart';
import '../../providers/invoice_list_provider.dart';
import 'filter_bottom_sheet.dart';

/// Search and filter section for invoice list
class SearchFilterSection extends ConsumerWidget {
  final TextEditingController searchController;

  const SearchFilterSection({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.watch(invoiceListProvider);

    return Column(
      children: [
        // Filter and Sort Controls
        Container(
          margin: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              FilterBottomSheet.show(context, ref);
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list_rounded,
                    size: 22,
                    color: TossColors.gray600,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      invoiceState.selectedPeriod.displayName,
                      style: TossTextStyles.labelLarge.copyWith(
                        color: TossColors.gray700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: TossColors.gray500,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Search Field
        Container(
          margin: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space4,
          ),
          child: TossSearchField(
            controller: searchController,
            hintText: 'Search by invoice number (e.g., IN2025...)',
            onChanged: (value) {
              ref.read(invoiceListProvider.notifier).updateSearch(value);
            },
          ),
        ),
      ],
    );
  }
}
