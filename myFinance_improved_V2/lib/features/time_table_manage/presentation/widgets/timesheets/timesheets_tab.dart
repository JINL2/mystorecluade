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
import 'package:myfinance_improved/shared/widgets/toss/month_dates_picker.dart';
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
  /// Initial filter to apply when tab is shown (e.g., 'this_month')
  final String? initialFilter;
  /// Selected date (shared with parent and other tabs)
  final DateTime selectedDate;
  /// Focused month (shared with parent and other tabs)
  final DateTime focusedMonth;
  /// Callback when date is selected
  final void Function(DateTime date)? onDateSelected;
  /// Callback when previous month is tapped
  final Future<void> Function()? onPreviousMonth;
  /// Callback when next month is tapped
  final Future<void> Function()? onNextMonth;

  const TimesheetsTab({
    super.key,
    this.selectedStoreId,
    this.onStoreChanged,
    this.onNavigateToSchedule,
    this.initialFilter,
    required this.selectedDate,
    required this.focusedMonth,
    this.onDateSelected,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  @override
  ConsumerState<TimesheetsTab> createState() => _TimesheetsTabState();
}

class _TimesheetsTabState extends ConsumerState<TimesheetsTab> {
  String? selectedFilter = 'today'; // 'today', 'this_week', 'this_month'
  bool _isExpanded = false; // Toggle between week and month view

  @override
  void initState() {
    super.initState();

    // Apply initial filter if provided
    if (widget.initialFilter != null) {
      selectedFilter = widget.initialFilter;
    }

    // Note: Data loading is handled by parent page (time_table_manage_page.dart)
    // Parent calls fetchManagerCards(forceRefresh: true) on page entry
    // We don't load data here to avoid duplicate RPC calls and race conditions
  }

  /// Get Monday of the week for current selected date
  DateTime get _currentWeekStart => _getWeekStart(widget.selectedDate);

  /// Toggle between week and month view
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Set the filter programmatically (called from parent)
  void setFilter(String filter) {
    if (mounted) {
      setState(() {
        selectedFilter = filter;
      });
    }
  }

  @override
  void didUpdateWidget(TimesheetsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if store changed - force refresh to get new store's data
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _loadMonthData(forceRefresh: true);
    }
    // Reload data if month changed
    if (widget.focusedMonth.month != oldWidget.focusedMonth.month ||
        widget.focusedMonth.year != oldWidget.focusedMonth.year) {
      _loadMonthData();
    }
    // Update filter if initialFilter changed
    if (widget.initialFilter != null && widget.initialFilter != oldWidget.initialFilter) {
      setState(() {
        selectedFilter = widget.initialFilter;
      });
    }
  }

  /// Load manager cards data for current selected date's month
  /// [forceRefresh] - If true, reload even if data is cached (use after save operations)
  void _loadMonthData({bool forceRefresh = false}) {
    if (widget.selectedStoreId == null) return;

    // Load manager cards (for time details)
    ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: widget.focusedMonth,
      forceRefresh: forceRefresh,
    );

    // Load monthly shift status (for understaffed detection)
    ref.read(monthlyShiftStatusProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: widget.focusedMonth,
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

  /// Get week label (e.g., "This week", "Next week", "Last week", or "Week 52")
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
      return 'Last week';
    }

    // Otherwise, return "Week [number]" (ISO week number)
    final weekNumber = _getIsoWeekNumber(_currentWeekStart);
    return 'Week $weekNumber';
  }

  /// Calculate ISO week number (1-53)
  /// ISO 8601: Week 1 is the week containing the first Thursday of the year
  int _getIsoWeekNumber(DateTime date) {
    // Find the Thursday of the current week
    final thursday = date.add(Duration(days: 4 - date.weekday));

    // Find January 1st of that Thursday's year
    final jan1 = DateTime(thursday.year, 1, 1);

    // Calculate the number of days from Jan 1 to the Thursday
    final daysDiff = thursday.difference(jan1).inDays;

    // Week number is (days / 7) + 1
    return (daysDiff / 7).floor() + 1;
  }

  /// Change week
  void _changeWeek(int days) {
    final newWeekStart = _currentWeekStart.add(Duration(days: days));
    final newSelectedDate = widget.selectedDate.add(Duration(days: days));

    // Notify parent of date change
    widget.onDateSelected?.call(newSelectedDate);
  }

  /// Jump to current week
  void _jumpToToday() {
    final now = DateTime.now();
    // Notify parent of date change
    widget.onDateSelected?.call(now);
  }

  /// Check if date is in current week
  bool _isDateInCurrentWeek(DateTime date) {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    return date.isAfter(_currentWeekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  /// Get problems from real data using problem_details_v2 (or fallback to legacy fields)
  /// Uses manager_shift_get_cards_v5 + get_monthly_shift_status_manager_v4
  /// Optimized: Uses cached consecutiveEndTimeMap from problemStatusProvider
  List<AttendanceProblem> _getProblemsFromRealData() {
    if (widget.selectedStoreId == null) return [];

    final List<AttendanceProblem> problems = [];

    // 1. Get problems from manager_shift_get_cards_v5 (approved cards only)
    final managerCardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));
    final allCards = managerCardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .where((card) => card.isApproved)
        .toList();

    // 2. Get pre-computed consecutiveEndTimeMap from problemStatusProvider (O(1) lookup)
    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: widget.selectedStoreId!,
      focusedMonth: widget.focusedMonth,
    )));
    final consecutiveEndTimeMap = problemData.consecutiveEndTimeMap;

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

      // Use pre-computed consecutiveEndTimeMap (O(1) instead of O(n))
      final mapKey = '${card.employee.userId}_${card.shiftDate}';
      final shiftEndTime = consecutiveEndTimeMap[mapKey] ?? _parseShiftEndTime(card.shiftEndTime);

      // Skip adding problems if shift is still in progress
      final isShiftInProgress = shiftEndTime != null && DateTime.now().isBefore(shiftEndTime);
      if (isShiftInProgress) continue;

      // Use problem_details_v2 exclusively (no legacy fallback)
      final pd = card.problemDetails;
      if (pd == null || pd.problemCount == 0) continue;

      // Collect all unsolved problems for this shift
      final List<ProblemType> problemTypes = [];
      String? reportReason;
      int? lateMinutes;
      int? overtimeMinutes;

      for (final problemItem in pd.problems) {
        // Skip solved problems
        if (problemItem.isSolved) continue;

        final problemType = _mapProblemItemToType(problemItem.type);
        if (problemType != null) {
          problemTypes.add(problemType);
          // Capture reason if this is a reported problem
          if (problemItem.reason != null) {
            reportReason = problemItem.reason;
          }
          // Capture actual minutes for late/overtime
          if (problemType == ProblemType.late && problemItem.actualMinutes != null) {
            lateMinutes = problemItem.actualMinutes;
          }
          if (problemType == ProblemType.overtime && problemItem.actualMinutes != null) {
            overtimeMinutes = problemItem.actualMinutes;
          }
        }
      }

      // Only add if there are unsolved problems
      if (problemTypes.isNotEmpty) {
        problems.add(AttendanceProblem(
          id: card.shiftRequestId,
          type: problemTypes.first,
          types: problemTypes,
          name: card.employee.userName,
          date: shiftDate,
          shiftName: card.shift.shiftName ?? 'Unknown',
          timeRange: shiftTimeRange,
          avatarUrl: card.employee.profileImage,
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
          reportReason: reportReason ?? card.reportReason,
          isProblemSolved: pd.isSolved,
          bonusAmount: card.bonusAmount ?? 0.0,
          salaryType: card.salaryType,
          salaryAmount: card.salaryAmount,
          basePay: card.basePay,
          totalPayWithBonus: card.totalPayWithBonus,
          paidHour: card.paidHour,
          lateMinute: lateMinutes ?? card.lateMinute,
          overtimeMinute: overtimeMinutes ?? card.overTimeMinute,
          shiftEndTime: shiftEndTime,
          // v5: Pass problemDetails for StaffTimeRecord
          problemDetails: pd,
        ));
      }
    }

    // NOTE: Understaffed shifts are NOT shown in Problems tab
    // This tab is for employee attendance issues only (Late, OT, No Checkout, etc.)
    // Understaffed is a scheduling issue, not an attendance problem

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
  /// Uses cached problemStatusProvider for performance
  /// Counts SHIFTS with problems (not individual problem types)
  /// One shift = one problem even if it has Late + OT + No Checkout
  int _getProblemCount(String filter) {
    if (widget.selectedStoreId == null) return 0;

    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: widget.selectedStoreId!,
      focusedMonth: widget.focusedMonth,
    )));

    switch (filter) {
      case 'today':
        return problemData.todayCount;
      case 'this_week':
        return problemData.thisWeekCount;
      case 'this_month':
        return problemData.thisMonthCount;
      default:
        return problemData.thisMonthCount;
    }
  }

  /// Get shift availability map for a date range
  ///
  /// Logic:
  /// - Blue dot: total_required > total_approved (understaffed)
  /// - Gray dot: total_required <= total_approved (fully staffed)
  ///
  /// [dates] - List of dates to check availability for
  Map<DateTime, ShiftAvailabilityStatus> _getShiftAvailabilityMapForDates(List<DateTime> dates) {
    if (widget.selectedStoreId == null || dates.isEmpty) return {};

    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));
    final Map<DateTime, ShiftAvailabilityStatus> availabilityMap = {};

    // Get shift metadata for total_required when no requests exist
    final hasMetadata = metadataAsync.hasValue && metadataAsync.value != null;
    final activeShifts = hasMetadata ? metadataAsync.value!.activeShifts : <ShiftMetadataItem>[];

    for (final date in dates) {
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
  /// Optimized: Uses cached consecutiveEndTimeMap from problemStatusProvider
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
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

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

    // 4. Get pre-computed consecutiveEndTimeMap from problemStatusProvider (O(1) lookup)
    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: widget.selectedStoreId!,
      focusedMonth: widget.focusedMonth,
    )));
    final consecutiveEndTimeMap = problemData.consecutiveEndTimeMap;

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

        // Use pre-computed consecutiveEndTimeMap (O(1) instead of O(n))
        // For consecutive shifts (e.g., Morning 10-14 + Afternoon 14-18),
        // use the LAST shift's end time (18:00) for all shifts
        final mapKey = '${req.employee.userId}_$selectedDateStr';
        final shiftEndTime = consecutiveEndTimeMap[mapKey] ?? _parseShiftEndTime(detailedCard?.shiftEndTime);

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
          // v4: New fields
          isReportedSolved: detailedCard?.isReportedSolved,
          managerMemos: detailedCard?.managerMemos ?? const [],
          shiftEndTime: shiftEndTime,
          // v5: Problem details from problem_details_v2
          problemDetails: detailedCard?.problemDetails,
        );
      }).toList();

      // Count shifts with problems (1 shift = 1 unit, not individual problem items)
      // A shift is "solved" ONLY when ALL problems are resolved:
      // - isSolved == true (general problems like late, overtime, no_checkout)
      // - AND if has reported → isReportSolved must also be true
      int unsolvedCount = 0;
      int solvedCount = 0;

      // DEBUG: Log shift and problem details
      debugPrint('=== SHIFT: ${shiftMeta.shiftName} ===');
      debugPrint('staffRecords count: ${staffRecords.length}');

      for (final r in staffRecords) {
        final pd = r.problemDetails;

        // DEBUG: Log each staff record
        debugPrint('  Staff: ${r.staffName}');
        debugPrint('    shiftRequestId: ${r.shiftRequestId}');
        debugPrint('    actualStart: ${r.actualStart}, confirmStart: ${r.confirmStartTime}');
        debugPrint('    actualEnd: ${r.actualEnd}, confirmEnd: ${r.confirmEndTime}');
        debugPrint('    problemDetails: ${pd != null ? "EXISTS" : "NULL"}');
        if (pd != null) {
          debugPrint('    problemCount: ${pd.problemCount}');
          debugPrint('    isSolved: ${pd.isSolved}');
          debugPrint('    isFullySolved: ${pd.isFullySolved}');
          debugPrint('    problems.length: ${pd.problems.length}');
          for (final p in pd.problems) {
            debugPrint('      - type: ${p.type}, isSolved: ${p.isSolved}, actualMinutes: ${p.actualMinutes}');
          }
        }

        if (pd != null && pd.problemCount > 0) {
          // Use isFullySolved which checks both isSolved AND reported status
          if (pd.isFullySolved) {
            solvedCount += 1;
          } else {
            unsolvedCount += 1;
          }
        }
      }

      debugPrint('  RESULT: unsolvedCount=$unsolvedCount, solvedCount=$solvedCount');

      // Format time range from shift metadata
      final startTimeStr = _formatTimeFromString(shiftMeta.startTime);
      final endTimeStr = _formatTimeFromString(shiftMeta.endTime);

      return ShiftTimelog(
        shiftId: shiftMeta.shiftId,
        shiftName: shiftMeta.shiftName,
        timeRange: '$startTimeStr - $endTimeStr',
        assignedCount: approvedRequests.length,
        totalCount: shiftMeta.targetCount,
        problemCount: unsolvedCount,
        solvedCount: solvedCount,
        date: widget.selectedDate,
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

  /// Parse shift end time string to DateTime
  /// Format: "2025-12-08 18:00" or "2025-12-08T18:00:00"
  DateTime? _parseShiftEndTime(String? shiftEndTimeStr) {
    if (shiftEndTimeStr == null || shiftEndTimeStr.isEmpty) return null;
    try {
      // Normalize: replace 'T' with space if present
      final normalized = shiftEndTimeStr.replaceAll('T', ' ');
      final parts = normalized.split(' ');
      if (parts.length < 2) return null;

      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      if (dateParts.length < 3 || timeParts.length < 2) return null;

      return DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
        int.parse(timeParts[0]), // hour
        int.parse(timeParts[1]), // minute
      );
    } catch (e) {
      return null;
    }
  }

  // NOTE: _findConsecutiveEndTime has been removed
  // Now using pre-computed consecutiveEndTimeMap from problemStatusProvider for O(1) lookup

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

  /// Map problem_details type string to ProblemType enum
  /// Returns null for unknown types
  ProblemType? _mapProblemItemToType(String type) {
    switch (type) {
      case 'late':
        return ProblemType.late;
      case 'overtime':
        return ProblemType.overtime;
      case 'no_checkout':
        return ProblemType.noCheckout;
      case 'no_checkin':
        return ProblemType.noCheckin;
      case 'early_leave':
        return ProblemType.earlyLeave;
      case 'absence':
        return ProblemType.noCheckin; // Map absence to noCheckin
      case 'reported':
        return ProblemType.reported;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: TossSpacing.space3);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TossSpacing.space2),

          // Store selector (with padding)
          Padding(
            padding: horizontalPadding,
            child: _buildStoreSelector(),
          ),

          // Gray divider after store selector (full width)
          const GrayDividerSpace(),

          // Problems Section (with padding)
          Padding(
            padding: horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          showDayNumber: selectedFilter == 'this_month',
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
                                shiftEndTime: problem.shiftEndTime,
                                // v5: Pass problemDetails for tag display
                                problemDetails: problem.problemDetails,
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
              ],
            ),
          ),

          // Gray divider before week navigation (full width)
          const GrayDividerSpace(),

          // Timelogs Section (with padding)
          Padding(
            padding: horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Week/Month Navigation with expand button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _isExpanded
                          ? _buildMonthNavigation()
                          : TossWeekNavigation(
                              weekLabel: _getWeekLabel(),
                              dateRange: _formatWeekRange(),
                              onPrevWeek: () => _changeWeek(-7),
                              onCurrentWeek: _jumpToToday,
                              onNextWeek: () => _changeWeek(7),
                            ),
                    ),
                    // Expand/Collapse button
                    IconButton(
                      onPressed: _toggleExpanded,
                      icon: Icon(
                        _isExpanded ? Icons.unfold_less : Icons.unfold_more,
                        color: TossColors.gray600,
                        size: 24,
                      ),
                      tooltip: _isExpanded ? 'Show week' : 'Show month',
                    ),
                  ],
                ),

                const SizedBox(height: TossSpacing.space3),

                // Week or Month Dates Picker
                if (_isExpanded)
                  MonthDatesPicker(
                    currentMonth: widget.focusedMonth,
                    selectedDate: widget.selectedDate,
                    problemStatusByDate: _getProblemStatusByDate(),
                    // Problems tab uses problem status only, NOT shift availability
                    // shiftAvailabilityMap is for Schedule tab only
                    onDateSelected: (date) {
                      widget.onDateSelected?.call(date);
                    },
                  )
                else
                  WeekDatesPicker(
                    selectedDate: widget.selectedDate,
                    weekStartDate: _currentWeekStart,
                    datesWithUserApproved: const {},
                    shiftAvailabilityMap: const {}, // Not used in Problems tab
                    problemStatusMap: _getProblemStatusByDate(), // Problems tab uses problem status
                    onDateSelected: (date) {
                      // Notify parent of date change
                      widget.onDateSelected?.call(date);
                    },
                  ),

                const SizedBox(height: TossSpacing.space4),

                // Timelogs section header
                Text(
                  'Timelogs for ${_formatSelectedDate(widget.selectedDate)}',
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
          ),
        ],
      ),
    );
  }

  /// Build month navigation widget
  Widget _buildMonthNavigation() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthName = months[widget.focusedMonth.month - 1];
    final year = widget.focusedMonth.year;

    return Row(
      children: [
        IconButton(
          onPressed: () => widget.onPreviousMonth?.call(),
          icon: Icon(Icons.chevron_left, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _jumpToToday,
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
          onPressed: () => widget.onNextMonth?.call(),
          icon: Icon(Icons.chevron_right, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  /// Get problem status for each date in the month
  /// Uses cached problemStatusProvider for performance
  /// Color logic:
  /// 🔴 Red: Unsolved problem (highest priority)
  /// 🟠 Orange: Unsolved report
  /// 🟢 Green: All solved
  /// ⚪ Gray: No problems
  Map<String, ProblemStatus> _getProblemStatusByDate() {
    if (widget.selectedStoreId == null) return {};

    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: widget.selectedStoreId!,
      focusedMonth: widget.focusedMonth,
    )));

    return problemData.statusByDate;
  }

  /// Get shift availability map for the entire month (uses unified method)
  Map<DateTime, ShiftAvailabilityStatus> _getMonthShiftAvailabilityMap() {
    final lastDay = DateTime(widget.focusedMonth.year, widget.focusedMonth.month + 1, 0);
    final monthDates = List.generate(
      lastDay.day,
      (day) => DateTime(widget.focusedMonth.year, widget.focusedMonth.month, day + 1),
    );
    return _getShiftAvailabilityMapForDates(monthDates);
  }

  /// Build store selector dropdown
  Widget _buildStoreSelector() {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];

    // Get stores from selected company only (no fallback to prevent showing wrong company's stores)
    List<dynamic> stores = [];
    if (companies.isNotEmpty && appState.companyChoosen.isNotEmpty) {
      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        if (companyMap['company_id']?.toString() == appState.companyChoosen) {
          stores = (companyMap['stores'] as List<dynamic>?) ?? [];
          break;
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
