import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../helpers/salary_calculator.dart';

/// Salary Information Card Widget
///
/// Displays salary type, amount, and worked hours for hourly employees.
class SalaryInfoCard extends StatelessWidget {
  final SalaryCalculation calculation;

  const SalaryInfoCard({
    super.key,
    required this.calculation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SalaryCalculator.getSalaryTypeDisplay(calculation.salaryType),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    calculation.salaryAmount > 0
                        ? NumberFormat('#,###').format(calculation.salaryAmount.toInt())
                        : '0',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: calculation.salaryType == 'hourly'
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : TossColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Text(
                  calculation.salaryType == 'hourly' ? 'Per Hour' : 'Per Month',
                  style: TossTextStyles.caption.copyWith(
                    color: calculation.salaryType == 'hourly'
                        ? TossColors.primary
                        : TossColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          // Show worked hours for hourly employees
          if (calculation.salaryType == 'hourly' && calculation.paidHours > 0) ...[
            const SizedBox(height: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: TossColors.gray600,
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    'Worked: ${calculation.paidHours.toStringAsFixed(1)} hours',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
