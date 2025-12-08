// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/employee_salary_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../domain/entities/monthly_salary_report.dart';

/// Employee Salary Card
///
/// Expandable card showing:
/// - Employee name & total payment
/// - Warning badge (if any)
/// - Bank info
/// - Warning details when expanded
class EmployeeSalaryCard extends StatefulWidget {
  final SalaryEmployee employee;
  final bool initiallyExpanded;

  const EmployeeSalaryCard({
    super.key,
    required this.employee,
    this.initiallyExpanded = false,
  });

  @override
  State<EmployeeSalaryCard> createState() => _EmployeeSalaryCardState();
}

class _EmployeeSalaryCardState extends State<EmployeeSalaryCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;
    final hasWarnings = employee.hasWarnings && employee.warnings.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasWarnings ? const Color(0xFFFECACA) : TossColors.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: hasWarnings
                ? () => setState(() => _isExpanded = !_isExpanded)
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Employee name row
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: hasWarnings
                              ? const Color(0xFFFEE2E2)
                              : TossColors.gray100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            employee.employeeName.isNotEmpty
                                ? employee.employeeName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: hasWarnings
                                  ? const Color(0xFFDC2626)
                                  : TossColors.gray600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Name and bank
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    employee.employeeName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: TossColors.gray900,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (employee.isManager) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Manager',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF7C3AED),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            _buildBankInfo(),
                          ],
                        ),
                      ),
                      // Payment amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            employee.salary.totalPaymentFormatted,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: TossColors.gray900,
                            ),
                          ),
                          if (hasWarnings) ...[
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.alertTriangle,
                                  size: 12,
                                  color: Color(0xFFDC2626),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${employee.warningCount}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      if (hasWarnings) ...[
                        const SizedBox(width: 8),
                        Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: 20,
                          color: TossColors.gray400,
                        ),
                      ],
                    ],
                  ),

                  // Hours and shifts info
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: LucideIcons.clock,
                        value: '${employee.salary.totalHours.toStringAsFixed(1)}h',
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: LucideIcons.calendarDays,
                        value: '${employee.salary.shiftCount} shifts',
                      ),
                      if (employee.salary.bonus > 0) ...[
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          icon: LucideIcons.gift,
                          value: '+${_formatAmount(employee.salary.bonus)}',
                          color: const Color(0xFF10B981),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expandable warnings section
          if (hasWarnings)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: const SizedBox.shrink(),
              secondChild: _buildWarningsSection(),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
        ],
      ),
    );
  }

  Widget _buildBankInfo() {
    final bankInfo = widget.employee.bankInfo;
    if (bankInfo == null ||
        (bankInfo.bankName == null && bankInfo.accountNumber == null)) {
      return Row(
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 12,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 4),
          const Text(
            'No bank info',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFF59E0B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Text(
      '${bankInfo.bankName ?? ''} ${bankInfo.accountNumber != null ? '•••${bankInfo.accountNumber!.substring(bankInfo.accountNumber!.length > 4 ? bankInfo.accountNumber!.length - 4 : 0)}' : ''}',
      style: const TextStyle(
        fontSize: 12,
        color: TossColors.gray500,
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String value,
    Color? color,
  }) {
    final chipColor = color ?? TossColors.gray500;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningsSection() {
    final employee = widget.employee;
    final hasSelfApproved = employee.warnings.any((w) => w.selfApproved);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFEF2F2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFFECACA)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning header
                Row(
                  children: [
                    const Icon(
                      LucideIcons.alertTriangle,
                      size: 14,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${employee.warningCount} warnings • ${employee.warningTotalFormatted}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    if (hasSelfApproved) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Self-approved',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 10),

                // Warning list
                ...employee.warnings.map((warning) => _buildWarningItem(warning)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(SalaryWarning warning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: warning.selfApproved
              ? const Color(0xFFFDE68A)
              : const Color(0xFFFECACA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and amount row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  warning.date,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                warning.amountFormatted,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Message
          Text(
            warning.message,
            style: const TextStyle(
              fontSize: 12,
              color: TossColors.gray700,
            ),
          ),

          const SizedBox(height: 4),

          // Approved by
          Row(
            children: [
              Icon(
                warning.selfApproved ? LucideIcons.alertCircle : LucideIcons.user,
                size: 12,
                color: warning.selfApproved
                    ? const Color(0xFFD97706)
                    : TossColors.gray500,
              ),
              const SizedBox(width: 4),
              Text(
                warning.approvedBy,
                style: TextStyle(
                  fontSize: 11,
                  color: warning.selfApproved
                      ? const Color(0xFFD97706)
                      : TossColors.gray500,
                  fontWeight: warning.selfApproved ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M ₫';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K ₫';
    }
    return '${amount.toStringAsFixed(0)} ₫';
  }
}
