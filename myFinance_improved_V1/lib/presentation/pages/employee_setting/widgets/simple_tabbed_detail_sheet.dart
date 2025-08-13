import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/employee_salary.dart';
import 'salary_edit_sheet.dart';

class SimpleTabbedDetailSheet extends StatefulWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;
  final Function(double amount, String type, String currencyId, String currencyName, String symbol)? onEmployeeUpdated;

  const SimpleTabbedDetailSheet({
    super.key,
    required this.employee,
    required this.onEdit,
    this.onEmployeeUpdated,
  });

  @override
  State<SimpleTabbedDetailSheet> createState() => _SimpleTabbedDetailSheetState();
}

class _SimpleTabbedDetailSheetState extends State<SimpleTabbedDetailSheet> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late EmployeeSalary _currentEmployee;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentEmployee = widget.employee;
  }
  
  void _updateEmployee(double amount, String type, String currencyId, String currencyName, String symbol) {
    print('=== DETAIL SHEET UPDATE ===');
    print('Received amount: $amount');
    print('Received type: $type');
    print('Received currencyId: $currencyId');
    print('Received currencyName: $currencyName');
    print('Received symbol: $symbol');
    
    setState(() {
      _currentEmployee = EmployeeSalary(
        salaryId: _currentEmployee.salaryId,
        userId: _currentEmployee.userId,
        fullName: _currentEmployee.fullName,
        email: _currentEmployee.email,
        profileImage: _currentEmployee.profileImage,
        roleName: _currentEmployee.roleName,
        companyId: _currentEmployee.companyId,
        storeId: _currentEmployee.storeId,
        salaryAmount: amount,
        salaryType: type,
        currencyId: currencyId,
        currencyName: currencyName,
        symbol: symbol,
        effectiveDate: _currentEmployee.effectiveDate,
        isActive: _currentEmployee.isActive,
        updatedAt: DateTime.now(),
        employeeId: _currentEmployee.employeeId,
        department: _currentEmployee.department,
        hireDate: _currentEmployee.hireDate,
        workLocation: _currentEmployee.workLocation,
        employmentType: _currentEmployee.employmentType,
        employmentStatus: _currentEmployee.employmentStatus,
        costCenter: _currentEmployee.costCenter,
        managerName: _currentEmployee.managerName,
        performanceRating: _currentEmployee.performanceRating,
        lastReviewDate: _currentEmployee.lastReviewDate,
        nextReviewDate: _currentEmployee.nextReviewDate,
        previousSalary: _currentEmployee.salaryAmount,
      );
    });
    
    // Also update the parent employee list
    if (widget.onEmployeeUpdated != null) {
      print('=== CALLING PARENT CALLBACK ===');
      widget.onEmployeeUpdated!(amount, type, currencyId, currencyName, symbol);
    }
  }
  
  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SalaryEditSheet(
        employee: _currentEmployee,
        onSalaryUpdated: _updateEmployee,
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header with profile
          _buildHeader(),
          
          // Tab bar
          _buildTabBar(),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ProfileTab(employee: _currentEmployee),
                _AttendanceTab(employee: _currentEmployee),
                _SalaryTab(
                  employee: _currentEmployee, 
                  onEdit: () => _showEditSheet(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Row(
        children: [
          // Profile image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TossColors.gray100,
              border: Border.all(
                color: TossColors.gray200,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: _currentEmployee.profileImage != null && _currentEmployee.profileImage!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: _currentEmployee.profileImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Icon(
                        Icons.person,
                        size: 32,
                        color: TossColors.gray400,
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 32,
                        color: TossColors.gray400,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 32,
                      color: TossColors.gray400,
                    ),
            ),
          ),
          
          SizedBox(width: TossSpacing.space4),
          
          // Employee info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentEmployee.fullName,
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  _currentEmployee.roleName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
                if (_currentEmployee.email.isNotEmpty)
                  Text(
                    _currentEmployee.email,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
              ],
            ),
          ),
          
          // Close button
          IconButton(
            icon: Icon(Icons.close, color: TossColors.gray600),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
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
        labelColor: TossColors.primary,
        unselectedLabelColor: TossColors.gray600,
        labelStyle: TossTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TossTextStyles.labelLarge,
        indicatorColor: TossColors.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Attendance'),
          Tab(text: 'Salary'),
        ],
      ),
    );
  }
}

// Profile Tab - Shows only actual data from Supabase
class _ProfileTab extends StatelessWidget {
  final EmployeeSalary employee;

  const _ProfileTab({required this.employee});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Basic Information',
            [
              _InfoRow('User ID', employee.userId),
              _InfoRow('Full Name', employee.fullName),
              _InfoRow('Email', employee.email),
              _InfoRow('Role', employee.roleName),
              _InfoRow('Company ID', employee.companyId),
              if (employee.storeId != null)
                _InfoRow('Store ID', employee.storeId!),
            ],
          ),
          
          // Only show employment details if data exists
          if (_hasEmploymentData()) ...[
            SizedBox(height: TossSpacing.space6),
            _buildSection(
              'Employment Details',
              [
                if (employee.employeeId != null)
                  _InfoRow('Employee ID', employee.employeeId!),
                if (employee.department != null && employee.department != 'General')
                  _InfoRow('Department', employee.department!),
                if (employee.employmentType != null)
                  _InfoRow('Employment Type', employee.employmentType!),
                if (employee.workLocation != null)
                  _InfoRow('Work Location', employee.workLocation!),
                if (employee.employmentStatus != null)
                  _InfoRow('Status', employee.employmentStatus!,
                      valueColor: _getStatusColor(employee.employmentStatus!)),
                if (employee.hireDate != null)
                  _InfoRow('Hire Date', _formatDate(employee.hireDate)),
                if (employee.managerName != null)
                  _InfoRow('Reports To', employee.managerName!),
                if (employee.costCenter != null)
                  _InfoRow('Cost Center', employee.costCenter!),
              ],
            ),
          ],
          
          // Only show performance data if exists
          if (_hasPerformanceData()) ...[
            SizedBox(height: TossSpacing.space6),
            _buildSection(
              'Performance',
              [
                if (employee.performanceRating != null)
                  _InfoRow('Performance Rating', employee.performanceRating!),
                if (employee.lastReviewDate != null)
                  _InfoRow('Last Review', _formatDate(employee.lastReviewDate)),
                if (employee.nextReviewDate != null)
                  _InfoRow('Next Review', _formatDate(employee.nextReviewDate)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool _hasEmploymentData() {
    return employee.employeeId != null ||
        (employee.department != null && employee.department != 'General') ||
        employee.employmentType != null ||
        employee.workLocation != null ||
        employee.employmentStatus != null ||
        employee.hireDate != null ||
        employee.managerName != null ||
        employee.costCenter != null;
  }

  bool _hasPerformanceData() {
    return employee.performanceRating != null ||
        employee.lastReviewDate != null ||
        employee.nextReviewDate != null;
  }

  Widget _buildSection(String title, List<Widget> children) {
    // Filter out empty rows
    final validChildren = children.where((child) => child is _InfoRow).toList();
    if (validChildren.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(children: validChildren),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return TossColors.success;
      case 'on leave':
        return TossColors.warning;
      case 'terminated':
        return TossColors.error;
      default:
        return TossColors.gray600;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// Attendance Tab - Currently shows placeholder as no attendance data in Supabase
class _AttendanceTab extends StatelessWidget {
  final EmployeeSalary employee;

  const _AttendanceTab({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 64,
            color: TossColors.gray300,
          ),
          SizedBox(height: TossSpacing.space4),
          Text(
            'Attendance Data',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray700,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'No attendance data available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            'Attendance tracking will be available soon',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}

// Salary Tab - Shows actual salary data from Supabase
class _SalaryTab extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;

  const _SalaryTab({required this.employee, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Salary Card
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TossColors.primary.withOpacity(0.1),
                  TossColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(color: TossColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.payments_outlined, color: TossColors.primary),
                    SizedBox(width: TossSpacing.space2),
                    Text(
                      'Current Salary',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space3),
                Text(
                  '${employee.symbol}${employee.salaryAmount.toStringAsFixed(2)}',
                  style: TossTextStyles.display.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                Text(
                  'per ${employee.salaryType}',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                
                // Only show salary trend if previous salary exists
                if (employee.previousSalary != null) ...[
                  SizedBox(height: TossSpacing.space3),
                  Row(
                    children: [
                      Icon(
                        employee.salaryAmount > employee.previousSalary! 
                            ? Icons.trending_up 
                            : Icons.trending_down,
                        size: 20,
                        color: employee.salaryAmount > employee.previousSalary! 
                            ? TossColors.success 
                            : TossColors.error,
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        _calculateTrend(),
                        style: TossTextStyles.labelLarge.copyWith(
                          color: employee.salaryAmount > employee.previousSalary! 
                              ? TossColors.success 
                              : TossColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        'from previous',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Edit Salary Button
          ElevatedButton(
            onPressed: onEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space6,
                vertical: TossSpacing.space4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              elevation: 0,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_outlined, size: 20),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Edit Salary',
                  style: TossTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Salary Details
          Text(
            'Salary Details',
            style: TossTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              children: [
                _InfoRow('Currency', employee.currencyName),
                _InfoRow('Salary Type', _capitalize(employee.salaryType)),
                _InfoRow('Amount', '${employee.symbol}${employee.salaryAmount.toStringAsFixed(2)}'),
                if (employee.previousSalary != null)
                  _InfoRow('Previous Salary', 
                      '${employee.symbol}${employee.previousSalary!.toStringAsFixed(2)}'),
                if (employee.effectiveDate != null)
                  _InfoRow('Effective Date', _formatDate(employee.effectiveDate)),
                _InfoRow('Status', employee.isActive ? 'Active' : 'Inactive',
                    valueColor: employee.isActive ? TossColors.success : TossColors.error),
                if (employee.updatedAt != null)
                  _InfoRow('Last Updated', _formatDate(employee.updatedAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTrend() {
    if (employee.previousSalary == null || employee.previousSalary == 0) return '0%';
    final change = ((employee.salaryAmount - employee.previousSalary!) / employee.previousSalary!) * 100;
    return '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TossTextStyles.bodySmall.copyWith(
                color: valueColor ?? TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}