import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

/// Hero stats row showing key metrics
///
/// Displays 3 metrics in a row with dividers:
/// - Late shifts
/// - Understaffed shifts
/// - OT hours
class StatsMetricRow extends StatelessWidget {
  final String lateShifts;
  final String lateShiftsChange;
  final bool lateShiftsIsNegative;
  final String understaffedShifts;
  final String understaffedShiftsChange;
  final bool understaffedIsNegative;
  final String otHours;
  final String otHoursChange;
  final bool otHoursIsNegative;

  const StatsMetricRow({
    super.key,
    required this.lateShifts,
    required this.lateShiftsChange,
    required this.lateShiftsIsNegative,
    required this.understaffedShifts,
    required this.understaffedShiftsChange,
    required this.understaffedIsNegative,
    required this.otHours,
    required this.otHoursChange,
    required this.otHoursIsNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricItem(
            label: 'Late shifts',
            value: lateShifts,
            change: lateShiftsChange,
            isNegative: lateShiftsIsNegative,
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _MetricItem(
            label: 'Understaffed shifts',
            value: understaffedShifts,
            change: understaffedShiftsChange,
            isNegative: understaffedIsNegative,
          ),
        ),
        _buildVerticalDivider(),
        Expanded(
          child: _MetricItem(
            label: 'OT hours',
            value: otHours,
            change: otHoursChange,
            isNegative: otHoursIsNegative,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
      color: TossColors.gray200,
    );
  }
}

/// Individual metric item
class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isNegative;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.change,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              change,
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: isNegative ? TossColors.error : TossColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
