import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

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

        // Total confirmed time
        _InfoRow(
          label: 'Total confirmed time',
          value: totalConfirmedTime,
          originalValue: originalConfirmedTime,
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Hourly salary', value: hourlySalary),
        const SizedBox(height: 12),
        Container(height: 1, color: TossColors.gray100),
        const SizedBox(height: 12),

        // Base pay
        _InfoRow(
          label: 'Base pay',
          value: basePay,
          originalValue: originalBasePay,
        ),
        const SizedBox(height: 12),

        // Bonus pay
        _InfoRow(
          label: 'Bonus pay',
          value: bonusPay,
          originalValue: originalBonusPay,
        ),
        const SizedBox(height: 12),

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
              const SizedBox(width: 8),
              // New value (primary color)
              Text(
                value,
                style: isTotal
                    ? TossTextStyles.titleMedium.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w700,
                      )
                    : TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
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
                    fontWeight: FontWeight.w700,
                  )
                : TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
          ),
      ],
    );
  }
}
