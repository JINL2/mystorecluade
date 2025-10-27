import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../providers/states/time_table_state.dart';
import '../../providers/time_table_providers.dart';
import 'calendar_day_cell.dart';
import 'calendar_header.dart';

/// Shift Calendar View
///
/// Main calendar grid displaying monthly shift data
class ShiftCalendarView extends ConsumerStatefulWidget {
  final String storeId;
  final void Function(DateTime)? onDateSelected;

  const ShiftCalendarView({
    super.key,
    required this.storeId,
    this.onDateSelected,
  });

  @override
  ConsumerState<ShiftCalendarView> createState() => _ShiftCalendarViewState();
}

class _ShiftCalendarViewState extends ConsumerState<ShiftCalendarView> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _selectedDate = DateTime.now();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthData();
    });
  }

  void _loadMonthData() {
    ref.read(monthlyShiftStatusProvider(widget.storeId).notifier).loadMonth(
          month: _currentMonth,
        );
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    _loadMonthData();
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    _loadMonthData();
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _currentMonth = DateTime(now.year, now.month);
      _selectedDate = now;
    });
    _loadMonthData();
    widget.onDateSelected?.call(now);
  }

  void _onDateTapped(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(monthlyShiftStatusProvider(widget.storeId));

    return Column(
      children: [
        // Calendar header with month navigation
        CalendarHeader(
          currentMonth: _currentMonth,
          onPreviousMonth: _goToPreviousMonth,
          onNextMonth: _goToNextMonth,
          onTodayPressed: _goToToday,
        ),

        // Week day labels
        const WeekDayHeader(),

        // Calendar grid
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
                  ? Center(
                      child: Text(
                        '데이터를 불러오는 중 오류가 발생했습니다:\n${state.error}',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : _buildCalendarGrid(state),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(MonthlyShiftStatusState state) {
    // Get data for current month
    final monthKey =
        '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';
    final monthlyStatuses = state.dataByMonth[monthKey] ?? [];

    // Find the monthly status for current month
    final currentMonthData = monthlyStatuses.isNotEmpty
        ? monthlyStatuses.first
        : MonthlyShiftStatus(
            month: monthKey,
            dailyShifts: const [],
          );

    // Build calendar days
    final calendarDays = _buildCalendarDays(currentMonthData);

    return Container(
      color: TossColors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.8,
        ),
        itemCount: calendarDays.length,
        itemBuilder: (context, index) {
          final dayData = calendarDays[index];
          return dayData['widget'] as Widget;
        },
      ),
    );
  }

  List<Map<String, dynamic>> _buildCalendarDays(MonthlyShiftStatus monthData) {
    final List<Map<String, dynamic>> days = [];

    // Get first day of month
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Get weekday of first day (1 = Monday, 7 = Sunday)
    int firstWeekday = firstDayOfMonth.weekday;
    if (firstWeekday == 7) firstWeekday = 0; // Sunday = 0

    // Add previous month days
    final previousMonthEnd =
        DateTime(_currentMonth.year, _currentMonth.month, 0);
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final date = previousMonthEnd.subtract(Duration(days: i));
      days.add({
        'date': date,
        'widget': CalendarDayCell(
          date: date,
          isCurrentMonth: false,
          isToday: false,
          isSelected: false,
          onTap: () {},
        ),
      });
    }

    // Add current month days
    final today = DateTime.now();
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final isSelected = _selectedDate != null &&
          date.year == _selectedDate!.year &&
          date.month == _selectedDate!.month &&
          date.day == _selectedDate!.day;

      // Find daily data for this date
      final dailyData = monthData.findByDate(_formatDate(date));

      days.add({
        'date': date,
        'widget': CalendarDayCell(
          date: date,
          isCurrentMonth: true,
          isToday: isToday,
          isSelected: isSelected,
          dailyData: dailyData,
          onTap: () => _onDateTapped(date),
        ),
      });
    }

    // Add next month days to fill grid
    final remainingCells = 42 - days.length; // 6 rows * 7 days
    for (int i = 1; i <= remainingCells; i++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month + 1, i);
      days.add({
        'date': date,
        'widget': CalendarDayCell(
          date: date,
          isCurrentMonth: false,
          isToday: false,
          isSelected: false,
          onTap: () {},
        ),
      });
    }

    return days;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
