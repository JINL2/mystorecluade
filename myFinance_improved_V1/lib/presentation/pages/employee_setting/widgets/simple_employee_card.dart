import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../models/employee_salary.dart';

class SimpleEmployeeCard extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;
  final VoidCallback? onTap;

  const SimpleEmployeeCard({
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
                      // Name only
                      Text(
                        employee.fullName,
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: TossSpacing.space1),
                      
                      // Role only
                      Text(
                        employee.roleName,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Salary only
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
    // Format based on actual currency
    if (amount == 0) {
      return '${symbol}0';
    } else if (amount >= 1000) {
      return '${symbol}${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return '${symbol}${amount.toStringAsFixed(0)}';
    }
  }


  String _getPerformanceRating() {
    if (employee.performanceRating != null) return employee.performanceRating!;
    if (employee.salaryAmount > 80000) return 'A+';
    if (employee.salaryAmount > 60000) return 'A';
    if (employee.salaryAmount > 40000) return 'B';
    return 'B+';
  }
}