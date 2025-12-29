import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Header card widget for Balance Sheet display
class BalanceSheetHeaderCard extends StatelessWidget {
  final Map<String, dynamic> companyInfo;
  final Map<String, dynamic> parameters;
  final VoidCallback onEdit;

  const BalanceSheetHeaderCard({
    super.key,
    required this.companyInfo,
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
                  child: Icon(
                    companyInfo['store_name'] != null
                        ? Icons.store_outlined
                        : Icons.business_outlined,
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
                        companyInfo['store_name']?.toString() ??
                            companyInfo['company_name']?.toString() ??
                            'Balance Sheet',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: TossColors.gray500,
                            size: 14,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            'All-time cumulative balance',
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
