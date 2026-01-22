import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';
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
        const SizedBox(height: TossSpacing.space2),
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
              style: isWeekend
                  ? TossTextStyles.captionGray400
                  : TossTextStyles.captionBold,
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
      mainAxisSpacing: TossSpacing.space1,
      crossAxisSpacing: TossSpacing.space1,
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
          bgColor = TossColors.primary.withValues(alpha: TossOpacity.light);
          textColor = TossColors.primary;
        case 'checked_in':
          bgColor = TossColors.success.withValues(alpha: TossOpacity.light);
          textColor = TossColors.success;
        case 'absent':
          bgColor = TossColors.error.withValues(alpha: TossOpacity.light);
          textColor = TossColors.error;
        case 'day_off':
          bgColor = TossColors.gray100;
          textColor = TossColors.gray500;
      }
    }

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onDateSelected?.call(date),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? TossColors.primary.withValues(alpha: TossOpacity.strong) : bgColor,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: isToday
                ? Border.all(color: TossColors.primary, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: (isToday || isSelected
                      ? TossTextStyles.captionBold
                      : TossTextStyles.caption)
                  .copyWith(color: textColor),
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
