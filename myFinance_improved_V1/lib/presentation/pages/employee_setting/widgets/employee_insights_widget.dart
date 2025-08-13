import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../models/employee_salary.dart';

class EmployeeInsightsWidget extends StatelessWidget {
  final List<EmployeeSalary> employees;

  const EmployeeInsightsWidget({
    super.key,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const SizedBox.shrink();
    }

    final insights = _calculateInsights();
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: TossShadows.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_outlined,
                size: 20,
                color: TossColors.primary,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Team Insights',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Key metrics row
          Row(
            children: [
              Expanded(child: _buildMetricCard(
                'Total',
                employees.length.toString(),
                'employees',
                TossColors.primary,
                Icons.people_outline,
              )),
              SizedBox(width: TossSpacing.space2),
              Expanded(child: _buildMetricCard(
                'Avg Salary',
                '\$${insights.averageSalary.toStringAsFixed(0)}',
                '/month',
                TossColors.success,
                Icons.attach_money_outlined,
              )),
              SizedBox(width: TossSpacing.space2),
              Expanded(child: _buildMetricCard(
                'Reviews Due',
                insights.reviewsDue.toString(),
                'this month',
                insights.reviewsDue > 0 ? TossColors.warning : TossColors.gray400,
                Icons.schedule_outlined,
              )),
            ],
          ),
          
          if (insights.insights.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space4),
            ...insights.insights.map((insight) => _buildInsightItem(insight)),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.labelSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.labelLarge.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String insight) {
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: TossColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              insight,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  EmployeeInsightsData _calculateInsights() {
    final totalSalary = employees.fold<double>(
      0, (sum, emp) => sum + emp.salaryAmount
    );
    final averageSalary = totalSalary / employees.length;
    
    final now = DateTime.now();
    final reviewsDue = employees.where((emp) => 
      emp.nextReviewDate != null && 
      emp.nextReviewDate!.difference(now).inDays <= 30 &&
      emp.nextReviewDate!.isAfter(now)
    ).length;
    
    final highPerformers = employees.where((emp) => 
      emp.performanceRating == 'A+' || emp.performanceRating == 'A'
    ).length;
    
    final departments = employees
      .map((emp) => emp.displayDepartment)
      .toSet()
      .length;
    
    final remoteEmployees = employees.where((emp) => 
      emp.workLocation?.toLowerCase() == 'remote'
    ).length;
    
    final List<String> insights = [];
    
    if (reviewsDue > 0) {
      insights.add('$reviewsDue employees due for review this month');
    }
    
    if (highPerformers > 0) {
      insights.add('$highPerformers high performers (A/A+ rating)');
    }
    
    if (departments > 1) {
      insights.add('Employees across $departments departments');
    }
    
    if (remoteEmployees > 0) {
      final percentage = (remoteEmployees / employees.length * 100).round();
      insights.add('$percentage% work remotely');
    }
    
    final salaryAboveAverage = employees.where((emp) => 
      emp.salaryAmount > averageSalary
    ).length;
    
    if (salaryAboveAverage != employees.length / 2) {
      insights.add('$salaryAboveAverage employees earn above average');
    }
    
    return EmployeeInsightsData(
      averageSalary: averageSalary,
      reviewsDue: reviewsDue,
      insights: insights,
    );
  }
}

class EmployeeInsightsData {
  final double averageSalary;
  final int reviewsDue;
  final List<String> insights;

  EmployeeInsightsData({
    required this.averageSalary,
    required this.reviewsDue,
    required this.insights,
  });
}