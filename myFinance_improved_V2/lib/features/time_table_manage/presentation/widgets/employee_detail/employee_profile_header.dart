import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../domain/entities/employee_monthly_detail.dart';
import '../stats/stats_leaderboard.dart';
import 'metric_card.dart';

/// Employee profile header with avatar, name, role, and metrics
class EmployeeProfileHeader extends StatelessWidget {
  final LeaderboardEmployee employee;
  final EmployeeMonthlyDetail? monthlyData;

  const EmployeeProfileHeader({
    super.key,
    required this.employee,
    this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            EmployeeProfileAvatar(
              imageUrl: employee.avatarUrl,
              name: employee.name,
              size: TossDimensions.avatarXXL,
              showBorder: true,
              borderColor: TossColors.gray200,
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: TossTextStyles.titleLarge.copyWith(
                      fontWeight: TossFontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    '${employee.role ?? 'Staff'} · ${employee.storeName ?? 'Store'}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space5),
        _buildMetricsRow(),
      ],
    );
  }

  Widget _buildMetricsRow() {
    final summary = monthlyData?.summary;
    final totalWorkedShifts = summary?.approvedCount ?? 0;
    final lateCount = summary?.lateCount ?? 0;
    final onTimeCount = totalWorkedShifts - lateCount;
    final onTimeRate = totalWorkedShifts > 0
        ? (onTimeCount / totalWorkedShifts * 100).round()
        : 0;
    final completedShifts = summary?.approvedCount ?? 0;
    final totalShifts = summary?.totalShifts ?? 0;

    return Row(
      children: [
        Expanded(
          child: MetricCard(
            label: 'On-time Rate',
            value: '$onTimeRate%',
            footnote: '$onTimeCount / $totalWorkedShifts shifts',
          ),
        ),
        const MetricDivider(),
        Expanded(
          child: MetricCard(
            label: 'Completed Shifts',
            value: completedShifts.toString(),
            footnote: 'of $totalShifts total',
          ),
        ),
        const MetricDivider(),
        Expanded(
          child: MetricCard(
            label: 'Total Hours',
            value: summary?.formattedWorkedHours ?? '0h',
            footnote: 'this month',
            showInfoIcon: true,
          ),
        ),
      ],
    );
  }
}
