import 'package:flutter/material.dart';

import '../../../../../../shared/themes/index.dart';

/// Salary breakdown card showing time, rates, and payment summary
///
/// v7: Simplified change display - just color change, no heavy UI
/// - Changed values shown in primary color
/// - Original value shown as small gray text (strikethrough)
/// - Clean, minimal design matching app style
class SalaryBreakdownCard extends StatelessWidget {
  final String asOfDate;
  final String totalConfirmedTime;
  final String hourlySalary;
  final String basePay;
  final String bonusPay;
  final String penaltyDeduction;
  final String totalPayment;

  // Original values for change detection (null = no change)
  final String? originalConfirmedTime;
  final String? originalBasePay;
  final String? originalBonusPay;
  final String? originalTotalPayment;

  const SalaryBreakdownCard({
    super.key,
    required this.asOfDate,
    required this.totalConfirmedTime,
    required this.hourlySalary,
    required this.basePay,
    required this.bonusPay,
    this.penaltyDeduction = '0₫',
    required this.totalPayment,
    this.originalConfirmedTime,
    this.originalBasePay,
    this.originalBonusPay,
    this.originalTotalPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Salary breakdown this shift',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        Text(
          'As of $asOfDate',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        SizedBox(height: TossSpacing.space3),

        // Total confirmed time
        _InfoRow(
          label: 'Total confirmed time',
          value: totalConfirmedTime,
          originalValue: originalConfirmedTime,
        ),
        SizedBox(height: TossSpacing.space3),
        _InfoRow(label: 'Hourly salary', value: hourlySalary),
        SizedBox(height: TossSpacing.space3),
        Container(height: TossDimensions.dividerThickness, color: TossColors.gray100),
        SizedBox(height: TossSpacing.space3),

        // Base pay
        _InfoRow(
          label: 'Base pay',
          value: basePay,
          originalValue: originalBasePay,
        ),
        SizedBox(height: TossSpacing.space3),

        // Bonus pay
        _InfoRow(
          label: 'Bonus pay',
          value: bonusPay,
          originalValue: originalBonusPay,
        ),
        SizedBox(height: TossSpacing.space3),

        // Total payment
        _InfoRow(
          label: 'Total payment',
          value: totalPayment,
          originalValue: originalTotalPayment,
          isTotal: true,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? originalValue;
  final bool isTotal;

  const _InfoRow({
    required this.label,
    required this.value,
    this.originalValue,
    this.isTotal = false,
  });

  bool get hasChange => originalValue != null;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? TossTextStyles.bodyMedium.copyWith(color: TossColors.gray900)
              : TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
        ),
        if (hasChange)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Original value (small, strikethrough)
              Text(
                originalValue!,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              // New value (primary color)
              Text(
                value,
                style: isTotal
                    ? TossTextStyles.titleMedium.copyWith(
                        color: TossColors.primary,
                        fontWeight: TossFontWeight.bold,
                      )
                    : TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.primary,
                        fontWeight: TossFontWeight.semibold,
                      ),
              ),
            ],
          )
        else
          Text(
            value,
            style: isTotal
                ? TossTextStyles.titleMedium.copyWith(
                    color: TossColors.primary,
                    fontWeight: TossFontWeight.bold,
                  )
                : TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: TossFontWeight.semibold,
                  ),
          ),
      ],
    );
  }
}
