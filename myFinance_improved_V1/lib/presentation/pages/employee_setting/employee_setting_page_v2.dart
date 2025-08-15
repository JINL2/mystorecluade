import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/toss/toss_search_field.dart';
import 'models/employee_salary.dart';
import 'providers/employee_setting_providers.dart';
import 'providers/employee_setting_providers_v2.dart' as providers_v2;
import 'widgets/employee_card_enhanced.dart';
import 'widgets/employee_detail_sheet_v2.dart';
import 'widgets/salary_edit_modal.dart';
import 'widgets/role_management_modal.dart';

class EmployeeSettingPageV2 extends ConsumerStatefulWidget {
  const EmployeeSettingPageV2({super.key});

  @override
  ConsumerState<EmployeeSettingPageV2> createState() => _EmployeeSettingPageV2State();
}

class _EmployeeSettingPageV2State extends ConsumerState<EmployeeSettingPageV2> 
    with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    
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

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(providers_v2.combinedFilteredEmployeesProvider);
    final employeesAsync = ref.watch(filteredEmployeesProvider);
    final isSyncing = ref.watch(isSyncingProvider);
    final searchQuery = ref.watch(employeeSearchQueryProvider);

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Employee Settings',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: TossColors.primary,
        child: Column(
          children: [
            // Search and Sort Bar
            Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  // Search Field
                  TossSearchField(
                    controller: _searchController,
                    hintText: 'Search by name, email, role...',
                    onChanged: (value) {
                      ref.read(employeeSearchQueryProvider.notifier).state = value;
                    },
                  ),
                  
                  SizedBox(height: TossSpacing.space3),
                  
                  // Sort Options
                  _buildSortBar(),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: employeesAsync.when(
                data: (_) {
                  if (employees.isEmpty) {
                    return TossEmptyView(
                      icon: Icon(
                        searchQuery.isNotEmpty 
                            ? Icons.search_off 
                            : Icons.people_outline,
                        size: 64,
                        color: TossColors.gray400,
                      ),
                      title: searchQuery.isNotEmpty
                          ? 'No results found'
                          : 'No employees yet',
                      description: searchQuery.isNotEmpty
                          ? 'Try adjusting your search or filters'
                          : 'Tap the + button to add your first employee',
                    );
                  }
                  
                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          bottom: 80, // Add padding for the FAB
                        ),
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return EmployeeCardEnhanced(
                            key: ValueKey(employee.userId),
                            employee: employee,
                            onTap: () => _showEmployeeDetails(employee),
                          );
                        },
                      ),
                      
                      // Scroll to Top FAB
                      if (_showScrollToTop)
                        Positioned(
                          bottom: 80, // Position above the add button
                          right: TossSpacing.space4,
                          child: FloatingActionButton.small(
                            backgroundColor: Colors.white,
                            foregroundColor: TossColors.primary,
                            elevation: 4,
                            onPressed: () {
                              _scrollController.animateTo(
                                0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Icon(Icons.arrow_upward),
                          ),
                        ),
                    ],
                  );
                },
                loading: () => const TossLoadingView(),
                error: (error, stack) => TossErrorView(
                  error: error,
                  title: 'Failed to load employees',
                  onRetry: _handleRefresh,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showEmployeeDetails(EmployeeSalary employee) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
      backgroundColor: Colors.transparent,
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
      backgroundColor: Colors.transparent,
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
  
  
  Widget _buildSortBar() {
    final sortOption = ref.watch(employeeSortOptionProvider);
    final totalEmployees = ref.watch(mutableEmployeeListProvider)?.length ?? 0;
    
    final sortOptions = {
      'name': 'Name',
      'salary': 'Salary',
      'role': 'Role',
    };
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            size: 16,
            color: TossColors.gray600,
          ),
          SizedBox(width: TossSpacing.space2),
          Text(
            'Sort by:',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortOption,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: TossColors.gray600),
                items: sortOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(employeeSortOptionProvider.notifier).state = value;
                  }
                },
              ),
            ),
          ),
          Container(
            height: 20,
            width: 1,
            color: TossColors.gray300,
            margin: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
          ),
          Icon(
            Icons.people,
            size: 16,
            color: TossColors.gray600,
          ),
          SizedBox(width: TossSpacing.space1),
          Text(
            totalEmployees.toString(),
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}