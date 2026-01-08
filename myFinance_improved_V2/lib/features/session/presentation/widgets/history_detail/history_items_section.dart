import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';
import 'history_item_card.dart';

/// Items section for history detail
class HistoryItemsSection extends StatelessWidget {
  final List<SessionHistoryItemDetail> items;
  final bool isCounting;

  const HistoryItemsSection({
    super.key,
    required this.items,
    required this.isCounting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: TossSpacing.iconMD,
                  color: TossColors.textSecondary,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Items',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Center(
                child: Text(
                  'No items scanned',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return HistoryItemCard(
                  item: item,
                  isCounting: isCounting,
                );
              },
            ),
        ],
      ),
    );
  }
}
