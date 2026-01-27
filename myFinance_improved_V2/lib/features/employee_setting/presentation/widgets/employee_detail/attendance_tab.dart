import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/utils/number_formatter.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../domain/entities/employee_salary.dart';
import '../../../domain/entities/shift_audit_log.dart';
import '../../providers/employee_providers.dart';

class AttendanceTab extends ConsumerWidget {
  final EmployeeSalary employee;

  const AttendanceTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    // Watch audit logs provider
    final auditLogsAsync = ref.watch(
      employeeShiftAuditLogsProvider(
        EmployeeAuditLogParams(
          employeeUserId: employee.userId,
          companyId: companyId,
          limit: 20,
          offset: 0,
        ),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Month Summary
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Month Summary',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                // First Row - Working Days and Hours
                Row(
                  children: [
                    Expanded(
                      child: _buildAttendanceMetric(
                        'Working Days',
                        '${employee.totalWorkingDay ?? 0}',
                        Icons.calendar_today,
                        TossColors.gray900,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: _buildAttendanceMetric(
                        'Working Hours',
                        '${employee.totalWorkingHour?.toStringAsFixed(1) ?? "0.0"}h',
                        Icons.access_time,
                        TossColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

          // Attendance Details
          Text(
            'Attendance Details',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          _buildDetailRow('Month', employee.month ?? 'Current'),
          _buildDetailRow(
            'Total Working Days',
            '${employee.totalWorkingDay ?? 0} days',
          ),
          _buildDetailRow(
            'Total Working Hours',
            '${employee.totalWorkingHour?.toStringAsFixed(2) ?? "0.00"} hours',
          ),
          _buildDetailRow(
            'Total Salary Earned',
            '${employee.symbol}${employee.totalSalary != null ? NumberFormatter.formatCurrencyDecimal(employee.totalSalary!, "") : "0.00"}',
          ),

          if (employee.totalWorkingDay != null &&
              employee.totalWorkingDay! > 0) ...[
            const SizedBox(height: TossSpacing.space4),
            _buildDetailRow(
              'Average Hours/Day',
              '${((employee.totalWorkingHour ?? 0) / employee.totalWorkingDay!).toStringAsFixed(1)} hours',
            ),
          ],

          const SizedBox(height: TossSpacing.space6),

          // Recent Activity Section
          Text(
            'Recent Activity',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Audit Logs List
          auditLogsAsync.when(
            data: (result) {
              final logs = result.logs;
              final pagination = result.pagination;

              if (logs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history,
                        color: TossColors.gray400,
                        size: TossSpacing.iconMD,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        'No recent activity recorded',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  ...logs.map((log) => _buildAuditLogItem(log)),
                  if (pagination.hasMore)
                    Padding(
                      padding: const EdgeInsets.only(top: TossSpacing.space2),
                      child: Text(
                        '${pagination.totalCount - logs.length} more activities...',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: TossLoadingView.inline(size: TossSpacing.iconLG),
            ),
            error: (error, _) => Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.errorLight,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: TossColors.error,
                    size: TossSpacing.iconMD,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Failed to load activity',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space6),

          // Performance Note
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: TossColors.gray600,
                  size: TossSpacing.iconMD,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Attendance data is updated monthly and reflects actual working hours recorded.',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLogItem(ShiftAuditLog log) {
    // Get icon based on action type
    IconData icon;
    Color iconColor;

    switch (log.actionType.toUpperCase()) {
      case 'CHECKIN':
        icon = Icons.login;
        iconColor = TossColors.success;
        break;
      case 'CHECKOUT':
        icon = Icons.logout;
        iconColor = TossColors.primary;
        break;
      case 'MANAGER_EDIT':
        icon = Icons.edit;
        iconColor = TossColors.warning;
        break;
      case 'REPORT_SOLVED':
        icon = Icons.check_circle;
        iconColor = TossColors.success;
        break;
      default:
        icon = Icons.history;
        iconColor = TossColors.gray500;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: TossDimensions.avatarMD2,
            height: TossDimensions.avatarMD2,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(
              icon,
              size: TossSpacing.iconSM2,
              color: iconColor,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      log.actionTypeText,
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    if (log.storeName != null) ...[
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        '@ ${log.storeName}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: TossSpacing.space0_5),
                Text(
                  log.relativeTimeText,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceMetric(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: InfoRow.between(
        label: label,
        value: value,
      ),
    );
  }
}
