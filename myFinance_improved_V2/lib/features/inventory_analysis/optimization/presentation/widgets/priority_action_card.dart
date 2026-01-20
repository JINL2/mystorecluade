import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';

/// 우선순위 액션 카드 (2026 트렌드 적용)
///
/// 중요도에 따라 시각적 계층 구조를 제공:
/// - urgent (긴급): 빨간색 - 품절/비정상
/// - attention (주의): 주황색 - 긴급/경고
class PriorityActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final Color color;
  final IconData icon;
  final List<_DetailItem> details;
  final VoidCallback? onTap;

  const PriorityActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.color,
    required this.icon,
    required this.details,
    this.onTap,
  });

  /// 긴급 조치 필요 카드 (빨간색)
  factory PriorityActionCard.urgent({
    required int count,
    required int stockoutCount,
    required int abnormalCount,
    VoidCallback? onTap,
  }) {
    final details = <_DetailItem>[];
    if (stockoutCount > 0) {
      details.add(_DetailItem(
        label: 'Out of Stock',
        count: stockoutCount,
      ));
    }
    if (abnormalCount > 0) {
      details.add(_DetailItem(
        label: 'Abnormal',
        count: abnormalCount,
      ));
    }

    return PriorityActionCard(
      title: 'Urgent Action Required',
      subtitle: 'These items need immediate attention',
      count: count,
      color: TossColors.error,
      icon: Icons.error_outline_rounded,
      details: details,
      onTap: onTap,
    );
  }

  /// 주의 필요 카드 (주황색)
  factory PriorityActionCard.attention({
    required int count,
    required int criticalCount,
    required int warningCount,
    required double criticalDays,
    required double warningDays,
    VoidCallback? onTap,
  }) {
    final details = <_DetailItem>[];
    if (criticalCount > 0) {
      details.add(_DetailItem(
        label: 'Critical (< ${criticalDays.toInt()} days)',
        count: criticalCount,
      ));
    }
    if (warningCount > 0) {
      details.add(_DetailItem(
        label: 'Warning (< ${warningDays.toInt()} days)',
        count: warningCount,
      ));
    }

    return PriorityActionCard(
      title: 'Attention Needed',
      subtitle: 'Low inventory - consider reordering',
      count: count,
      color: TossColors.amber,
      icon: Icons.warning_amber_rounded,
      details: details,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.card),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(TossBorderRadius.card),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.paddingXS),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(TossBorderRadius.button),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: TossSpacing.iconMD,
                  ),
                ),
                const SizedBox(width: TossSpacing.gapMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TossTextStyles.subtitle.copyWith(
                          color: color,
                          fontWeight: TossFontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.marginXS),
                      Text(
                        subtitle,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.paddingSM,
                    vertical: TossSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                        BorderRadius.circular(TossBorderRadius.button),
                  ),
                  child: Text(
                    '$count',
                    style: TossTextStyles.h4.copyWith(
                      color: TossColors.white,
                      fontWeight: TossFontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Details (if any)
            if (details.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.gapMD),
              const Divider(height: 1, color: TossColors.gray200),
              const SizedBox(height: TossSpacing.gapMD),
              Wrap(
                spacing: TossSpacing.gapMD,
                runSpacing: TossSpacing.gapSM,
                children: details
                    .map((detail) => _buildDetailChip(detail))
                    .toList(),
              ),
            ],

            // Action hint
            const SizedBox(height: TossSpacing.gapMD),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View Details',
                  style: TossTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
                const SizedBox(width: TossSpacing.gapXS),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(_DetailItem detail) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingSM,
        vertical: TossSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.chip),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            detail.label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(width: TossSpacing.gapXS),
          Text(
            '${detail.count}',
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: TossFontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  final String label;
  final int count;

  const _DetailItem({
    required this.label,
    required this.count,
  });
}
