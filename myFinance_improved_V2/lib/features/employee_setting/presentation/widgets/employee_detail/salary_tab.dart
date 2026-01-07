import 'package:flutter/material.dart';

import 'package:myfinance_improved/core/utils/number_formatter.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/employee_salary.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class SalaryTab extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;

  const SalaryTab({
    super.key,
    required this.employee,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Salary Card
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    border: Border.all(
                      color: TossColors.gray200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Salary',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            employee.symbol,
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.gray900,
                            ),
                          ),
                          Text(
                            NumberFormatter.formatWithCommas((employee.totalSalary ?? employee.salaryAmount).round()),
                            style: TossTextStyles.display.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            employee.salaryType == 'hourly' ? '/hr' : '/mo',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TossSpacing.space5),

                // Salary Details
                _buildDetailRow('Base Salary', '${employee.symbol}${NumberFormatter.formatWithCommas(employee.salaryAmount.round())} / ${employee.salaryType}'),
                if (employee.totalSalary != null && employee.totalSalary != employee.salaryAmount)
                  _buildDetailRow('Total Earned', '${employee.symbol}${NumberFormatter.formatWithCommas(employee.totalSalary!.round())} (This Month)'),
                _buildDetailRow('Currency', '${employee.currencyName} (${employee.symbol})'),
                _buildDetailRow('Payment Type', employee.salaryType.capitalize()),
                if (employee.effectiveDate != null)
                  _buildDetailRow(
                    'Effective Date',
                    employee.effectiveDate!.toString().split(' ')[0],
                  ),
                _buildDetailRow(
                  'Last Updated',
                  _formatLastUpdated(employee),
                ),
                if (employee.editedByName != null && employee.editedByName!.trim().isNotEmpty)
                  _buildDetailRow(
                    'Last Edited By',
                    employee.editedByName!,
                  ),
              ],
            ),
          ),
        ),

        // Fixed bottom button
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: const BoxDecoration(
            color: TossColors.background,
            border: Border(
              top: BorderSide(
                color: TossColors.gray200,
                width: TossDimensions.dividerThickness,
              ),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: TossButton.primary(
                text: 'Edit Salary',
                onPressed: onEdit,
                fullWidth: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: InfoRow.between(label: label, value: value),
    );
  }

  /// Format last updated text
  /// e.g., "2025-01-04 14:30" or "Never"
  String _formatLastUpdated(EmployeeSalary employee) {
    if (employee.updatedAt == null) {
      return 'Never';
    }

    // Format: YYYY-MM-DD HH:mm
    final date = employee.updatedAt!;
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return '$dateStr $timeStr';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
