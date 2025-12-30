import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'date_attention_summary.dart';
import 'dot_indicator.dart';

/// Single date column in the timeline
class TimelineDate extends StatelessWidget {
  final DateTime date;
  final DateAttentionSummary? summary;
  final bool isToday;
  final VoidCallback? onDateTap;
  final VoidCallback? onScheduleTap;
  final VoidCallback? onProblemTap;

  const TimelineDate({
    super.key,
    required this.date,
    this.summary,
    required this.isToday,
    this.onDateTap,
    this.onScheduleTap,
    this.onProblemTap,
  });

  String _formatDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = summary != null && summary!.hasItems;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Day name (Thu, Fri, ...)
        Text(
          _formatDayName(date),
          style: TossTextStyles.labelSmall.copyWith(
            color: isToday ? TossColors.primary : TossColors.gray500,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),

        // Day number (tappable)
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            width: 32,
            height: 32,
            decoration: isToday
                ? BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  )
                : null,
            alignment: Alignment.center,
            child: Text(
              '${date.day}',
              style: TossTextStyles.body.copyWith(
                color: isToday ? TossColors.primary : TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Vertical line
        Container(
          width: 1,
          height: 16,
          color: hasItems ? TossColors.gray300 : TossColors.gray200,
        ),

        const SizedBox(height: 4),

        // Dots row - Fixed height container for consistent alignment
        SizedBox(
          height: 32, // Fixed height: dots(8) + spacing(4) + text(~18) + padding
          child: hasItems
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Orange dots (schedule issues: empty/understaffed)
                        if (summary!.scheduleCount > 0)
                          GestureDetector(
                            onTap: onScheduleTap,
                            child: DotIndicator(
                              color: TossColors.warning,
                              count: summary!.scheduleCount,
                            ),
                          ),

                        if (summary!.scheduleCount > 0 &&
                            summary!.problemCount > 0)
                          const SizedBox(width: 4),

                        // Red dots (problems)
                        if (summary!.problemCount > 0)
                          GestureDetector(
                            onTap: onProblemTap,
                            child: DotIndicator(
                              color: TossColors.error,
                              count: summary!.problemCount,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Total count
                    Text(
                      '(${summary!.totalCount})',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                )
              : null, // Empty - just takes up fixed height
        ),
      ],
    );
  }
}
