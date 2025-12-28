import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/monthly_attendance.dart';

/// Monthly 직원용 캘린더 위젯 (심플 버전)
class MonthlyCalendar extends StatelessWidget {
  final List<MonthlyAttendance> attendanceList;
  final DateTime currentMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const MonthlyCalendar({
    super.key,
    required this.attendanceList,
    required this.currentMonth,
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWeekDayHeader(),
        const SizedBox(height: 8),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildWeekDayHeader() {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        final isWeekend = day == 'Sun' || day == 'Sat';
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TossTextStyles.caption.copyWith(
                color: isWeekend ? TossColors.gray400 : TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final days = <Widget>[];

    // 이전 달 빈 칸
    for (var i = 0; i < firstWeekday; i++) {
      days.add(const SizedBox());
    }

    // 현재 달 날짜들
    for (var day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      days.add(_buildDayCell(date));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: days,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final attendance = _getAttendanceForDate(date);
    final isToday = _isToday(date);
    final isSelected = selectedDate != null &&
        date.year == selectedDate!.year &&
        date.month == selectedDate!.month &&
        date.day == selectedDate!.day;
    final isFuture = date.isAfter(DateTime.now());

    Color textColor = TossColors.gray900;
    Color? bgColor;

    // Weekend styling
    if (date.weekday == DateTime.sunday || date.weekday == DateTime.saturday) {
      textColor = TossColors.gray400;
    }

    // Future dates
    if (isFuture) {
      textColor = TossColors.gray400;
    }

    // Attendance status coloring
    if (attendance != null) {
      switch (attendance.status) {
        case 'completed':
          bgColor = TossColors.primary.withValues(alpha: 0.1);
          textColor = TossColors.primary;
        case 'checked_in':
          bgColor = TossColors.success.withValues(alpha: 0.1);
          textColor = TossColors.success;
        case 'absent':
          bgColor = TossColors.error.withValues(alpha: 0.1);
          textColor = TossColors.error;
        case 'day_off':
          bgColor = TossColors.gray100;
          textColor = TossColors.gray500;
      }
    }

    return GestureDetector(
      onTap: () => onDateSelected?.call(date),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.2) : bgColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: isToday
              ? Border.all(color: TossColors.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TossTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  MonthlyAttendance? _getAttendanceForDate(DateTime date) {
    try {
      return attendanceList.firstWhere(
        (a) =>
            a.attendanceDate.year == date.year &&
            a.attendanceDate.month == date.month &&
            a.attendanceDate.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
