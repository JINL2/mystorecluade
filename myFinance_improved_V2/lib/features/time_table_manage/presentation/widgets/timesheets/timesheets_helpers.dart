import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/month_dates_picker.dart' show ProblemStatus;

import '../../../domain/entities/shift_card.dart';
import '../../providers/time_table_providers.dart';
import 'problem_card.dart';
import 'shift_section.dart' show ShiftTimelog;
import 'staff_timelog_card.dart' show StaffTimeRecord;

/// Mixin providing helper methods for TimesheetsTab
/// Includes date/time formatting and data processing utilities
mixin TimesheetsHelpersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Get Monday of the week for a given date
  DateTime getWeekStart(DateTime date) {
    final weekday = date.weekday; // Monday = 1, Sunday = 7
    return date.subtract(Duration(days: weekday - 1));
  }

  /// Format week range (e.g., "1-7 Dec")
  String formatWeekRange(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final startDay = weekStart.day;
    final endDay = weekEnd.day;
    final month = _getMonthAbbreviation(weekStart.month);
    return '$startDay-$endDay $month';
  }

  /// Get week label (e.g., "This week", "Next week", "Last week", or "Week 52")
  String getWeekLabel(DateTime weekStart) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekStart = getWeekStart(today);

    if (_isSameDay(weekStart, currentWeekStart)) {
      return 'This week';
    }

    final nextWeekStart = currentWeekStart.add(const Duration(days: 7));
    if (_isSameDay(weekStart, nextWeekStart)) {
      return 'Next week';
    }

    final previousWeekStart = currentWeekStart.subtract(const Duration(days: 7));
    if (_isSameDay(weekStart, previousWeekStart)) {
      return 'Last week';
    }

    final weekNumber = getIsoWeekNumber(weekStart);
    return 'Week $weekNumber';
  }

  /// Calculate ISO week number (1-53)
  int getIsoWeekNumber(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final jan1 = DateTime(thursday.year, 1, 1);
    final daysDiff = thursday.difference(jan1).inDays;
    return (daysDiff / 7).floor() + 1;
  }

  /// Format time string to HH:mm format (e.g., "02:00:00+07" -> "02:00")
  String formatTimeFromString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '--:--';
    try {
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
  DateTime? parseShiftEndTime(String? shiftEndTimeStr) {
    if (shiftEndTimeStr == null || shiftEndTimeStr.isEmpty) return null;
    try {
      final normalized = shiftEndTimeStr.replaceAll('T', ' ');
      final parts = normalized.split(' ');
      if (parts.length < 2) return null;

      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      if (dateParts.length < 3 || timeParts.length < 2) return null;

      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  /// Map problem_details type string to ProblemType enum
  ProblemType? mapProblemItemToType(String type) {
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
        return ProblemType.noCheckin;
      case 'reported':
        return ProblemType.reported;
      default:
        return null;
    }
  }

  /// Get problems from real data using problem_details
  List<AttendanceProblem> getProblemsFromRealData({
    required String? storeId,
    required DateTime focusedMonth,
  }) {
    if (storeId == null) return [];

    final List<AttendanceProblem> problems = [];

    // Get problems from manager_shift_get_cards_v6 (approved cards only)
    final managerCardsState = ref.watch(managerCardsProvider(storeId));
    final allCards = managerCardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .where((card) => card.isApproved)
        .toList();

    // Get pre-computed consecutiveEndTimeMap from problemStatusProvider
    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: storeId,
      focusedMonth: focusedMonth,
    )));
    final consecutiveEndTimeMap = problemData.consecutiveEndTimeMap;

    for (final card in allCards) {
      final shiftDate = DateTime.tryParse(card.shiftDate) ?? DateTime.now();

      final clockInRaw = card.actualStartRaw ?? card.confirmedStartRaw;
      final clockOutRaw = card.actualEndRaw ?? card.confirmedEndRaw;
      final clockInStr = formatTimeFromString(clockInRaw);
      final clockOutStr = formatTimeFromString(clockOutRaw);

      final shiftStartStr = '${card.shift.planStartTime.hour.toString().padLeft(2, '0')}:${card.shift.planStartTime.minute.toString().padLeft(2, '0')}';
      final shiftEndStr = '${card.shift.planEndTime.hour.toString().padLeft(2, '0')}:${card.shift.planEndTime.minute.toString().padLeft(2, '0')}';
      final shiftTimeRange = '$shiftStartStr - $shiftEndStr';

      final isConfirmed = card.confirmedStartRaw != null || card.confirmedEndRaw != null;

      final mapKey = '${card.employee.userId}_${card.shiftDate}';
      final shiftEndTime = consecutiveEndTimeMap[mapKey] ?? parseShiftEndTime(card.shiftEndTime);

      final isShiftInProgress = shiftEndTime != null && DateTime.now().isBefore(shiftEndTime);
      if (isShiftInProgress) continue;

      final pd = card.problemDetails;
      if (pd == null || pd.problemCount == 0) continue;

      final List<ProblemType> problemTypes = [];
      String? reportReason;
      int? lateMinutes;
      int? overtimeMinutes;

      for (final problemItem in pd.problems) {
        if (problemItem.isSolved) continue;

        final problemType = mapProblemItemToType(problemItem.type);
        if (problemType != null) {
          problemTypes.add(problemType);
          if (problemItem.reason != null) {
            reportReason = problemItem.reason;
          }
          if (problemType == ProblemType.late && problemItem.actualMinutes != null) {
            lateMinutes = problemItem.actualMinutes;
          }
          if (problemType == ProblemType.overtime && problemItem.actualMinutes != null) {
            overtimeMinutes = problemItem.actualMinutes;
          }
        }
      }

      if (problemTypes.isNotEmpty) {
        final hasLate = problemTypes.contains(ProblemType.late);
        final hasOvertime = problemTypes.contains(ProblemType.overtime);
        final hasReported = problemTypes.contains(ProblemType.reported);

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
          isLate: hasLate,
          isOvertime: hasOvertime,
          isConfirmed: isConfirmed,
          actualStart: card.actualStartRaw,
          actualEnd: card.actualEndRaw,
          confirmStartTime: card.confirmedStartRaw,
          confirmEndTime: card.confirmedEndRaw,
          isReported: hasReported,
          reportReason: reportReason,
          isProblemSolved: pd.isSolved,
          bonusAmount: card.bonusAmount ?? 0.0,
          salaryType: card.salaryType,
          salaryAmount: card.salaryAmount,
          basePay: card.basePay,
          totalPayWithBonus: card.totalPayWithBonus,
          paidHour: card.paidHour,
          lateMinute: lateMinutes ?? 0,
          overtimeMinute: overtimeMinutes ?? 0,
          shiftEndTime: shiftEndTime,
          problemDetails: pd,
        ));
      }
    }

    return problems;
  }

  /// Filter problems by selected time range
  List<AttendanceProblem> getFilteredProblems(String filter, List<AttendanceProblem> allProblems) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return allProblems.where((problem) {
      final problemDate = DateTime(problem.date.year, problem.date.month, problem.date.day);

      switch (filter) {
        case 'today':
          return problemDate.isAtSameMomentAs(today);
        case 'this_week':
          final weekStart = getWeekStart(now);
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
  int getProblemCount(String filter, String? storeId, DateTime focusedMonth) {
    if (storeId == null) return 0;

    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: storeId,
      focusedMonth: focusedMonth,
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

  /// Get shift timelogs for selected date
  List<ShiftTimelog> getShiftsForSelectedDate({
    required String? storeId,
    required DateTime selectedDate,
    required DateTime focusedMonth,
  }) {
    if (storeId == null) return [];

    final metadataAsync = ref.watch(shiftMetadataProvider(storeId));
    if (!metadataAsync.hasValue || metadataAsync.value == null) {
      return [];
    }

    final metadata = metadataAsync.value!;
    final activeShifts = metadata.activeShifts;
    if (activeShifts.isEmpty) return [];

    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(storeId));
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    final dailyShiftData = monthlyStatusState.allMonthlyStatuses
        .expand((status) => status.dailyShifts)
        .where((daily) => daily.date == selectedDateStr)
        .firstOrNull;

    final managerCardsState = ref.watch(managerCardsProvider(storeId));
    final allApprovedCards = managerCardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .where((card) => card.isApproved && card.shiftDate == selectedDateStr)
        .toList();

    final Map<String, ShiftCard> cardsByRequestId = {};
    for (final card in allApprovedCards) {
      cardsByRequestId[card.shiftRequestId] = card;
    }

    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: storeId,
      focusedMonth: focusedMonth,
    )));
    final consecutiveEndTimeMap = problemData.consecutiveEndTimeMap;

    return activeShifts.map((shiftMeta) {
      final shiftWithRequests = dailyShiftData?.shifts
          .where((s) => s.shift.shiftId == shiftMeta.shiftId)
          .firstOrNull;

      final approvedRequests = shiftWithRequests?.approvedRequests ?? [];

      final staffRecords = approvedRequests.map((req) {
        final detailedCard = cardsByRequestId[req.shiftRequestId];

        final clockInRaw = detailedCard?.actualStartRaw ?? detailedCard?.confirmedStartRaw;
        final clockInStr = formatTimeFromString(clockInRaw);

        final clockOutRaw = detailedCard?.actualEndRaw ?? detailedCard?.confirmedEndRaw;
        final clockOutStr = formatTimeFromString(clockOutRaw);

        final pd = detailedCard?.problemDetails;
        final hasLate = pd?.problems.any((p) => p.type == 'late' && !p.isSolved) ?? false;
        final hasOvertime = pd?.problems.any((p) => p.type == 'overtime' && !p.isSolved) ?? false;
        final reportedProblem = pd?.problems.where((p) => p.type == 'reported').firstOrNull;
        final isReported = reportedProblem != null;
        final lateProblem = pd?.problems.where((p) => p.type == 'late').firstOrNull;
        final overtimeProblem = pd?.problems.where((p) => p.type == 'overtime').firstOrNull;

        final isConfirmed = detailedCard?.confirmedStartRaw != null ||
                            detailedCard?.confirmedEndRaw != null;
        final needsConfirm = (hasLate || hasOvertime) && !isConfirmed;

        final mapKey = '${req.employee.userId}_$selectedDateStr';
        final shiftEndTime = consecutiveEndTimeMap[mapKey] ?? parseShiftEndTime(detailedCard?.shiftEndTime);

        return StaffTimeRecord(
          staffId: req.employee.userId,
          staffName: req.employee.userName,
          avatarUrl: req.employee.profileImage,
          clockIn: clockInStr,
          clockOut: clockOutStr,
          isLate: hasLate,
          isOvertime: hasOvertime,
          needsConfirm: needsConfirm,
          isConfirmed: isConfirmed,
          shiftRequestId: req.shiftRequestId,
          actualStart: detailedCard?.actualStartRaw,
          actualEnd: detailedCard?.actualEndRaw,
          confirmStartTime: detailedCard?.confirmedStartRaw,
          confirmEndTime: detailedCard?.confirmedEndRaw,
          isReported: isReported,
          reportReason: reportedProblem?.reason,
          isProblemSolved: pd?.isSolved ?? false,
          bonusAmount: detailedCard?.bonusAmount ?? 0.0,
          salaryType: detailedCard?.salaryType,
          salaryAmount: detailedCard?.salaryAmount,
          basePay: detailedCard?.basePay,
          totalPayWithBonus: detailedCard?.totalPayWithBonus,
          paidHour: detailedCard?.paidHour ?? 0.0,
          lateMinute: lateProblem?.actualMinutes ?? 0,
          overtimeMinute: overtimeProblem?.actualMinutes ?? 0,
          isReportedSolved: reportedProblem?.isSolved,
          managerMemos: detailedCard?.managerMemos ?? const [],
          shiftEndTime: shiftEndTime,
          problemDetails: pd,
        );
      }).toList();

      int unsolvedCount = 0;
      int solvedCount = 0;

      for (final r in staffRecords) {
        final pd = r.problemDetails;
        final shiftEnd = r.shiftEndTime;
        final isInProgress = shiftEnd != null && DateTime.now().isBefore(shiftEnd);

        if (pd != null && pd.problemCount > 0) {
          if (isInProgress) {
            final realProblems = pd.problems.where((p) =>
              !p.isSolved &&
              p.type != 'no_checkout' &&
              p.type != 'absence'
            ).toList();

            if (realProblems.isNotEmpty) {
              unsolvedCount += 1;
            }
          } else {
            if (pd.isFullySolved) {
              solvedCount += 1;
            } else {
              unsolvedCount += 1;
            }
          }
        }
      }

      final startTimeStr = formatTimeFromString(shiftMeta.startTime);
      final endTimeStr = formatTimeFromString(shiftMeta.endTime);

      return ShiftTimelog(
        shiftId: shiftMeta.shiftId,
        shiftName: shiftMeta.shiftName,
        timeRange: '$startTimeStr - $endTimeStr',
        assignedCount: approvedRequests.length,
        totalCount: shiftMeta.targetCount,
        problemCount: unsolvedCount,
        solvedCount: solvedCount,
        date: selectedDate,
        staffRecords: staffRecords,
      );
    }).toList();
  }

  /// Get problem status for each date in the month
  Map<String, ProblemStatus> getProblemStatusByDate(String? storeId, DateTime focusedMonth) {
    if (storeId == null) return {};

    final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
      storeId: storeId,
      focusedMonth: focusedMonth,
    )));

    return problemData.statusByDate;
  }

  // Private helpers
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
