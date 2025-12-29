import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Header card widget for Income Statement display
class IncomeHeaderCard extends StatelessWidget {
  final Map<String, dynamic> parameters;
  final VoidCallback onEdit;

  const IncomeHeaderCard({
    super.key,
    required this.parameters,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: const EdgeInsets.all(TossSpacing.space4),
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: TossColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income Statement',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: TossColors.gray500,
                            size: 14,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            '${parameters['start_date']} ~ ${parameters['end_date']}',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        color: TossColors.gray600,
                        size: 16,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        'Edit',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
