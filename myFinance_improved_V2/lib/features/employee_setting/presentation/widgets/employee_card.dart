import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/employee_salary.dart';

/// Individual employee card displaying key information
class EmployeeCard extends StatelessWidget {
  final EmployeeSalary employee;
  final int index;
  final int totalCount;
  final VoidCallback onTap;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.index,
    required this.totalCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: index == 0
            ? const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              )
            : BorderRadius.zero,
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Profile Image
              Hero(
                tag: 'employee_${employee.userId}',
                child: _buildAvatar(),
              ),

              const SizedBox(width: TossSpacing.space3),

              // Employee Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with active indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.fullName.isNotEmpty ? employee.fullName : 'Unknown User',
                            style: TossTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (employee.isActive)
                          Container(
                            margin: const EdgeInsets.only(left: TossSpacing.space2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: TossColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: TossColors.surface,
                                width: 1.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Role or department
                    Text(
                      employee.roleName.isNotEmpty
                          ? employee.roleName
                          : (employee.department ?? 'No role assigned'),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Last activity - always show
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          employee.isActiveToday
                              ? Icons.circle
                              : Icons.access_time_rounded,
                          size: 10,
                          color: employee.isActiveToday
                              ? TossColors.success
                              : (employee.isInactive
                                  ? TossColors.gray300
                                  : TossColors.gray400),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          employee.lastActivityText,
                          style: TossTextStyles.caption.copyWith(
                            color: employee.isActiveToday
                                ? TossColors.success
                                : (employee.isInactive
                                    ? TossColors.gray400
                                    : TossColors.gray500),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Salary Info
              Container(
                padding: const EdgeInsets.only(left: TossSpacing.space2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${employee.symbol}${_formatSalary(employee.salaryAmount)}',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      employee.salaryType == 'hourly' ? '/hour' : '/month',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: TossSpacing.space3),

              // Arrow icon
              const Icon(
                Icons.chevron_right_rounded,
                color: TossColors.gray300,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        image: employee.profileImage?.isNotEmpty == true
            ? DecorationImage(
                image: NetworkImage(employee.profileImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: employee.profileImage == null || employee.profileImage!.isEmpty
          ? Center(
              child: Text(
                employee.fullName.isNotEmpty
                    ? employee.fullName.substring(0, 1).toUpperCase()
                    : 'U',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  String _formatSalary(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
