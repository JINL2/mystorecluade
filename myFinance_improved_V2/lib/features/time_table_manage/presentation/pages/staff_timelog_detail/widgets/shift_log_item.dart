import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/shift_audit_log.dart';

/// Shift Log Item Widget
///
/// Displays a single audit log entry in a timeline format.
/// Shows: event icon, event description, who made the change, when, and details.
class ShiftLogItem extends StatelessWidget {
  final ShiftAuditLog log;
  final bool isLast;

  const ShiftLogItem({
    super.key,
    required this.log,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getEventConfig(log.eventType);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Timeline indicator (circle + line)
          _buildTimelineIndicator(config.color),
          const SizedBox(width: TossSpacing.space3),

          // Right side: Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : TossSpacing.space4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Event name + relative time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          config.title,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        _formatRelativeTime(log.changedAt),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                    ],
                  ),

                  // Changed by info
                  if (log.changedByName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'by ${log.changedByName}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],

                  // Detail content based on event type
                  ..._buildDetailContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the timeline indicator (circle + vertical line)
  Widget _buildTimelineIndicator(Color color) {
    return SizedBox(
      width: 24,
      child: Column(
        children: [
          // Circle indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
            ),
            child: Icon(
              _getEventConfig(log.eventType).icon,
              size: 14,
              color: color,
            ),
          ),

          // Vertical line (if not last item)
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                color: TossColors.gray200,
              ),
            ),
        ],
      ),
    );
  }

  /// Build detail content based on event type
  List<Widget> _buildDetailContent() {
    final List<Widget> details = [];

    // Report reason (for shift_reported event)
    final reportReason = log.reportReason;
    if (reportReason != null && reportReason.isNotEmpty) {
      details.add(const SizedBox(height: TossSpacing.space2));
      details.add(
        Container(
          padding: const EdgeInsets.all(TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '"$reportReason"',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray700,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    // Manager memo (for manager edit events)
    final memo = log.managerMemo;
    if (memo != null && memo.isNotEmpty) {
      details.add(const SizedBox(height: TossSpacing.space2));
      details.add(
        Row(
          children: [
            const Icon(
              Icons.note_outlined,
              size: 14,
              color: TossColors.gray500,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Memo: "$memo"',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Bonus change
    final bonusChange = log.bonusChange;
    if (bonusChange != null) {
      final formatter = NumberFormat('#,###');
      details.add(const SizedBox(height: TossSpacing.space2));
      details.add(
        Row(
          children: [
            Icon(
              bonusChange.isIncrease ? Icons.add_circle_outline : Icons.remove_circle_outline,
              size: 14,
              color: bonusChange.isIncrease ? TossColors.success : TossColors.error,
            ),
            const SizedBox(width: 4),
            Text(
              'Bonus: ${formatter.format(bonusChange.from)} → ${formatter.format(bonusChange.to)}',
              style: TossTextStyles.caption.copyWith(
                color: bonusChange.isIncrease ? TossColors.success : TossColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Time changes
    final startTimeChange = log.confirmStartTimeChange;
    if (startTimeChange != null && startTimeChange.hasChange) {
      details.add(const SizedBox(height: TossSpacing.space2));
      details.add(
        _buildTimeChangeRow(
          'Check-in',
          _formatTimeValue(startTimeChange.from),
          _formatTimeValue(startTimeChange.to),
        ),
      );
    }

    final endTimeChange = log.confirmEndTimeChange;
    if (endTimeChange != null && endTimeChange.hasChange) {
      details.add(const SizedBox(height: TossSpacing.space2));
      details.add(
        _buildTimeChangeRow(
          'Check-out',
          _formatTimeValue(endTimeChange.from),
          _formatTimeValue(endTimeChange.to),
        ),
      );
    }

    return details;
  }

  Widget _buildTimeChangeRow(String label, String from, String to) {
    return Row(
      children: [
        const Icon(
          Icons.schedule_outlined,
          size: 14,
          color: TossColors.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $from → $to',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Format time value from UTC string to readable time
  String _formatTimeValue(String? value) {
    if (value == null || value.isEmpty) return '--:--';

    try {
      final dateTime = DateTime.parse(value).toLocal();
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      // If parsing fails, try to extract time from the string
      if (value.contains('T')) {
        final timePart = value.split('T').last;
        if (timePart.length >= 5) {
          return timePart.substring(0, 5);
        }
      }
      return value.length > 5 ? value.substring(0, 5) : value;
    }
  }

  /// Format relative time (e.g., "2h ago", "3d ago")
  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  /// Get event configuration (icon, color, title) based on event type
  _EventConfig _getEventConfig(String eventType) {
    switch (eventType) {
      case 'shift_requested':
        return const _EventConfig(
          icon: Icons.schedule_outlined,
          color: TossColors.gray600,
          title: 'Shift requested',
        );
      case 'shift_approved':
        return const _EventConfig(
          icon: Icons.check_circle_outline,
          color: TossColors.success,
          title: 'Shift approved',
        );
      case 'employee_checked_in':
        return const _EventConfig(
          icon: Icons.login_outlined,
          color: TossColors.success,
          title: 'Checked in',
        );
      case 'employee_late':
        return const _EventConfig(
          icon: Icons.warning_amber_outlined,
          color: TossColors.warning,
          title: 'Checked in late',
        );
      case 'employee_checked_out':
        return const _EventConfig(
          icon: Icons.logout_outlined,
          color: TossColors.primary,
          title: 'Checked out',
        );
      case 'employee_overtime':
        return const _EventConfig(
          icon: Icons.timer_outlined,
          color: TossColors.warning,
          title: 'Overtime recorded',
        );
      case 'employee_early_leave':
        return const _EventConfig(
          icon: Icons.exit_to_app_outlined,
          color: TossColors.warning,
          title: 'Early leave',
        );
      case 'shift_reported':
        return const _EventConfig(
          icon: Icons.report_outlined,
          color: TossColors.warning,
          title: 'Issue reported',
        );
      case 'shift_report_solved':
        return const _EventConfig(
          icon: Icons.task_alt_outlined,
          color: TossColors.success,
          title: 'Report resolved',
        );
      case 'shift_manager_edited':
        return const _EventConfig(
          icon: Icons.edit_outlined,
          color: TossColors.primary,
          title: 'Manager edited',
        );
      case 'shift_problem_solved':
        return const _EventConfig(
          icon: Icons.verified_outlined,
          color: TossColors.success,
          title: 'Problem resolved',
        );
      case 'shift_updated':
        return const _EventConfig(
          icon: Icons.update_outlined,
          color: TossColors.gray500,
          title: 'Shift updated',
        );
      case 'shift_cancelled':
        return const _EventConfig(
          icon: Icons.cancel_outlined,
          color: TossColors.error,
          title: 'Shift cancelled',
        );
      case 'shift_deleted':
        return const _EventConfig(
          icon: Icons.delete_outlined,
          color: TossColors.error,
          title: 'Shift deleted',
        );
      default:
        return _EventConfig(
          icon: Icons.info_outline,
          color: TossColors.gray500,
          title: log.eventDescription,
        );
    }
  }
}

/// Event configuration for display
class _EventConfig {
  final IconData icon;
  final Color color;
  final String title;

  const _EventConfig({
    required this.icon,
    required this.color,
    required this.title,
  });
}
