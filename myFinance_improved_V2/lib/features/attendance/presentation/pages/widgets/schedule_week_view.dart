import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/toss/toss_week_navigation.dart';

/// Week view component with navigation and shift list
/// Auto-scrolls to the closest upcoming shift when loaded
class ScheduleWeekView extends StatefulWidget {
  final DateTime currentWeek;
  final int weekOffset;
  final List<Widget> shifts;
  final int? closestUpcomingIndex; // Index of closest upcoming shift for auto-scroll
  final ValueChanged<int> onNavigate;

  const ScheduleWeekView({
    super.key,
    required this.currentWeek,
    required this.weekOffset,
    required this.shifts,
    this.closestUpcomingIndex,
    required this.onNavigate,
  });

  @override
  State<ScheduleWeekView> createState() => _ScheduleWeekViewState();
}

class _ScheduleWeekViewState extends State<ScheduleWeekView> {
  final ScrollController _scrollController = ScrollController();
  static const double _cardHeight = 80.0; // Approximate height of each shift card with padding

  @override
  void initState() {
    super.initState();
    // Schedule auto-scroll after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToClosestUpcoming();
    });
  }

  @override
  void didUpdateWidget(ScheduleWeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-scroll when week changes or closest index changes
    if (oldWidget.weekOffset != widget.weekOffset ||
        oldWidget.closestUpcomingIndex != widget.closestUpcomingIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToClosestUpcoming();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToClosestUpcoming() {
    if (widget.closestUpcomingIndex == null ||
        widget.closestUpcomingIndex! <= 0 ||
        !_scrollController.hasClients) {
      return;
    }

    // Calculate the target scroll position
    final targetOffset = widget.closestUpcomingIndex! * _cardHeight;

    // Respect maxScrollExtent - don't scroll past the end
    final maxScroll = _scrollController.position.maxScrollExtent;
    final finalOffset = targetOffset.clamp(0.0, maxScroll);

    // Jump to the position (no animation for instant load)
    _scrollController.jumpTo(finalOffset);
  }

  DateTimeRange get _weekRange {
    final weekday = widget.currentWeek.weekday;
    final monday = widget.currentWeek.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateTimeRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  int get _weekNumber {
    final firstDayOfYear = DateTime(widget.currentWeek.year, 1, 1);
    final daysSinceFirstDay = widget.currentWeek.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('week'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week Navigation (fixed at top)
        TossWeekNavigation(
          weekLabel: widget.weekOffset == 0 ? 'This week' : 'Week $_weekNumber',
          dateRange:
              '${DateFormat('d').format(_weekRange.start)} - ${DateFormat('d MMM').format(_weekRange.end)}',
          onPrevWeek: () => widget.onNavigate(-1),
          onCurrentWeek: () => widget.onNavigate(0),
          onNextWeek: () => widget.onNavigate(1),
        ),
        const SizedBox(height: 12),

        // Shift List (scrollable) - use Flexible to prevent overflow
        Flexible(
          child: widget.shifts.isEmpty
              ? const Center(
                  child: Text('No shifts this week'),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.shifts.length,
                  itemBuilder: (context, index) => widget.shifts[index],
                ),
        ),
      ],
    );
  }
}
