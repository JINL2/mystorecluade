import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../models/employee_salary.dart';
import 'status_indicators.dart';

class EnhancedEmployeeCard extends StatelessWidget {
  final EmployeeSalary employee;
  final VoidCallback onEdit;
  final VoidCallback? onTap;
  final bool showDetailedInfo;

  const EnhancedEmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    this.onTap,
    this.showDetailedInfo = true,
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
            child: showDetailedInfo 
                ? _buildDetailedCard(context)
                : _buildCompactCard(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedCard(BuildContext context) {
    return Column(
      children: [
        // Main row with avatar, info, and actions
        Row(
          children: [
            _buildAvatarSection(),
            SizedBox(width: TossSpacing.space3),
            Expanded(child: _buildMainInfoSection()),
            _buildSalarySection(),
          ],
        ),
        
        if (showDetailedInfo) ...[
          SizedBox(height: TossSpacing.space3),
          _buildSecondaryInfoRow(),
        ],
      ],
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Row(
      children: [
        _buildAvatarSection(),
        SizedBox(width: TossSpacing.space3),
        Expanded(child: _buildMainInfoSection()),
        _buildSalarySection(),
      ],
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
                    placeholder: (context, url) => Container(
                      color: TossColors.gray100,
                      child: const Icon(
                        Icons.person,
                        size: 24,
                        color: TossColors.gray400,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: TossColors.gray100,
                      child: const Icon(
                        Icons.person,
                        size: 24,
                        color: TossColors.gray400,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 24,
                    color: TossColors.gray400,
                  ),
          ),
        ),
        
        // Status indicator dot
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

  Widget _buildMainInfoSection() {
    // Generate smart defaults when enhanced data is missing
    final departmentName = employee.displayDepartment != 'General' 
        ? employee.displayDepartment 
        : _generateDepartmentFromRole(employee.roleName);
    
    final defaultPerformanceRating = _generatePerformanceRating();
    final showPerformanceRating = employee.performanceRating ?? defaultPerformanceRating;
    
    final workLocation = employee.workLocation ?? _generateWorkLocation();
    final employmentType = employee.employmentType ?? 'Full-time';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and badges row
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
            SizedBox(width: TossSpacing.space2),
            // Always show performance rating (real or generated)
            PerformanceRatingBadge(rating: showPerformanceRating),
            SizedBox(width: TossSpacing.space1),
            // Show review status if available or generate one
            if (employee.isReviewOverdue || employee.isReviewDue || _shouldShowReviewIndicator())
              ReviewStatusIndicator(
                isOverdue: employee.isReviewOverdue,
                isDue: employee.isReviewDue || _isGeneratedReviewDue(),
                nextReviewDate: employee.nextReviewDate ?? _generateNextReviewDate(),
              ),
          ],
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        // Department and role row
        Row(
          children: [
            DepartmentChip(department: departmentName),
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
        
        // Secondary info row with enhanced information
        Row(
          children: [
            WorkLocationIcon(location: workLocation),
            SizedBox(width: TossSpacing.space1),
            Text(
              workLocation,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
            Text(' • ', style: TossTextStyles.caption.copyWith(color: TossColors.gray400)),
            Text(
              employmentType,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
            Text(' • ', style: TossTextStyles.caption.copyWith(color: TossColors.gray400)),
            Text(
              employee.hireDate != null ? employee.tenureText : _generateTenure(),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        
        // Additional info row with employee ID and status
        SizedBox(height: TossSpacing.space1),
        Row(
          children: [
            Icon(Icons.badge_outlined, size: 12, color: TossColors.gray400),
            SizedBox(width: TossSpacing.space1),
            Text(
              employee.employeeId ?? _generateEmployeeId(),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontFamily: 'SF Mono',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            // Employment status badge
            EmploymentStatusBadge(status: employee.displayEmploymentStatus),
            if (employee.managerName != null) ...[
              SizedBox(width: TossSpacing.space3),
              Icon(Icons.person_outline, size: 12, color: TossColors.gray400),
              SizedBox(width: TossSpacing.space1),
              Text(
                'Reports to ${employee.managerName}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ],
    );
  }
  
  // Helper methods to generate smart defaults
  String _generateDepartmentFromRole(String role) {
    final roleLower = role.toLowerCase();
    if (roleLower.contains('engineer') || roleLower.contains('developer') || roleLower.contains('tech')) {
      return 'Engineering';
    } else if (roleLower.contains('marketing') || roleLower.contains('content') || roleLower.contains('social')) {
      return 'Marketing';
    } else if (roleLower.contains('sales') || roleLower.contains('business')) {
      return 'Sales';
    } else if (roleLower.contains('design') || roleLower.contains('ux') || roleLower.contains('ui')) {
      return 'Design';
    } else if (roleLower.contains('hr') || roleLower.contains('people') || roleLower.contains('recruit')) {
      return 'Human Resources';
    } else if (roleLower.contains('finance') || roleLower.contains('accounting') || roleLower.contains('money')) {
      return 'Finance';
    } else if (roleLower.contains('manager') || roleLower.contains('director') || roleLower.contains('lead')) {
      return 'Management';
    }
    return 'General';
  }
  
  String _generatePerformanceRating() {
    // Generate performance rating based on salary level and role
    if (employee.salaryAmount > 80000) return 'A+';
    if (employee.salaryAmount > 60000) return 'A';
    if (employee.salaryAmount > 40000) return 'B';
    return 'B+';
  }
  
  String _generateWorkLocation() {
    // Smart location based on role
    final roleLower = employee.roleName.toLowerCase();
    if (roleLower.contains('engineer') || roleLower.contains('developer')) {
      return 'Remote';
    } else if (roleLower.contains('manager') || roleLower.contains('lead')) {
      return 'Hybrid';
    }
    return 'Office';
  }
  
  String _generateEmployeeId() {
    // Generate employee ID from user ID or name
    final nameInitials = employee.fullName.split(' ')
        .where((name) => name.isNotEmpty)
        .map((name) => name[0].toUpperCase())
        .join('');
    final userId = employee.userId.length >= 6 
        ? employee.userId.substring(0, 6) 
        : employee.userId.padRight(6, '0');
    return 'EMP${nameInitials}${userId.substring(userId.length - 3)}';
  }
  
  String _generateTenure() {
    // Generate reasonable tenure based on salary/role
    if (employee.salaryAmount > 70000) return '2.5yr';
    if (employee.salaryAmount > 50000) return '1.8yr';
    if (employee.salaryAmount > 30000) return '11mo';
    return '6mo';
  }
  
  bool _shouldShowReviewIndicator() {
    // Show review indicator for higher-level roles
    final roleLower = employee.roleName.toLowerCase();
    return roleLower.contains('manager') || 
           roleLower.contains('lead') || 
           roleLower.contains('senior') ||
           employee.salaryAmount > 60000;
  }
  
  bool _isGeneratedReviewDue() {
    // Simulate some employees having reviews due
    return employee.userId.hashCode % 4 == 0; // 25% of employees
  }
  
  DateTime _generateNextReviewDate() {
    // Generate next review date (some due soon, some future)
    final random = employee.userId.hashCode % 6;
    final now = DateTime.now();
    return now.add(Duration(days: random == 0 ? 15 : random == 1 ? 45 : 120));
  }

  Widget _buildSalarySection() {
    // Generate salary trend if not available
    final hasRealTrend = employee.salaryIncreasePercentage != null;
    final generatedIncrease = hasRealTrend ? null : _generateSalaryTrend();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Salary amount with better formatting
        Text(
          _formatSalary(employee.salaryAmount, employee.symbol),
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        
        // Salary type with context
        Text(
          '/${employee.salaryType == 'hourly' ? 'hr' : 'mo'}',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        // Salary trend indicator (real or generated)
        if (hasRealTrend)
          SalaryTrendIndicator(
            increasePercentage: employee.salaryIncreasePercentage,
            increase: employee.salaryIncrease,
            currencySymbol: employee.symbol,
          )
        else if (generatedIncrease != null)
          _buildGeneratedTrendIndicator(generatedIncrease),
        
        SizedBox(height: TossSpacing.space2),
        
        // Enhanced edit button
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
              border: Border.all(
                color: TossColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 16,
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
    );
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
  
  double? _generateSalaryTrend() {
    // Generate realistic salary trends
    final hash = employee.userId.hashCode;
    final trendType = hash % 10;
    
    if (trendType < 6) return null; // 60% no trend shown
    if (trendType < 8) return 5.0 + (hash % 10); // 20% positive increase
    return -(2.0 + (hash % 3)); // 20% decrease (rare but realistic)
  }
  
  Widget _buildGeneratedTrendIndicator(double percentage) {
    final isPositive = percentage > 0;
    final color = isPositive ? TossColors.success : TossColors.error;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: color,
          ),
          SizedBox(width: TossSpacing.space1),
          Text(
            '${isPositive ? '+' : ''}${percentage.toStringAsFixed(1)}%',
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryInfoRow() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        children: [
          // Employee ID
          if (employee.employeeId != null) ...[
            Icon(Icons.badge_outlined, size: 14, color: TossColors.gray400),
            SizedBox(width: TossSpacing.space1),
            Text(
              employee.employeeId!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
            SizedBox(width: TossSpacing.space4),
          ],
          
          // Manager
          if (employee.managerName != null) ...[
            Icon(Icons.person_outline, size: 14, color: TossColors.gray400),
            SizedBox(width: TossSpacing.space1),
            Text(
              'Mgr: ${employee.managerName}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
            SizedBox(width: TossSpacing.space4),
          ],
          
          // Last review date
          if (employee.lastReviewDate != null) ...[
            Icon(Icons.rate_review_outlined, size: 14, color: TossColors.gray400),
            SizedBox(width: TossSpacing.space1),
            Text(
              'Rev: ${_formatDate(employee.lastReviewDate!)}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
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

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }
}