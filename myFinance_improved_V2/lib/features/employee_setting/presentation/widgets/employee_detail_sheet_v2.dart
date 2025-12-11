import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/utils/number_formatter.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/employee_salary.dart';
import '../../domain/entities/shift_audit_log.dart';
import '../providers/employee_providers.dart';

class EmployeeDetailSheetV2 extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final void Function(EmployeeSalary) onUpdate;
  final void Function(EmployeeSalary) onEditSalary;
  final VoidCallback onManageRoles;

  const EmployeeDetailSheetV2({
    super.key,
    required this.employee,
    required this.onUpdate,
    required this.onEditSalary,
    required this.onManageRoles,
  });

  @override
  ConsumerState<EmployeeDetailSheetV2> createState() => 
      _EmployeeDetailSheetV2State();
}

class _EmployeeDetailSheetV2State extends ConsumerState<EmployeeDetailSheetV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current employee data from the provider to reflect any updates
    final employees = ref.watch(mutableEmployeeListProvider);
    final employee = employees?.firstWhere(
      (emp) => emp.userId == widget.employee.userId,
      orElse: () => widget.employee,
    ) ?? widget.employee;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(
              top: TossSpacing.space3,
              bottom: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Header Section
          _buildHeader(employee),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Tab Bar
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: TossColors.gray900,
              unselectedLabelColor: TossColors.gray500,
              indicatorColor: TossColors.gray900,
              indicatorWeight: 2,
              labelStyle: TossTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TossTextStyles.bodySmall,
              labelPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
              tabs: const [
                Tab(text: 'Salary'),
                Tab(text: 'Attendance'),
                Tab(text: 'Info'),
                Tab(text: 'Role'),
              ],
            ),
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _SalaryTab(
                  employee: employee,
                  onEdit: () => widget.onEditSalary(employee),
                ),
                _AttendanceTab(employee: employee),
                _InfoTab(employee: employee),
                _RoleTab(
                  employee: employee,
                  onManage: widget.onManageRoles,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(EmployeeSalary employee) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Large Avatar
          Hero(
            tag: 'avatar_${employee.userId}',
            child: _buildAvatar(employee, size: 80),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Name
          Text(
            employee.fullName,
            style: TossTextStyles.h2.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: TossSpacing.space2),

          const SizedBox(height: TossSpacing.space1),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Text(
              employee.roleName.isNotEmpty ? employee.roleName : 'No role assigned',
              style: TossTextStyles.bodySmall.copyWith(
                color: employee.roleName.isNotEmpty ? TossColors.gray900 : TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Last Activity Status
          const SizedBox(height: TossSpacing.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                employee.isActiveToday
                    ? Icons.circle
                    : Icons.access_time_rounded,
                size: 10,
                color: employee.isActiveToday
                    ? TossColors.success
                    : (employee.isInactive
                        ? TossColors.gray300
                        : TossColors.gray400),
              ),
              const SizedBox(width: 4),
              Text(
                employee.lastActivityAt != null
                    ? 'Last active ${employee.lastActivityText}'
                    : 'No recent activity',
                style: TossTextStyles.caption.copyWith(
                  color: employee.isActiveToday
                      ? TossColors.success
                      : (employee.isInactive
                          ? TossColors.gray400
                          : TossColors.gray500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAvatar(EmployeeSalary employee, {double size = 52}) {
    if (employee.profileImage != null && 
        employee.profileImage!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(employee.profileImage!),
        backgroundColor: TossColors.gray100,
      );
    }
    
    final initials = employee.fullName
        .split(' ')
        .map((name) => name.isNotEmpty ? name[0] : '')
        .take(2)
        .join()
        .toUpperCase();
    
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: TossColors.gray100,
      child: Text(
        initials,
        style: TossTextStyles.bodyLarge.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final EmployeeSalary employee;

  const _InfoTab({required this.employee});

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

// Salary Tab
class _SalaryTab extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;

  const _SalaryTab({
    required this.employee,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Salary Card
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    border: Border.all(
                      color: TossColors.gray200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Salary',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            employee.symbol,
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.gray900,
                            ),
                          ),
                          Text(
                            NumberFormatter.formatWithCommas((employee.totalSalary ?? employee.salaryAmount).round()),
                            style: TossTextStyles.display.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            employee.salaryType == 'hourly' ? '/hr' : '/mo',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space5),
                
                // Salary Details
                _buildDetailRow('Base Salary', '${employee.symbol}${NumberFormatter.formatWithCommas(employee.salaryAmount.round())} / ${employee.salaryType}'),
                if (employee.totalSalary != null && employee.totalSalary != employee.salaryAmount)
                  _buildDetailRow('Total Earned', '${employee.symbol}${NumberFormatter.formatWithCommas(employee.totalSalary!.round())} (This Month)'),
                _buildDetailRow('Currency', '${employee.currencyName} (${employee.symbol})'),
                _buildDetailRow('Payment Type', employee.salaryType.capitalize()),
                if (employee.effectiveDate != null)
                  _buildDetailRow(
                    'Effective Date', 
                    employee.effectiveDate!.toString().split(' ')[0],
                  ),
                _buildDetailRow(
                  'Last Updated', 
                  employee.updatedAt?.toString().split(' ')[0] ?? 'Never',
                ),
              ],
            ),
          ),
        ),
        
        // Fixed bottom button
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: const BoxDecoration(
            color: TossColors.background,
            border: Border(
              top: BorderSide(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: TossPrimaryButton(
                text: 'Edit Salary',
                onPressed: onEdit,
                fullWidth: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Role Tab
class _RoleTab extends ConsumerWidget {
  final EmployeeSalary employee;
  final VoidCallback onManage;

  const _RoleTab({
    required this.employee,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasRole = employee.roleName.isNotEmpty;
    final isOwnerAsync = ref.watch(isCurrentUserOwnerProvider);

    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Role Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        hasRole ? TossColors.primary.withValues(alpha: 0.08) : TossColors.gray100,
                        hasRole ? TossColors.primary.withValues(alpha: 0.03) : TossColors.gray50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: hasRole ? TossColors.primary.withValues(alpha: 0.2) : TossColors.gray200,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        hasRole ? Icons.verified_user : Icons.person_outline,
                        size: 48,
                        color: hasRole ? TossColors.primary : TossColors.gray400,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        hasRole ? employee.roleName : 'No Role Assigned',
                        style: TossTextStyles.h3.copyWith(
                          color: hasRole ? TossColors.gray900 : TossColors.gray600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Fixed bottom buttons
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: const BoxDecoration(
            color: TossColors.background,
            border: Border(
              top: BorderSide(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Change Role Button
                SizedBox(
                  width: double.infinity,
                  child: TossPrimaryButton(
                    text: hasRole ? 'Change Role' : 'Assign Role',
                    onPressed: onManage,
                    fullWidth: true,
                  ),
                ),

                // Delete Employee Button - Only visible to Owner
                isOwnerAsync.when(
                  data: (isOwner) {
                    if (!isOwner) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(top: TossSpacing.space3),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showDeleteConfirmationDialog(context, ref),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: TossColors.error,
                            side: const BorderSide(color: TossColors.error),
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                          ),
                          child: Text(
                            'Remove Employee',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _DeleteEmployeeDialog(
        employee: employee,
        onConfirm: (deleteSalary) async {
          Navigator.of(dialogContext).pop();
          await _executeDelete(context, ref, deleteSalary);
        },
      ),
    );
  }

  Future<void> _executeDelete(BuildContext context, WidgetRef ref, bool deleteSalary) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final repository = ref.read(employeeRepositoryProvider);

    // Show loading indicator
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final result = await repository.deleteEmployee(
        companyId: companyId,
        employeeUserId: employee.userId,
        deleteSalary: deleteSalary,
      );

      // Hide loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (result['success'] == true) {
        // Remove employee from mutable list immediately
        final currentList = ref.read(mutableEmployeeListProvider);
        if (currentList != null) {
          final updatedList = currentList.where((e) => e.userId != employee.userId).toList();
          ref.read(mutableEmployeeListProvider.notifier).state = updatedList;
        }

        // Also invalidate the source provider to refresh from server
        ref.invalidate(employeeSalaryListProvider);

        // Close the bottom sheet
        if (context.mounted) {
          Navigator.of(context).pop();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${employee.fullName} has been removed from the company.'),
              backgroundColor: TossColors.success,
            ),
          );
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text((result['message'] as String?) ?? 'Failed to remove employee.'),
              backgroundColor: TossColors.error,
            ),
          );
        }
      }
    } catch (e) {
      // Hide loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
}

// Delete Employee Confirmation Dialog
class _DeleteEmployeeDialog extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final void Function(bool deleteSalary) onConfirm;

  const _DeleteEmployeeDialog({
    required this.employee,
    required this.onConfirm,
  });

  @override
  ConsumerState<_DeleteEmployeeDialog> createState() => _DeleteEmployeeDialogState();
}

class _DeleteEmployeeDialogState extends ConsumerState<_DeleteEmployeeDialog> {
  bool _deleteSalary = true;
  bool _isLoading = true;
  Map<String, dynamic>? _validationData;

  @override
  void initState() {
    super.initState();
    _loadValidationData();
  }

  Future<void> _loadValidationData() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final repository = ref.read(employeeRepositoryProvider);

    try {
      final result = await repository.validateEmployeeDelete(
        companyId: companyId,
        employeeUserId: widget.employee.userId,
      );

      if (mounted) {
        setState(() {
          _validationData = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _validationData = {
            'success': false,
            'message': 'Failed to validate: $e',
          };
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: TossColors.error, size: 28),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Remove Employee',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : _buildContent(),
      actions: _isLoading
          ? null
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
              if (_validationData?['success'] == true)
                ElevatedButton(
                  onPressed: () => widget.onConfirm(_deleteSalary),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.error,
                    foregroundColor: TossColors.white,
                  ),
                  child: const Text('Remove'),
                ),
            ],
    );
  }

  Widget _buildContent() {
    if (_validationData?['success'] != true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: TossColors.error, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    (_validationData?['message'] as String?) ?? 'Cannot delete this employee.',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final dataSummary = _validationData?['data_summary'] as Map<String, dynamic>?;
    final willPreserve = dataSummary?['will_preserve'] as Map<String, dynamic>?;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Are you sure you want to remove "${widget.employee.fullName}" from your company?',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Data preservation notice
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data to be preserved:',
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              if (willPreserve != null) ...[
                _buildPreserveRow('Shift Records', (willPreserve['shift_requests'] as int?) ?? 0),
                _buildPreserveRow('Journal Entries', (willPreserve['journal_entries_created'] as int?) ?? 0),
                _buildPreserveRow('Cash Entries', (willPreserve['cash_amount_entries'] as int?) ?? 0),
              ],
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Delete salary option
        CheckboxListTile(
          value: _deleteSalary,
          onChanged: (value) => setState(() => _deleteSalary = value ?? true),
          title: Text(
            'Also delete salary information',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray900,
            ),
          ),
          subtitle: Text(
            'Uncheck to preserve salary history',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: TossColors.primary,
        ),

        const SizedBox(height: TossSpacing.space2),

        Text(
          'This action will soft-delete the employee\'s company connection. The user account will remain active for other companies.',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildPreserveRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            '$count records',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


// Attendance Tab
class _AttendanceTab extends ConsumerWidget {
  final EmployeeSalary employee;

  const _AttendanceTab({required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    // Watch audit logs provider
    final auditLogsAsync = ref.watch(
      employeeShiftAuditLogsProvider(
        EmployeeAuditLogParams(
          userId: employee.userId,
          companyId: companyId,
          limit: 20,
          offset: 0,
        ),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Month Summary
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Month Summary',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                // First Row - Working Days and Hours
                Row(
                  children: [
                    Expanded(
                      child: _buildAttendanceMetric(
                        'Working Days',
                        '${employee.totalWorkingDay ?? 0}',
                        Icons.calendar_today,
                        TossColors.gray900,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: _buildAttendanceMetric(
                        'Working Hours',
                        '${employee.totalWorkingHour?.toStringAsFixed(1) ?? "0.0"}h',
                        Icons.access_time,
                        TossColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

          // Attendance Details
          Text(
            'Attendance Details',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          _buildDetailRow('Month', employee.month ?? 'Current'),
          _buildDetailRow(
            'Total Working Days',
            '${employee.totalWorkingDay ?? 0} days',
          ),
          _buildDetailRow(
            'Total Working Hours',
            '${employee.totalWorkingHour?.toStringAsFixed(2) ?? "0.00"} hours',
          ),
          _buildDetailRow(
            'Total Salary Earned',
            '${employee.symbol}${employee.totalSalary != null ? NumberFormatter.formatCurrencyDecimal(employee.totalSalary!, "") : "0.00"}',
          ),

          if (employee.totalWorkingDay != null &&
              employee.totalWorkingDay! > 0) ...[
            const SizedBox(height: TossSpacing.space4),
            _buildDetailRow(
              'Average Hours/Day',
              '${((employee.totalWorkingHour ?? 0) / employee.totalWorkingDay!).toStringAsFixed(1)} hours',
            ),
          ],

          const SizedBox(height: TossSpacing.space6),

          // Recent Activity Section
          Text(
            'Recent Activity',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Audit Logs List
          auditLogsAsync.when(
            data: (logs) {
              if (logs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history,
                        color: TossColors.gray400,
                        size: 20,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        'No recent activity recorded',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  ...logs.map((log) => _buildAuditLogItem(log)),
                  if (logs.isNotEmpty && logs.first.totalCount > logs.length)
                    Padding(
                      padding: const EdgeInsets.only(top: TossSpacing.space2),
                      child: Text(
                        '${logs.first.totalCount - logs.length} more activities...',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, _) => Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.errorLight,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: TossColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Failed to load activity',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space6),

          // Performance Note
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: TossColors.gray600,
                  size: 20,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Attendance data is updated monthly and reflects actual working hours recorded.',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
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

  Widget _buildAuditLogItem(ShiftAuditLog log) {
    // Get icon based on action type
    IconData icon;
    Color iconColor;

    switch (log.actionType.toUpperCase()) {
      case 'CHECKIN':
        icon = Icons.login;
        iconColor = TossColors.success;
        break;
      case 'CHECKOUT':
        icon = Icons.logout;
        iconColor = TossColors.primary;
        break;
      case 'MANAGER_EDIT':
        icon = Icons.edit;
        iconColor = TossColors.warning;
        break;
      case 'REPORT_SOLVED':
        icon = Icons.check_circle;
        iconColor = TossColors.success;
        break;
      default:
        icon = Icons.history;
        iconColor = TossColors.gray500;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      log.actionTypeText,
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    if (log.storeName != null) ...[
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        '@ ${log.storeName}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  log.relativeTimeText,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttendanceMetric(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}