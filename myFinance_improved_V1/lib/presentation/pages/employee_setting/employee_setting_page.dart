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
import 'widgets/employee_card.dart';
import 'widgets/salary_edit_sheet.dart';

class EmployeeSettingPage extends ConsumerStatefulWidget {
  const EmployeeSettingPage({super.key});

  @override
  ConsumerState<EmployeeSettingPage> createState() => _EmployeeSettingPageState();
}

class _EmployeeSettingPageState extends ConsumerState<EmployeeSettingPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Reset any loading states
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
      // Refresh data when app comes back to foreground
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

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(filteredEmployeesProvider);
    final searchQuery = ref.watch(employeeSearchQueryProvider);
    final isSyncing = ref.watch(isSyncingProvider);

    return TossScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: TossAppBar(
        title: 'Employee Setting',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
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
            // Search Bar
            Padding(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: TossSearchField(
                hintText: 'Search employees by name or role',
                prefixIcon: Icons.search,
                onChanged: (value) {
                  ref.read(employeeSearchQueryProvider.notifier).state = value;
                },
              ),
            ),
            
            // Employee List
            Expanded(
              child: employeesAsync.when(
                data: (employees) {
                  if (employees.isEmpty) {
                    return TossEmptyView(
                      icon: Icon(
                        Icons.people_outline,
                        size: 48,
                        color: TossColors.gray400,
                      ),
                      title: searchQuery.isEmpty 
                          ? 'No employees found' 
                          : 'No results for "$searchQuery"',
                      description: searchQuery.isEmpty
                          ? 'Add employees to manage their salaries'
                          : 'Try searching with a different keyword',
                    );
                  }
                  
                  return ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: TossSpacing.space10,
                    ),
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return EmployeeCard(
                        key: ValueKey(employee.userId),
                        employeeName: employee.fullName,
                        employeeRole: employee.roleName,
                        salaryAmount: employee.salaryAmount,
                        currencySymbol: employee.symbol,
                        profileImageUrl: employee.profileImage,
                        onEdit: () => _showSalaryEditSheet(employee),
                      );
                    },
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