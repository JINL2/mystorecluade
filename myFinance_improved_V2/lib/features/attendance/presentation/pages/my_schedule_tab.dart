import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../domain/entities/shift_card.dart';
import '../providers/attendance_providers.dart';
import 'dialogs/shift_detail_dialog.dart';
import 'widgets/schedule_header.dart';
import 'widgets/schedule_week_view.dart';
import 'widgets/schedule_month_view.dart';

export 'widgets/schedule_header.dart' show ViewMode;

/// MyScheduleTab - Main tab with Week/Month view switching
///
/// Features:
/// - Segmented control to switch between Week and Month views
/// - Featured "Today's Shift" card
/// - Week view: Week navigation + shift list
/// - Month view: Month navigation + calendar + filtered shift list
class MyScheduleTab extends ConsumerStatefulWidget {
  const MyScheduleTab({super.key});

  @override
  ConsumerState<MyScheduleTab> createState() => _MyScheduleTabState();
}

class _MyScheduleTabState extends ConsumerState<MyScheduleTab> {
  // View mode state
  ViewMode _viewMode = ViewMode.week;

  // Navigation state
  int _currentWeekOffset = 0; // 0 = current week, -1 = prev, +1 = next
  int _currentMonthOffset = 0; // 0 = current month, -1 = prev, +1 = next

  // Selection state (for Month view)
  DateTime _selectedDate = DateTime.now();

  // Scroll controller for month view with max scroll limit
  final ScrollController _monthScrollController = ScrollController();

  // GlobalKey to measure Today's shift card height
  final GlobalKey _todayShiftCardKey = GlobalKey();

  // Maximum scroll offset (height of Today's Shift card + 12px spacing)
  double? _maxScrollOffset;

  @override
  void initState() {
    super.initState();
    _monthScrollController.addListener(_limitScroll);

    // Measure card height after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMaxScrollOffset();
    });
  }

  @override
  void dispose() {
    _monthScrollController.removeListener(_limitScroll);
    _monthScrollController.dispose();
    super.dispose();
  }

  // Calculate max scroll offset based on actual card height
  void _calculateMaxScrollOffset() {
    final RenderBox? renderBox = _todayShiftCardKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        // Card height + 12px spacing below it
        _maxScrollOffset = renderBox.size.height + 12;
      });
    }
  }

  // Limit scroll to prevent toggle buttons from going off-screen
  void _limitScroll() {
    if (_monthScrollController.hasClients && _maxScrollOffset != null) {
      final offset = _monthScrollController.offset;
      if (offset > _maxScrollOffset!) {
        _monthScrollController.jumpTo(_maxScrollOffset!);
      }
    }
  }

  // Computed properties
  DateTime get _currentWeek {
    return DateTime.now().add(Duration(days: _currentWeekOffset * 7));
  }

  DateTime get _currentMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + _currentMonthOffset, 1);
  }

  DateTimeRange get _weekRange => _getWeekRange(_currentWeek);

  // Date calculation helpers
  DateTimeRange _getWeekRange(DateTime date) {
    final weekday = date.weekday; // 1=Mon, 7=Sun
    final monday = date.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateTimeRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Navigation handlers
  void _navigateWeek(int offset) {
    if (offset == 0) {
      setState(() => _currentWeekOffset = 0);
    } else {
      setState(() => _currentWeekOffset += offset);
    }
  }

  void _navigateMonth(int offset) {
    if (offset == 0) {
      setState(() => _currentMonthOffset = 0);
    } else {
      setState(() => _currentMonthOffset += offset);
    }
  }

  void _handleDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
  }

  // Find the closest upcoming shift across all dates
  // This ensures both week and month views highlight the same shift
  DateTime? _findClosestUpcomingShift() {
    final now = DateTime.now();
    DateTime? closestDate;

    // Check current week range
    final weekRange = _weekRange;
    for (int i = 0; i < 7; i++) {
      final date = weekRange.start.add(Duration(days: i));
      // Mock logic: shifts on even days (matching _buildMockWeekShifts)
      if (i % 2 == 0 && date.isAfter(now)) {
        if (closestDate == null || date.isBefore(closestDate)) {
          closestDate = date;
        }
      }
    }

    // Also check current month for month view
    final daysInMonth = _getDaysInMonth();
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      // Mock logic: shifts on weekdays (matching _buildMockShiftsInMonth)
      if (date.weekday <= 5 && date.isAfter(now)) {
        if (closestDate == null || date.isBefore(closestDate)) {
          closestDate = date;
        }
      }
    }

    return closestDate;
  }

  int _getDaysInMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return _viewMode == ViewMode.week
        ? _buildWeekView()
        : _buildMonthView();
  }

  Widget _buildWeekView() {
    final weekRange = _weekRange;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Common Header (Today's Shift Card + Toggle)
            ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              onCheckIn: () {
                // TODO: Implement check-in
              },
              onCheckOut: () {
                // TODO: Implement check-out
              },
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),

            // Week View
            ScheduleWeekView(
              currentWeek: _currentWeek,
              weekOffset: _currentWeekOffset,
              shifts: _buildMockWeekShifts(weekRange),
              onNavigate: _navigateWeek,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthView() {
    return SingleChildScrollView(
      controller: _monthScrollController,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Common Header (Today's Shift Card + Toggle)
            ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              onCheckIn: () {
                // TODO: Implement check-in
              },
              onCheckOut: () {
                // TODO: Implement check-out
              },
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),

            // Month View
            ScheduleMonthView(
              currentMonth: _currentMonth,
              selectedDate: _selectedDate,
              monthOffset: _currentMonthOffset,
              shiftsInMonth: _buildMockShiftsInMonth(),
              dayShifts: _buildMockDayShifts(_selectedDate),
              onNavigate: _navigateMonth,
              onDateSelected: _handleDateSelected,
            ),
          ],
        ),
      ),
    );
  }

  // Mock data builders (will be replaced with real data)
  List<Widget> _buildMockWeekShifts(DateTimeRange weekRange) {
    final shifts = <Widget>[];
    final now = DateTime.now();
    final closestUpcomingDate = _findClosestUpcomingShift();

    // Build shift cards
    for (int i = 0; i < 7; i++) {
      final date = weekRange.start.add(Duration(days: i));
      final dayName = DateFormat.E().format(date);
      final dayNumber = date.day;

      // Mock: Add shift for even days
      if (i % 2 == 0) {
        final shiftType = i % 4 == 0 ? 'Morning' : 'Evening';
        final timeRange = i % 4 == 0 ? '9:00 AM - 5:00 PM' : '2:00 PM - 10:00 PM';
        final isClosest = closestUpcomingDate != null && _isSameDay(date, closestUpcomingDate);

        shifts.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TossWeekShiftCard(
              date: '$dayName $dayNumber',
              shiftType: shiftType,
              timeRange: timeRange,
              status: date.isBefore(now)
                  ? ShiftCardStatus.completed
                  : ShiftCardStatus.onTime,
              isClosestUpcoming: isClosest,
              onTap: () {
                ShiftDetailDialog.show(
                  context,
                  shiftDate: DateFormat('yyyy-MM-dd').format(date),
                  shiftType: shiftType,
                  shiftTime: i % 4 == 0 ? '09:00 – 17:00' : '14:00 – 22:00',
                  shiftStatus: 'On-time',
                );
              },
            ),
          ),
        );
      }
    }
    return shifts;
  }

  Map<DateTime, bool> _buildMockShiftsInMonth() {
    final shifts = <DateTime, bool>{};
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      // Mock: Add shifts for weekdays (Mon-Fri)
      if (date.weekday <= 5) {
        shifts[date] = true;
      }
    }
    return shifts;
  }

  List<Widget> _buildMockDayShifts(DateTime date) {
    final shifts = <Widget>[];
    final dayName = DateFormat.E().format(date);
    final dayNumber = date.day;
    final closestUpcomingDate = _findClosestUpcomingShift();

    // Mock: Show 1-2 shifts for selected date if it has shifts
    if (date.weekday <= 5) {
      final isClosest = closestUpcomingDate != null && _isSameDay(date, closestUpcomingDate);

      shifts.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TossWeekShiftCard(
            date: '$dayName $dayNumber',
            shiftType: 'Morning',
            timeRange: '9:00 AM - 5:00 PM',
            status: date.isBefore(DateTime.now())
                ? ShiftCardStatus.completed
                : ShiftCardStatus.onTime,
            isClosestUpcoming: isClosest,
            onTap: () {
              ShiftDetailDialog.show(
                context,
                shiftDate: DateFormat('yyyy-MM-dd').format(date),
                shiftType: 'Morning',
                shiftTime: '09:00 – 17:00',
                shiftStatus: 'On-time',
              );
            },
          ),
        ),
      );
    } else {
      // No shifts on weekends
      shifts.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No shifts scheduled for this day',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        ),
      );
    }

    return shifts;
  }
}
