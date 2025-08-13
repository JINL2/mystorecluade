import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'models/employee_salary.dart';
import 'providers/employee_setting_providers.dart';
import '../../providers/app_state_provider.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/toss/toss_search_field.dart';
import 'widgets/simple_employee_card.dart';
import 'widgets/salary_edit_sheet.dart';
import 'widgets/employee_filter_sheet.dart';
import 'widgets/simple_tabbed_detail_sheet.dart';

class EnhancedEmployeeSettingPage extends ConsumerStatefulWidget {
  const EnhancedEmployeeSettingPage({super.key});

  @override
  ConsumerState<EnhancedEmployeeSettingPage> createState() => _EnhancedEmployeeSettingPageState();
}

class _EnhancedEmployeeSettingPageState extends ConsumerState<EnhancedEmployeeSettingPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  EmployeeFilterCriteria _filterCriteria = const EmployeeFilterCriteria();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isUpdatingSalaryProvider.notifier).state = false;
      ref.read(isSyncingProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshEmployees(ref);
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

  void _showSalaryEditSheet(EmployeeSalary employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SalaryEditSheet(employee: employee),
    );
  }

  void _updateEmployeeInList(EmployeeSalary originalEmployee, double amount, String type, String currencyId, String currencyName, String symbol) {
    // Update the mutable employee list
    final currentList = ref.read(mutableEmployeeListProvider);
    if (currentList != null) {
      final updatedList = currentList.map((emp) {
        if (emp.salaryId == originalEmployee.salaryId) {
          return EmployeeSalary(
            salaryId: originalEmployee.salaryId,
            userId: originalEmployee.userId,
            fullName: originalEmployee.fullName,
            email: originalEmployee.email,
            profileImage: originalEmployee.profileImage,
            roleName: originalEmployee.roleName,
            companyId: originalEmployee.companyId,
            storeId: originalEmployee.storeId,
            salaryAmount: amount,
            salaryType: type,
            currencyId: currencyId,
            currencyName: currencyName,
            symbol: symbol,
            effectiveDate: originalEmployee.effectiveDate,
            isActive: originalEmployee.isActive,
            updatedAt: DateTime.now(),
            employeeId: originalEmployee.employeeId,
            department: originalEmployee.department,
            hireDate: originalEmployee.hireDate,
            workLocation: originalEmployee.workLocation,
            employmentType: originalEmployee.employmentType,
            employmentStatus: originalEmployee.employmentStatus,
            costCenter: originalEmployee.costCenter,
            managerName: originalEmployee.managerName,
            performanceRating: originalEmployee.performanceRating,
            lastReviewDate: originalEmployee.lastReviewDate,
            nextReviewDate: originalEmployee.nextReviewDate,
            previousSalary: originalEmployee.salaryAmount,
          );
        }
        return emp;
      }).toList();
      
      ref.read(mutableEmployeeListProvider.notifier).state = updatedList;
      print('Updated employee list with new salary data');
    }
  }

  void _showEmployeeDetailSheet(EmployeeSalary employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SimpleTabbedDetailSheet(
        employee: employee,
        onEdit: () => _showSalaryEditSheet(employee),
        onEmployeeUpdated: (amount, type, currencyId, currencyName, symbol) {
          _updateEmployeeInList(employee, amount, type, currencyId, currencyName, symbol);
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: EmployeeFilterSheet(
          initialCriteria: _filterCriteria,
          onApplyFilters: (criteria) {
            setState(() {
              _filterCriteria = criteria;
            });
          },
        ),
      ),
    );
  }

  List<EmployeeSalary> _applyFiltersAndSort(List<EmployeeSalary> employees) {
    List<EmployeeSalary> filtered = employees;
    
    // Apply filters
    if (_filterCriteria.department != null) {
      filtered = filtered.where((emp) => 
        emp.displayDepartment == _filterCriteria.department).toList();
    }
    
    if (_filterCriteria.performanceRating != null) {
      filtered = filtered.where((emp) => 
        emp.performanceRating == _filterCriteria.performanceRating).toList();
    }
    
    if (_filterCriteria.workLocation != null) {
      filtered = filtered.where((emp) => 
        emp.displayWorkLocation == _filterCriteria.workLocation).toList();
    }
    
    if (_filterCriteria.employmentType != null) {
      filtered = filtered.where((emp) => 
        emp.displayEmploymentType == _filterCriteria.employmentType).toList();
    }
    
    if (_filterCriteria.employmentStatus != null) {
      filtered = filtered.where((emp) => 
        emp.displayEmploymentStatus == _filterCriteria.employmentStatus).toList();
    }
    
    if (_filterCriteria.salaryRange != null) {
      filtered = filtered.where((emp) => 
        emp.salaryAmount >= _filterCriteria.salaryRange!.start &&
        emp.salaryAmount <= _filterCriteria.salaryRange!.end).toList();
    }
    
    // Apply sorting
    if (_filterCriteria.sortBy != null) {
      filtered.sort((a, b) {
        int comparison = 0;
        
        switch (_filterCriteria.sortBy!) {
          case 'name':
            comparison = a.fullName.compareTo(b.fullName);
            break;
          case 'salary':
            comparison = a.salaryAmount.compareTo(b.salaryAmount);
            break;
          case 'department':
            comparison = a.displayDepartment.compareTo(b.displayDepartment);
            break;
          case 'hire_date':
            if (a.hireDate != null && b.hireDate != null) {
              comparison = a.hireDate!.compareTo(b.hireDate!);
            }
            break;
          case 'performance':
            final aRating = _getPerformanceValue(a.performanceRating);
            final bRating = _getPerformanceValue(b.performanceRating);
            comparison = aRating.compareTo(bRating);
            break;
        }
        
        return _filterCriteria.sortAscending ? comparison : -comparison;
      });
    }
    
    return filtered;
  }

  int _getPerformanceValue(String? rating) {
    switch (rating) {
      case 'A+': return 5;
      case 'A': return 4;
      case 'B': return 3;
      case 'C': return 2;
      case 'Needs Improvement': return 1;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(filteredEmployeesProvider);
    final searchQuery = ref.watch(employeeSearchQueryProvider);
    final isSyncing = ref.watch(isSyncingProvider);

    return TossScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: TossAppBar(
        title: 'Employee Management',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Sync button
          IconButton(
            icon: AnimatedRotation(
              duration: const Duration(milliseconds: 1000),
              turns: isSyncing ? 1 : 0,
              child: Icon(
                Icons.sync,
                color: isSyncing ? TossColors.primary : TossColors.gray600,
              ),
            ),
            onPressed: isSyncing ? null : _handleRefresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: TossColors.primary,
        child: Column(
          children: [
            // Search Bar and Filter in same row
            Padding(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: TossColors.gray400,
                            size: 20,
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                ref.read(employeeSearchQueryProvider.notifier).state = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Search employees',
                                hintStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  // Filter button
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_list_outlined,
                          color: _filterCriteria.hasActiveFilters 
                              ? TossColors.primary 
                              : TossColors.gray600,
                          size: 24,
                        ),
                        onPressed: _showFilterSheet,
                        padding: EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                      ),
                      if (_filterCriteria.hasActiveFilters)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: TossColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _filterCriteria.activeFilterCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Employee List
            Expanded(
              child: employeesAsync.when(
                data: (employees) {
                  final filteredEmployees = _applyFiltersAndSort(employees);
                  
                  if (filteredEmployees.isEmpty) {
                    return TossEmptyView(
                      icon: Icon(
                        _filterCriteria.hasActiveFilters 
                            ? Icons.search_off 
                            : Icons.people_outline,
                        size: 48,
                        color: TossColors.gray400,
                      ),
                      title: _filterCriteria.hasActiveFilters || searchQuery.isNotEmpty
                          ? 'No employees match your search'
                          : 'No employees found',
                      description: _filterCriteria.hasActiveFilters
                          ? 'Try adjusting your filters or search terms'
                          : searchQuery.isNotEmpty
                              ? 'Try searching with different keywords'
                              : 'Add employees to manage their information',
                    );
                  }
                  
                  return CustomScrollView(
                    slivers: [
                      // Employee cards
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final employee = filteredEmployees[index];
                            return SimpleEmployeeCard(
                              key: ValueKey(employee.userId),
                              employee: employee,
                              onEdit: () => _showSalaryEditSheet(employee),
                              onTap: () => _showEmployeeDetailSheet(employee),
                            );
                          },
                          childCount: filteredEmployees.length,
                        ),
                      ),
                      
                      // Bottom padding
                      SliverToBoxAdapter(
                        child: SizedBox(height: TossSpacing.space10),
                      ),
                    ],
                  );
                },
                loading: () => const TossLoadingView(
                  message: 'Loading employees...',
                ),
                error: (error, _) => TossErrorView(
                  error: error,
                  title: 'Something went wrong',
                  onRetry: () => refreshEmployees(ref),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}