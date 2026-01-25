import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';

/// Month navigation widget for schedule tab (expanded view)
///
/// Shows month name with year and navigation arrows
class ScheduleMonthNavigation extends StatelessWidget {
  final DateTime focusedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onTodayTap;

  const ScheduleMonthNavigation({
    super.key,
    required this.focusedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onTodayTap,
  });

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String get _monthName => _months[focusedMonth.month - 1];
  int get _year => focusedMonth.year;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: Icon(Icons.chevron_left, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTodayTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$_monthName $_year',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: Icon(Icons.chevron_right, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }
}
