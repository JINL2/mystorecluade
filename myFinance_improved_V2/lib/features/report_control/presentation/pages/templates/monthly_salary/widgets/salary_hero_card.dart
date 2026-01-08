// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/salary_hero_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../domain/entities/monthly_salary_report.dart';

/// Filter type for salary report
enum SalaryFilter {
  all,           // Show all employees
  withWarnings,  // Show only employees with warnings
  noWarnings,    // Show employees without warnings
  selfApproved,  // Show employees with self-approved warnings
}

/// Salary Hero Card with summary and filters
class SalaryHeroCard extends StatelessWidget {
  final SalarySummary summary;
  final SalaryFilter activeFilter;
  final ValueChanged<SalaryFilter>? onFilterChanged;

  const SalaryHeroCard({
    super.key,
    required this.summary,
    this.activeFilter = SalaryFilter.all,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with status
          Row(
            children: [
              Container(
                width: TossDimensions.avatarLG,
                height: TossDimensions.avatarLG,
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                ),
                child: Icon(
                  _getStatusIcon(),
                  size: TossSpacing.iconMD,
                  color: _getStatusColor(),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Payroll',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                        fontWeight: TossFontWeight.medium,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space0_5),
                    Text(
                      '${summary.totalEmployees} employees',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              _buildStatusBadge(),
            ],
          ),

          SizedBox(height: TossSpacing.space5),

          // Total payment (hero number)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              children: [
                Text(
                  'Total Payroll',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                    fontWeight: TossFontWeight.medium,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Text(
                  summary.totalPaymentFormatted,
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: TossColors.gray900,
                    height: 1.1,
                  ),
                ),
                if (summary.totalWarningAmount > 0) ...[
                  SizedBox(height: TossSpacing.space2),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2_5, vertical: TossSpacing.space1),
                    decoration: BoxDecoration(
                      color: TossColors.redLight,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Text(
                      '⚠️ ${summary.totalWarningAmountFormatted} needs review',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: TossFontWeight.medium,
                        color: TossColors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: TossSpacing.space4),

          // Filter hint
          if (onFilterChanged != null)
            Padding(
              padding: EdgeInsets.only(bottom: TossSpacing.space2),
              child: Text(
                activeFilter == SalaryFilter.all
                    ? 'Tap to filter employees'
                    : 'Tap again to clear filter',
                style: TossTextStyles.labelSmall.copyWith(
                  color: TossColors.gray400,
                ),
              ),
            ),

          // Clickable filter chips
          Row(
            children: [
              _buildFilterChip(
                icon: LucideIcons.alertTriangle,
                value: '${summary.employeesWithWarnings}',
                label: 'Warnings',
                color: TossColors.red,
                filter: SalaryFilter.withWarnings,
                isActive: activeFilter == SalaryFilter.withWarnings,
              ),
              SizedBox(width: TossSpacing.space2),
              _buildFilterChip(
                icon: LucideIcons.checkCircle,
                value: '${summary.totalEmployees - summary.employeesWithWarnings}',
                label: 'Clean',
                color: TossColors.emerald,
                filter: SalaryFilter.noWarnings,
                isActive: activeFilter == SalaryFilter.noWarnings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final color = _getStatusColor();
    final text = _getStatusText();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: TossOpacity.light),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        text,
        style: TossTextStyles.labelSmall.copyWith(
          fontWeight: TossFontWeight.semibold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required SalaryFilter filter,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onFilterChanged != null
            ? () {
                if (isActive) {
                  onFilterChanged!(SalaryFilter.all);
                } else {
                  onFilterChanged!(filter);
                }
              }
            : null,
        child: AnimatedContainer(
          duration: TossAnimations.normal,
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2_5),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: TossOpacity.medium) : color.withValues(alpha: TossOpacity.subtle),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: isActive ? color : color.withValues(alpha: TossOpacity.strong),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: TossSpacing.iconXS2, color: color),
              SizedBox(width: TossSpacing.space1_5),
              Text(
                value,
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (summary.payrollStatus) {
      case 'critical':
        return TossColors.red;
      case 'warning':
        return TossColors.amber;
      case 'normal':
      default:
        return TossColors.emerald;
    }
  }

  IconData _getStatusIcon() {
    switch (summary.payrollStatus) {
      case 'critical':
        return LucideIcons.alertOctagon;
      case 'warning':
        return LucideIcons.alertTriangle;
      case 'normal':
      default:
        return LucideIcons.checkCircle;
    }
  }

  String _getStatusText() {
    switch (summary.payrollStatus) {
      case 'critical':
        return 'Critical';
      case 'warning':
        return 'Warning';
      case 'normal':
      default:
        return 'Normal';
    }
  }
}
