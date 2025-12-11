import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Salary breakdown card showing time, rates, and payment summary
class SalaryBreakdownCard extends StatelessWidget {
  final String asOfDate;
  final String totalConfirmedTime;
  final String hourlySalary;
  final String basePay;
  final String bonusPay;
  final String totalPayment;

  const SalaryBreakdownCard({
    super.key,
    required this.asOfDate,
    required this.totalConfirmedTime,
    required this.hourlySalary,
    required this.basePay,
    required this.bonusPay,
    required this.totalPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary breakdown this shift',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'As of $asOfDate',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray100, width: 1),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            children: [
              _InfoRow(label: 'Total confirmed time', value: totalConfirmedTime),
              const SizedBox(height: 12),
              _InfoRow(label: 'Hourly salary', value: hourlySalary),
              const SizedBox(height: 12),
              Container(height: 1, color: TossColors.gray100),
              const SizedBox(height: 12),
              _InfoRow(label: 'Base pay', value: basePay),
              const SizedBox(height: 12),
              _InfoRow(label: 'Bonus pay', value: bonusPay),
              const SizedBox(height: 12),
              _InfoRow(
                label: 'Total payment',
                value: totalPayment,
                labelStyle: TossTextStyles.titleMedium.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
                valueStyle: TossTextStyles.titleMedium.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
