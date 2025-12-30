import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/shift_card.dart';
import 'activity_item.dart';

/// Activity log section widget - expandable list of shift activities
class ActivityLogSection extends StatefulWidget {
  final ShiftCard shift;
  final bool initiallyExpanded;

  const ActivityLogSection({
    super.key,
    required this.shift,
    this.initiallyExpanded = false,
  });

  @override
  State<ActivityLogSection> createState() => _ActivityLogSectionState();
}

class _ActivityLogSectionState extends State<ActivityLogSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  List<ActivityItem> _buildActivities() {
    final activities = <ActivityItem>[];

    if (widget.shift.actualStartTime != null) {
      activities.add(ActivityItem(
        icon: Icons.login,
        color: TossColors.success,
        label: 'Check-in',
        time: widget.shift.actualStartTime!,
      ));
    }

    if (widget.shift.actualEndTime != null) {
      activities.add(ActivityItem(
        icon: Icons.logout,
        color: TossColors.primary,
        label: 'Check-out',
        time: widget.shift.actualEndTime!,
      ));
    }

    final reportedAt = widget.shift.problemDetails?.reportedProblem?.reportedAt;
    if (reportedAt != null) {
      activities.add(ActivityItem(
        icon: Icons.report_outlined,
        color: TossColors.warning,
        label: 'Report submitted',
        time: reportedAt,
      ));
    }

    for (final memo in widget.shift.managerMemos) {
      if (memo.createdAt != null) {
        activities.add(ActivityItem(
          icon: Icons.comment_outlined,
          color: TossColors.primary,
          label: 'Manager response',
          time: memo.createdAt!,
        ));
      }
    }

    return activities;
  }

  Widget _buildActivityItemWidget(ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activity.color.withValues(alpha: 0.1),
            ),
            child: Icon(
              activity.icon,
              size: 14,
              color: activity.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.time,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = _buildActivities();

    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Activity',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${activities.length}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: TossColors.gray500,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          ...activities.map((activity) => _buildActivityItemWidget(activity)),
        ],
      ],
    );
  }
}
