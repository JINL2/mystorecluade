import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';
import 'reliability_score_bottom_sheet.dart';

/// Performance KPI card with 3 horizontal metrics
class PerformanceKpiCard extends StatelessWidget {
  final String ontimeRate;
  final String completedShifts;
  final String reliabilityScore;
  final String? ontimeRateChange;
  final String? completedShiftsChange;
  final String? reliabilityScoreChange;
  final Map<String, dynamic>? scoreBreakdown;

  const PerformanceKpiCard({
    super.key,
    required this.ontimeRate,
    required this.completedShifts,
    required this.reliabilityScore,
    this.ontimeRateChange,
    this.completedShiftsChange,
    this.reliabilityScoreChange,
    this.scoreBreakdown,
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
          showBorder: false,
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
                  changePercentage: ontimeRateChange,
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
                  changePercentage: completedShiftsChange,
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
                  changePercentage: reliabilityScoreChange,
                  showInfoIcon: true,
                  alignRight: false,
                  onInfoTap: () => _showScoreBreakdown(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showScoreBreakdown(BuildContext context) {
    ReliabilityScoreBottomSheet.show(
      context: context,
      finalScore: double.tryParse(reliabilityScore) ?? 50.0,
      scoreBreakdown: scoreBreakdown,
    );
  }
}

class _KpiColumn extends StatelessWidget {
  final String label;
  final String value;
  final String? changePercentage;
  final bool showInfoIcon;
  final bool alignRight;
  final VoidCallback? onInfoTap;

  const _KpiColumn({
    required this.label,
    required this.value,
    this.changePercentage,
    this.showInfoIcon = false,
    this.alignRight = false,
    this.onInfoTap,
  });

  /// Determine if change is positive based on the string
  bool get _isPositiveChange {
    if (changePercentage == null) return false;
    return changePercentage!.startsWith('+');
  }

  /// Determine if change is negative
  bool get _isNegativeChange {
    if (changePercentage == null) return false;
    return changePercentage!.startsWith('-');
  }

  /// Get color for change percentage
  Color get _changeColor {
    if (_isPositiveChange) return TossColors.primary;
    if (_isNegativeChange) return TossColors.error;
    return TossColors.gray600;
  }

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
              GestureDetector(
                onTap: onInfoTap,
                child: const Icon(
                  LucideIcons.info,
                  size: 16,
                  color: TossColors.gray600,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Value with change percentage
        Row(
          mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TossTextStyles.bodyMedium.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TossColors.gray900,
              ),
            ),
            if (changePercentage != null) ...[
              const SizedBox(width: 6),
              Text(
                changePercentage!,
                style: TossTextStyles.caption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _changeColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
