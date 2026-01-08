import 'package:flutter/material.dart';
import '../../../../../shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

          SizedBox(height: TossSpacing.space2 + TossSpacing.space1 / 2),

          // Hourly salary
          _BreakdownRow(
            label: 'Hourly salary',
            value: hourlySalary,
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
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

          SizedBox(height: TossSpacing.space2 + TossSpacing.space1 / 2),

          // Bonus pay
          _BreakdownRow(
            label: 'Bonus pay',
            value: bonusPay,
          ),

          SizedBox(height: TossSpacing.space3),

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
          style: (isTotal ? TossTextStyles.titleMedium : TossTextStyles.bodySmall).copyWith(
            fontWeight: isTotal ? TossFontWeight.bold : TossFontWeight.medium,
            color: isTotal ? TossColors.gray900 : TossColors.gray600,
            height: 1.4,
          ),
        ),

        // Value
        Text(
          value,
          style: (isTotal ? TossTextStyles.titleMedium : TossTextStyles.body).copyWith(
            fontWeight: isTotal ? TossFontWeight.bold : TossFontWeight.semibold,
            color: isTotal ? TossColors.primary : TossColors.gray900,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
