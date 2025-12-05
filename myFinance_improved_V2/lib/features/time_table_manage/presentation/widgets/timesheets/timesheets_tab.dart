import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_chip.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_week_navigation.dart';
import 'package:myfinance_improved/shared/widgets/toss/week_dates_picker.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import '../../../../../app/providers/app_state_provider.dart';
import '../../providers/time_table_providers.dart';
import '../../../domain/entities/shift_metadata_item.dart';
import '../../../domain/entities/shift_card.dart';
import 'problem_card.dart';
import 'shift_section.dart';
import 'staff_timelog_card.dart';
import '../../pages/staff_timelog_detail_page.dart';

/// Timesheets tab - Problems view for attendance tracking
class TimesheetsTab extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final void Function(String storeId)? onStoreChanged;
  /// Callback to navigate to Schedule tab with a specific date
  final void Function(DateTime date)? onNavigateToSchedule;

  const TimesheetsTab({
    super.key,
    this.selectedStoreId,
    this.onStoreChanged,
    this.onNavigateToSchedule,
  });

  @override
  ConsumerState<TimesheetsTab> createState() => _TimesheetsTabState();
}

class _TimesheetsTabState extends ConsumerState<TimesheetsTab> {
  String? selectedFilter = 'today'; // 'today', 'this_week', 'this_month'
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentWeekStart;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _getWeekStart(_selectedDate);

    // Load data for current month
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthData();
    });
  }

  @override
  void didUpdateWidget(TimesheetsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if store changed
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _loadMonthData();
    }
  }

  /// Load manager cards data for current selected date's month
  /// [forceRefresh] - If true, reload even if data is cached (use after save operations)
  void _loadMonthData({bool forceRefresh = false}) {
    if (widget.selectedStoreId == null) return;

    // Load manager cards (for time details)
    ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: _selectedDate,
      forceRefresh: forceRefresh,
    );

    // Also invalidate shift metadata to ensure fresh data
    ref.invalidate(shiftMetadataProvider(widget.selectedStoreId!));
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
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekStart = _getWeekStart(today);

    // Compare year, month, day only (ignore time)
    if (_currentWeekStart.year == currentWeekStart.year &&
        _currentWeekStart.month == currentWeekStart.month &&
        _currentWeekStart.day == currentWeekStart.day) {
      return 'This week';
    }

    // Check if it's next week (7 days ahead)
    final nextWeekStart = currentWeekStart.add(const Duration(days: 7));
    if (_currentWeekStart.year == nextWeekStart.year &&
        _currentWeekStart.month == nextWeekStart.month &&
        _currentWeekStart.day == nextWeekStart.day) {
      return 'Next week';
    }

    // Check if it's previous week (7 days back)
    final previousWeekStart = currentWeekStart.subtract(const Duration(days: 7));
    if (_currentWeekStart.year == previousWeekStart.year &&
        _currentWeekStart.month == previousWeekStart.month &&
        _currentWeekStart.day == previousWeekStart.day) {
      return 'Previous week';
    }

    // Otherwise, return "Week of [date]"
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return 'Week of ${_currentWeekStart.day} ${months[_currentWeekStart.month - 1]}';
  }

  /// Change week
  void _changeWeek(int days) {
    final oldMonth = _selectedDate.month;
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: days));
      // Also update selected date to first day of new week if needed
      if (!_isDateInCurrentWeek(_selectedDate)) {
        _selectedDate = _currentWeekStart;
      }
    });

    // Load new month data if month changed
    if (_selectedDate.month != oldMonth) {
      _loadMonthData();
    }
  }

  /// Jump to current week
  void _jumpToToday() {
    final now = DateTime.now();
    final oldMonth = _selectedDate.month;
    setState(() {
      _currentWeekStart = _getWeekStart(now);
      _selectedDate = now;
    });

    // Load new month data if month changed
    if (now.month != oldMonth) {
      _loadMonthData();
    }
  }

  /// Check if date is in current week
  bool _isDateInCurrentWeek(DateTime date) {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    return date.isAfter(_currentWeekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  /// Get problems from real data (manager_shift_get_cards_v3 + get_monthly_shift_status_manager_v4)
  List<AttendanceProblem> _getProblemsFromRealData() {
    if (widget.selectedStoreId == null) return [];

    final List<AttendanceProblem> problems = [];

    // 1. Get problems from manager_shift_get_cards_v3 (approved cards only)
    final managerCardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));
    final allCards = managerCardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .where((card) => card.isApproved)
        .toList();

    for (final card in allCards) {
      final shiftDate = DateTime.tryParse(card.shiftDate) ?? DateTime.now();

      // Get clock in/out times for staff detail
      final clockInRaw = card.actualStartRaw ?? card.confirmedStartRaw;
      final clockOutRaw = card.actualEndRaw ?? card.confirmedEndRaw;
      final clockInStr = _formatTimeFromString(clockInRaw);
      final clockOutStr = _formatTimeFromString(clockOutRaw);

      // Format shift time range from planStartTime/planEndTime (DateTime)
      final shiftStartStr = '${card.shift.planStartTime.hour.toString().padLeft(2, '0')}:${card.shift.planStartTime.minute.toString().padLeft(2, '0')}';
      final shiftEndStr = '${card.shift.planEndTime.hour.toString().padLeft(2, '0')}:${card.shift.planEndTime.minute.toString().padLeft(2, '0')}';
      final shiftTimeRange = '$shiftStartStr - $shiftEndStr';

      // Check confirmed status
      final isConfirmed = card.confirmedStartRaw != null || card.confirmedEndRaw != null;

      // No check-out: actual_end_time == null AND confirmed_end_time == null
      if (card.actualEndTime == null && card.confirmedEndTime == null) {
        problems.add(AttendanceProblem(
          id: '${card.shiftRequestId}_nocheckout',
          type: ProblemType.noCheckout,
          name: card.employee.userName,
          date: shiftDate,
          shiftName: card.shift.shiftName ?? 'Unknown',
          timeRange: shiftTimeRange,
          avatarUrl: card.employee.profileImage,
          // Staff-specific fields
          staffId: card.employee.userId,
          shiftRequestId: card.shiftRequestId,
          clockIn: clockInStr,
          clockOut: clockOutStr,
          isLate: card.isLate,
          isOvertime: card.isOverTime,
          isConfirmed: isConfirmed,
          actualStart: card.actualStartRaw,
          actualEnd: card.actualEndRaw,
          confirmStartTime: card.confirmedStartRaw,
          confirmEndTime: card.confirmedEndRaw,
          isReported: card.isReported,
          reportReason: card.reportReason,
          isProblemSolved: card.isProblemSolved,
          bonusAmount: card.bonusAmount ?? 0.0,
          salaryType: card.salaryType,
          salaryAmount: card.salaryAmount,
          basePay: card.basePay,
          totalPayWithBonus: card.totalPayWithBonus,
          paidHour: card.paidHour,
          lateMinute: card.lateMinute,
          overtimeMinute: card.overTimeMinute,
        ));
      }

      // Overtime: is_over_time = true
      if (card.isOverTime) {
        problems.add(AttendanceProblem(
          id: '${card.shiftRequestId}_overtime',
          type: ProblemType.overtime,
          name: card.employee.userName,
          date: shiftDate,
          shiftName: card.shift.shiftName ?? 'Unknown',
          timeRange: shiftTimeRange,
          avatarUrl: card.employee.profileImage,
          // Staff-specific fields
          staffId: card.employee.userId,
          shiftRequestId: card.shiftRequestId,
          clockIn: clockInStr,
          clockOut: clockOutStr,
          isLate: card.isLate,
          isOvertime: card.isOverTime,
          isConfirmed: isConfirmed,
          actualStart: card.actualStartRaw,
          actualEnd: card.actualEndRaw,
          confirmStartTime: card.confirmedStartRaw,
          confirmEndTime: card.confirmedEndRaw,
          isReported: card.isReported,
          reportReason: card.reportReason,
          isProblemSolved: card.isProblemSolved,
          bonusAmount: card.bonusAmount ?? 0.0,
          salaryType: card.salaryType,
          salaryAmount: card.salaryAmount,
          basePay: card.basePay,
          totalPayWithBonus: card.totalPayWithBonus,
          paidHour: card.paidHour,
          lateMinute: card.lateMinute,
          overtimeMinute: card.overTimeMinute,
        ));
      }

      // Late: is_late = true
      if (card.isLate) {
        problems.add(AttendanceProblem(
          id: '${card.shiftRequestId}_late',
          type: ProblemType.late,
          name: card.employee.userName,
          date: shiftDate,
          shiftName: card.shift.shiftName ?? 'Unknown',
          timeRange: shiftTimeRange,
          avatarUrl: card.employee.profileImage,
          // Staff-specific fields
          staffId: card.employee.userId,
          shiftRequestId: card.shiftRequestId,
          clockIn: clockInStr,
          clockOut: clockOutStr,
          isLate: card.isLate,
          isOvertime: card.isOverTime,
          isConfirmed: isConfirmed,
          actualStart: card.actualStartRaw,
          actualEnd: card.actualEndRaw,
          confirmStartTime: card.confirmedStartRaw,
          confirmEndTime: card.confirmedEndRaw,
          isReported: card.isReported,
          reportReason: card.reportReason,
          isProblemSolved: card.isProblemSolved,
          bonusAmount: card.bonusAmount ?? 0.0,
          salaryType: card.salaryType,
          salaryAmount: card.salaryAmount,
          basePay: card.basePay,
          totalPayWithBonus: card.totalPayWithBonus,
          paidHour: card.paidHour,
          lateMinute: card.lateMinute,
          overtimeMinute: card.overTimeMinute,
        ));
      }
    }

    // 2. Get understaffed from get_monthly_shift_status_manager_v4
    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));
    for (final monthlyStatus in monthlyStatusState.allMonthlyStatuses) {
      for (final dailyData in monthlyStatus.dailyShifts) {
        for (final shiftWithReqs in dailyData.shifts) {
          final shift = shiftWithReqs.shift;
          final totalRequired = shift.targetCount;
          final totalApproved = shiftWithReqs.approvedRequests.length;

          // Understaffed: total_required > total_approved
          if (totalRequired > totalApproved) {
            final shiftDate = DateTime.tryParse(dailyData.date) ?? DateTime.now();
            final startTimeStr = '${shift.planStartTime.hour.toString().padLeft(2, '0')}:${shift.planStartTime.minute.toString().padLeft(2, '0')}';
            final endTimeStr = '${shift.planEndTime.hour.toString().padLeft(2, '0')}:${shift.planEndTime.minute.toString().padLeft(2, '0')}';

            problems.add(AttendanceProblem(
              id: '${shift.shiftId}_${dailyData.date}_understaffed',
              type: ProblemType.understaffed,
              name: shift.shiftName ?? 'Unknown Shift',
              date: shiftDate,
              shiftName: shift.shiftName ?? 'Unknown',
              timeRange: '$startTimeStr - $endTimeStr',
              isShiftProblem: true,
            ));
          }
        }
      }
    }

    return problems;
  }

  /// Filter problems by selected time range
  List<AttendanceProblem> _getFilteredProblems(String filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final allProblems = _getProblemsFromRealData();

    return allProblems.where((problem) {
      final problemDate = DateTime(problem.date.year, problem.date.month, problem.date.day);

      switch (filter) {
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
    return _getFilteredProblems(filter).length;
  }

  /// Get shift availability map for the week
  ///
  /// Logic:
  /// - Blue dot: total_required > total_approved (understaffed)
  /// - Gray dot: total_required <= total_approved (fully staffed)
  Map<DateTime, ShiftAvailabilityStatus> _getShiftAvailabilityMap() {
    if (widget.selectedStoreId == null) return {};

    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));
    final Map<DateTime, ShiftAvailabilityStatus> availabilityMap = {};

    // Get shift metadata for total_required when no requests exist
    final hasMetadata = metadataAsync.hasValue && metadataAsync.value != null;
    final activeShifts = hasMetadata ? metadataAsync.value!.activeShifts : <ShiftMetadataItem>[];

    // Check each day of the week
    for (int i = 0; i < 7; i++) {
      final date = _currentWeekStart.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      // Find daily shift data for this date
      final dailyShiftData = monthlyStatusState.allMonthlyStatuses
          .expand((status) => status.dailyShifts)
          .where((daily) => daily.date == dateStr)
          .firstOrNull;

      int totalRequired = 0;
      int totalApproved = 0;

      if (dailyShiftData != null && dailyShiftData.shifts.isNotEmpty) {
        // Has request data - use it
        for (final shiftWithReqs in dailyShiftData.shifts) {
          totalRequired += shiftWithReqs.shift.targetCount;
          totalApproved += shiftWithReqs.approvedRequests.length;
        }
      } else if (activeShifts.isNotEmpty) {
        // No request data but has active shifts - use metadata
        // All shifts are understaffed (0 approved, total_required from metadata)
        for (final shiftMeta in activeShifts) {
          totalRequired += shiftMeta.targetCount;
        }
        // totalApproved stays 0
      } else {
        // No shifts configured - no dot
        continue;
      }

      // Determine availability status
      if (totalRequired > totalApproved) {
        // Understaffed - blue dot
        availabilityMap[normalizedDate] = ShiftAvailabilityStatus.available;
      } else {
        // Fully staffed - gray dot
        availabilityMap[normalizedDate] = ShiftAvailabilityStatus.full;
      }
    }

    return availabilityMap;
  }

  /// Get shift timelogs for selected date from real data
  /// Uses shiftMetadataProvider for ALL shifts (like Schedule tab)
  /// Uses monthlyShiftStatusProvider for approved employees
  /// Uses managerCardsProvider for detailed time info (isLate, isOverTime, etc.)
  List<ShiftTimelog> _getShiftsForSelectedDate() {
    if (widget.selectedStoreId == null) return [];

    // 1. Get shift metadata (ALL active shifts) - same as Schedule tab
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));
    if (!metadataAsync.hasValue || metadataAsync.value == null) {
      return [];
    }

    final metadata = metadataAsync.value!;
    final activeShifts = metadata.activeShifts;

    if (activeShifts.isEmpty) return [];

    // 2. Get monthly shift status (approved/pending employees)
    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Find daily shift data for selected date
    final dailyShiftData = monthlyStatusState.allMonthlyStatuses
        .expand((status) => status.dailyShifts)
        .where((daily) => daily.date == selectedDateStr)
        .firstOrNull;

    // 3. Get manager cards for detailed time info (actual times, isLate, isOverTime)
    // Match by shiftRequestId (both ShiftRequest and ShiftCard have this field)
    final managerCardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));
    final allApprovedCards = managerCardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .where((card) => card.isApproved && card.shiftDate == selectedDateStr)
        .toList();

    // Create a map of shiftRequestId -> ShiftCard for quick lookup
    final Map<String, ShiftCard> cardsByRequestId = {};
    for (final card in allApprovedCards) {
      cardsByRequestId[card.shiftRequestId] = card;
    }

    // 4. Build ShiftTimelog for ALL active shifts
    return activeShifts.map((shiftMeta) {
      // Find shift with requests for this shift ID
      final shiftWithRequests = dailyShiftData?.shifts
          .where((s) => s.shift.shiftId == shiftMeta.shiftId)
          .firstOrNull;

      // Get approved employees from monthlyShiftStatusProvider
      final approvedRequests = shiftWithRequests?.approvedRequests ?? [];

      // Build staff records with detailed time info from manager cards
      final staffRecords = approvedRequests.map((req) {
        // Get detailed card info by matching shiftRequestId
        final detailedCard = cardsByRequestId[req.shiftRequestId];

        // Use raw time strings from RPC (no DateTime conversion)
        // Clock in: actual_start_raw -> confirmed_start_raw
        final clockInRaw = detailedCard?.actualStartRaw ?? detailedCard?.confirmedStartRaw;
        final clockInStr = _formatTimeFromString(clockInRaw);

        // Clock out: actual_end_raw -> confirmed_end_raw
        final clockOutRaw = detailedCard?.actualEndRaw ?? detailedCard?.confirmedEndRaw;
        final clockOutStr = _formatTimeFromString(clockOutRaw);

        // Get isLate and isOverTime from detailed card
        final isLate = detailedCard?.isLate ?? false;
        final isOverTime = detailedCard?.isOverTime ?? false;

        // Determine if confirmed (has confirmed times)
        final isConfirmed = detailedCard?.confirmedStartRaw != null ||
                            detailedCard?.confirmedEndRaw != null;

        // Needs confirm if late/overtime but not yet confirmed
        final needsConfirm = (isLate || isOverTime) && !isConfirmed;

        return StaffTimeRecord(
          staffId: req.employee.userId,
          staffName: req.employee.userName,
          avatarUrl: req.employee.profileImage,
          clockIn: clockInStr,
          clockOut: clockOutStr,
          isLate: isLate,
          isOvertime: isOverTime,
          needsConfirm: needsConfirm,
          isConfirmed: isConfirmed,
          // shiftRequestId for RPC calls
          shiftRequestId: req.shiftRequestId,
          // Use raw time strings from RPC directly (no conversion)
          actualStart: detailedCard?.actualStartRaw,
          actualEnd: detailedCard?.actualEndRaw,
          confirmStartTime: detailedCard?.confirmedStartRaw,
          confirmEndTime: detailedCard?.confirmedEndRaw,
          isReported: detailedCard?.isReported ?? false,
          reportReason: detailedCard?.reportReason,
          isProblemSolved: detailedCard?.isProblemSolved ?? false,
          bonusAmount: detailedCard?.bonusAmount ?? 0.0,
          salaryType: detailedCard?.salaryType,
          salaryAmount: detailedCard?.salaryAmount,
          basePay: detailedCard?.basePay,
          totalPayWithBonus: detailedCard?.totalPayWithBonus,
          paidHour: detailedCard?.paidHour ?? 0.0,
          lateMinute: detailedCard?.lateMinute ?? 0,
          overtimeMinute: detailedCard?.overTimeMinute ?? 0,
        );
      }).toList();

      // Count problems (late or overtime)
      final problemCount = staffRecords.where((r) => r.isLate || r.isOvertime).length;

      // Format time range from shift metadata
      final startTimeStr = _formatTimeFromString(shiftMeta.startTime);
      final endTimeStr = _formatTimeFromString(shiftMeta.endTime);

      return ShiftTimelog(
        shiftId: shiftMeta.shiftId,
        shiftName: shiftMeta.shiftName,
        timeRange: '$startTimeStr - $endTimeStr',
        assignedCount: approvedRequests.length,
        totalCount: shiftMeta.targetCount,
        problemCount: problemCount,
        date: _selectedDate,
        staffRecords: staffRecords,
      );
    }).toList();
  }

  /// Format time string to HH:mm format (e.g., "02:00:00+07" -> "02:00")
  String _formatTimeFromString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '--:--';

    try {
      // Remove timezone offset and seconds (e.g., "02:00:00+07" -> "02:00")
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
    } catch (e) {
      // Return original on error
    }

    return timeString;
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
          _buildStoreSelector(),

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
          Builder(
            builder: (context) {
              final filteredProblems = _getFilteredProblems(selectedFilter ?? 'today');
              if (filteredProblems.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(TossSpacing.space8),
                  child: TossEmptyView(
                    title: 'No problems found',
                    description: 'All attendance records look good!',
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: filteredProblems.length,
                itemBuilder: (context, index) {
                  final problem = filteredProblems[index];
                  return ProblemCard(
                    problem: problem,
                    onTap: () async {
                      // Staff problems navigate to detail page
                      if (!problem.isShiftProblem && problem.staffId != null) {
                        // Create StaffTimeRecord from problem data
                        final staffRecord = StaffTimeRecord(
                          staffId: problem.staffId!,
                          staffName: problem.name,
                          avatarUrl: problem.avatarUrl,
                          clockIn: problem.clockIn ?? '--:--',
                          clockOut: problem.clockOut ?? '--:--',
                          isLate: problem.isLate,
                          isOvertime: problem.isOvertime,
                          needsConfirm: !problem.isConfirmed && (problem.isLate || problem.isOvertime),
                          isConfirmed: problem.isConfirmed,
                          shiftRequestId: problem.shiftRequestId,
                          actualStart: problem.actualStart,
                          actualEnd: problem.actualEnd,
                          confirmStartTime: problem.confirmStartTime,
                          confirmEndTime: problem.confirmEndTime,
                          isReported: problem.isReported,
                          reportReason: problem.reportReason,
                          isProblemSolved: problem.isProblemSolved,
                          bonusAmount: problem.bonusAmount,
                          salaryType: problem.salaryType,
                          salaryAmount: problem.salaryAmount,
                          basePay: problem.basePay,
                          totalPayWithBonus: problem.totalPayWithBonus,
                          paidHour: problem.paidHour,
                          lateMinute: problem.lateMinute,
                          overtimeMinute: problem.overtimeMinute,
                        );

                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute<bool>(
                            builder: (context) => StaffTimelogDetailPage(
                              staffRecord: staffRecord,
                              shiftName: problem.shiftName,
                              shiftDate: DateFormat('EEE, d MMM yyyy').format(problem.date),
                              shiftTimeRange: problem.timeRange ?? '--:-- - --:--',
                            ),
                          ),
                        );
                        // Refresh data if save was successful (force refresh to bypass cache)
                        if (result == true) {
                          _loadMonthData(forceRefresh: true);
                        }
                      } else {
                        // Shift problems (understaffed) navigate to Schedule tab
                        if (widget.onNavigateToSchedule != null) {
                          widget.onNavigateToSchedule!(problem.date);
                        }
                      }
                    },
                  );
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
            datesWithUserApproved: const {},
            shiftAvailabilityMap: _getShiftAvailabilityMap(),
            onDateSelected: (date) {
              final oldMonth = _selectedDate.month;
              setState(() => _selectedDate = date);
              // Load new month data if month changed
              if (date.month != oldMonth) {
                _loadMonthData();
              }
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
          Builder(
            builder: (context) {
              final shifts = _getShiftsForSelectedDate();
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
                    initiallyExpanded: false, // All sections collapsed by default
                    onDataChanged: () => _loadMonthData(forceRefresh: true),
                  );
                },
              );
            },
          ),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  /// Build store selector dropdown
  Widget _buildStoreSelector() {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];

    // Get stores from selected company
    List<dynamic> stores = [];
    if (companies.isNotEmpty) {
      try {
        final selectedCompany = companies.firstWhere(
          (c) => (c as Map<String, dynamic>)['company_id'] == appState.companyChoosen,
        ) as Map<String, dynamic>;
        stores = (selectedCompany['stores'] as List<dynamic>?) ?? [];
      } catch (e) {
        if (companies.isNotEmpty) {
          final firstCompany = companies.first as Map<String, dynamic>;
          stores = (firstCompany['stores'] as List<dynamic>?) ?? [];
        }
      }
    }

    final storeItems = stores.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return TossDropdownItem<String>(
        value: storeMap['store_id']?.toString() ?? '',
        label: storeMap['store_name']?.toString() ?? 'Unknown',
      );
    }).toList();

    return TossDropdown<String>(
      label: 'Store',
      value: widget.selectedStoreId,
      items: storeItems,
      onChanged: (newValue) {
        if (newValue != null && newValue != widget.selectedStoreId) {
          widget.onStoreChanged?.call(newValue);
        }
      },
    );
  }
}
