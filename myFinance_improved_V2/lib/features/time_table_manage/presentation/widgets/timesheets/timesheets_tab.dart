import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_chip.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_week_navigation.dart';
import 'package:myfinance_improved/shared/widgets/toss/week_dates_picker.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import 'problem_card.dart';
import 'shift_section.dart';
import 'staff_timelog_card.dart';

/// Timesheets tab - Problems view for attendance tracking
class TimesheetsTab extends StatefulWidget {
  const TimesheetsTab({super.key});

  @override
  State<TimesheetsTab> createState() => _TimesheetsTabState();
}

class _TimesheetsTabState extends State<TimesheetsTab> {
  String? selectedFilter = 'today'; // 'today', 'this_week', 'this_month'
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentWeekStart;
  String selectedStore = 'test1';

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _getWeekStart(_selectedDate);
  }

  /// Get Monday of the week for a given date
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday; // Monday = 1, Sunday = 7
    return date.subtract(Duration(days: weekday - 1));
  }

  /// Format week range (e.g., "1-7 Dec")
  String _formatWeekRange() {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    final startDay = _currentWeekStart.day;
    final endDay = weekEnd.day;
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
    ][_currentWeekStart.month - 1];

    return '$startDay-$endDay $month';
  }

  /// Get week label
  String _getWeekLabel() {
    final now = DateTime.now();
    final currentWeekStart = _getWeekStart(now);

    if (_currentWeekStart.isAtSameMomentAs(currentWeekStart)) {
      return 'This week';
    } else if (_currentWeekStart.isBefore(currentWeekStart)) {
      return 'Previous week';
    } else {
      return 'Next week';
    }
  }

  /// Change week
  void _changeWeek(int days) {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: days));
      // Also update selected date to first day of new week if needed
      if (!_isDateInCurrentWeek(_selectedDate)) {
        _selectedDate = _currentWeekStart;
      }
    });
  }

  /// Jump to current week
  void _jumpToToday() {
    final now = DateTime.now();
    setState(() {
      _currentWeekStart = _getWeekStart(now);
      _selectedDate = now;
    });
  }

  /// Check if date is in current week
  bool _isDateInCurrentWeek(DateTime date) {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    return date.isAfter(_currentWeekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  /// Mock problems data - replace with real data from provider
  List<AttendanceProblem> get _mockProblems {
    final now = DateTime.now();
    return [
      AttendanceProblem(
        id: '1',
        type: ProblemType.noCheckout,
        name: 'Alex Rivera',
        date: now,
        shiftName: 'Morning',
        avatarUrl: 'https://app.banani.co/avatar1.jpeg',
      ),
      AttendanceProblem(
        id: '2',
        type: ProblemType.noCheckin,
        name: 'Jamie Lee',
        date: now,
        shiftName: 'Morning',
        avatarUrl: 'https://app.banani.co/avatar2.jpg',
      ),
      AttendanceProblem(
        id: '3',
        type: ProblemType.overtime,
        name: 'Sarah Kim',
        date: now.add(const Duration(days: 1)),
        shiftName: 'Afternoon',
        avatarUrl: 'https://app.banani.co/avatar5.jpg',
      ),
      AttendanceProblem(
        id: '4',
        type: ProblemType.understaffed,
        name: 'Evening Shift',
        date: now.add(const Duration(days: 1)),
        shiftName: 'Evening',
        timeRange: '18:00 - 22:00',
        isShiftProblem: true,
      ),
    ];
  }

  /// Filter problems by selected time range
  List<AttendanceProblem> get _filteredProblems {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _mockProblems.where((problem) {
      final problemDate = DateTime(problem.date.year, problem.date.month, problem.date.day);

      switch (selectedFilter) {
        case 'today':
          return problemDate.isAtSameMomentAs(today);
        case 'this_week':
          final weekStart = _getWeekStart(now);
          final weekEnd = weekStart.add(const Duration(days: 6));
          return problemDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
              problemDate.isBefore(weekEnd.add(const Duration(days: 1)));
        case 'this_month':
          return problemDate.year == now.year && problemDate.month == now.month;
        default:
          return true;
      }
    }).toList();
  }

  /// Get problem count for each filter
  int _getProblemCount(String filter) {
    final tempFilter = selectedFilter;
    selectedFilter = filter;
    final count = _filteredProblems.length;
    selectedFilter = tempFilter;
    return count;
  }

  /// Get dates with problems (for week picker dots)
  Set<DateTime> _getDatesWithProblems() {
    return _mockProblems
        .map((p) => DateTime(p.date.year, p.date.month, p.date.day))
        .toSet();
  }

  /// Mock shift data for selected date - replace with real data from provider
  List<ShiftTimelog> get _mockShifts {
    return [
      ShiftTimelog(
        shiftId: '1',
        shiftName: 'Morning',
        timeRange: '09:00 - 13:00',
        assignedCount: 3,
        totalCount: 3,
        problemCount: 2,
        date: _selectedDate,
        staffRecords: [
          // Normal - no issues, confirmed (no chip, no "confirmed" text needed)
          StaffTimeRecord(
            staffId: '1',
            staffName: 'Alex R.',
            avatarUrl: 'https://app.banani.co/avatar1.jpeg',
            clockIn: '09:00',
            clockOut: '13:00',
            isLate: false,
            isOvertime: false,
            needsConfirm: false,
            isConfirmed: true,
          ),
          // Late - NOT confirmed (red start time + "Need Confirm" + Late chip)
          StaffTimeRecord(
            staffId: '2',
            staffName: 'Sarah K.',
            avatarUrl: 'https://app.banani.co/avatar5.jpg',
            clockIn: '09:05',
            clockOut: '13:00',
            isLate: true,
            isOvertime: false,
            needsConfirm: true,
            isConfirmed: false,
          ),
          // OT - NOT confirmed (red end time + "Need Confirm" + OT chip)
          StaffTimeRecord(
            staffId: '3',
            staffName: 'Mike T.',
            avatarUrl: 'https://app.banani.co/avatar3.jpeg',
            clockIn: '09:00',
            clockOut: '13:15',
            isLate: false,
            isOvertime: true,
            needsConfirm: true,
            isConfirmed: false,
          ),
        ],
      ),
      ShiftTimelog(
        shiftId: '2',
        shiftName: 'Afternoon',
        timeRange: '13:00 - 17:00',
        assignedCount: 4,
        totalCount: 5,
        problemCount: 1, // Taylor K. is late but confirmed
        date: _selectedDate,
        staffRecords: [
          // Normal - no issues, confirmed
          StaffTimeRecord(
            staffId: '4',
            staffName: 'Morgan C.',
            avatarUrl: 'https://app.banani.co/avatar4.jpg',
            clockIn: '13:00',
            clockOut: '17:00',
            isLate: false,
            isOvertime: false,
            needsConfirm: false,
            isConfirmed: true,
          ),
          // Normal - no issues, confirmed
          StaffTimeRecord(
            staffId: '5',
            staffName: 'Sam P.',
            clockIn: '13:00',
            clockOut: '17:00',
            isLate: false,
            isOvertime: false,
            needsConfirm: false,
            isConfirmed: true,
          ),
          // Late - CONFIRMED (blue start time + "Confirmed" + Late chip)
          StaffTimeRecord(
            staffId: '6',
            staffName: 'Taylor K.',
            avatarUrl: 'https://app.banani.co/avatar6.jpg',
            clockIn: '13:05',
            clockOut: '17:00',
            isLate: true,
            isOvertime: false,
            needsConfirm: false,
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
        problemCount: 1, // Chris N. has overtime and confirmed
        date: _selectedDate,
        staffRecords: [
          // Normal - no issues, confirmed
          StaffTimeRecord(
            staffId: '7',
            staffName: 'Jamie L.',
            avatarUrl: 'https://app.banani.co/avatar2.jpg',
            clockIn: '17:00',
            clockOut: '22:00',
            isLate: false,
            isOvertime: false,
            needsConfirm: false,
            isConfirmed: true,
          ),
          // OT - CONFIRMED (blue end time + "Confirmed" + OT chip)
          StaffTimeRecord(
            staffId: '8',
            staffName: 'Chris N.',
            clockIn: '17:10',
            clockOut: '22:15',
            isLate: false,
            isOvertime: true,
            needsConfirm: false,
            isConfirmed: true,
          ),
        ],
      ),
    ];
  }

  String _formatSelectedDate(DateTime date) {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector
          Text(
            'Store',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          InkWell(
            onTap: () {
              // TODO: Show store selector
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2 + 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: TossColors.gray200),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedStore,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: TossColors.gray600,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Gray divider after store selector
          const GrayDividerSpace(),

          const SizedBox(height: TossSpacing.space4),

          // "Problems" Section Header
          Text(
            'Problems',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Filter Chips
          TossChipGroup(
            items: [
              TossChipItem(
                value: 'today',
                label: 'Today',
                count: _getProblemCount('today'),
              ),
              TossChipItem(
                value: 'this_week',
                label: 'This week',
                count: _getProblemCount('this_week'),
              ),
              TossChipItem(
                value: 'this_month',
                label: 'This month',
                count: _getProblemCount('this_month'),
              ),
            ],
            selectedValue: selectedFilter,
            onChanged: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
          ),

          const SizedBox(height: TossSpacing.space3),

          // Problems List
          if (_filteredProblems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(TossSpacing.space8),
              child: TossEmptyView(
                title: 'No problems found',
                description: 'All attendance records look good!',
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _filteredProblems.length,
              itemBuilder: (context, index) {
                final problem = _filteredProblems[index];
                return ProblemCard(
                  problem: problem,
                  onTap: () {
                    setState(() {
                      _selectedDate = problem.date;
                    });
                  },
                );
              },
            ),

          const SizedBox(height: TossSpacing.space4),

          // Gray divider before week navigation
          const GrayDividerSpace(),

          const SizedBox(height: TossSpacing.space4),

          // Week Navigation
          TossWeekNavigation(
            weekLabel: _getWeekLabel(),
            dateRange: _formatWeekRange(),
            onPrevWeek: () => _changeWeek(-7),
            onCurrentWeek: _jumpToToday,
            onNextWeek: () => _changeWeek(7),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Week Dates Picker
          WeekDatesPicker(
            selectedDate: _selectedDate,
            weekStartDate: _currentWeekStart,
            datesWithUserApproved: {},
            shiftAvailabilityMap: {},
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
            },
          ),

          const SizedBox(height: TossSpacing.space4),

          const SizedBox(height: 16),

          // Timelogs section header
          Text(
            'Timelogs for ${_formatSelectedDate(_selectedDate)}',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Shift sections
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _mockShifts.length,
            itemBuilder: (context, index) {
              final shift = _mockShifts[index];
              return ShiftSection(
                shift: shift,
                initiallyExpanded: false, // All sections collapsed by default
              );
            },
          ),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
}
