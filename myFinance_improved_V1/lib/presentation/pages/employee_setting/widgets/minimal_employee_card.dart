import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../models/employee_salary.dart';

class MinimalEmployeeCard extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;
  final VoidCallback? onTap;

  const MinimalEmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: TossShadows.shadow1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                // Avatar with status
                _buildAvatarSection(),
                SizedBox(width: TossSpacing.space3),
                
                // Basic info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name with performance badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              employee.fullName,
                              style: TossTextStyles.labelLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_getPerformanceRating() != null) ...[
                            SizedBox(width: TossSpacing.space2),
                            _buildPerformanceBadge(_getPerformanceRating()!),
                          ],
                        ],
                      ),
                      
                      SizedBox(height: TossSpacing.space1),
                      
                      // Department and role
                      Row(
                        children: [
                          _buildDepartmentChip(_getDepartment()),
                          SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Text(
                              employee.roleName,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: TossSpacing.space1),
                      
                      // Minimal info row
                      Row(
                        children: [
                          Icon(Icons.apartment, size: 12, color: TossColors.gray400),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            _getWorkLocation(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                          Text(' • ', style: TossTextStyles.caption.copyWith(color: TossColors.gray400)),
                          Text(
                            employee.employmentType ?? 'Full-time',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                          Text(' • ', style: TossTextStyles.caption.copyWith(color: TossColors.gray400)),
                          Text(
                            _getTenure(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: TossSpacing.space2),
                      
                      // Employee ID and status row
                      Row(
                        children: [
                          Icon(Icons.badge_outlined, size: 12, color: TossColors.gray400),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            employee.employeeId ?? _generateEmployeeId(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontFamily: 'SF Mono',
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          _buildStatusBadge(employee.employmentStatus ?? 'Active'),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Salary and edit
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatSalary(employee.salaryAmount, employee.symbol),
                      style: TossTextStyles.labelLarge.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '/${employee.salaryType == 'hourly' ? 'hr' : 'mo'}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: TossColors.primary,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              'Edit',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: TossColors.gray100,
          ),
          child: ClipOval(
            child: employee.profileImage != null
                ? CachedNetworkImage(
                    imageUrl: employee.profileImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Icon(
                      Icons.person,
                      size: 24,
                      color: TossColors.gray400,
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 24,
                      color: TossColors.gray400,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 24,
                    color: TossColors.gray400,
                  ),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getStatusColor(employee.employmentStatus ?? 'Active'),
              shape: BoxShape.circle,
              border: Border.all(color: TossColors.background, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentChip(String department) {
    final color = _getDepartmentColor(department);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        department,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPerformanceBadge(String rating) {
    final color = _getPerformanceColor(rating);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 10, color: color),
          SizedBox(width: 2),
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

  Color _getDepartmentColor(String department) {
    switch (department.toLowerCase()) {
      case 'engineering':
        return TossColors.primary;
      case 'marketing':
        return Color(0xFF9333EA);
      case 'sales':
        return Color(0xFFEA580C);
      case 'design':
        return Color(0xFFEC4899);
      case 'human resources':
      case 'hr':
        return Color(0xFF10B981);
      case 'finance':
        return Color(0xFF6366F1);
      case 'management':
        return Color(0xFF8B5CF6);
      default:
        return TossColors.gray600;
    }
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

  String _formatSalary(double amount, String symbol) {
    if (amount >= 1000000) {
      return '${symbol}${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${symbol}${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return '${symbol}${amount.toStringAsFixed(0)}';
    }
  }

  String _getDepartment() {
    if (employee.department != null && employee.department != 'General') {
      return employee.department!;
    }
    return _generateDepartmentFromRole(employee.roleName);
  }

  String _generateDepartmentFromRole(String role) {
    final roleLower = role.toLowerCase();
    if (roleLower.contains('engineer') || roleLower.contains('developer')) {
      return 'Engineering';
    } else if (roleLower.contains('marketing')) {
      return 'Marketing';
    } else if (roleLower.contains('sales')) {
      return 'Sales';
    } else if (roleLower.contains('design')) {
      return 'Design';
    } else if (roleLower.contains('hr') || roleLower.contains('human')) {
      return 'HR';
    } else if (roleLower.contains('finance')) {
      return 'Finance';
    }
    return 'General';
  }

  String? _getPerformanceRating() {
    if (employee.performanceRating != null) return employee.performanceRating;
    if (employee.salaryAmount > 80000) return 'A+';
    if (employee.salaryAmount > 60000) return 'A';
    if (employee.salaryAmount > 40000) return 'B';
    return 'B+';
  }

  String _getWorkLocation() {
    if (employee.workLocation != null) return employee.workLocation!;
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower.contains('engineer') || roleLower.contains('developer')) {
      return 'Remote';
    } else if (roleLower.contains('manager')) {
      return 'Hybrid';
    }
    return 'Office';
  }

  String _getTenure() {
    if (employee.hireDate != null) {
      final now = DateTime.now();
      final difference = now.difference(employee.hireDate!);
      final years = difference.inDays ~/ 365;
      final months = (difference.inDays % 365) ~/ 30;
      
      if (years > 0) {
        return months > 0 ? '${years}.${(months / 12 * 10).round()}yr' : '${years}yr';
      } else if (months > 0) {
        return '${months}mo';
      } else {
        return '${difference.inDays}d';
      }
    }
    
    // Generate based on salary
    if (employee.salaryAmount > 70000) return '2.5yr';
    if (employee.salaryAmount > 50000) return '1.8yr';
    if (employee.salaryAmount > 30000) return '11mo';
    return '6mo';
  }

  String _generateEmployeeId() {
    final nameInitials = employee.fullName.split(' ')
        .where((name) => name.isNotEmpty)
        .map((name) => name[0].toUpperCase())
        .join('');
    final userId = employee.userId.length >= 6 
        ? employee.userId.substring(0, 6) 
        : employee.userId.padRight(6, '0');
    return 'EMP${nameInitials}${userId.substring(userId.length - 3)}';
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'on leave':
        return 'On Leave';
      case 'terminated':
        return 'Terminated';
      default:
        return status;
    }
  }
}