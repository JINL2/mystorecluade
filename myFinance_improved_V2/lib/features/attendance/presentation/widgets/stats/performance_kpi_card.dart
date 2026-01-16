import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/index.dart';
import 'reliability_score_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
        // KPI Card
        TossCard(
          padding: EdgeInsets.zero,
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
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                child: Container(
                  width: 1,
                  height: TossSpacing.space8,
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
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                child: Container(
                  width: 1,
                  height: TossSpacing.space8,
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
        // Label with optional info icon
        Row(
          mainAxisAlignment: showInfoIcon ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label,
                style: TossTextStyles.small.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: TossColors.gray600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showInfoIcon)
              GestureDetector(
                onTap: onInfoTap,
                child: Icon(
                  LucideIcons.info,
                  size: TossSpacing.iconXS,
                  color: TossColors.gray600,
                ),
              ),
          ],
        ),

        SizedBox(height: TossSpacing.space1),

        // Value with change percentage - wrap to prevent overflow
        Wrap(
          alignment: alignRight ? WrapAlignment.end : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: TossSpacing.space1,
          runSpacing: TossSpacing.space1 / 2,
          children: [
            Text(
              value,
              style: TossTextStyles.h4.copyWith(
                fontWeight: TossFontWeight.bold,
                color: TossColors.gray900,
              ),
            ),
            if (changePercentage != null)
              Text(
                changePercentage!,
                style: TossTextStyles.small.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: _changeColor,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
