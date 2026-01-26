import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/manager_shift_cards.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/manager_memo.dart';
import '../../pages/staff_timelog_detail_page.dart';
import '../../providers/states/time_table_state.dart';
import '../../providers/time_table_providers.dart';
import '../timesheets/staff_timelog_card.dart';
import 'shift_info_card.dart';

/// Helper functions for overview card builders
class OverviewCardHelpers {
  /// Format date for display (e.g., "Tue, 18 Jun 2025")
  static String formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, ${date.day} $month ${date.year}';
  }

  /// Format time range (e.g., "09:00 - 13:00")
  static String formatTimeRange(DateTime start, DateTime end) {
    final startStr = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endStr = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startStr - $endStr';
  }

  /// Parse shift end time string to DateTime
  static DateTime? parseShiftEndTime(String? shiftEndTimeStr) {
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

  /// Find the last consecutive shift end time for a staff member
  static DateTime? findConsecutiveEndTime({
    required String staffId,
    required String shiftDate,
    required DateTime? currentShiftEndTime,
    required List<ShiftCard> allCards,
  }) {
    if (currentShiftEndTime == null) return null;

    final staffShiftsOnDate = allCards
        .where((c) => c.employee.userId == staffId && c.shiftDate == shiftDate)
        .toList();

    if (staffShiftsOnDate.isEmpty) return currentShiftEndTime;

    final shiftEndTimes = <DateTime>[];
    for (final card in staffShiftsOnDate) {
      final endTime = parseShiftEndTime(card.shiftEndTime);
      if (endTime != null) {
        shiftEndTimes.add(endTime);
      }
    }

    if (shiftEndTimes.isEmpty) return currentShiftEndTime;

    shiftEndTimes.sort();
    return shiftEndTimes.last;
  }

  /// Get all cards from manager cards state
  static List<ShiftCard> getAllCards(ManagerShiftCardsState? cardsState) {
    if (cardsState == null) return [];
    return cardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .toList();
  }

  /// Get cards for a specific shift from manager cards data
  static List<ShiftCard> getCardsForShift(
    ManagerShiftCardsState? cardsState,
    String shiftName,
    String shiftDate,
  ) {
    if (cardsState == null) return [];

    return cardsState.dataByMonth.values
        .expand((m) => m.cards)
        .where((card) =>
            card.isApproved &&
            card.shiftDate == shiftDate &&
            card.shift.shiftName == shiftName)
        .toList();
  }
}

/// Builder for Current Activity card in Overview tab
class CurrentActivityCardBuilder extends ConsumerWidget {
  final String? selectedStoreId;
  final ShiftWithRequests? currentShift;
  final ManagerShiftCardsState? managerCardsState;
  final List<DailyShiftData> allDailyShifts;
  final VoidCallback? onDataUpdated;

  const CurrentActivityCardBuilder({
    super.key,
    required this.selectedStoreId,
    required this.currentShift,
    required this.managerCardsState,
    required this.allDailyShifts,
    this.onDataUpdated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If no shift data, show placeholder with dummy data
    if (currentShift == null) {
      return ShiftInfoCard(
        date: 'No shifts available',
        shiftName: '-',
        timeRange: '-',
        type: ShiftCardType.active,
        statusLabel: '0/0 arrived',
        statusType: ShiftStatusType.neutral,
        snapshotData: SnapshotData(
          onTime: SnapshotMetric(count: 0, employees: []),
          late: SnapshotMetric(count: 0, employees: []),
          notCheckedIn: SnapshotMetric(count: 0, employees: []),
        ),
      );
    }

    final shift = currentShift!.shift;
    final targetCount = currentShift!.approvedRequests.length;

    final shiftDate = '${shift.planStartTime.year}-${shift.planStartTime.month.toString().padLeft(2, '0')}-${shift.planStartTime.day.toString().padLeft(2, '0')}';
    final cardsForShift = OverviewCardHelpers.getCardsForShift(
      managerCardsState,
      shift.shiftName ?? '',
      shiftDate,
    );

    final allCards = OverviewCardHelpers.getAllCards(managerCardsState);
    final allCardsEntity = allCards.isNotEmpty
        ? ManagerShiftCards(
            storeId: selectedStoreId ?? '',
            startDate: shiftDate,
            endDate: shiftDate,
            cards: allCards,
          )
        : null;

    final calculateAttendanceStatusUseCase = ref.watch(calculateAttendanceStatusUseCaseProvider);
    final attendance = calculateAttendanceStatusUseCase(
      cardsForShift,
      shift.planStartTime,
      currentShiftWithReqs: currentShift,
      allCards: allCardsEntity,
    );
    final arrivedCount = attendance.arrivedCount;

    final onTimeEmployees = attendance.onTime.map((ShiftCard card) => <String, dynamic>{
      'user_name': card.employee.userName,
      'profile_image': card.employee.profileImage ?? '',
    }).toList();

    final lateEmployees = attendance.late.map((ShiftCard card) => <String, dynamic>{
      'user_name': card.employee.userName,
      'profile_image': card.employee.profileImage ?? '',
    }).toList();

    final notCheckedInEmployees = attendance.notCheckedIn.map((ShiftCard card) => <String, dynamic>{
      'user_name': card.employee.userName,
      'profile_image': card.employee.profileImage ?? '',
    }).toList();

    return ShiftInfoCard(
      date: OverviewCardHelpers.formatDate(shift.planStartTime),
      shiftName: shift.shiftName ?? 'Unnamed Shift',
      timeRange: OverviewCardHelpers.formatTimeRange(shift.planStartTime, shift.planEndTime),
      type: ShiftCardType.active,
      statusLabel: '$arrivedCount/$targetCount arrived',
      statusType: arrivedCount >= targetCount
          ? ShiftStatusType.success
          : ShiftStatusType.error,
      snapshotData: SnapshotData(
        onTime: SnapshotMetric(
          count: attendance.onTime.length,
          employees: onTimeEmployees,
          cards: attendance.onTime,
        ),
        late: SnapshotMetric(
          count: attendance.late.length,
          employees: lateEmployees,
          cards: attendance.late,
        ),
        notCheckedIn: SnapshotMetric(
          count: attendance.notCheckedIn.length,
          employees: notCheckedInEmployees,
          cards: attendance.notCheckedIn,
        ),
      ),
      onEmployeeTap: (card) => _handleEmployeeTap(context, ref, card, shift, allCards),
    );
  }

  Future<void> _handleEmployeeTap(
    BuildContext context,
    WidgetRef ref,
    ShiftCard card,
    Shift shift,
    List<ShiftCard> allCards,
  ) async {
    final currentShiftEndTime = OverviewCardHelpers.parseShiftEndTime(card.shiftEndTime);
    final shiftEndTime = OverviewCardHelpers.findConsecutiveEndTime(
      staffId: card.employee.userId,
      shiftDate: card.shiftDate,
      currentShiftEndTime: currentShiftEndTime,
      allCards: allCards,
    );

    final pd = card.problemDetails;
    final hasLate = pd?.problems.any((p) => p.type == 'late' && p.isSolved != true) ?? false;
    final hasOvertime = pd?.problems.any((p) => p.type == 'overtime' && p.isSolved != true) ?? false;
    final hasReported = pd?.problems.any((p) => p.type == 'reported' && p.isSolved != true) ?? false;
    final reportedProblem = pd?.problems.where((p) => p.type == 'reported').firstOrNull;
    final lateProblem = pd?.problems.where((p) => p.type == 'late').firstOrNull;
    final overtimeProblem = pd?.problems.where((p) => p.type == 'overtime').firstOrNull;

    final staffRecord = StaffTimeRecord(
      staffId: card.employee.userId,
      staffName: card.employee.userName,
      avatarUrl: card.employee.profileImage,
      clockIn: card.actualStartTime != null
          ? '${card.actualStartTime!.hour.toString().padLeft(2, '0')}:${card.actualStartTime!.minute.toString().padLeft(2, '0')}'
          : '--:--',
      clockOut: card.actualEndTime != null
          ? '${card.actualEndTime!.hour.toString().padLeft(2, '0')}:${card.actualEndTime!.minute.toString().padLeft(2, '0')}'
          : '--:--',
      isLate: hasLate,
      isOvertime: hasOvertime,
      needsConfirm: card.confirmedStartTime == null && card.confirmedEndTime == null,
      isConfirmed: card.confirmedStartTime != null || card.confirmedEndTime != null,
      shiftRequestId: card.shiftRequestId,
      actualStart: card.actualStartTime?.toIso8601String(),
      actualEnd: card.actualEndTime?.toIso8601String(),
      confirmStartTime: card.confirmedStartTime?.toIso8601String(),
      confirmEndTime: card.confirmedEndTime?.toIso8601String(),
      isReported: hasReported,
      reportReason: reportedProblem?.reason,
      isProblemSolved: pd?.isSolved ?? false,
      bonusAmount: card.bonusAmount ?? 0.0,
      salaryType: card.salaryType,
      salaryAmount: card.salaryAmount,
      basePay: card.basePay,
      totalPayWithBonus: card.totalPayWithBonus,
      paidHour: card.paidHour,
      lateMinute: lateProblem?.actualMinutes ?? 0,
      overtimeMinute: overtimeProblem?.actualMinutes ?? 0,
      shiftEndTime: shiftEndTime,
      problemDetails: pd,
    );

    final shiftDateStr = DateFormat('EEE, d MMM yyyy').format(shift.planStartTime);

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute<Map<String, dynamic>>(
        builder: (context) => StaffTimelogDetailPage(
          staffRecord: staffRecord,
          shiftName: shift.shiftName ?? 'Shift',
          shiftDate: shiftDateStr,
          shiftTimeRange: OverviewCardHelpers.formatTimeRange(shift.planStartTime, shift.planEndTime),
        ),
      ),
    );

    if (result != null && result['success'] == true && selectedStoreId != null) {
      ManagerMemo? newMemo;
      final memoText = result['managerMemo'] as String?;
      if (memoText != null && memoText.isNotEmpty) {
        newMemo = ManagerMemo(
          type: 'note',
          content: memoText,
          createdAt: DateTime.now().toIso8601String(),
          createdBy: null,
        );
      }

      final parsedDate = DateFormat('EEE, d MMM yyyy').parse(result['shiftDate'] as String);
      final shiftDateFormatted = DateFormat('yyyy-MM-dd').format(parsedDate);

      ref.read(managerCardsProvider(selectedStoreId!).notifier).updateCardProblemData(
        shiftRequestId: result['shiftRequestId'] as String,
        shiftDate: shiftDateFormatted,
        isProblemSolved: result['isProblemSolved'] as bool?,
        isReportedSolved: result['isReportedSolved'] as bool?,
        confirmedStartTime: result['confirmedStartTime'] as String?,
        confirmedEndTime: result['confirmedEndTime'] as String?,
        bonusAmount: result['bonusAmount'] as double?,
        newManagerMemo: newMemo,
        calculatedPaidHour: result['calculatedPaidHour'] as double?,
      );

      onDataUpdated?.call();
    }
  }
}
