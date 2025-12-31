import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/attention_item_data.dart';
import 'timeline/date_attention_summary.dart';
import 'timeline/legend_item.dart';
import 'timeline/navigation_button.dart';
import 'timeline/timeline_date.dart';

// Re-export for backwards compatibility
export 'timeline/date_attention_summary.dart';

/// Attention Timeline Widget
///
/// Displays a 5-day timeline showing attention items grouped by date.
/// - Schedule dots: Empty/Understaffed shifts (tap → Schedule tab)
///   - Red: At least one shift has 0 employees
///   - Orange: All shifts have ≥1 but understaffed
/// - Red dots: Staff problems (tap → Problems tab)
class AttentionTimeline extends StatelessWidget {
  /// All attention items (will be grouped by date internally)
  final List<AttentionItemData> items;

  /// Center date of the timeline (usually today)
  final DateTime centerDate;

  /// Number of days to show (default: 5)
  final int visibleDays;

  /// Pre-computed problem shift count (from problemStatusProvider)
  /// If provided, uses this instead of recalculating from items
  final int? precomputedProblemCount;

  /// Callback when a schedule dot (empty/understaffed) is tapped
  final void Function(DateTime date)? onScheduleTap;

  /// Callback when a red dot (problem) is tapped
  final void Function(DateTime date)? onProblemTap;

  /// Callback when a date circle is tapped (navigates to appropriate tab)
  final void Function(DateTime date, bool hasProblem)? onDateTap;

  /// Callback to navigate to previous period
  final VoidCallback? onPrevious;

  /// Callback to navigate to next period
  final VoidCallback? onNext;

  const AttentionTimeline({
    super.key,
    required this.items,
    required this.centerDate,
    this.visibleDays = 5,
    this.precomputedProblemCount,
    this.onScheduleTap,
    this.onProblemTap,
    this.onDateTap,
    this.onPrevious,
    this.onNext,
  });

  /// Group items by date and calculate summaries
  ///
  /// IMPORTANT: problemCount is calculated per SHIFT (using shiftRequestId),
  /// not per individual problem item. This ensures consistency with Problems tab.
  /// e.g., 1 shift with Late + Reported = 1 problem (not 2)
  Map<DateTime, DateAttentionSummary> _groupItemsByDate() {
    final Map<DateTime, List<AttentionItemData>> grouped = {};

    for (final item in items) {
      if (item.shiftDate == null) continue;
      final normalizedDate = DateTime(
        item.shiftDate!.year,
        item.shiftDate!.month,
        item.shiftDate!.day,
      );
      grouped.putIfAbsent(normalizedDate, () => []).add(item);
    }

    final Map<DateTime, DateAttentionSummary> summaries = {};
    for (final entry in grouped.entries) {
      // Schedule issues (shift-level): empty or understaffed shifts
      final scheduleCount =
          entry.value.where((item) => item.isShiftProblem).length;

      // Count problems per SHIFT (not per problem item)
      // Use shiftRequestId to deduplicate - 1 shift = 1 problem unit
      final uniqueProblemShifts = entry.value
          .where((item) => !item.isShiftProblem && item.shiftRequestId != null)
          .map((item) => item.shiftRequestId!)
          .toSet();
      final problemCount = uniqueProblemShifts.length;

      summaries[entry.key] = DateAttentionSummary(
        date: entry.key,
        scheduleCount: scheduleCount,
        problemCount: problemCount,
        items: entry.value,
      );
    }

    return summaries;
  }

  /// Get dates to display (centered around centerDate)
  List<DateTime> _getVisibleDates() {
    final List<DateTime> dates = [];
    final halfDays = visibleDays ~/ 2;

    for (int i = -halfDays; i <= halfDays; i++) {
      dates.add(DateTime(
        centerDate.year,
        centerDate.month,
        centerDate.day + i,
      ));
    }

    return dates;
  }

  /// Count items before visible range (shift-based for problems)
  int _countItemsBefore(
    Map<DateTime, DateAttentionSummary> summaries,
    DateTime firstVisible,
  ) {
    int count = 0;
    for (final entry in summaries.entries) {
      if (entry.key.isBefore(firstVisible)) {
        // scheduleCount + problemCount (already shift-based from _groupItemsByDate)
        count += entry.value.scheduleCount + entry.value.problemCount;
      }
    }
    return count;
  }

  /// Count items after visible range (shift-based for problems)
  int _countItemsAfter(
    Map<DateTime, DateAttentionSummary> summaries,
    DateTime lastVisible,
  ) {
    int count = 0;
    for (final entry in summaries.entries) {
      if (entry.key.isAfter(lastVisible)) {
        // scheduleCount + problemCount (already shift-based from _groupItemsByDate)
        count += entry.value.scheduleCount + entry.value.problemCount;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final summaries = _groupItemsByDate();
    final visibleDates = _getVisibleDates();

    // Calculate total schedule issues count (empty/understaffed shifts)
    final totalSchedule = items.where((item) => item.isShiftProblem).length;

    // Total problems: use precomputed count if available (from problemStatusProvider)
    // Otherwise calculate per SHIFT (using shiftRequestId) - 1 shift = 1 unit
    final int totalProblem;
    if (precomputedProblemCount != null) {
      totalProblem = precomputedProblemCount!;
    } else {
      final uniqueProblemShifts = items
          .where((item) => !item.isShiftProblem && item.shiftRequestId != null)
          .map((item) => item.shiftRequestId!)
          .toSet();
      totalProblem = uniqueProblemShifts.length;
    }

    final beforeCount = _countItemsBefore(summaries, visibleDates.first);
    final afterCount = _countItemsAfter(summaries, visibleDates.last);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with split badges (schedule issues + problems)
        _buildHeader(totalSchedule, totalProblem),

        const SizedBox(height: TossSpacing.space4),

        // Timeline row with navigation
        Row(
          children: [
            // Previous button
            NavigationButton(
              count: beforeCount,
              direction: NavigationDirection.previous,
              onTap: beforeCount > 0 ? onPrevious : null,
            ),

            // Timeline dates
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: visibleDates.map((date) {
                  final summary = summaries[date];
                  final hasProblem = summary != null && summary.problemCount > 0;
                  return TimelineDate(
                    date: date,
                    summary: summary,
                    isToday: _isSameDay(date, DateTime.now()),
                    onDateTap: () => onDateTap?.call(date, hasProblem),
                    onScheduleTap: summary != null && summary.scheduleCount > 0
                        ? () => onScheduleTap?.call(date)
                        : null,
                    onProblemTap: hasProblem
                        ? () => onProblemTap?.call(date)
                        : null,
                  );
                }).toList(),
              ),
            ),

            // Next button
            NavigationButton(
              count: afterCount,
              direction: NavigationDirection.next,
              onTap: afterCount > 0 ? onNext : null,
            ),
          ],
        ),

        const SizedBox(height: TossSpacing.space3),

        // Legend
        _buildLegend(),
      ],
    );
  }

  Widget _buildHeader(int totalSchedule, int totalProblem) {
    return Row(
      children: [
        Text(
          'Need Attention',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Orange badge for schedule issues (empty/understaffed)
        if (totalSchedule > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: TossColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Text(
              '$totalSchedule',
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        // Red badge for problems
        if (totalProblem > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Text(
              '$totalProblem',
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        // Show "All clear" badge when no issues
        if (totalSchedule == 0 && totalProblem == 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Text(
              'All clear',
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LegendItem(
          color: TossColors.warning,
          label: 'Schedule',
        ),
        const SizedBox(width: TossSpacing.space4),
        LegendItem(
          color: TossColors.error,
          label: 'Problem',
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
