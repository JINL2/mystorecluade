import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/employee_salary.dart';
import '../providers/employee_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Bottom sheet for filtering employees
class EmployeeFilterSheet extends ConsumerWidget {
  final List<EmployeeSalary> allEmployees;
  final VoidCallback onClearAll;

  const EmployeeFilterSheet({
    super.key,
    required this.allEmployees,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = allEmployees.map((e) => e.roleName).whereType<String>().toSet().toList();
    final departments = allEmployees.map((e) => e.department).whereType<String>().toSet().toList();

    // Get current filter values from providers
    final selectedRole = ref.watch(selectedRoleFilterProvider);
    final selectedDepartment = ref.watch(selectedDepartmentFilterProvider);
    final selectedSalaryType = ref.watch(selectedSalaryTypeFilterProvider);

    final hasActiveFilters =
        selectedRole != null || selectedDepartment != null || selectedSalaryType != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: TossDimensions.dragHandleWidth,
            height: TossDimensions.dragHandleHeight,
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Title
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'Filter Team Members',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (hasActiveFilters)
                  TossButton.secondary(
                    text: 'Clear All',
                    onPressed: onClearAll,
                  ),
              ],
            ),
          ),

          // Filter Options
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
              ),
              child: Column(
                children: [
                  _FilterSection(
                    title: 'Salary Type',
                    icon: Icons.attach_money_rounded,
                    options: const ['hourly', 'monthly'],
                    selectedValue: selectedSalaryType,
                    allEmployees: allEmployees,
                    onChanged: (value) {
                      ref.read(selectedSalaryTypeFilterProvider.notifier).update(value);
                      Navigator.pop(context);
                    },
                    customLabels: const {'hourly': 'Hourly', 'monthly': 'Monthly'},
                  ),
                  _FilterSection(
                    title: 'Role',
                    icon: Icons.badge_outlined,
                    options: roles,
                    selectedValue: selectedRole,
                    allEmployees: allEmployees,
                    onChanged: (value) {
                      ref.read(selectedRoleFilterProvider.notifier).update(value);
                      Navigator.pop(context);
                    },
                  ),
                  if (departments.isNotEmpty)
                    _FilterSection(
                      title: 'Department',
                      icon: Icons.business_rounded,
                      options: departments,
                      selectedValue: selectedDepartment,
                      allEmployees: allEmployees,
                      onChanged: (value) {
                        ref.read(selectedDepartmentFilterProvider.notifier).update(value);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> options;
  final String? selectedValue;
  final List<EmployeeSalary> allEmployees;
  final ValueChanged<String?> onChanged;
  final Map<String, String>? customLabels;

  const _FilterSection({
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedValue,
    required this.allEmployees,
    required this.onChanged,
    this.customLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space6),
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space3),
            child: Row(
              children: [
                Icon(icon, size: TossSpacing.iconMD, color: TossColors.gray600),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  title,
                  style: TossTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),

          // All Option
          _FilterOption(
            label: 'All ${title}s',
            value: null,
            selectedValue: selectedValue,
            icon: Icons.clear_all_rounded,
            onChanged: onChanged,
          ),

          // Individual Options
          ...options.map((option) {
            final displayLabel = customLabels?[option] ?? option;
            final count = allEmployees.where((e) {
              switch (title) {
                case 'Role':
                  return e.roleName == option;
                case 'Department':
                  return e.department == option;
                case 'Salary Type':
                  return e.salaryType == option;
                default:
                  return false;
              }
            }).length;

            return _FilterOption(
              label: displayLabel,
              value: option,
              selectedValue: selectedValue,
              icon: _getFilterIcon(title, option),
              onChanged: onChanged,
              count: count,
            );
          }),
        ],
      ),
    );
  }

  IconData _getFilterIcon(String filterType, String option) {
    switch (filterType) {
      case 'Role':
        return Icons.badge_outlined;
      case 'Department':
        return Icons.business_rounded;
      case 'Salary Type':
        if (option == 'hourly') return Icons.schedule_rounded;
        if (option == 'monthly') return Icons.calendar_month_rounded;
        return Icons.attach_money_rounded;
      default:
        return Icons.filter_list_rounded;
    }
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final String? value;
  final String? selectedValue;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  final int? count;

  const _FilterOption({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.icon,
    required this.onChanged,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: TossSpacing.iconMD,
                color: TossColors.gray600,
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (count != null)
                Text(
                  '($count)',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              if (isSelected)
                const Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: TossSpacing.iconMD,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
