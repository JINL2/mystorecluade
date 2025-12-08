// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/salary_hero_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TossColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with status
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getStatusIcon(),
                  size: 20,
                  color: _getStatusColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Payroll',
                      style: TextStyle(
                        fontSize: 12,
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${summary.totalEmployees} employees',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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

          const SizedBox(height: 20),

          // Total payment (hero number)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Payroll',
                  style: TextStyle(
                    fontSize: 12,
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  summary.totalPaymentFormatted,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                    height: 1.1,
                  ),
                ),
                if (summary.totalWarningAmount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⚠️ ${summary.totalWarningAmountFormatted} needs review',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Filter hint
          if (onFilterChanged != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                activeFilter == SalaryFilter.all
                    ? 'Tap to filter employees'
                    : 'Tap again to clear filter',
                style: const TextStyle(
                  fontSize: 11,
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
                color: const Color(0xFFDC2626),
                filter: SalaryFilter.withWarnings,
                isActive: activeFilter == SalaryFilter.withWarnings,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                icon: LucideIcons.checkCircle,
                value: '${summary.totalEmployees - summary.employeesWithWarnings}',
                label: 'Clean',
                color: const Color(0xFF10B981),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? color : color.withValues(alpha: 0.2),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
        return const Color(0xFFDC2626);
      case 'warning':
        return const Color(0xFFF59E0B);
      case 'normal':
      default:
        return const Color(0xFF10B981);
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
