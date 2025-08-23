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
import '../../widgets/toss/toss_dropdown.dart';
import '../../widgets/toss/toss_secondary_button.dart';
import '../../widgets/SB_widget/SB_searchbar_filter.dart';
import '../../widgets/SB_widget/SB_headline_group.dart';
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
  String _searchQuery = '';
  
  // Dynamic filter states
  Map<String, String?> _activeFilters = {
    'role': null,
    'department': null,
    'employmentType': null,
    'employmentStatus': null,
    'workLocation': null,
    'salaryType': null,
  };
  
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
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    
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

  // Dynamic filter extraction from employee data
  Map<String, List<String>> _extractFilterOptions(List<EmployeeSalary> employees) {
    return {
      'role': employees.map((e) => e.roleName).whereType<String>().where((s) => s.isNotEmpty).toSet().toList()..sort(),
      'department': employees.map((e) => e.department).whereType<String>().where((s) => s.isNotEmpty).toSet().toList()..sort(),
      'employmentType': employees.map((e) => e.employmentType).whereType<String>().where((s) => s.isNotEmpty).toSet().toList()..sort(),
      'employmentStatus': employees.map((e) => e.employmentStatus).whereType<String>().where((s) => s.isNotEmpty).toSet().toList()..sort(),
      'workLocation': employees.map((e) => e.workLocation).whereType<String>().where((s) => s.isNotEmpty).toSet().toList()..sort(),
      'salaryType': employees.map((e) => e.salaryType).whereType<String>().where((s) => s.isNotEmpty).toSet().toList()..sort(),
    };
  }

  // Apply search and filters
  List<EmployeeSalary> _applySearchAndFilters(List<EmployeeSalary> employees) {
    var filtered = employees;
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((employee) {
        final name = employee.fullName.toLowerCase();
        final email = employee.email?.toLowerCase() ?? '';
        final role = employee.roleName?.toLowerCase() ?? '';
        final department = employee.department?.toLowerCase() ?? '';
        
        return name.contains(_searchQuery) || 
               email.contains(_searchQuery) ||
               role.contains(_searchQuery) ||
               department.contains(_searchQuery);
      }).toList();
    }
    
    // Apply active filters
    _activeFilters.forEach((filterType, filterValue) {
      if (filterValue != null && filterValue.isNotEmpty) {
        filtered = filtered.where((employee) {
          switch (filterType) {
            case 'role':
              return employee.roleName == filterValue;
            case 'department':
              return employee.department == filterValue;
            case 'employmentType':
              return employee.employmentType == filterValue;
            case 'employmentStatus':
              return employee.employmentStatus == filterValue;
            case 'workLocation':
              return employee.workLocation == filterValue;
            case 'salaryType':
              return employee.salaryType == filterValue;
            default:
              return true;
          }
        }).toList();
      }
    });
    
    return filtered;
  }

  // Check if any filters are active
  bool _hasActiveFilters() {
    return _activeFilters.values.any((value) => value != null && value.isNotEmpty);
  }

  // Get count of active filters
  int _getActiveFilterCount() {
    return _activeFilters.values.where((value) => value != null && value.isNotEmpty).length;
  }

  // Clear all filters
  void _clearAllFilters() {
    setState(() {
      _activeFilters = {
        'role': null,
        'department': null,
        'employmentType': null,
        'employmentStatus': null,
        'workLocation': null,
        'salaryType': null,
      };
      _searchController.clear();
      _searchQuery = '';
    });
  }


  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(filteredEmployeesProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Team Management',
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: TossColors.primary,
        child: employeesAsync.when(
          data: (allEmployees) {
            final filteredEmployees = _applySearchAndFilters(allEmployees);
            
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Stats Section (Always shown)
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _filterAnimation,
                        child: _buildStatsSection(allEmployees, filteredEmployees),
                      ),
                    ),
                    
                    // Search and Filter Section
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _filterAnimation,
                        child: _buildSearchFilterSection(allEmployees),
                      ),
                    ),
                    
                    // Employee List Section or Empty View
                    if (filteredEmployees.isEmpty)
                      SliverFillRemaining(
                        child: TossEmptyView(
                          icon: Icon(
                            _searchQuery.isNotEmpty || _hasActiveFilters()
                                ? Icons.search_off_rounded 
                                : Icons.groups_rounded,
                            size: 64,
                            color: TossColors.gray400,
                          ),
                          title: _searchQuery.isNotEmpty || _hasActiveFilters()
                              ? 'No results found'
                              : 'No team members yet',
                          description: _searchQuery.isNotEmpty || _hasActiveFilters()
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
  
  

  Widget _buildStatsSection(List<EmployeeSalary> allEmployees, List<EmployeeSalary> filteredEmployees) {
    // Extract unique values for stats
    final roles = allEmployees.map((e) => e.roleName).whereType<String>().toSet().toList();
    
    return Container(
      margin: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space4,
        TossSpacing.space4,
        TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Total Members Card
          Expanded(
            child: _buildModernStatCard(
              value: allEmployees.length.toString(),
              label: 'Members',
              icon: Icons.people_alt_outlined,
              color: TossColors.primary,
            ),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Total Roles Card
          Expanded(
            child: _buildModernStatCard(
              value: roles.length.toString(),
              label: 'Roles',
              icon: Icons.work_outline,
              color: TossColors.success,
            ),
          ),
          
          // Filtered Results Card (only when filters/search are active)
          if (_hasActiveFilters() || _searchQuery.isNotEmpty) ...[
            SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildModernStatCard(
                value: filteredEmployees.length.toString(),
                label: 'Filtered',
                icon: Icons.filter_alt_outlined,
                color: TossColors.warning,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    // Create background colors based on the primary color
    final backgroundColor = color == TossColors.primary 
        ? Color(0xFFE8F0FF)  // Light blue
        : color == TossColors.success 
            ? Color(0xFFE8F5E9)  // Light green
            : color == TossColors.warning
                ? Color(0xFFFFF3E0)  // Light orange
                : Color(0xFFE3F2FD);  // Light info blue
    
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Row(
          children: [
            // Left side - Text content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    label,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Right side - Icon
            Container(
              padding: EdgeInsets.all(TossSpacing.space2),
              child: Icon(
                icon,
                color: color.withOpacity(0.7),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilterSection(List<EmployeeSalary> allEmployees) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space4,
      ),
      child: SBSearchBarFilter(
        searchController: _searchController,
        searchHint: 'Search team members...',
        onSearchChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        onFilterTap: () => _showFilterOptionsSheet(allEmployees),
      ),
    );
  }

  void _showFilterOptionsSheet(List<EmployeeSalary> allEmployees) {
    final filterOptions = _extractFilterOptions(allEmployees);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => _buildFilterSheet(filterOptions),
    );
  }

  Widget _buildFilterSheet(Map<String, List<String>> filterOptions) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
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
          
          // Header with title and clear all
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Team Members',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_hasActiveFilters())
                  TextButton(
                    onPressed: () {
                      _clearAllFilters();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear All',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Filter Categories (Scrollable)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFilterCategory('Role', 'role', filterOptions['role'] ?? [], Icons.badge_outlined),
                  _buildFilterCategory('Department', 'department', filterOptions['department'] ?? [], Icons.business_outlined),
                  _buildFilterCategory('Employment Type', 'employmentType', filterOptions['employmentType'] ?? [], Icons.work_outline),
                  _buildFilterCategory('Employment Status', 'employmentStatus', filterOptions['employmentStatus'] ?? [], Icons.account_circle_outlined),
                  _buildFilterCategory('Work Location', 'workLocation', filterOptions['workLocation'] ?? [], Icons.location_on_outlined),
                  _buildFilterCategory('Salary Type', 'salaryType', filterOptions['salaryType'] ?? [], Icons.payments_outlined),
                ],
              ),
            ),
          ),
          
          // Active Filters Summary
          if (_hasActiveFilters())
            Container(
              margin: EdgeInsets.all(TossSpacing.space4),
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: TossColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: TossColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      '${_getActiveFilterCount()} filter${_getActiveFilterCount() > 1 ? 's' : ''} active',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          SizedBox(height: TossSpacing.space2),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(String title, String filterKey, List<String> options, IconData icon) {
    if (options.isEmpty) return SizedBox.shrink();
    
    final selectedValue = _activeFilters[filterKey];
    
    return Column(
      children: [
        // Category Header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space2,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray800,
                ),
              ),
              if (selectedValue != null && selectedValue.isNotEmpty) ...[
                SizedBox(width: TossSpacing.space2),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // All Option
        _buildFilterOption(title, filterKey, null, 'All ${title}s', selectedValue == null),
        
        // Individual Options
        ...options.map((option) => _buildFilterOption(title, filterKey, option, option, selectedValue == option)),
        
        SizedBox(height: TossSpacing.space2),
      ],
    );
  }

  Widget _buildFilterOption(String categoryTitle, String filterKey, String? value, String displayText, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _activeFilters[filterKey] = value;
          });
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space6,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              SizedBox(width: TossSpacing.space6), // Indentation
              Expanded(
                child: Text(
                  displayText,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
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

  Widget _buildEmployeeListSection(List<EmployeeSalary> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header - No background, separated from list
        SBHeadlineGroup(
          title: 'Team Members',
        ),
        
        // Employee List Container
        Container(
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            children: [
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
        ),
      ],
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
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(28),
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
              
              SizedBox(width: TossSpacing.space4),
              
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
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black87,
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
                    SizedBox(height: TossSpacing.space1),
                    // Role or department info
                    Text(
                      employee.roleName ?? employee.department ?? 'No role assigned',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
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
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      employee.salaryType == 'hourly' ? '/hour' : '/month',
                      style: TossTextStyles.caption.copyWith(
                        color: const Color(0xFFE53935),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: TossSpacing.space2),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods


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



  String _formatSalary(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}