import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/employee_monthly_detail.dart';
import '../stats/stats_leaderboard.dart';
import 'salary_row.dart';

/// Salary breakdown section showing payment details
class SalaryBreakdownSection extends StatelessWidget {
  final LeaderboardEmployee employee;
  final EmployeeMonthlyDetail? monthlyData;
  final DateTime selectedMonth;

  const SalaryBreakdownSection({
    super.key,
    required this.employee,
    this.monthlyData,
    required this.selectedMonth,
  });

  String _getMonthRange() {
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final monthName = DateFormat('MMM').format(selectedMonth);
    return '$monthName/${firstDay.day} to $monthName/${lastDay.day}';
  }

  @override
  Widget build(BuildContext context) {
    final summary = monthlyData?.summary;
    final salaryInfo = monthlyData?.salary;

    final salaryAmount = salaryInfo?.salaryAmount ?? employee.salaryAmount;
    final totalBonus = summary?.totalBonus ?? 0;
    final unresolvedCount = summary?.unresolvedCount ?? 0;

    final formatter = NumberFormat('#,###');
    final currencySymbol = salaryInfo?.currencySymbol ?? '\u20ab';

    // Use RPC calculated values (from v_shift_request view)
    final basePay = summary?.totalBasePay ?? 0;
    final totalPayment = summary?.totalPayment ?? 0;

    final monthRange = monthlyData?.period.displayRange ?? _getMonthRange();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Breakdown This Month',
          style: TossTextStyles.titleMedium.copyWith(
            fontWeight: TossFontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'From $monthRange',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        SalaryRow(
          label: 'Total confirmed time',
          value: summary?.formattedWorkedHours ?? '0h 0m',
        ),
        const SizedBox(height: TossSpacing.space3),
        SalaryRow(
          label: 'Hourly salary',
          value: '${formatter.format(salaryAmount.toInt())}$currencySymbol',
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(height: TossDimensions.dividerThickness, color: TossColors.gray100),
        const SizedBox(height: TossSpacing.space3),
        SalaryRow(
          label: 'Base pay',
          value: '${formatter.format(basePay.toInt())}$currencySymbol',
        ),
        const SizedBox(height: TossSpacing.space3),
        SalaryRow(
          label: 'Bonus pay',
          value: '${formatter.format(totalBonus.toInt())}$currencySymbol',
        ),
        const SizedBox(height: TossSpacing.space3),
        SalaryRow(
          label: 'Total payment',
          value: '${formatter.format(totalPayment.toInt())}$currencySymbol',
          labelStyle: TossTextStyles.titleMedium.copyWith(
            fontWeight: TossFontWeight.semibold,
          ),
          valueStyle: TossTextStyles.titleMedium.copyWith(
            color: TossColors.primary,
            fontWeight: TossFontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        if (unresolvedCount > 0)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.warning.withValues(alpha: TossOpacity.light),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: TossSpacing.iconMD + 2, // 18px
                  color: TossColors.warning,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Warning: $unresolvedCount unresolved problems may affect final payment',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.warning,
                      fontWeight: TossFontWeight.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
