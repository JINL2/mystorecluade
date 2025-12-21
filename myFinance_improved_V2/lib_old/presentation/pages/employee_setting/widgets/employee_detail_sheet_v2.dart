import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../models/employee_salary.dart';
import '../providers/employee_setting_providers.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class EmployeeDetailSheetV2 extends ConsumerStatefulWidget {
  final EmployeeSalary employee;
  final Function(EmployeeSalary) onUpdate;
  final Function(EmployeeSalary) onEditSalary;
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
      decoration: BoxDecoration(
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
            margin: EdgeInsets.only(
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
          
          SizedBox(height: TossSpacing.space5),
          
          // Tab Bar
          Container(
            decoration: BoxDecoration(
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
              labelPadding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
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
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Large Avatar
          Hero(
            tag: 'avatar_${employee.userId}',
            child: _buildAvatar(employee, size: 80),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Name
          Text(
            employee.fullName,
            style: TossTextStyles.h2.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          
          if (employee.roleName != null) ...[
            SizedBox(height: TossSpacing.space1),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Text(
                employee.roleName!,
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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
      padding: EdgeInsets.all(TossSpacing.space5),
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
          
          SizedBox(height: TossSpacing.space4),
          
          // Employment Information Section
          _buildInfoCard(
            title: 'Employment Details',
            icon: Icons.work_outline,
            color: TossColors.success,
            children: [
              if (employee.department != null)
                _buildInfoRow('Department', employee.department!),
              _buildInfoRow('Role', employee.roleName),
              if (employee.managerName != null)
                _buildInfoRow('Manager', employee.managerName!),
              if (employee.workLocation != null)
                _buildInfoRow('Work Location', employee.workLocation!),
              if (employee.employmentType != null)
                _buildInfoRow('Employment Type', employee.employmentType!),
              _buildInfoRow('Employment Status', employee.employmentStatus ?? 'Active'),
              if (employee.costCenter != null)
                _buildInfoRow('Cost Center', employee.costCenter!),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Bank Information Section (Only Bank Name and Bank Number as requested)
          _buildInfoCard(
            title: 'Bank Information',
            icon: Icons.account_balance_outlined,
            color: TossColors.warning,
            children: [
              _buildInfoRow('Bank Name', 'Not specified'), // TODO: Add to database
              _buildInfoRow('Bank Number', 'Not specified'), // TODO: Add to database
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
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
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
                  padding: EdgeInsets.all(TossSpacing.space2),
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
                SizedBox(width: TossSpacing.space3),
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
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    final isEmpty = value.isEmpty || value == 'Not specified' || value == 'Not assigned';
    
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space3),
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
          SizedBox(width: TossSpacing.space3),
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
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Salary Card
                Container(
                  padding: EdgeInsets.all(TossSpacing.space4),
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
                      SizedBox(height: TossSpacing.space2),
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
                
                SizedBox(height: TossSpacing.space5),
                
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
          padding: EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
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
      padding: EdgeInsets.only(bottom: TossSpacing.space3),
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
class _RoleTab extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onManage;

  const _RoleTab({
    required this.employee,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final hasRole = employee.roleName != null;
    
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Role Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(TossSpacing.space5),
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
                      SizedBox(height: TossSpacing.space3),
                      Text(
                        hasRole ? employee.roleName! : 'No Role Assigned',
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
        
        // Fixed bottom button
        Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
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
                text: hasRole ? 'Change Role' : 'Assign Role',
                onPressed: onManage,
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
      padding: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.bodySmall.copyWith(
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
class _AttendanceTab extends StatelessWidget {
  final EmployeeSalary employee;

  const _AttendanceTab({required this.employee});


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Month Summary
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
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
                SizedBox(height: TossSpacing.space3),
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
                    SizedBox(width: TossSpacing.space3),
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
          
          SizedBox(height: TossSpacing.space5),
          
          // Attendance Details
          Text(
            'Attendance Details',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
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
          
          if (employee.totalWorkingDay != null && employee.totalWorkingDay! > 0) ...[
            SizedBox(height: TossSpacing.space4),
            _buildDetailRow(
              'Average Hours/Day', 
              '${((employee.totalWorkingHour ?? 0) / employee.totalWorkingDay!).toStringAsFixed(1)} hours',
            ),
          ],
          
          SizedBox(height: TossSpacing.space6),
          
          // Performance Note
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: TossColors.gray600,
                  size: 20,
                ),
                SizedBox(width: TossSpacing.space2),
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
  
  Widget _buildAttendanceMetric(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
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
          SizedBox(height: TossSpacing.space1),
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
      padding: EdgeInsets.only(bottom: TossSpacing.space3),
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