import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';

/// Performance KPI card with 3 horizontal metrics
class PerformanceKpiCard extends StatelessWidget {
  final String ontimeRate;
  final String completedShifts;
  final String reliabilityScore;

  const PerformanceKpiCard({
    super.key,
    required this.ontimeRate,
    required this.completedShifts,
    required this.reliabilityScore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Performance Overview',
          style: TossTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),

        const SizedBox(height: TossSpacing.space2),

        // KPI Card
        TossWhiteCard(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              // On-time Rate
              Expanded(
                child: _KpiColumn(
                  label: 'On-time Rate',
                  value: ontimeRate,
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 1,
                  height: 32,
                  color: TossColors.gray100,
                ),
              ),

              // Completed Shifts
              Expanded(
                child: _KpiColumn(
                  label: 'Completed Shifts',
                  value: completedShifts,
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 1,
                  height: 32,
                  color: TossColors.gray100,
                ),
              ),

              // Reliability Score
              Expanded(
                child: _KpiColumn(
                  label: 'Reliability Score',
                  value: reliabilityScore,
                  showInfoIcon: true,
                  alignRight: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KpiColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool showInfoIcon;
  final bool alignRight;

  const _KpiColumn({
    required this.label,
    required this.value,
    this.showInfoIcon = false,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional info icon (always left-aligned)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showInfoIcon) ...[
              const SizedBox(width: 4),
              const Icon(
                LucideIcons.info,
                size: 16,
                color: TossColors.gray600,
              ),
            ],
          ],
        ),

        const SizedBox(height: 2),

        // Value (respects alignRight)
        SizedBox(
          width: double.infinity,
          child: Text(
            value,
            style: TossTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}
