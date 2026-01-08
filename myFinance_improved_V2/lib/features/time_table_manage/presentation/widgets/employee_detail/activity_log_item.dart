import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/employee_monthly_detail.dart';

/// Activity log item widget for Recent Activity section
class ActivityLogItem extends StatelessWidget {
  final EmployeeAuditLog log;

  const ActivityLogItem({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: TossDimensions.timelineDateCircle,
            height: TossDimensions.timelineDateCircle,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getActionColor().withValues(alpha: TossOpacity.light),
            ),
            child: Icon(
              _getActionIcon(),
              size: TossSpacing.iconSM,
              color: _getActionColor(),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.actionType.label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
                const SizedBox(height: TossSpacing.space0_5),
                Text.rich(
                  TextSpan(
                    children: [
                      if (log.storeName != null) ...[
                        TextSpan(
                          text: log.storeName,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: ' · ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                      ],
                      if (log.workDate != null) ...[
                        TextSpan(
                          text: _formatWorkDate(log.workDate!),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: ' · ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                      ],
                      TextSpan(
                        text: log.changedByName ?? 'System',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            log.relativeTime,
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatWorkDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  IconData _getActionIcon() {
    switch (log.actionType) {
      case AuditActionType.scheduleCreated:
        return Icons.add_circle_outline;
      case AuditActionType.scheduleDeleted:
        return Icons.remove_circle_outline;
      case AuditActionType.approvalChanged:
        return Icons.check_circle_outline;
      case AuditActionType.checkIn:
        return Icons.login;
      case AuditActionType.checkOut:
        return Icons.logout;
      case AuditActionType.timeConfirmed:
        return Icons.schedule;
      case AuditActionType.problemResolved:
        return Icons.build_circle_outlined;
      case AuditActionType.reportResolved:
        return Icons.report_off_outlined;
      case AuditActionType.bonusUpdated:
        return Icons.attach_money;
      case AuditActionType.memoAdded:
        return Icons.note_add_outlined;
      case AuditActionType.updated:
        return Icons.edit_outlined;
    }
  }

  Color _getActionColor() {
    switch (log.actionType) {
      case AuditActionType.scheduleCreated:
        return TossColors.primary;
      case AuditActionType.scheduleDeleted:
        return TossColors.error;
      case AuditActionType.approvalChanged:
        return TossColors.success;
      case AuditActionType.checkIn:
        return TossColors.success;
      case AuditActionType.checkOut:
        return TossColors.primary;
      case AuditActionType.timeConfirmed:
        return TossColors.success;
      case AuditActionType.problemResolved:
        return TossColors.warning;
      case AuditActionType.reportResolved:
        return TossColors.warning;
      case AuditActionType.bonusUpdated:
        return TossColors.success;
      case AuditActionType.memoAdded:
        return TossColors.gray600;
      case AuditActionType.updated:
        return TossColors.gray600;
    }
  }
}
