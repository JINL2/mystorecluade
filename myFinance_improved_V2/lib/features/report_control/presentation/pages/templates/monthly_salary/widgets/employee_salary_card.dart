// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/employee_salary_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
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
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: hasWarnings ? TossColors.redLighter : TossColors.gray100,
        ),
      ),
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: hasWarnings
                ? () => setState(() => _isExpanded = !_isExpanded)
                : null,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  // Employee name row
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: TossDimensions.avatarLG,
                        height: TossDimensions.avatarLG,
                        decoration: BoxDecoration(
                          color: hasWarnings
                              ? TossColors.redLight
                              : TossColors.gray100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            employee.employeeName.isNotEmpty
                                ? employee.employeeName[0].toUpperCase()
                                : '?',
                            style: TossTextStyles.titleMedium.copyWith(
                              fontWeight: TossFontWeight.semibold,
                              color: hasWarnings
                                  ? TossColors.red
                                  : TossColors.gray600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: TossSpacing.space3),
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
                                    style: TossTextStyles.body.copyWith(
                                      fontWeight: TossFontWeight.semibold,
                                      color: TossColors.gray900,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (employee.isManager) ...[
                                  SizedBox(width: TossSpacing.space1_5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: TossSpacing.badgePaddingHorizontalXS,
                                      vertical: TossSpacing.badgePaddingVerticalXS,
                                    ),
                                    decoration: BoxDecoration(
                                      color: TossColors.purpleLight,
                                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                    ),
                                    child: Text(
                                      'Manager',
                                      style: TossTextStyles.labelSmall.copyWith(
                                        fontWeight: TossFontWeight.semibold,
                                        color: TossColors.purple,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: TossSpacing.space0_5),
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
                            style: TossTextStyles.body.copyWith(
                              fontWeight: TossFontWeight.bold,
                              color: TossColors.gray900,
                            ),
                          ),
                          if (hasWarnings) ...[
                            SizedBox(height: TossSpacing.space0_5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.alertTriangle,
                                  size: TossSpacing.iconXS2,
                                  color: TossColors.red,
                                ),
                                SizedBox(width: TossSpacing.space1),
                                Text(
                                  '${employee.warningCount}',
                                  style: TossTextStyles.bodySmall.copyWith(
                                    fontWeight: TossFontWeight.semibold,
                                    color: TossColors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      if (hasWarnings) ...[
                        SizedBox(width: TossSpacing.space2),
                        Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: TossSpacing.iconMD,
                          color: TossColors.gray400,
                        ),
                      ],
                    ],
                  ),

                  // Hours and shifts info
                  SizedBox(height: TossSpacing.space3),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: LucideIcons.clock,
                        value: '${employee.salary.totalHours.toStringAsFixed(1)}h',
                      ),
                      SizedBox(width: TossSpacing.space2),
                      _buildInfoChip(
                        icon: LucideIcons.calendarDays,
                        value: '${employee.salary.shiftCount} shifts',
                      ),
                      if (employee.salary.bonus > 0) ...[
                        SizedBox(width: TossSpacing.space2),
                        _buildInfoChip(
                          icon: LucideIcons.gift,
                          value: '+${_formatAmount(employee.salary.bonus)}',
                          color: TossColors.emerald,
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
              duration: TossAnimations.normal,
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
            size: TossSpacing.iconXS2,
            color: TossColors.amber,
          ),
          SizedBox(width: TossSpacing.space1),
          Text(
            'No bank info',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.amber,
              fontWeight: TossFontWeight.medium,
            ),
          ),
        ],
      );
    }

    return Text(
      '${bankInfo.bankName ?? ''} ${bankInfo.accountNumber != null ? '•••${bankInfo.accountNumber!.substring(bankInfo.accountNumber!.length > 4 ? bankInfo.accountNumber!.length - 4 : 0)}' : ''}',
      style: TossTextStyles.bodySmall.copyWith(
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
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: TossSpacing.iconXS2, color: chipColor),
          SizedBox(width: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.labelSmall.copyWith(
              fontWeight: TossFontWeight.medium,
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
        color: TossColors.redSurface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(TossBorderRadius.lg),
          bottomRight: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      child: Column(
        children: [
          const Divider(height: 1, color: TossColors.redLighter),
          Padding(
            padding: EdgeInsets.all(TossSpacing.space3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning header
                Row(
                  children: [
                    const Icon(
                      LucideIcons.alertTriangle,
                      size: TossSpacing.iconXS,
                      color: TossColors.red,
                    ),
                    SizedBox(width: TossSpacing.space1_5),
                    Text(
                      '${employee.warningCount} warnings • ${employee.warningTotalFormatted}',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.red,
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
                          color: TossColors.amberLight,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          'Self-approved',
                          style: TossTextStyles.labelSmall.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: TossColors.amberDark,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: TossSpacing.space2_5),

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
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: warning.selfApproved
              ? TossColors.yellowLight
              : TossColors.redLighter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and amount row
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.badgePaddingHorizontalXS, vertical: TossSpacing.badgePaddingVerticalXS),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  warning.date,
                  style: TossTextStyles.labelSmall.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.gray700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                warning.amountFormatted,
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: TossColors.red,
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space1_5),

          // Message
          Text(
            warning.message,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray700,
            ),
          ),

          SizedBox(height: TossSpacing.space1),

          // Approved by
          Row(
            children: [
              Icon(
                warning.selfApproved ? LucideIcons.alertCircle : LucideIcons.user,
                size: TossSpacing.iconXS2,
                color: warning.selfApproved
                    ? TossColors.amberDark
                    : TossColors.gray500,
              ),
              SizedBox(width: TossSpacing.space1),
              Text(
                warning.approvedBy,
                style: TossTextStyles.labelSmall.copyWith(
                  color: warning.selfApproved
                      ? TossColors.amberDark
                      : TossColors.gray500,
                  fontWeight: warning.selfApproved ? TossFontWeight.semibold : TossFontWeight.regular,
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
