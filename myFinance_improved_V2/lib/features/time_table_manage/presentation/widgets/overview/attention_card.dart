import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_badge.dart';
import '../../../domain/entities/attention_item_data.dart';

// Re-export for backward compatibility
export '../../../domain/entities/attention_item_data.dart';

/// Attention Card
///
/// Card displaying items that need attention (late, understaffed, overtime).
///
/// 데이터 클래스(AttentionType, AttentionItemData)는
/// `domain/entities/attention_item_data.dart`에 분리되어 있음
class AttentionCard extends StatelessWidget {
  final AttentionItemData item;
  final VoidCallback? onTap;

  const AttentionCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            _buildBadge(),
            const SizedBox(height: TossSpacing.space3),

            // Title
            Text(
              item.title,
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Date
            Text(
              item.date,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray600,
              ),
            ),

            // Time
            Text(
              item.time,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray600,
              ),
            ),

            const Spacer(),

            // Subtext
            Text(
              item.subtext,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build badge based on attention type
  /// All badges use error (red) status for Need Attention section
  Widget _buildBadge() {
    String label;

    switch (item.type) {
      case AttentionType.late:
        label = 'Late';
      case AttentionType.understaffed:
        label = 'Understaffed';
      case AttentionType.overtime:
        label = 'Overtime';
      case AttentionType.reported:
        label = 'Reported';
      case AttentionType.noCheckIn:
        label = 'No check-in';
      case AttentionType.noCheckOut:
        label = 'No check-out';
      case AttentionType.earlyCheckOut:
        label = 'Early check-out';
    }

    return TossStatusBadge(
      label: label,
      status: BadgeStatus.error,
    );
  }
}
