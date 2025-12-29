import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/employee_salary.dart';

class InfoTab extends StatelessWidget {
  final EmployeeSalary employee;

  const InfoTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Information Section
          _buildInfoCard(
            title: 'Personal Information',
            icon: Icons.person_outline,
            color: TossColors.primary,
            children: [
              _buildInfoRow('Full Name', employee.fullName),
              _buildInfoRow('Email', employee.email),
              _buildInfoRow('Employee ID', employee.employeeId ?? 'Not assigned'),
              if (employee.hireDate != null)
                _buildInfoRow('Hire Date', employee.hireDate!.toString().split(' ')[0]),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Employment Information Section
          _buildInfoCard(
            title: 'Employment Details',
            icon: Icons.work_outline,
            color: TossColors.success,
            children: [
              if (employee.department != null)
                _buildInfoRow('Department', employee.department!),
              _buildInfoRow('Role', employee.roleName.isNotEmpty ? employee.roleName : 'No role assigned'),
              if (employee.managerName != null)
                _buildInfoRow('Manager', employee.managerName!),
              if (employee.workLocation != null)
                _buildInfoRow('Work Location', employee.workLocation!),
              if (employee.employmentType != null)
                _buildInfoRow('Employment Type', employee.employmentType!),
              _buildInfoRow('Employment Status', employee.employmentStatus ?? 'Active'),
              if (employee.costCenter != null)
                _buildInfoRow('Cost Center', employee.costCenter!),
              // Last Activity
              _buildLastActivityRow(employee),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Bank Information Section (Only Bank Name and Bank Number as requested)
          _buildInfoCard(
            title: 'Bank Information',
            icon: Icons.account_balance_outlined,
            color: TossColors.warning,
            children: [
              _buildInfoRow('Bank Name', employee.bankName ?? 'Not specified'),
              _buildInfoRow('Bank Number', employee.bankAccountNumber ?? 'Not specified'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
              border: Border(
                bottom: BorderSide(
                  color: color.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Text(
                  title,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final isEmpty = value.isEmpty || value == 'Not specified' || value == 'Not assigned' || value == 'No role assigned';

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.bodySmall.copyWith(
                color: isEmpty ? TossColors.gray400 : TossColors.gray900,
                fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w500,
                fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastActivityRow(EmployeeSalary employee) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              'Last Activity',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Row(
              children: [
                Icon(
                  employee.isActiveToday
                      ? Icons.circle
                      : Icons.access_time_rounded,
                  size: 12,
                  color: employee.isActiveToday
                      ? TossColors.success
                      : (employee.isInactive
                          ? TossColors.gray300
                          : TossColors.gray400),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    employee.lastActivityAt != null
                        ? employee.lastActivityText
                        : 'No activity recorded',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: employee.isActiveToday
                          ? TossColors.success
                          : (employee.isInactive
                              ? TossColors.gray400
                              : TossColors.gray900),
                      fontWeight: employee.isActiveToday ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
