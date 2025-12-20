import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'attention_card.dart';

/// Summary of attention items for a single date
class DateAttentionSummary {
  final DateTime date;
  final int understaffedCount; // Blue dots (shift-level)
  final int problemCount; // Red dots (staff-level)
  final List<AttentionItemData> items;

  const DateAttentionSummary({
    required this.date,
    required this.understaffedCount,
    required this.problemCount,
    required this.items,
  });

  /// Total count of all attention items
  int get totalCount => understaffedCount + problemCount;

  /// Check if this date has any attention items
  bool get hasItems => totalCount > 0;
}

/// Attention Timeline Widget
///
/// Displays a 5-day timeline showing attention items grouped by date.
/// - Blue dots: Understaffed shifts (tap → Schedule tab)
/// - Red dots: Staff problems (tap → Problems tab)
class AttentionTimeline extends StatelessWidget {
  /// All attention items (will be grouped by date internally)
  final List<AttentionItemData> items;

  /// Center date of the timeline (usually today)
  final DateTime centerDate;

  /// Number of days to show (default: 5)
  final int visibleDays;

  /// Callback when a blue dot (understaffed) is tapped
  final void Function(DateTime date)? onUnderstaffedTap;

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
    this.onUnderstaffedTap,
    this.onProblemTap,
    this.onDateTap,
    this.onPrevious,
    this.onNext,
  });

  /// Group items by date and calculate summaries
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
      final understaffedCount =
          entry.value.where((item) => item.isShiftProblem).length;
      final problemCount =
          entry.value.where((item) => !item.isShiftProblem).length;

      summaries[entry.key] = DateAttentionSummary(
        date: entry.key,
        understaffedCount: understaffedCount,
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

  /// Count items before visible range
  int _countItemsBefore(
      Map<DateTime, DateAttentionSummary> summaries, DateTime firstVisible) {
    int count = 0;
    for (final entry in summaries.entries) {
      if (entry.key.isBefore(firstVisible)) {
        count += entry.value.totalCount;
      }
    }
    return count;
  }

  /// Count items after visible range
  int _countItemsAfter(
      Map<DateTime, DateAttentionSummary> summaries, DateTime lastVisible) {
    int count = 0;
    for (final entry in summaries.entries) {
      if (entry.key.isAfter(lastVisible)) {
        count += entry.value.totalCount;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final summaries = _groupItemsByDate();
    final visibleDates = _getVisibleDates();

    // Calculate total understaffed and problem counts
    final totalUnderstaffed = items.where((item) => item.isShiftProblem).length;
    final totalProblem = items.where((item) => !item.isShiftProblem).length;

    final beforeCount = _countItemsBefore(summaries, visibleDates.first);
    final afterCount = _countItemsAfter(summaries, visibleDates.last);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with split badges (blue for understaffed, red for problems)
        Row(
          children: [
            Text(
              'Need Attention',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Blue badge for understaffed
            if (totalUnderstaffed > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalUnderstaffed',
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.primary,
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
                  borderRadius: BorderRadius.circular(12),
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
          ],
        ),

        const SizedBox(height: TossSpacing.space4),

        // Timeline row with navigation
        Row(
          children: [
            // Previous button
            _NavigationButton(
              count: beforeCount,
              direction: _NavigationDirection.previous,
              onTap: beforeCount > 0 ? onPrevious : null,
            ),

            // Timeline dates
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: visibleDates.map((date) {
                  final summary = summaries[date];
                  final hasProblem = summary != null && summary.problemCount > 0;
                  return _TimelineDate(
                    date: date,
                    summary: summary,
                    isToday: _isSameDay(date, DateTime.now()),
                    onDateTap: () => onDateTap?.call(date, hasProblem),
                    onUnderstaffedTap:
                        summary != null && summary.understaffedCount > 0
                            ? () => onUnderstaffedTap?.call(date)
                            : null,
                    onProblemTap: hasProblem
                        ? () => onProblemTap?.call(date)
                        : null,
                  );
                }).toList(),
              ),
            ),

            // Next button
            _NavigationButton(
              count: afterCount,
              direction: _NavigationDirection.next,
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

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: TossColors.primary,
          label: 'Understaffed',
        ),
        const SizedBox(width: TossSpacing.space4),
        _LegendItem(
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

/// Single date column in the timeline
class _TimelineDate extends StatelessWidget {
  final DateTime date;
  final DateAttentionSummary? summary;
  final bool isToday;
  final VoidCallback? onDateTap;
  final VoidCallback? onUnderstaffedTap;
  final VoidCallback? onProblemTap;

  const _TimelineDate({
    required this.date,
    this.summary,
    required this.isToday,
    this.onDateTap,
    this.onUnderstaffedTap,
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
            decoration: BoxDecoration(
              color: isToday ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray100,
              borderRadius: BorderRadius.circular(16),
            ),
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

        // Dots row
        if (hasItems) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Blue dots (understaffed)
              if (summary!.understaffedCount > 0)
                GestureDetector(
                  onTap: onUnderstaffedTap,
                  child: _DotIndicator(
                    color: TossColors.primary,
                    count: summary!.understaffedCount,
                  ),
                ),

              if (summary!.understaffedCount > 0 && summary!.problemCount > 0)
                const SizedBox(width: 4),

              // Red dots (problems)
              if (summary!.problemCount > 0)
                GestureDetector(
                  onTap: onProblemTap,
                  child: _DotIndicator(
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
        ] else ...[
          // Empty placeholder for alignment
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

/// Dot indicator showing count
class _DotIndicator extends StatelessWidget {
  final Color color;
  final int count;

  const _DotIndicator({
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    // Show up to 3 dots, then show number
    if (count <= 3) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          count,
          (index) => Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(left: index > 0 ? 2 : 0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    }

    // More than 3: show dot with number
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '×$count',
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

enum _NavigationDirection { previous, next }

/// Navigation button (< 7 more) or (5 more >)
class _NavigationButton extends StatelessWidget {
  final int count;
  final _NavigationDirection direction;
  final VoidCallback? onTap;

  const _NavigationButton({
    required this.count,
    required this.direction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = count > 0 && onTap != null;
    final color = isEnabled ? TossColors.gray600 : TossColors.gray300;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (direction == _NavigationDirection.previous) ...[
              Icon(Icons.chevron_left, size: 20, color: color),
              if (count > 0)
                Text(
                  '$count',
                  style: TossTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ] else ...[
              Icon(Icons.chevron_right, size: 20, color: color),
              if (count > 0)
                Text(
                  '$count',
                  style: TossTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Legend item
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }
}
