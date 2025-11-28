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
import 'widgets/schedule_month_view.dart';
import 'widgets/schedule_week_view.dart';

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

  // GlobalKey to measure Today's shift card height
  final GlobalKey _todayShiftCardKey = GlobalKey();

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

  // Find today's shift from the shift cards list
  ShiftCard? _findTodayShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final card in shiftCards) {
      final cardDate = _parseRequestDate(card.requestDate);
      if (cardDate == null) continue;

      if (_isSameDay(cardDate, today)) {
        return card;
      }
    }
    return null;
  }

  // Find the closest upcoming shift from actual data
  DateTime? _findClosestUpcomingShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? closestDate;

    for (final card in shiftCards) {
      final cardDate = _parseRequestDate(card.requestDate);
      if (cardDate == null) continue;

      // Only consider future or today's shifts that haven't started
      if (!cardDate.isBefore(today)) {
        if (card.actualStartTime == null) {
          // Shift hasn't started yet
          if (closestDate == null || cardDate.isBefore(closestDate)) {
            closestDate = cardDate;
          }
        }
      }
    }

    return closestDate;
  }

  // Parse request_date string to DateTime
  DateTime? _parseRequestDate(String requestDate) {
    try {
      // Format: "2025-11-01" or "2025-11-01T00:00:00Z"
      if (requestDate.contains('T')) {
        return DateTime.parse(requestDate).toLocal();
      }
      final parts = requestDate.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (e) {
      return null;
    }
  }

  // Determine ShiftCardStatus from ShiftCard data
  ShiftCardStatus _determineStatus(ShiftCard card, DateTime cardDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Future shift (hasn't come yet)
    if (cardDate.isAfter(today)) {
      return ShiftCardStatus.upcoming;
    }

    // Past or today's shift
    if (card.actualStartTime != null && card.actualEndTime != null) {
      // Check-in and check-out completed
      return card.isLate ? ShiftCardStatus.late : ShiftCardStatus.onTime;
    }

    if (card.actualStartTime != null && card.actualEndTime == null) {
      // Currently working (checked in but not out)
      return ShiftCardStatus.inProgress;
    }

    // Past date but no check-in
    if (cardDate.isBefore(today)) {
      return ShiftCardStatus.undone;
    }

    return ShiftCardStatus.upcoming;
  }

  // Format shift time for display (e.g., "14:00 ~ 18:00" -> "2:00 PM - 6:00 PM")
  String _formatTimeRange(String shiftTime) {
    try {
      final parts = shiftTime.split('~').map((s) => s.trim()).toList();
      if (parts.length != 2) return shiftTime;

      final startTime = _formatTime(parts[0]);
      final endTime = _formatTime(parts[1]);
      return '$startTime - $endTime';
    } catch (e) {
      return shiftTime;
    }
  }

  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24;
    }
  }

  // Extract shift type from shift_time (Morning/Evening based on start hour)
  String _extractShiftType(String shiftTime) {
    try {
      final parts = shiftTime.split('~').map((s) => s.trim()).toList();
      if (parts.isEmpty) return 'Shift';

      final startHour = int.parse(parts[0].split(':')[0]);
      if (startHour < 12) return 'Morning';
      if (startHour < 17) return 'Afternoon';
      return 'Evening';
    } catch (e) {
      return 'Shift';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _viewMode == ViewMode.week
        ? _buildWeekView()
        : _buildMonthView();
  }

  Widget _buildWeekView() {
    final weekRange = _weekRange;
    // Use year-month string key to prevent infinite rebuilds
    final yearMonth = '${_currentWeek.year}-${_currentWeek.month.toString().padLeft(2, '0')}';
    final shiftCardsAsync = ref.watch(monthlyShiftCardsProvider(yearMonth));

    // Also get today's month data for the header (in case current week is different month)
    final now = DateTime.now();
    final todayYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final todayShiftCardsAsync = ref.watch(monthlyShiftCardsProvider(todayYearMonth));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Common Header (Today's Shift Card + Toggle) - Fixed
          todayShiftCardsAsync.when(
            data: (todayShiftCards) => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: _findTodayShift(todayShiftCards),
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
            loading: () => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: null,
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),
            error: (_, __) => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: null,
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),
          ),

          // Week View (contains scrollable shift list)
          Expanded(
            child: shiftCardsAsync.when(
              data: (shiftCards) {
                final result = _buildWeekShiftsWithIndex(weekRange, shiftCards);
                return ScheduleWeekView(
                  currentWeek: _currentWeek,
                  weekOffset: _currentWeekOffset,
                  shifts: result.shifts,
                  closestUpcomingIndex: result.closestUpcomingIndex,
                  onNavigate: _navigateWeek,
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    // Use year-month string key to prevent infinite rebuilds
    final yearMonth = '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';
    final shiftCardsAsync = ref.watch(monthlyShiftCardsProvider(yearMonth));

    // Also get today's month data for the header (in case current month is different)
    final now = DateTime.now();
    final todayYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final todayShiftCardsAsync = ref.watch(monthlyShiftCardsProvider(todayYearMonth));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Common Header (Today's Shift Card + Toggle) - Fixed
          todayShiftCardsAsync.when(
            data: (todayShiftCards) => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: _findTodayShift(todayShiftCards),
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
            loading: () => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: null,
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),
            error: (_, __) => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: null,
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),
          ),

          // Month View (contains scrollable shift list)
          Expanded(
            child: shiftCardsAsync.when(
              data: (shiftCards) => ScheduleMonthView(
                currentMonth: _currentMonth,
                selectedDate: _selectedDate,
                monthOffset: _currentMonthOffset,
                shiftsInMonth: _buildShiftsInMonth(shiftCards),
                dayShifts: _buildDayShifts(_selectedDate, shiftCards),
                onNavigate: _navigateMonth,
                onDateSelected: _handleDateSelected,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build week shifts from real data
  // Returns (shifts, closestUpcomingIndex) for auto-scroll functionality
  ({List<Widget> shifts, int? closestUpcomingIndex}) _buildWeekShiftsWithIndex(
    DateTimeRange weekRange,
    List<ShiftCard> shiftCards,
  ) {
    final shifts = <Widget>[];
    final closestUpcomingDate = _findClosestUpcomingShift(shiftCards);
    int? closestUpcomingIndex;

    // Filter shifts within the week range
    final weekShifts = shiftCards.where((card) {
      final cardDate = _parseRequestDate(card.requestDate);
      if (cardDate == null) return false;
      return !cardDate.isBefore(weekRange.start) && !cardDate.isAfter(weekRange.end);
    }).toList();

    // Sort by date
    weekShifts.sort((a, b) {
      final dateA = _parseRequestDate(a.requestDate);
      final dateB = _parseRequestDate(b.requestDate);
      if (dateA == null || dateB == null) return 0;
      return dateA.compareTo(dateB);
    });

    for (int i = 0; i < weekShifts.length; i++) {
      final card = weekShifts[i];
      final cardDate = _parseRequestDate(card.requestDate);
      if (cardDate == null) continue;

      final dayName = DateFormat.E().format(cardDate);
      final dayNumber = cardDate.day;
      final shiftType = _extractShiftType(card.shiftTime);
      final timeRange = _formatTimeRange(card.shiftTime);
      final status = _determineStatus(card, cardDate);
      final isClosest = closestUpcomingDate != null && _isSameDay(cardDate, closestUpcomingDate);

      // Track the index of closest upcoming shift for auto-scroll
      if (isClosest) {
        closestUpcomingIndex = shifts.length; // Current index in the shifts list
      }

      shifts.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TossWeekShiftCard(
            date: '$dayName $dayNumber',
            shiftType: shiftType,
            timeRange: timeRange,
            status: status,
            isClosestUpcoming: isClosest,
            onTap: () {
              ShiftDetailDialog.show(
                context,
                shiftCard: card,
              );
            },
          ),
        ),
      );
    }

    return (shifts: shifts, closestUpcomingIndex: closestUpcomingIndex);
  }

  // Build shifts map for calendar display
  Map<DateTime, bool> _buildShiftsInMonth(List<ShiftCard> shiftCards) {
    final shifts = <DateTime, bool>{};

    for (final card in shiftCards) {
      final cardDate = _parseRequestDate(card.requestDate);
      if (cardDate == null) continue;

      // Only include shifts in the current month
      if (cardDate.year == _currentMonth.year && cardDate.month == _currentMonth.month) {
        final dateOnly = DateTime(cardDate.year, cardDate.month, cardDate.day);
        shifts[dateOnly] = true;
      }
    }

    return shifts;
  }

  // Build day shifts for selected date
  List<Widget> _buildDayShifts(DateTime date, List<ShiftCard> shiftCards) {
    final shifts = <Widget>[];
    final closestUpcomingDate = _findClosestUpcomingShift(shiftCards);

    // Filter shifts for the selected date
    final dayShifts = shiftCards.where((card) {
      final cardDate = _parseRequestDate(card.requestDate);
      if (cardDate == null) return false;
      return _isSameDay(cardDate, date);
    }).toList();

    if (dayShifts.isEmpty) {
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
      return shifts;
    }

    for (final card in dayShifts) {
      final cardDate = _parseRequestDate(card.requestDate);
      if (cardDate == null) continue;

      final dayName = DateFormat.E().format(cardDate);
      final dayNumber = cardDate.day;
      final shiftType = _extractShiftType(card.shiftTime);
      final timeRange = _formatTimeRange(card.shiftTime);
      final status = _determineStatus(card, cardDate);
      final isClosest = closestUpcomingDate != null && _isSameDay(cardDate, closestUpcomingDate);

      shifts.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TossWeekShiftCard(
            date: '$dayName $dayNumber',
            shiftType: shiftType,
            timeRange: timeRange,
            status: status,
            isClosestUpcoming: isClosest,
            onTap: () {
              ShiftDetailDialog.show(
                context,
                shiftCard: card,
              );
            },
          ),
        ),
      );
    }

    return shifts;
  }
}
