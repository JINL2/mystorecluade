import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';

import '../providers/employee_providers.dart';

/// Search and filter controls section for employee management
class EmployeeSearchFilterSection extends ConsumerWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;

  const EmployeeSearchFilterSection({
    super.key,
    required this.searchController,
    required this.onFilterPressed,
    required this.onSortPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(employeeSortOptionProvider);
    final hasActiveFilters = _hasActiveFilters(ref);
    final activeFilterCount = _getActiveFilterCount(ref);

    return Column(
      children: [
        // Filter and Sort Controls
        Container(
          margin: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Filter Section - 50% space
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onFilterPressed();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              size: 22,
                              color: hasActiveFilters ? TossColors.primary : TossColors.gray600,
                            ),
                            if (hasActiveFilters)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: TossColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$activeFilterCount',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            hasActiveFilters ? '$activeFilterCount filters active' : 'Filters',
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 20,
                color: TossColors.gray200,
              ),

              // Sort Section - 50% space
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onSortPressed();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 22,
                          color: sortOption != null ? TossColors.primary : TossColors.gray600,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _getSortLabel(sortOption, ref),
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Show sort direction indicator
                        if (sortOption != null)
                          Icon(
                            ref.watch(employeeSortDirectionProvider)
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 16,
                            color: TossColors.primary,
                          ),
                        const SizedBox(width: TossSpacing.space1),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search Field
        Container(
          margin: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          child: TossSearchField(
            controller: searchController,
            hintText: 'Search team members...',
            onChanged: (value) {
              ref.read(employeeSearchQueryProvider.notifier).state = value;
            },
          ),
        ),
      ],
    );
  }

  String _getSortLabel(String? sortOption, WidgetRef ref) {
    final isAscending = ref.watch(employeeSortDirectionProvider);

    switch (sortOption) {
      case 'name':
        return isAscending ? 'Name (A-Z)' : 'Name (Z-A)';
      case 'salary':
        return isAscending ? 'Salary (Low to High)' : 'Salary (High to Low)';
      case 'role':
        return isAscending ? 'Role (A-Z)' : 'Role (Z-A)';
      case 'recent':
        return isAscending ? 'Oldest First' : 'Recently Added';
      default:
        return 'Sort by';
    }
  }

  bool _hasActiveFilters(WidgetRef ref) {
    final selectedRole = ref.watch(selectedRoleFilterProvider);
    final selectedDepartment = ref.watch(selectedDepartmentFilterProvider);
    final selectedSalaryType = ref.watch(selectedSalaryTypeFilterProvider);

    return selectedRole != null || selectedDepartment != null || selectedSalaryType != null;
  }

  int _getActiveFilterCount(WidgetRef ref) {
    int count = 0;
    final selectedRole = ref.watch(selectedRoleFilterProvider);
    final selectedDepartment = ref.watch(selectedDepartmentFilterProvider);
    final selectedSalaryType = ref.watch(selectedSalaryTypeFilterProvider);

    if (selectedRole != null) count++;
    if (selectedDepartment != null) count++;
    if (selectedSalaryType != null) count++;
    return count;
  }
}
