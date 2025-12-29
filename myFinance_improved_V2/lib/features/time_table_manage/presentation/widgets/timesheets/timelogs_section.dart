import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_week_navigation.dart';
import 'package:myfinance_improved/shared/widgets/toss/week_dates_picker.dart';
import 'package:myfinance_improved/shared/widgets/toss/month_dates_picker.dart';
import '../../pages/staff_timelog_detail_page.dart';
import 'shift_section.dart';

/// Timelogs section widget for TimesheetsTab
/// Displays calendar navigation and shift timelogs
class TimelogsSection extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final DateTime weekStartDate;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final ValueChanged<DateTime> onDateSelected;
  final Future<void> Function()? onPreviousMonth;
  final Future<void> Function()? onNextMonth;
  final VoidCallback onJumpToToday;
  final void Function(int days) onChangeWeek;
  final String weekLabel;
  final String weekRange;
  final List<ShiftTimelog> shifts;
  final Map<String, ProblemStatus> problemStatusByDate;
  final void Function(Map<String, dynamic> result)? onSaveResult;

  const TimelogsSection({
    super.key,
    required this.selectedDate,
    required this.focusedMonth,
    required this.weekStartDate,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onDateSelected,
    this.onPreviousMonth,
    this.onNextMonth,
    required this.onJumpToToday,
    required this.onChangeWeek,
    required this.weekLabel,
    required this.weekRange,
    required this.shifts,
    required this.problemStatusByDate,
    this.onSaveResult,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week/Month Navigation with expand button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: isExpanded
                  ? _buildMonthNavigation()
                  : TossWeekNavigation(
                      weekLabel: weekLabel,
                      dateRange: weekRange,
                      onPrevWeek: () => onChangeWeek(-7),
                      onCurrentWeek: onJumpToToday,
                      onNextWeek: () => onChangeWeek(7),
                    ),
            ),
            // Expand/Collapse button - Calendar icon
            IconButton(
              onPressed: onToggleExpanded,
              icon: Icon(
                isExpanded ? Icons.calendar_view_week : Icons.calendar_month,
                color: isExpanded ? TossColors.primary : TossColors.gray600,
                size: 24,
              ),
              tooltip: isExpanded ? 'Show week view' : 'Show month view',
            ),
          ],
        ),

        const SizedBox(height: TossSpacing.space3),

        // Week or Month Dates Picker
        if (isExpanded)
          MonthDatesPicker(
            currentMonth: focusedMonth,
            selectedDate: selectedDate,
            problemStatusByDate: problemStatusByDate,
            onDateSelected: onDateSelected,
          )
        else
          WeekDatesPicker(
            selectedDate: selectedDate,
            weekStartDate: weekStartDate,
            problemStatusMap: problemStatusByDate,
            onDateSelected: onDateSelected,
          ),

        const SizedBox(height: TossSpacing.space4),

        // Timelogs section header
        Text(
          'Timelogs for ${_formatSelectedDate(selectedDate)}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Shift sections
        _buildShiftSections(),

        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildMonthNavigation() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthName = months[focusedMonth.month - 1];
    final year = focusedMonth.year;

    return Row(
      children: [
        IconButton(
          onPressed: () => onPreviousMonth?.call(),
          icon: Icon(Icons.chevron_left, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onJumpToToday,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$monthName $year',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => onNextMonth?.call(),
          icon: Icon(Icons.chevron_right, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Widget _buildShiftSections() {
    if (shifts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(TossSpacing.space8),
        child: TossEmptyView(
          title: 'No timelogs',
          description: 'No approved shifts for this date',
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: shifts.length,
      itemBuilder: (context, index) {
        final shift = shifts[index];
        return ShiftSection(
          shift: shift,
          initiallyExpanded: false,
          onSaveResult: onSaveResult,
        );
      },
    );
  }

  String _formatSelectedDate(DateTime date) {
    final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
    final day = date.day;
    final month = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][date.month - 1];
    return '$weekday, $day $month';
  }
}
