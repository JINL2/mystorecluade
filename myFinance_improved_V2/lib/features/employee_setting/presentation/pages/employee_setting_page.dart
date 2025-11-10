import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';

import '../../domain/entities/employee_salary.dart';
import '../providers/employee_providers.dart';
import '../widgets/employee_detail_sheet_v2.dart';
import '../widgets/role_selection_helper.dart';
import '../widgets/salary_edit_modal.dart';

class EmployeeSettingPageV2 extends ConsumerStatefulWidget {
  const EmployeeSettingPageV2({super.key});

  @override
  ConsumerState<EmployeeSettingPageV2> createState() => _EmployeeSettingPageV2State();
}

class _EmployeeSettingPageV2State extends ConsumerState<EmployeeSettingPageV2> 
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showScrollToTop = false;
  
  // Remove local filter states - using providers instead
  
  // Animation controllers
  late AnimationController _filterAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _filterAnimation;
  late Animation<double> _cardAnimation;

  bool _isFirstBuild = true;

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

    // Refresh data every time the page becomes visible
    if (_isFirstBuild) {
      _isFirstBuild = false;
    }

    // Reset loading states and refresh data on page entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isUpdatingSalaryProvider.notifier).state = false;
      ref.read(isSyncingProvider.notifier).state = false;

      // Reset all filters
      ref.read(selectedRoleFilterProvider.notifier).state = null;
      ref.read(selectedDepartmentFilterProvider.notifier).state = null;
      ref.read(selectedSalaryTypeFilterProvider.notifier).state = null;

      // Reset search query
      ref.read(employeeSearchQueryProvider.notifier).state = '';
      _searchController.clear();

      // Reset sort to default (name, ascending)
      ref.read(employeeSortOptionProvider.notifier).state = 'name';
      ref.read(employeeSortDirectionProvider.notifier).state = true;

      // Invalidate providers to force fresh data load from database
      ref.invalidate(employeeSalaryListProvider);
      ref.invalidate(currencyTypesProvider);
      ref.invalidate(rolesProvider);

      // Also clear mutable employee list to force reload
      ref.read(mutableEmployeeListProvider.notifier).state = null;
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
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  Future<void> _handleRefresh() async {
    ref.read(isSyncingProvider.notifier).state = true;
    try {
      await refreshEmployees(ref);
    } finally {
      ref.read(isSyncingProvider.notifier).state = false;
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
        backgroundColor: TossColors.gray100,
        appBar: TossAppBar1(
          title: 'Team Management',
          backgroundColor: TossColors.gray100,
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
                        child: _buildSearchFilterSection(employees, filteredEmployees),
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
                            size: 64,
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
                        padding: EdgeInsets.only(
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
                              child: _buildEmployeeListSection(filteredEmployees),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                        
                // Floating Action Buttons
                if (filteredEmployees.isNotEmpty)
                  _buildFloatingActions(),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true, // Allow tap-outside-to-dismiss
      enableDrag: true, // Allow swipe-to-dismiss
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      isDismissible: true, // Allow tap-outside-to-dismiss
      enableDrag: true, // Allow swipe-to-dismiss
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
            
            // Attendance fields - keep existing or update if this affects total salary
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
    // Use the new RoleSelectionHelper
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
    final currentList = ref.read(mutableEmployeeListProvider);
    if (currentList != null) {
      final updatedList = currentList.map((emp) {
        if (emp.salaryId == original.salaryId) {
          return updated;
        }
        return emp;
      }).toList();
      
      ref.read(mutableEmployeeListProvider.notifier).state = updatedList;
    }
  }
  
  

  Widget _buildSearchFilterSection(List<EmployeeSalary> allEmployees, List<EmployeeSalary> filteredEmployees) {
    final sortOption = ref.watch(employeeSortOptionProvider);
    
    
    return Column(
      children: [
        // Filter and Sort Controls
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: EdgeInsets.symmetric(
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
                    _showFilterOptionsSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
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
                              color: _hasActiveFilters() ? TossColors.primary : TossColors.gray600,
                            ),
                            if (_hasActiveFilters())
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${_getActiveFilterCount()}',
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
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _hasActiveFilters() ? '${_getActiveFilterCount()} filters active' : 'Filters',
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
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
                    _showSortOptionsSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
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
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _getSortLabel(sortOption),
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
                        SizedBox(width: TossSpacing.space1),
                        Icon(
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
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          child: TossSearchField(
            controller: _searchController,
            hintText: 'Search team members...',
            onChanged: (value) {
              ref.read(employeeSearchQueryProvider.notifier).state = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeListSection(List<EmployeeSalary> employees) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.groups_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Team Members',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
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
                _buildEmployeeCard(employee, index),
                if (index < employees.length - 1)
                  Divider(
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

  Widget _buildEmployeeCard(EmployeeSalary employee, int index) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _showEmployeeDetails(employee),
        borderRadius: index == 0 
            ? BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              )
            : BorderRadius.zero,
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Profile Image with better styling
              Hero(
                tag: 'employee_${employee.userId}',
                child: Container(
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
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
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
                            employee.fullName.isNotEmpty 
                                ? employee.fullName 
                                : 'Unknown User',
                            style: TossTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (employee.isActive)
                          Container(
                            margin: EdgeInsets.only(left: TossSpacing.space2),
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
                    SizedBox(height: 4),
                    // Role or department info
                    Text(
                      employee.roleName.isNotEmpty ? employee.roleName : (employee.department ?? 'No role assigned'),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Salary Info with better formatting
              Container(
                padding: EdgeInsets.only(left: TossSpacing.space2),
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
              
              SizedBox(width: TossSpacing.space3),
              
              // Arrow icon
              Icon(
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

  // Helper Methods

  String _getSortLabel(String? sortOption) {
    final isAscending = ref.watch(employeeSortDirectionProvider);
    
    switch (sortOption) {
      case 'name':
        return isAscending ? 'Name (A-Z)' : 'Name (Z-A)';
      case 'salary':
        // Salary default is high-to-low (descending), so reverse the labels
        return isAscending ? 'Salary (Low to High)' : 'Salary (High to Low)';
      case 'role':
        return isAscending ? 'Role (A-Z)' : 'Role (Z-A)';
      case 'recent':
        return isAscending ? 'Oldest First' : 'Recently Added';
      default:
        return 'Sort by';
    }
  }
  
  
  
  
  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isDismissible: true, // Allow tap-outside-to-dismiss
      enableDrag: true, // Allow swipe-to-dismiss
      builder: (context) => _buildSortSheet(),
    );
  }
  
  Widget _buildSortSheet() {
    final currentSort = ref.read(employeeSortOptionProvider);
    final isAscending = ref.read(employeeSortDirectionProvider);
    
    // Dynamic labels based on current direction
    final sortOptions = [
      {
        'value': 'name', 
        'label': isAscending ? 'Name (A-Z)' : 'Name (Z-A)', 
        'icon': Icons.sort_by_alpha,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
      {
        'value': 'salary', 
        'label': isAscending ? 'Salary (Low to High)' : 'Salary (High to Low)', 
        'icon': Icons.attach_money,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
      {
        'value': 'role', 
        'label': isAscending ? 'Role (A-Z)' : 'Role (Z-A)', 
        'icon': Icons.badge_outlined,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
      {
        'value': 'recent', 
        'label': isAscending ? 'Oldest First' : 'Recently Added', 
        'icon': Icons.access_time,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
    ];
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
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
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Sort by',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // Sort Options
          ...sortOptions.map((option) {
            final isSelected = option['value'] == currentSort;
            return Material(
              color: TossColors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  
                  // If clicking the same sort option, toggle direction
                  if (option['value'] == currentSort) {
                    ref.read(employeeSortDirectionProvider.notifier).state = !isAscending;
                  } else {
                    // Set new sort option with default direction
                    ref.read(employeeSortOptionProvider.notifier).state = option['value'] as String;
                    // Reset to default direction for each sort type
                    if (option['value'] == 'name' || option['value'] == 'role') {
                      ref.read(employeeSortDirectionProvider.notifier).state = true; // A-Z by default
                    } else {
                      ref.read(employeeSortDirectionProvider.notifier).state = false; // High-to-Low/Recent first by default
                    }
                  }
                  
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option['icon'] as IconData,
                        size: 20,
                        color: isSelected ? TossColors.primary : TossColors.gray600,
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Text(
                          option['label'] as String,
                          style: TossTextStyles.body.copyWith(
                            color: isSelected ? TossColors.primary : TossColors.gray900,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      // Show direction indicator for selected item
                      if (isSelected) ...[                    
                        Icon(
                          option['directionIcon'] as IconData,
                          size: 16,
                          color: TossColors.primary,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Icon(
                          Icons.check_rounded,
                          color: TossColors.primary,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
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
              elevation: 4,
              onPressed: () {
                HapticFeedback.lightImpact();
                _scrollController.animateTo(
                  0,
                  duration: TossAnimations.medium,
                  curve: TossAnimations.decelerate,
                );
              },
              child: Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ],
      ),
    );
  }


  void _clearAllFilters() {
    HapticFeedback.lightImpact();
    ref.read(selectedRoleFilterProvider.notifier).state = null;
    ref.read(selectedDepartmentFilterProvider.notifier).state = null;
    ref.read(selectedSalaryTypeFilterProvider.notifier).state = null;
    _searchController.clear();
    ref.read(employeeSearchQueryProvider.notifier).state = '';
  }

  bool _hasActiveFilters() {
    final selectedRole = ref.watch(selectedRoleFilterProvider);
    final selectedDepartment = ref.watch(selectedDepartmentFilterProvider);
    final selectedSalaryType = ref.watch(selectedSalaryTypeFilterProvider);
    
    return selectedRole != null || 
           selectedDepartment != null ||
           selectedSalaryType != null;
  }

  int _getActiveFilterCount() {
    int count = 0;
    final selectedRole = ref.watch(selectedRoleFilterProvider);
    final selectedDepartment = ref.watch(selectedDepartmentFilterProvider);
    final selectedSalaryType = ref.watch(selectedSalaryTypeFilterProvider);
    
    if (selectedRole != null) count++;
    if (selectedDepartment != null) count++;
    if (selectedSalaryType != null) count++;
    return count;
  }

  String _formatSalary(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
  
  
  
  
  void _showFilterOptionsSheet() {
    final employeesAsync = ref.read(filteredEmployeesProvider);
    employeesAsync.whenData((employees) {
      showModalBottomSheet(
        context: context,
        backgroundColor: TossColors.transparent,
        isScrollControlled: true,
        isDismissible: true, // Allow tap-outside-to-dismiss
        enableDrag: true, // Allow swipe-to-dismiss
        builder: (context) => _buildFilterSheet(employees),
      );
    });
  }
  
  Widget _buildFilterSheet(List<EmployeeSalary> allEmployees) {
    final roles = allEmployees.map((e) => e.roleName).whereType<String>().toSet().toList();
    final departments = allEmployees.map((e) => e.department).whereType<String>().toSet().toList();
    
    // Get current filter values from providers
    final selectedRole = ref.watch(selectedRoleFilterProvider);
    final selectedDepartment = ref.watch(selectedDepartmentFilterProvider);
    final selectedSalaryType = ref.watch(selectedSalaryTypeFilterProvider);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
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
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'Filter Team Members',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                if (_hasActiveFilters())
                  TossSecondaryButton(
                    text: 'Clear All',
                    onPressed: () {
                      _clearAllFilters();
                      Navigator.pop(context);
                    },
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
                  _buildFilterSection('Salary Type', 
                    ['hourly', 'monthly'], 
                    selectedSalaryType, 
                    Icons.attach_money_rounded, 
                    allEmployees,
                    (value) {
                      ref.read(selectedSalaryTypeFilterProvider.notifier).state = value;
                      Navigator.pop(context);
                    },
                    customLabels: {'hourly': 'Hourly', 'monthly': 'Monthly'},
                  ),
                  
                  _buildFilterSection('Role', roles, selectedRole, Icons.badge_outlined, allEmployees, (value) {
                    ref.read(selectedRoleFilterProvider.notifier).state = value;
                    Navigator.pop(context);
                  }),
                  
                  if (departments.isNotEmpty)
                    _buildFilterSection('Department', departments, selectedDepartment, Icons.business_rounded, allEmployees, (value) {
                      ref.read(selectedDepartmentFilterProvider.notifier).state = value;
                      Navigator.pop(context);
                    }),
                ],
              ),
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
  
  Widget _buildFilterSection(
    String title, 
    List<String> options, 
    String? selectedValue, 
    IconData icon,
    List<EmployeeSalary> allEmployees,
    ValueChanged<String?> onChanged,
    {Map<String, String>? customLabels}
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space6),
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.only(bottom: TossSpacing.space3),
            child: Row(
              children: [
                Icon(icon, size: 20, color: TossColors.gray600),
                SizedBox(width: TossSpacing.space2),
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
          _buildFilterOption(
            'All ${title}s',
            null,
            selectedValue,
            Icons.clear_all_rounded,
            onChanged,
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
            
            return _buildFilterOption(
              displayLabel,
              option,
              selectedValue,
              _getFilterIcon(title, option),
              onChanged,
              count: count,
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildFilterOption(
    String label,
    String? value,
    String? selectedValue,
    IconData icon,
    ValueChanged<String?> onChanged,
    {int? count}
  ) {
    final isSelected = value == selectedValue;
    
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onChanged(value),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space3),
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
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
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