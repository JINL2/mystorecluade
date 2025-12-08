import '../entities/daily_shift_data.dart';
import '../entities/manager_shift_cards.dart';
import '../entities/shift_card.dart';

/// Attendance Status Result
class AttendanceStatus {
  final List<ShiftCard> onTime;
  final List<ShiftCard> late;
  final List<ShiftCard> notCheckedIn;
  final int arrivedCount;

  const AttendanceStatus({
    required this.onTime,
    required this.late,
    required this.notCheckedIn,
    required this.arrivedCount,
  });
}

/// Calculate Attendance Status UseCase
///
/// Business logic to calculate employee attendance status from shift cards.
/// Supports consecutive shift inheritance.
class CalculateAttendanceStatusUseCase {
  /// Calculate attendance status from ShiftCard data with consecutive shift support
  ///
  /// Logic based on manager_shift_get_cards_v3 RPC:
  /// - On-time: actualStartTime <= shift.planStartTime
  /// - Late: actualStartTime > shift.planStartTime (or isLate flag)
  /// - Not checked in: actualStartTime == null && confirmedStartTime == null
  ///
  /// For consecutive shifts: If employee has no data for current shift but
  /// was in a previous consecutive shift, inherit their status from the first shift.
  AttendanceStatus call(
    List<ShiftCard> cardsForShift,
    DateTime planStartTime, {
    ShiftWithRequests? currentShiftWithReqs,
    ManagerShiftCards? allCards,
  }) {
    final List<ShiftCard> onTimeCards = [];
    final List<ShiftCard> lateCards = [];
    final List<ShiftCard> notCheckedInCards = [];

    // Track processed employees to avoid duplicates
    final Set<String> processedEmployees = {};

    // Get all cards for consecutive shift lookup
    final allCardsList = allCards?.cards ?? [];

    for (final card in cardsForShift) {
      processedEmployees.add(card.employee.userName);

      // Use actualStartTime if available, otherwise use confirmedStartTime
      final checkInTime = card.actualStartTime ?? card.confirmedStartTime;

      if (checkInTime != null) {
        // Has check-in data
        // Late: checkInTime > planStartTime (or isLate flag is true)
        if (card.isLate || checkInTime.isAfter(planStartTime)) {
          lateCards.add(card);
        } else {
          // On-time: checkInTime <= planStartTime
          onTimeCards.add(card);
        }
      } else {
        // No check-in data for current shift
        // Check if employee has check-in from consecutive shift chain
        if (card.shiftStartTime != null) {
          final inheritedStatus = _getEmployeeStatusFromConsecutiveCards(
            card.employee.userName,
            card.shiftStartTime,
            allCardsList,
          );

          if (inheritedStatus == 'onTime') {
            onTimeCards.add(card);
          } else if (inheritedStatus == 'late') {
            lateCards.add(card);
          } else {
            // No inherited status from previous shifts
            notCheckedInCards.add(card);
          }
        } else {
          // No shiftStartTime available, mark as not checked in
          notCheckedInCards.add(card);
        }
      }
    }

    // Handle consecutive shift inheritance for employees not in cardsForShift
    if (currentShiftWithReqs != null) {
      final approvedEmployeesForShift = currentShiftWithReqs.approvedRequests;

      // Get shiftStartTime from any card in this shift
      final currentShiftStartTime = cardsForShift.isNotEmpty
          ? cardsForShift.first.shiftStartTime
          : null;

      for (final req in approvedEmployeesForShift) {
        final employeeName = req.employee.userName;

        // Skip if already processed
        if (processedEmployees.contains(employeeName)) continue;

        // Check if this employee has status from consecutive shifts
        final inheritedStatus = _getEmployeeStatusFromConsecutiveCards(
          employeeName,
          currentShiftStartTime,
          allCardsList,
        );

        if (inheritedStatus != null) {
          // Create a synthetic card for display
          final syntheticCard = ShiftCard(
            shiftRequestId: req.shiftRequestId,
            employee: req.employee,
            shift: currentShiftWithReqs.shift,
            shiftDate: _formatDate(currentShiftWithReqs.shift.planStartTime),
            isApproved: true,
            hasProblem: false,
            createdAt: DateTime.now(),
          );

          if (inheritedStatus == 'onTime') {
            onTimeCards.add(syntheticCard);
          } else if (inheritedStatus == 'late') {
            lateCards.add(syntheticCard);
          }
          processedEmployees.add(employeeName);
        }
      }
    }

    return AttendanceStatus(
      onTime: onTimeCards,
      late: lateCards,
      notCheckedIn: notCheckedInCards,
      arrivedCount: onTimeCards.length + lateCards.length,
    );
  }

  /// Get employee attendance status from consecutive shifts using card data
  String? _getEmployeeStatusFromConsecutiveCards(
    String employeeName,
    String? currentShiftStartTime,
    List<ShiftCard> allCards,
  ) {
    if (currentShiftStartTime == null) return null;

    // Get all cards for this employee
    final employeeCards = allCards
        .where((card) => card.employee.userName == employeeName && card.isApproved)
        .toList();

    if (employeeCards.isEmpty) return null;

    // Start chain search
    String? expectedStartTime = currentShiftStartTime;

    // Maximum chain depth to prevent infinite loops
    const maxChainDepth = 10;

    for (int depth = 0; depth < maxChainDepth; depth++) {
      // Find card where shiftEndTime == expectedStartTime
      final prevCard = employeeCards.where(
        (card) => card.shiftEndTime == expectedStartTime,
      ).firstOrNull;

      if (prevCard == null) {
        // No previous consecutive shift found - chain ends
        return null;
      }

      // Found a consecutive previous shift!
      // Check if this card has check-in data
      if (prevCard.actualStartTime != null || prevCard.confirmedStartTime != null) {
        // Has check-in! Return status based on isLate flag
        if (prevCard.isLate) {
          return 'late';
        } else {
          return 'onTime';
        }
      }

      // No check-in in this card, continue chain backwards
      expectedStartTime = prevCard.shiftStartTime;

      if (expectedStartTime == null) {
        // Can't continue chain
        return null;
      }
    }

    return null; // Chain too deep or no check-in found
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
