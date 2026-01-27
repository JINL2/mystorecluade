import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

import '../../domain/entities/employee_salary.dart';
import '../providers/employee_providers.dart';
import '../widgets/employee_detail_sheet_v2.dart';
import '../widgets/employee_filter_sheet.dart';
import '../widgets/employee_list_section.dart';
import '../widgets/employee_search_filter_section.dart';
import '../widgets/employee_sort_sheet.dart';
import '../widgets/role_selection_helper.dart';
import '../widgets/salary_edit_modal.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class EmployeeSettingPageV2 extends ConsumerStatefulWidget {
  const EmployeeSettingPageV2({super.key});

  @override
  ConsumerState<EmployeeSettingPageV2> createState() => _EmployeeSettingPageV2State();
}

class _EmployeeSettingPageV2State extends ConsumerState<EmployeeSettingPageV2>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Constants
  static const double _scrollToTopThreshold = 200.0;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showScrollToTop = false;

  // Animation controllers
  late AnimationController _filterAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _filterAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);

    // Initialize animation controllers
    _filterAnimationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );

    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: TossAnimations.standard,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardAnimationController,
      curve: TossAnimations.standard,
    );

    // Start animations
    _filterAnimationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Reset loading states and refresh data on page entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isUpdatingSalaryProvider.notifier).update(false);
      ref.read(isSyncingProvider.notifier).update(false);

      // Reset all filters
      ref.read(selectedRoleFilterProvider.notifier).clear();
      ref.read(selectedDepartmentFilterProvider.notifier).clear();
      ref.read(selectedSalaryTypeFilterProvider.notifier).clear();

      // Reset search query
      ref.read(employeeSearchQueryProvider.notifier).clear();
      _searchController.clear();

      // Reset sort to default (name, ascending)
      ref.read(employeeSortOptionProvider.notifier).update('name');
      ref.read(employeeSortDirectionProvider.notifier).update(true);

      // Invalidate unified provider to force fresh data load from database
      ref.invalidate(employeeSettingDataProvider);

      // Also clear mutable employee list to force reload
      ref.read(mutableEmployeeListProvider.notifier).clear();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _scrollController.dispose();
    _filterAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshEmployees(ref);
    }
  }

  void _onScroll() {
    if (_scrollController.offset > _scrollToTopThreshold && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= _scrollToTopThreshold && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  Future<void> _handleRefresh() async {
    ref.read(isSyncingProvider.notifier).update(true);
    try {
      await refreshEmployees(ref);
    } finally {
      ref.read(isSyncingProvider.notifier).update(false);
    }
  }

  List<EmployeeSalary> _applyFilters(List<EmployeeSalary> employees) {
    var filtered = employees;

    // Apply role filter from provider
    final selectedRole = ref.read(selectedRoleFilterProvider);
    if (selectedRole != null && selectedRole.isNotEmpty) {
      filtered = filtered.where((e) => e.roleName == selectedRole).toList();
    }

    // Apply department filter from provider
    final selectedDepartment = ref.read(selectedDepartmentFilterProvider);
    if (selectedDepartment != null && selectedDepartment.isNotEmpty) {
      filtered = filtered.where((e) => e.department == selectedDepartment).toList();
    }

    // Apply salary type filter from provider
    final selectedSalaryType = ref.read(selectedSalaryTypeFilterProvider);
    if (selectedSalaryType != null && selectedSalaryType.isNotEmpty) {
      filtered = filtered.where((e) => e.salaryType == selectedSalaryType).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(filteredEmployeesProvider);
    final searchQuery = ref.watch(employeeSearchQueryProvider);

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text field
        FocusScope.of(context).unfocus();
      },
      child: TossScaffold(
        backgroundColor: TossColors.white,
        appBar: const TossAppBar(
          title: 'Team Management',
          backgroundColor: TossColors.white,
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: TossColors.primary,
          child: employeesAsync.when(
            data: (employees) {
              final filteredEmployees = _applyFilters(employees);

              return Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Search and Filter Section (Always shown)
                      SliverToBoxAdapter(
                        child: FadeTransition(
                          opacity: _filterAnimation,
                          child: EmployeeSearchFilterSection(
                            searchController: _searchController,
                            onFilterPressed: () => _showFilterOptionsSheet(employees),
                            onSortPressed: _showSortOptionsSheet,
                          ),
                        ),
                      ),

                      // Employee List Section or Empty View
                      if (filteredEmployees.isEmpty)
                        SliverFillRemaining(
                          child: TossEmptyView(
                            icon: Icon(
                              searchQuery.isNotEmpty || _hasActiveFilters()
                                  ? Icons.search_off_rounded
                                  : Icons.groups_rounded,
                              size: TossDimensions.avatar3XL,
                              color: TossColors.gray400,
                            ),
                            title: searchQuery.isNotEmpty || _hasActiveFilters()
                                ? 'No results found'
                                : 'No team members yet',
                            description: searchQuery.isNotEmpty || _hasActiveFilters()
                                ? 'Try adjusting your search or filters'
                                : 'Add your first team member to get started',
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            left: TossSpacing.space4,
                            right: TossSpacing.space4,
                            bottom: TossSpacing.space4,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: FadeTransition(
                              opacity: _cardAnimation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.05),
                                  end: Offset.zero,
                                ).animate(_cardAnimation),
                                child: EmployeeListSection(
                                  employees: filteredEmployees,
                                  onEmployeeTap: _showEmployeeDetails,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Floating Action Buttons
                  if (filteredEmployees.isNotEmpty) _buildFloatingActions(),
                ],
              );
            },
            loading: () => const TossLoadingView(),
            error: (error, stack) => TossErrorView(
              error: error,
              title: 'Failed to load team members',
              onRetry: _handleRefresh,
            ),
          ),
        ),
      ),
    );
  }

  void _showEmployeeDetails(EmployeeSalary employee) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => EmployeeDetailSheetV2(
        employee: employee,
        onUpdate: (updatedEmployee) {
          _updateEmployeeInList(employee, updatedEmployee);
        },
        onEditSalary: (updatedEmployee) => _showSalaryEdit(updatedEmployee),
        onManageRoles: () => _showRoleManagement(employee),
      ),
    );
  }

  void _showSalaryEdit(EmployeeSalary employee) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => SalaryEditModal(
        employee: employee,
        onSave: (amount, type, currencyId, currencyName, symbol) {
          // Create updated employee with new salary data
          final updatedEmployee = EmployeeSalary(
            salaryId: employee.salaryId,
            userId: employee.userId,
            fullName: employee.fullName,
            email: employee.email,
            profileImage: employee.profileImage,
            roleName: employee.roleName,
            companyId: employee.companyId,
            storeId: employee.storeId,
            salaryAmount: amount,
            salaryType: type,
            currencyId: currencyId,
            currencyName: currencyName,
            symbol: symbol,
            effectiveDate: employee.effectiveDate,
            isActive: employee.isActive,
            updatedAt: DateTime.now(),
            // Enhanced fields
            department: employee.department,
            hireDate: employee.hireDate,
            employeeId: employee.employeeId,
            workLocation: employee.workLocation,
            performanceRating: employee.performanceRating,
            employmentType: employee.employmentType,
            lastReviewDate: employee.lastReviewDate,
            nextReviewDate: employee.nextReviewDate,
            previousSalary: employee.previousSalary,
            managerName: employee.managerName,
            costCenter: employee.costCenter,
            employmentStatus: employee.employmentStatus,
            // Attendance fields
            month: employee.month,
            totalWorkingDay: employee.totalWorkingDay,
            totalWorkingHour: employee.totalWorkingHour,
            totalSalary: amount, // Update total salary to match new base salary
          );

          _updateEmployeeInList(employee, updatedEmployee);
        },
      ),
    );
  }

  void _showRoleManagement(EmployeeSalary employee) async {
    // Use the RoleSelectionHelper
    final result = await RoleSelectionHelper.showRoleSelector(
      context: context,
      ref: ref,
      userId: employee.userId,
      currentRoleName: employee.roleName,
      onRoleUpdated: (String? newRole) {
        // Update the employee in the local list immediately
        _updateEmployeeInList(
          employee,
          employee.copyWith(
            roleName: newRole,
            updatedAt: DateTime.now(),
          ),
        );
      },
    );

    // Handle the result if needed
    if (result == true && mounted) {
      // Role was successfully updated
    }
  }

  void _updateEmployeeInList(EmployeeSalary original, EmployeeSalary updated) {
    // 2025+ Riverpod Best Practice: Use Optimistic Update method directly
    // This avoids creating a new list and is more efficient
    ref.read(mutableEmployeeListProvider.notifier).updateEmployee(updated);
  }

  Widget _buildFloatingActions() {
    return Positioned(
      bottom: TossSpacing.space4,
      right: TossSpacing.space4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Scroll to Top FAB
          AnimatedScale(
            scale: _showScrollToTop ? 1.0 : 0.0,
            duration: TossAnimations.normal,
            curve: TossAnimations.standard,
            child: FloatingActionButton.small(
              heroTag: 'scroll_to_top',
              backgroundColor: TossColors.surface,
              foregroundColor: TossColors.primary,
              elevation: 0,
              onPressed: () {
                HapticFeedback.lightImpact();
                _scrollController.animateTo(
                  0,
                  duration: TossAnimations.medium,
                  curve: TossAnimations.decelerate,
                );
              },
              child: const Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    HapticFeedback.lightImpact();
    ref.read(selectedRoleFilterProvider.notifier).clear();
    ref.read(selectedDepartmentFilterProvider.notifier).clear();
    ref.read(selectedSalaryTypeFilterProvider.notifier).clear();
    _searchController.clear();
    ref.read(employeeSearchQueryProvider.notifier).clear();
  }

  bool _hasActiveFilters() {
    final selectedRole = ref.watch(selectedRoleFilterProvider);
    final selectedDepartment = ref.watch(selectedDepartmentFilterProvider);
    final selectedSalaryType = ref.watch(selectedSalaryTypeFilterProvider);

    return selectedRole != null || selectedDepartment != null || selectedSalaryType != null;
  }

  void _showSortOptionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const EmployeeSortSheet(),
    );
  }

  void _showFilterOptionsSheet(List<EmployeeSalary> employees) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => EmployeeFilterSheet(
        allEmployees: employees,
        onClearAll: () {
          _clearAllFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}
