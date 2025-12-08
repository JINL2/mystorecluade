import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'shift_section.dart';
import 'staff_timelog_card.dart';

/// Bottom sheet showing timelogs for a specific day
class TimelogDayView extends StatelessWidget {
  final DateTime selectedDate;

  const TimelogDayView({
    super.key,
    required this.selectedDate,
  });

  String _formatDate(DateTime date) {
    final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
    final day = date.day;
    final month = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][date.month - 1];
    return '$weekday, $day $month';
  }

  /// Mock shift data - replace with real data from provider
  List<ShiftTimelog> get _mockShifts {
    return [
      ShiftTimelog(
        shiftId: '1',
        shiftName: 'Morning',
        timeRange: '09:00 - 13:00',
        assignedCount: 3,
        totalCount: 3,
        problemCount: 2,
        staffRecords: [
          StaffTimeRecord(
            staffId: '1',
            staffName: 'Alex R.',
            avatarUrl: 'https://app.banani.co/avatar1.jpeg',
            clockIn: '09:00',
            clockOut: '13:00',
            isConfirmed: true,
          ),
          StaffTimeRecord(
            staffId: '2',
            staffName: 'Sarah K.',
            avatarUrl: 'https://app.banani.co/avatar5.jpg',
            clockIn: '09:05',
            clockOut: '13:00',
            isLate: true,
            needsConfirm: true,
          ),
          StaffTimeRecord(
            staffId: '3',
            staffName: 'Mike T.',
            avatarUrl: 'https://app.banani.co/avatar3.jpeg',
            clockIn: '09:00',
            clockOut: '13:15',
            isOvertime: true,
            needsConfirm: true,
          ),
        ],
      ),
      ShiftTimelog(
        shiftId: '2',
        shiftName: 'Afternoon',
        timeRange: '13:00 - 17:00',
        assignedCount: 4,
        totalCount: 5,
        problemCount: 0,
        staffRecords: [
          StaffTimeRecord(
            staffId: '4',
            staffName: 'Morgan C.',
            avatarUrl: 'https://app.banani.co/avatar4.jpg',
            clockIn: '13:00',
            clockOut: '17:00',
            isConfirmed: true,
          ),
          StaffTimeRecord(
            staffId: '5',
            staffName: 'Sam P.',
            clockIn: '13:00',
            clockOut: '17:00',
            isConfirmed: true,
          ),
          StaffTimeRecord(
            staffId: '6',
            staffName: 'Taylor K.',
            avatarUrl: 'https://app.banani.co/avatar6.jpg',
            clockIn: '13:05',
            clockOut: '17:00',
            isLate: true,
            isConfirmed: true,
          ),
        ],
      ),
      ShiftTimelog(
        shiftId: '3',
        shiftName: 'Night',
        timeRange: '17:00 - 22:00',
        assignedCount: 2,
        totalCount: 3,
        problemCount: 0,
        staffRecords: [
          StaffTimeRecord(
            staffId: '7',
            staffName: 'Jamie L.',
            avatarUrl: 'https://app.banani.co/avatar2.jpg',
            clockIn: '17:00',
            clockOut: '22:00',
            isConfirmed: true,
          ),
          StaffTimeRecord(
            staffId: '8',
            staffName: 'Chris N.',
            clockIn: '17:10',
            clockOut: '22:15',
            isOvertime: true,
            isConfirmed: true,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Text(
              'Timelogs for ${_formatDate(selectedDate)}',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Shift sections
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: TossSpacing.space3,
                right: TossSpacing.space3,
                bottom: TossSpacing.space6,
              ),
              itemCount: _mockShifts.length,
              itemBuilder: (context, index) {
                final shift = _mockShifts[index];
                return ShiftSection(
                  shift: shift,
                  initiallyExpanded: index == 0, // First section expanded by default
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
