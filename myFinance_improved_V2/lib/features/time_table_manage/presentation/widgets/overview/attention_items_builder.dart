import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../providers/state/coverage_gap_provider.dart';
import '../../providers/states/time_table_state.dart';
import 'attention_card.dart';

/// Builder class for attention items in OverviewTab
///
/// Handles the complex logic of extracting attention items from:
/// 1. Manager cards (late, overtime, reported, etc.)
/// 2. Coverage gap provider (understaffed shifts)
class AttentionItemsBuilder {
  final String? selectedStoreId;

  /// Cached attention items (expensive to compute)
  List<AttentionItemData>? _cachedAttentionItems;

  /// Hash of inputs for attention items cache invalidation
  int _lastAttentionInputsHash = 0;

  AttentionItemsBuilder({required this.selectedStoreId});

  /// Get attention items from real data (with caching)
  ///
  /// OPTIMIZED: Results are cached and only recomputed when input data changes
  ///
  /// Sources:
  /// 1. manager_shift_get_cards_v4 (is_approved = true):
  ///    - Late: is_late = true (show late_minute)
  ///    - Problem: is_problem = true AND is_problem_solved = false
  ///    - Reported: is_reported = true AND is_problem_solved = false
  ///    - Overtime: is_overtime = true (show overtime_minute)
  /// 2. Coverage Gap Detection (NEW):
  ///    - Uses centralized coverageGapProvider for consistent data across tabs
  ///    - Only shows gap if no shift with approved employees covers that time
  ///    - Replaces old "understaffed" logic which counted per-shift
  List<AttentionItemData> getAttentionItems({
    required ManagerShiftCardsState? managerCardsState,
    required MonthlyShiftStatusState? monthlyStatusState,
    required ShiftMetadata? shiftMetadata,
    required List<ShiftCard> Function(ManagerShiftCardsState?) getAllCards,
    required String Function(DateTime) formatDate,
    required String Function(DateTime, DateTime) formatTimeRange,
    required DateTime? Function(String?) parseShiftEndTime,
    CoverageGapState? coverageGapState,
  }) {
    // Compute cache hash from input data AND storeId
    // Include storeId to invalidate cache when store changes
    final storeHash = selectedStoreId?.hashCode ?? 0;
    final cardsHash = managerCardsState?.dataByMonth.values
            .fold<int>(0, (sum, m) => sum + m.cards.length) ??
        0;
    final statusHash = monthlyStatusState?.allMonthlyStatuses
            .fold<int>(0, (sum, s) => sum + s.dailyShifts.length) ??
        0;
    final metadataHash = shiftMetadata?.activeShifts.length ?? 0;
    final coverageGapHash = coverageGapState?.totalGapCount ?? 0;

    // Include problem status in hash to invalidate cache when isSolved changes
    // Count unsolved problems to detect status changes
    final problemHash = managerCardsState?.dataByMonth.values
            .expand((m) => m.cards)
            .where((c) => c.isApproved && c.problemDetails != null)
            .fold<int>(0, (sum, c) {
          final pd = c.problemDetails!;
          // Include both problemCount and unsolved count in hash
          final unsolvedCount = pd.problems.where((p) => !p.isSolved).length;
          return sum + pd.problemCount * 10 + unsolvedCount;
        }) ??
        0;

    final currentHash = storeHash +
        cardsHash * 10000 +
        statusHash * 100 +
        metadataHash +
        problemHash +
        coverageGapHash;

    // Return cached result if inputs haven't changed
    if (_cachedAttentionItems != null &&
        _lastAttentionInputsHash == currentHash) {
      return _cachedAttentionItems!;
    }

    final List<AttentionItemData> items = [];

    // 1. Get attention items from manager cards (approved cards only)
    // Use problem_details_v2 exclusively (same as Problems tab)
    final allCards = getAllCards(managerCardsState);
    final approvedCards = allCards.where((card) => card.isApproved).toList();

    // Pre-compute consecutive end times for all staff+date combinations (same as problemStatusProvider)
    final Map<String, DateTime> consecutiveEndTimeMap = {};
    final Map<String, List<DateTime>> staffDateEndTimes = {};

    for (final card in approvedCards) {
      final endTime = parseShiftEndTime(card.shiftEndTime);
      if (endTime == null) continue;

      final mapKey = '${card.employee.userId}_${card.shiftDate}';
      staffDateEndTimes.putIfAbsent(mapKey, () => []).add(endTime);
    }

    for (final entry in staffDateEndTimes.entries) {
      entry.value.sort();
      consecutiveEndTimeMap[entry.key] = entry.value.last;
    }

    // Get current time for filtering (same as problemStatusProvider)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final card in approvedCards) {
      final shiftDate = DateTime.tryParse(card.shiftDate);
      if (shiftDate == null) continue;

      final cardDate = DateTime(shiftDate.year, shiftDate.month, shiftDate.day);
      final dateStr = formatDate(shiftDate);
      final timeStr =
          formatTimeRange(card.shift.planStartTime, card.shift.planEndTime);

      // Skip future dates (same logic as problemStatusProvider)
      if (cardDate.isAfter(today)) continue;

      // Check if shift is still in progress using pre-computed map (same as problemStatusProvider)
      final mapKey = '${card.employee.userId}_${card.shiftDate}';
      final shiftEndTime = consecutiveEndTimeMap[mapKey];
      if (shiftEndTime != null && now.isBefore(shiftEndTime)) {
        continue; // Shift still in progress
      }

      // Use problem_details_v2 exclusively (no legacy fallback)
      final pd = card.problemDetails;
      if (pd == null || pd.problemCount == 0) continue;

      // Skip if all problems are solved (same logic as problemStatusProvider)
      if (pd.isFullySolved) continue;

      // Extract values from problem_details_v2 (no legacy fields)
      final hasLate = pd.problems.any((p) => p.type == 'late' && !p.isSolved);
      final hasOvertime =
          pd.problems.any((p) => p.type == 'overtime' && !p.isSolved);
      final hasReported =
          pd.problems.any((p) => p.type == 'reported' && !p.isSolved);
      final reportedProblem =
          pd.problems.where((p) => p.type == 'reported').firstOrNull;
      final lateProblem =
          pd.problems.where((p) => p.type == 'late').firstOrNull;
      final overtimeProblem =
          pd.problems.where((p) => p.type == 'overtime').firstOrNull;

      // Process each problem from problem_details_v2
      for (final problemItem in pd.problems) {
        // Skip solved problems
        if (problemItem.isSolved) continue;

        final problemType = _mapProblemTypeFromString(problemItem.type);
        if (problemType == null) continue;

        // Build subtext based on problem type
        String subtext;
        int? lateMinutes;
        int? overtimeMinutes;
        String? reportReason;

        switch (problemType) {
          case AttentionType.late:
            lateMinutes = problemItem.actualMinutes;
            subtext = '${lateMinutes ?? 0} mins late';
          case AttentionType.overtime:
            overtimeMinutes = problemItem.actualMinutes;
            final hours = (overtimeMinutes ?? 0) ~/ 60;
            final mins = (overtimeMinutes ?? 0) % 60;
            subtext = hours > 0
                ? (mins > 0
                    ? '$hours hrs $mins mins overtime'
                    : '$hours hrs overtime')
                : '${overtimeMinutes ?? 0} mins overtime';
          case AttentionType.reported:
            reportReason = problemItem.reason;
            subtext = reportReason ?? 'Reported';
          case AttentionType.noCheckIn:
            subtext = 'No check-in recorded';
          case AttentionType.noCheckOut:
            subtext = 'No check-out recorded';
          case AttentionType.earlyCheckOut:
            subtext = '${problemItem.actualMinutes ?? 0} mins early';
          case AttentionType.understaffed:
            continue; // Skip understaffed - handled separately
        }

        items.add(
          AttentionItemData(
            type: problemType,
            title: card.employee.userName,
            date: dateStr,
            time: timeStr,
            subtext: subtext,
            // Navigation data
            staffId: card.employee.userId,
            shiftRequestId: card.shiftRequestId,
            clockIn: card.actualStartTime != null
                ? '${card.actualStartTime!.hour.toString().padLeft(2, '0')}:${card.actualStartTime!.minute.toString().padLeft(2, '0')}'
                : '--:--',
            clockOut: card.actualEndTime != null
                ? '${card.actualEndTime!.hour.toString().padLeft(2, '0')}:${card.actualEndTime!.minute.toString().padLeft(2, '0')}'
                : '--:--',
            // Use problem_details_v2 instead of legacy fields
            isLate: hasLate,
            isOvertime: hasOvertime,
            isConfirmed:
                card.confirmedStartTime != null || card.confirmedEndTime != null,
            actualStart: card.actualStartTime?.toIso8601String(),
            actualEnd: card.actualEndTime?.toIso8601String(),
            confirmStartTime: card.confirmedStartTime?.toIso8601String(),
            confirmEndTime: card.confirmedEndTime?.toIso8601String(),
            isReported: hasReported,
            reportReason: reportReason ?? reportedProblem?.reason,
            isProblemSolved: pd.isSolved,
            bonusAmount: card.bonusAmount ?? 0.0,
            salaryType: card.salaryType,
            salaryAmount: card.salaryAmount,
            basePay: card.basePay,
            totalPayWithBonus: card.totalPayWithBonus,
            paidHour: card.paidHour,
            lateMinute: lateMinutes ?? lateProblem?.actualMinutes ?? 0,
            overtimeMinute:
                overtimeMinutes ?? overtimeProblem?.actualMinutes ?? 0,
            avatarUrl: card.employee.profileImage,
            shiftDate: shiftDate,
            shiftName: card.shift.shiftName,
            shiftTimeRange: timeStr,
            isShiftProblem: false,
            shiftEndTime: shiftEndTime,
          ),
        );
      }
    }

    // 2. Coverage Gap Detection - Uses CENTRALIZED coverageGapProvider
    // This ensures consistent data between Overview and Schedule tabs
    // The provider handles:
    // - Fetching business hours (no default value fallback during loading)
    // - Approved shift coverage calculation
    // - TODAY time-based filtering (only show gaps AFTER current time)
    // - Caching for performance
    //
    // NOTE: coverageGapState is passed in from _buildNeedAttentionTimeline
    //       to avoid duplicate provider watch calls
    if (coverageGapState != null && !coverageGapState.isLoading) {
      for (final entry in coverageGapState.gapsByDate.entries) {
        final gapInfo = entry.value;
        if (!gapInfo.hasGap) continue;

        final normalizedDate = entry.key;

        items.add(AttentionItemData(
          type: AttentionType.understaffed,
          title: 'Schedule Gap',
          date: formatDate(normalizedDate),
          time: gapInfo.gapSummary,
          subtext: 'Uncovered: ${gapInfo.gapSummary}',
          isShiftProblem: true,
          shiftDate: normalizedDate,
          shiftName: 'Coverage Gap',
          shiftTimeRange: gapInfo.gapSummary,
        ));
      }
    }

    // Cache the result for next build
    _cachedAttentionItems = items;
    _lastAttentionInputsHash = currentHash;

    return items;
  }

  /// Map problem type string from problem_details_v2 to AttentionType
  /// NOTE: Type strings from RPC use 'no_checkin', 'no_checkout', 'early_leave'
  /// (same as timesheets_tab.dart)
  AttentionType? _mapProblemTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'late':
        return AttentionType.late;
      case 'overtime':
        return AttentionType.overtime;
      case 'reported':
        return AttentionType.reported;
      case 'no_checkin':
      case 'no_check_in': // fallback for safety
        return AttentionType.noCheckIn;
      case 'no_checkout':
      case 'no_check_out': // fallback for safety
        return AttentionType.noCheckOut;
      case 'early_leave':
      case 'early_check_out': // fallback for safety
        return AttentionType.earlyCheckOut;
      case 'absence':
        return AttentionType.noCheckIn; // Map absence to noCheckIn (same as Problems tab)
      default:
        return null;
    }
  }
}
