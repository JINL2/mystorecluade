import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../widgets/toss/toss_dropdown.dart';
import '../../widgets/toss/toss_secondary_button.dart';
import 'models/employee_salary.dart';
import 'providers/employee_setting_providers.dart';
import 'widgets/employee_detail_sheet_v2.dart';
import 'widgets/salary_edit_modal.dart';
import 'widgets/role_management_modal.dart';

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
  
  // Filter states
  String? _selectedRole;
  String? _selectedDepartment;
  
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
    
    // Reset loading states
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isUpdatingSalaryProvider.notifier).state = false;
      ref.read(isSyncingProvider.notifier).state = false;
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
    
    // Apply role filter
    if (_selectedRole != null && _selectedRole!.isNotEmpty) {
      filtered = filtered.where((e) => e.roleName == _selectedRole).toList();
    }
    
    // Apply department filter
    if (_selectedDepartment != null && _selectedDepartment!.isNotEmpty) {
      filtered = filtered.where((e) => e.department == _selectedDepartment).toList();
    }
    
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(filteredEmployeesProvider);
    final searchQuery = ref.watch(employeeSearchQueryProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Team Management',
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
      );
  }
  
  void _showEmployeeDetails(EmployeeSalary employee) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
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
  
  void _showRoleManagement(EmployeeSalary employee) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => RoleManagementModal(
        userId: employee.userId,
        currentRole: employee.roleName,
        onSave: (newRole) {
          // Update the employee in the local list immediately
          _updateEmployeeInList(
            employee,
            employee.copyWith(
              roleName: newRole,
              updatedAt: DateTime.now(),
            ),
          );
        },
      ),
    ).then((result) {
      // Handle the result if needed
      if (result == true) {
        // Role was successfully updated
      }
    });
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
    
    // Extract unique values for filters
    final roles = allEmployees.map((e) => e.roleName).whereType<String>().toSet().toList();
    
    return Column(
      children: [
        // Stats Section - Always show
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space4,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat('Total', allEmployees.length.toString(), Icons.groups_rounded),
              Container(
                height: 20,
                width: 1,
                color: TossColors.gray200,
              ),
              _buildQuickStat('Roles', roles.length.toString(), Icons.badge_outlined),
            ],
          ),
        ),
        
        // Filter and Sort Controls - Always show
        Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
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
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _selectedRole ?? 'Filter',
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
        
        // Search Field - At the bottom
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
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
                    color: TossColors.primary.withOpacity(0.1),
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
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeSalary employee, int index) {
    return Material(
      color: Colors.transparent,
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
                    borderRadius: BorderRadius.circular(26),
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
                      employee.roleName ?? employee.department ?? 'No role assigned',
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
                      '${employee.symbol ?? '\$'}${_formatSalary(employee.salaryAmount)}',
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
  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: TossColors.gray500,
        ),
        SizedBox(width: TossSpacing.space2),
        Text(
          value,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  String _getSortLabel(String? sortOption) {
    switch (sortOption) {
      case 'name':
        return 'Name (A-Z)';
      case 'salary':
        return 'Salary (High to Low)';
      case 'role':
        return 'Role';
      case 'recent':
        return 'Recently Added';
      default:
        return 'Sort by';
    }
  }
  
  String _getFilterSortLabel() {
    final parts = <String>[];
    
    if (_selectedRole != null) {
      parts.add('Role: $_selectedRole');
    }
    
    final sortLabel = _getSortLabel(ref.read(employeeSortOptionProvider));
    if (sortLabel != 'Sort by') {
      parts.add(sortLabel);
    }
    
    if (parts.isEmpty) {
      return 'Filter & Sort';
    }
    
    return parts.join(' • ');
  }
  
  void _showFilterOptionsSheet() {
    final employeesAsync = ref.read(filteredEmployeesProvider);
    employeesAsync.whenData((employees) {
      final roles = employees.map((e) => e.roleName).whereType<String>().toSet().toList();
      
      showModalBottomSheet(
        context: context,
        backgroundColor: TossColors.transparent,
        builder: (context) => _buildFilterSheet(roles),
      );
    });
  }
  
  Widget _buildFilterSheet(List<String> roles) {
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
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Filter by Role',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // All Roles Option
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedRole = null;
                });
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
                      Icons.clear_all_rounded,
                      size: 20,
                      color: TossColors.gray600,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'All Roles',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    if (_selectedRole == null)
                      Icon(
                        Icons.check_rounded,
                        color: TossColors.primary,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Role Options
          ...roles.map((role) {
            final isSelected = role == _selectedRole;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedRole = role;
                  });
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
                        Icons.badge_outlined,
                        size: 20,
                        color: TossColors.gray600,
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Text(
                        role,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
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
          }).toList(),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
  
  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => _buildSortSheet(),
    );
  }
  
  Widget _buildSortSheet() {
    final sortOptions = [
      {'value': 'name', 'label': 'Name (A-Z)', 'icon': Icons.sort_by_alpha},
      {'value': 'salary', 'label': 'Salary (High to Low)', 'icon': Icons.attach_money},
      {'value': 'role', 'label': 'Role', 'icon': Icons.badge_outlined},
      {'value': 'recent', 'label': 'Recently Added', 'icon': Icons.access_time},
    ];
    
    final currentSort = ref.read(employeeSortOptionProvider);
    
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
              borderRadius: BorderRadius.circular(2),
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
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(employeeSortOptionProvider.notifier).state = option['value'] as String;
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
                        color: TossColors.gray600,
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Text(
                        option['label'] as String,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
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
          }).toList(),
          
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
    setState(() {
      _selectedRole = null;
      _selectedDepartment = null;
      _searchController.clear();
      ref.read(employeeSearchQueryProvider.notifier).state = '';
    });
  }

  bool _hasActiveFilters() {
    return _selectedRole != null || 
           _selectedDepartment != null;
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedRole != null) count++;
    if (_selectedDepartment != null) count++;
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
}