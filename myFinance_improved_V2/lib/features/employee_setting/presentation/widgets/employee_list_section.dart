import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/employee_salary.dart';
import 'employee_card.dart';

/// Employee list section with header and cards
class EmployeeListSection extends StatelessWidget {
  final List<EmployeeSalary> employees;
  final void Function(EmployeeSalary) onEmployeeTap;

  const EmployeeListSection({
    super.key,
    required this.employees,
    required this.onEmployeeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.groups_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Team Members',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${employees.length} members',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Employee List
          ...employees.asMap().entries.map((entry) {
            final index = entry.key;
            final employee = entry.value;

            return Column(
              children: [
                EmployeeCard(
                  employee: employee,
                  index: index,
                  totalCount: employees.length,
                  onTap: () => onEmployeeTap(employee),
                ),
                if (index < employees.length - 1)
                  const Divider(
                    height: 1,
                    color: TossColors.gray100,
                    indent: TossSpacing.space4,
                    endIndent: TossSpacing.space4,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
