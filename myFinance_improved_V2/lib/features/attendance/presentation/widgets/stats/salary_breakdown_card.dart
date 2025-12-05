import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';

/// Salary breakdown card showing itemized payment details
class SalaryBreakdownCard extends StatelessWidget {
  final String totalConfirmedTime;
  final String hourlySalary;
  final String basePay;
  final String bonusPay;
  final String totalPayment;

  const SalaryBreakdownCard({
    super.key,
    required this.totalConfirmedTime,
    required this.hourlySalary,
    required this.basePay,
    required this.bonusPay,
    required this.totalPayment,
  });

  @override
  Widget build(BuildContext context) {
    return TossWhiteCard(
      showBorder: false,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Total confirmed time
          _BreakdownRow(
            label: 'Total confirmed time',
            value: totalConfirmedTime,
          ),

          const SizedBox(height: 10),

          // Hourly salary
          _BreakdownRow(
            label: 'Hourly salary',
            value: hourlySalary,
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              thickness: 1,
              color: TossColors.gray100,
            ),
          ),

          // Base pay
          _BreakdownRow(
            label: 'Base pay',
            value: basePay,
          ),

          const SizedBox(height: 10),

          // Bonus pay
          _BreakdownRow(
            label: 'Bonus pay',
            value: bonusPay,
          ),

          const SizedBox(height: 12),

          // Total payment
          _BreakdownRow(
            label: 'Total payment',
            value: totalPayment,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? TossColors.gray900 : TossColors.gray600,
            height: 1.4,
          ),
        ),

        // Value
        Text(
          value,
          style: TossTextStyles.bodyMedium.copyWith(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? TossColors.primary : TossColors.gray900,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
