import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_badge.dart';

/// Attention Type
enum AttentionType {
  late,
  understaffed,
  overtime,
}

/// Attention Item Data
class AttentionItemData {
  final AttentionType type;
  final String title;
  final String date;
  final String time;
  final String subtext;

  AttentionItemData({
    required this.type,
    required this.title,
    required this.date,
    required this.time,
    required this.subtext,
  });
}

/// Attention Card
///
/// Card displaying items that need attention (late, understaffed, overtime).
class AttentionCard extends StatelessWidget {
  final AttentionItemData item;

  const AttentionCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ),
        ],
      ),
    );
  }

  /// Build badge based on attention type
  Widget _buildBadge() {
    BadgeStatus status;
    String label;

    switch (item.type) {
      case AttentionType.late:
        status = BadgeStatus.error;
        label = 'Late';
      case AttentionType.understaffed:
        status = BadgeStatus.info;
        label = 'Understaffed';
      case AttentionType.overtime:
        status = BadgeStatus.error;
        label = 'Overtime';
    }

    return TossStatusBadge(
      label: label,
      status: status,
    );
  }
}
