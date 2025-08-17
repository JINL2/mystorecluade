import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../widgets/toss/toss_card.dart';
import '../models/employee_salary.dart';

class EmployeeCardEnhanced extends ConsumerWidget {
  final EmployeeSalary employee;
  final VoidCallback onTap;

  const EmployeeCardEnhanced({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: TossCard(
        onTap: onTap,
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
              children: [
                // Avatar
                Hero(
                  tag: 'avatar_${employee.userId}',
                  child: _buildAvatar(size: 48),
                ),
                
                SizedBox(width: TossSpacing.space3),
                
                // Employee Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        employee.fullName,
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: TossSpacing.space1),
                      
                      // Role Badge (moved under name)
                      if (employee.roleName != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(employee.roleName!).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            employee.roleName!,
                            style: TossTextStyles.small.copyWith(
                              color: _getRoleColor(employee.roleName!),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                SizedBox(width: TossSpacing.space3),
                
                // Salary Information (moved to right)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${employee.symbol}${_formatAmount(employee.totalSalary ?? employee.salaryAmount)}',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      employee.salaryType == 'hourly' ? '/hr' : '/mo',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildAvatar({double size = 52}) {
    final radius = size / 2;
    
    if (employee.profileImage != null && employee.profileImage!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
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
      radius: radius,
      backgroundColor: TossColors.primary.withValues(alpha: 0.1),
      child: Text(
        initials,
        style: TossTextStyles.body.copyWith(
          color: TossColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }
  
  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
  
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return const Color(0xFF8B5CF6); // Purple for Owner
      case 'assistant manager':
      case 'manager':
        return TossColors.primary; // Primary color for managers
      case 'supervisor':
        return TossColors.primary; // Primary color for supervisors
      case 'employee':
      case 'staff':
        return TossColors.success; // Green for regular employees
      case 'intern':
        return TossColors.warning; // Orange for interns
      case 'contractor':
        return const Color(0xFF06B6D4); // Cyan for contractors
      default:
        return TossColors.gray600; // Default gray
    }
  }
  
}