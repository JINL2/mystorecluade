import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';
import 'history_stat_card.dart';

/// Statistics summary section for history detail
class HistoryStatisticsSummary extends StatelessWidget {
  final SessionHistoryItem session;

  const HistoryStatisticsSummary({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final hasConfirmed = session.hasConfirmed;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      color: TossColors.gray50,
      child: Column(
        children: [
          // Main stats row
          Row(
            children: [
              Expanded(
                child: HistoryStatCard(
                  label: 'Products',
                  value: session.totalItemsCount.toString(),
                  icon: Icons.inventory_2_outlined,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: HistoryStatCard(
                  label: hasConfirmed ? 'Confirmed' : 'Scanned',
                  value: session.totalQuantity.toString(),
                  icon: Icons.numbers,
                  color: TossColors.success,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: HistoryStatCard(
                  label: 'Rejected',
                  value: session.totalRejected.toString(),
                  icon: Icons.error_outline,
                  color: TossColors.error,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: HistoryStatCard(
                  label: 'Members',
                  value: session.memberCount.toString(),
                  icon: Icons.group_outlined,
                  color: TossColors.info,
                ),
              ),
            ],
          ),

          // Show scanned vs confirmed comparison if finalized
          if (hasConfirmed && session.totalScannedQuantity != session.totalConfirmedQuantity) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildAdjustmentInfo(),
          ],

          // Show difference for counting sessions
          if (session.isCounting && session.totalDifference != null) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildDifferenceInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildAdjustmentInfo() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit, size: TossSpacing.iconSM2, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Manager adjusted: ',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Text(
            '${session.totalScannedQuantity} → ${session.totalConfirmedQuantity}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: TossFontWeight.semibold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              '${(session.totalConfirmedQuantity ?? 0) - session.totalScannedQuantity >= 0 ? '+' : ''}${(session.totalConfirmedQuantity ?? 0) - session.totalScannedQuantity}',
              style: TossTextStyles.micro.copyWith(
                color: TossColors.primary,
                fontWeight: TossFontWeight.semibold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifferenceInfo() {
    final difference = session.totalDifference!;
    final isNegative = difference < 0;
    final isPositive = difference > 0;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: isNegative
              ? TossColors.error.withValues(alpha: 0.3)
              : isPositive
                  ? TossColors.success.withValues(alpha: 0.3)
                  : TossColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isNegative
                ? Icons.trending_down
                : isPositive
                    ? Icons.trending_up
                    : Icons.check_circle_outline,
            size: TossSpacing.iconSM2,
            color: isNegative
                ? TossColors.error
                : isPositive
                    ? TossColors.success
                    : TossColors.textSecondary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Stock Difference: ',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Text(
            '${difference >= 0 ? '+' : ''}$difference',
            style: TossTextStyles.caption.copyWith(
              color: isNegative
                  ? TossColors.error
                  : isPositive
                      ? TossColors.success
                      : TossColors.textSecondary,
              fontWeight: TossFontWeight.semibold,
            ),
          ),
        ],
      ),
    );
  }
}
