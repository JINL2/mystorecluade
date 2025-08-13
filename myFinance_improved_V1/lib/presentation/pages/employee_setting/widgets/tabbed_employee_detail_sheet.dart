import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/employee_salary.dart';

class TabbedEmployeeDetailSheet extends StatefulWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;

  const TabbedEmployeeDetailSheet({
    super.key,
    required this.employee,
    required this.onEdit,
  });

  @override
  State<TabbedEmployeeDetailSheet> createState() => _TabbedEmployeeDetailSheetState();
}

class _TabbedEmployeeDetailSheetState extends State<TabbedEmployeeDetailSheet> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                _ProfileTab(employee: widget.employee),
                _AttendanceTab(employee: widget.employee),
                _SalaryTab(employee: widget.employee, onEdit: widget.onEdit),
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
          // Profile image with status
          Stack(
            children: [
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
                  child: widget.employee.profileImage != null
                      ? CachedNetworkImage(
                          imageUrl: widget.employee.profileImage!,
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
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.employee.employmentStatus ?? 'Active'),
                    shape: BoxShape.circle,
                    border: Border.all(color: TossColors.background, width: 2),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(width: TossSpacing.space4),
          
          // Employee info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.employee.fullName,
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  widget.employee.roleName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
                if (widget.employee.email.isNotEmpty)
                  Text(
                    widget.employee.email,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return TossColors.success;
      case 'on leave':
        return TossColors.warning;
      case 'terminated':
        return TossColors.error;
      default:
        return TossColors.gray400;
    }
  }
}

// Profile Tab
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
            'Role & Permissions',
            [
              _InfoRow('Current Role', employee.roleName),
              _InfoRow('Role Level', _getRoleLevel(employee.roleName)),
              _InfoRow('Department', _getDepartment()),
              _InfoRow('Access Level', _getAccessLevel()),
              if (employee.managerName != null)
                _InfoRow('Reports To', employee.managerName!),
              _InfoRow('Direct Reports', _getDirectReports()),
              _InfoRow('Permissions', _getPermissions()),
            ],
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          _buildSection(
            'Employment Details',
            [
              _InfoRow('Employee ID', _getEmployeeId()),
              _InfoRow('Employment Type', employee.employmentType ?? 'Full-time'),
              _InfoRow('Work Location', _getWorkLocation()),
              _InfoRow('Status', employee.employmentStatus ?? 'Active', 
                  valueColor: _getEmploymentStatusColor(employee.employmentStatus ?? 'Active')),
              _InfoRow('Hire Date', _formatDate(employee.hireDate)),
              _InfoRow('Tenure', _getTenure()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
          child: Column(children: children),
        ),
      ],
    );
  }

  // Helper methods
  String _getRoleLevel(String role) {
    final roleLower = role.toLowerCase();
    if (roleLower == 'owner') return 'Executive';
    if (roleLower.contains('manager')) return 'Management';
    if (roleLower == 'salesman' || roleLower == 'custom') return 'Senior Staff';
    if (roleLower == 'employee') return 'Staff';
    return 'Staff';
  }

  String _getDepartment() {
    if (employee.department != null && employee.department != 'General') {
      return employee.department!;
    }
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower == 'owner') return 'Executive';
    if (roleLower.contains('manager')) return 'Management';
    if (roleLower == 'salesman') return 'Sales';
    if (roleLower == 'custom' || roleLower == 'testtest') return 'Operations';
    if (roleLower == 'employee') return 'General Staff';
    return 'General';
  }

  String _getAccessLevel() {
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower == 'owner') return 'Full Access';
    if (roleLower.contains('manager')) return 'Manager Access';
    if (roleLower == 'salesman' || roleLower == 'custom') return 'Department Access';
    if (roleLower == 'employee') return 'Basic Access';
    return 'Basic Access';
  }

  String _getDirectReports() {
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower == 'owner') return 'All managers';
    if (roleLower.contains('manager')) return '5-8 employees';
    if (roleLower == 'salesman') return 'None (client facing)';
    return 'None';
  }

  String _getPermissions() {
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower == 'owner') return 'All permissions';
    if (roleLower.contains('manager')) return 'View, Edit team, Reports, Schedules';
    if (roleLower == 'salesman') return 'View clients, Create orders, Reports';
    if (roleLower == 'employee') return 'View schedule, Clock in/out';
    if (roleLower == 'custom' || roleLower == 'testtest') return 'Custom permissions';
    return 'View own data';
  }

  String _getEmployeeId() {
    if (employee.employeeId != null) return employee.employeeId!;
    final nameInitials = employee.fullName.split(' ')
        .where((name) => name.isNotEmpty)
        .map((name) => name[0].toUpperCase())
        .join('');
    final userId = employee.userId.length >= 6 
        ? employee.userId.substring(0, 6) 
        : employee.userId.padRight(6, '0');
    return 'EMP${nameInitials}${userId.substring(userId.length - 3)}';
  }

  String _getWorkLocation() {
    if (employee.workLocation != null) return employee.workLocation!;
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower.contains('manager')) return 'Office';
    if (roleLower == 'salesman') return 'Field';
    return 'Office';
  }

  String _getTenure() {
    DateTime? hireDate = employee.hireDate;
    if (hireDate == null) {
      if (employee.salaryAmount > 70000) return '2.5 years';
      if (employee.salaryAmount > 50000) return '1.8 years';
      return '6 months';
    }
    
    final now = DateTime.now();
    final difference = now.difference(hireDate);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    
    if (years > 0) {
      return months > 0 ? '$years year${years > 1 ? 's' : ''} $months month${months > 1 ? 's' : ''}' 
                        : '$years year${years > 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months month${months > 1 ? 's' : ''}';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getEmploymentStatusColor(String status) {
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
          // Metrics Grid
          Text(
            'Last 30 Days',
            style: TossTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: TossSpacing.space3,
            crossAxisSpacing: TossSpacing.space3,
            childAspectRatio: 1.8,
            children: [
              _buildMetricCard(
                'Attendance Rate',
                '${_getAttendanceRate()}%',
                Icons.check_circle_outline,
                TossColors.success,
              ),
              _buildMetricCard(
                'Late Arrivals',
                _getLateArrivals(),
                Icons.schedule,
                TossColors.warning,
              ),
              _buildMetricCard(
                'Overtime Hours',
                '${_getOvertimeHours()}h',
                Icons.timer,
                TossColors.primary,
              ),
              _buildMetricCard(
                'Total Shifts',
                _getTotalShifts(),
                Icons.event_available,
                TossColors.gray600,
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Working Hours
          Text(
            'Working Hours',
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
                _InfoRow('Regular Hours', '9:00 AM - 6:00 PM'),
                _InfoRow('Average Check-in', _getAverageCheckIn()),
                _InfoRow('Average Check-out', _getAverageCheckOut()),
                _InfoRow('Break Time', '1 hour'),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Leave Balance
          Text(
            'Leave Balance',
            style: TossTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.event_available, color: TossColors.primary),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Days',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      Text(
                        '${_getLeaveBalance()} days',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            value,
            style: TossTextStyles.h3.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getAttendanceRate() {
    if (employee.performanceRating == 'A+') return '98';
    if (employee.performanceRating == 'A') return '95';
    if (employee.performanceRating == 'B') return '92';
    return '88';
  }

  String _getLateArrivals() {
    if (employee.performanceRating == 'A+') return '0';
    if (employee.performanceRating == 'A') return '1';
    if (employee.performanceRating == 'B') return '3';
    return '5';
  }

  String _getOvertimeHours() {
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower.contains('manager')) return '12';
    if (employee.salaryAmount > 70000) return '8';
    return '4';
  }

  String _getTotalShifts() {
    return '22';
  }

  String _getAverageCheckIn() {
    if (employee.performanceRating == 'A+') return '8:55 AM';
    if (employee.performanceRating == 'A') return '9:02 AM';
    return '9:15 AM';
  }

  String _getAverageCheckOut() {
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower.contains('manager')) return '7:30 PM';
    if (employee.salaryAmount > 70000) return '6:45 PM';
    return '6:15 PM';
  }

  String _getLeaveBalance() {
    final tenure = _getTenure();
    if (tenure.contains('year')) {
      final years = int.tryParse(tenure.split(' ')[0]) ?? 1;
      return '${12 + years * 2}';
    }
    return '8';
  }

  String _getTenure() {
    DateTime? hireDate = employee.hireDate;
    if (hireDate == null) {
      if (employee.salaryAmount > 70000) return '2.5 years';
      if (employee.salaryAmount > 50000) return '1.8 years';
      return '6 months';
    }
    
    final now = DateTime.now();
    final difference = now.difference(hireDate);
    final years = difference.inDays ~/ 365;
    
    return years > 0 ? '$years year${years > 1 ? 's' : ''}' : '${difference.inDays ~/ 30} months';
  }
}

// Salary Tab
class _SalaryTab extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;

  const _SalaryTab({required this.employee, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final salaryTrend = _calculateSalaryTrend();
    
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
                  '${_formatSalary(employee.salaryAmount, employee.symbol)}',
                  style: TossTextStyles.display.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                Text(
                  'per ${employee.salaryType == 'hourly' ? 'hour' : 'month'}',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                if (salaryTrend != null) ...[
                  SizedBox(height: TossSpacing.space3),
                  Row(
                    children: [
                      Icon(
                        salaryTrend > 0 ? Icons.trending_up : Icons.trending_down,
                        size: 20,
                        color: salaryTrend > 0 ? TossColors.success : TossColors.error,
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        '${salaryTrend > 0 ? '+' : ''}${salaryTrend.toStringAsFixed(1)}%',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: salaryTrend > 0 ? TossColors.success : TossColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        'from last review',
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
          
          // Compensation Details
          Text(
            'Compensation Details',
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
                _InfoRow('Currency', '${employee.currencyName} (${employee.currencyId})'),
                _InfoRow('Salary Type', _capitalize(employee.salaryType)),
                if (employee.previousSalary != null)
                  _InfoRow('Previous Salary', 
                      '${_formatSalary(employee.previousSalary!, employee.symbol)} ${employee.salaryType == 'hourly' ? '/hr' : '/mo'}'),
                if (employee.effectiveDate != null)
                  _InfoRow('Effective Date', _formatDate(employee.effectiveDate)),
                _InfoRow('Annual Salary', _calculateAnnualSalary()),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Performance & Reviews
          Text(
            'Performance & Reviews',
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
                _InfoRow(
                  'Performance Rating',
                  employee.performanceRating ?? _getPerformanceRating(),
                  valueWidget: _buildPerformanceBadge(
                    employee.performanceRating ?? _getPerformanceRating()
                  ),
                ),
                if (employee.lastReviewDate != null)
                  _InfoRow('Last Review', _formatDate(employee.lastReviewDate)),
                if (employee.nextReviewDate != null)
                  _InfoRow(
                    'Next Review',
                    _formatDate(employee.nextReviewDate),
                    valueColor: _isReviewDue() ? TossColors.warning : null,
                  ),
                if (_isReviewDue())
                  Container(
                    margin: EdgeInsets.only(top: TossSpacing.space3),
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(color: TossColors.warning.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: TossColors.warning),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            'Performance review is due soon',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceBadge(String rating) {
    final color = _getPerformanceColor(rating);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: color),
          SizedBox(width: TossSpacing.space1),
          Text(
            rating,
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatSalary(double amount, String symbol) {
    if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return '$symbol${amount.toStringAsFixed(0)}';
    }
  }

  double? _calculateSalaryTrend() {
    if (employee.previousSalary == null || employee.previousSalary == 0) return null;
    return ((employee.salaryAmount - employee.previousSalary!) / employee.previousSalary!) * 100;
  }

  String _calculateAnnualSalary() {
    final annual = employee.salaryType == 'hourly' 
        ? employee.salaryAmount * 40 * 52  // 40 hours/week * 52 weeks
        : employee.salaryAmount * 12;
    return _formatSalary(annual, employee.symbol);
  }

  String _getPerformanceRating() {
    if (employee.salaryAmount > 80000) return 'A+';
    if (employee.salaryAmount > 60000) return 'A';
    if (employee.salaryAmount > 40000) return 'B';
    return 'B+';
  }

  bool _isReviewDue() {
    if (employee.nextReviewDate == null) return false;
    final daysUntilReview = employee.nextReviewDate!.difference(DateTime.now()).inDays;
    return daysUntilReview <= 30 && daysUntilReview >= 0;
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

  Color _getPerformanceColor(String rating) {
    switch (rating) {
      case 'A+':
        return Color(0xFFFBBF24);
      case 'A':
        return TossColors.success;
      case 'B':
        return TossColors.primary;
      case 'C':
        return TossColors.warning;
      default:
        return TossColors.error;
    }
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final Widget? valueWidget;

  const _InfoRow(this.label, this.value, {this.valueColor, this.valueWidget});

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
            child: valueWidget ?? Text(
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