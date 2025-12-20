import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../store_shift/domain/entities/business_hours.dart';
import '../../../../store_shift/presentation/providers/store_shift_providers.dart';
import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/manager_shift_cards.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../pages/staff_timelog_detail_page.dart';
import '../../providers/states/time_table_state.dart';
import '../../providers/time_table_providers.dart';
import 'attention_card.dart';
import 'attention_timeline.dart';
import 'shift_info_card.dart';
import '../timesheets/staff_timelog_card.dart';

/// Overview Tab
///
/// Main overview tab showing:
/// - Store selector
/// - Currently Active shift with snapshot metrics
/// - Upcoming shift with staff grid
/// - Need Attention horizontal scroll
class OverviewTab extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final VoidCallback onStoreSelectorTap;
  final void Function(String storeId)? onStoreChanged;
  /// Callback to navigate to Schedule tab with a specific date
  final void Function(DateTime date)? onNavigateToSchedule;
  /// Callback to navigate to Problems tab with a specific date
  final void Function(DateTime date)? onNavigateToProblems;

  const OverviewTab({
    super.key,
    required this.selectedStoreId,
    required this.onStoreSelectorTap,
    this.onStoreChanged,
    this.onNavigateToSchedule,
    this.onNavigateToProblems,
  });

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> {
  /// Center date for the attention timeline (defaults to today)
  late DateTime _timelineCenterDate;

  // ═══════════════════════════════════════════════════════════════════════════
  // OPTIMIZATION: Cached computed values to avoid recalculation on each build
  // ═══════════════════════════════════════════════════════════════════════════

  /// Cached all cards from manager cards state (expensive to compute)
  List<ShiftCard>? _cachedAllCards;
  /// Hash of the last manager cards state to detect changes
  int _lastCardsStateHash = 0;

  /// Cached attention items (expensive to compute)
  List<AttentionItemData>? _cachedAttentionItems;
  /// Hash of inputs for attention items cache invalidation
  int _lastAttentionInputsHash = 0;

  /// Cached cards by shift lookup (Map<"shiftDate_shiftName", List<ShiftCard>>)
  Map<String, List<ShiftCard>>? _cachedCardsByShift;

  @override
  void initState() {
    super.initState();
    _timelineCenterDate = DateTime.now();
  }

  /// Get all cards with caching (avoids repeated .expand() and .toList())
  ///
  /// IMPORTANT: Cache is invalidated when:
  /// 1. Number of months or total cards changes
  /// 2. Problem status on any card changes (detected via problemHash)
  List<ShiftCard> _getAllCards(ManagerShiftCardsState? cardsState) {
    if (cardsState == null) return [];

    // Create a hash that includes:
    // 1. Number of months and total cards
    // 2. Problem status (problemCount + unsolved count) for cache invalidation
    final countHash = cardsState.dataByMonth.length * 1000 +
        cardsState.dataByMonth.values.fold<int>(0, (sum, m) => sum + m.cards.length);

    // Include problem status in hash to detect isSolved changes
    final problemHash = cardsState.dataByMonth.values
        .expand((m) => m.cards)
        .where((c) => c.isApproved && c.problemDetails != null)
        .fold<int>(0, (sum, c) {
          final pd = c.problemDetails!;
          final unsolvedCount = pd.problems.where((p) => !p.isSolved).length;
          return sum + pd.problemCount * 10 + unsolvedCount;
        });

    final currentHash = countHash * 1000 + problemHash;

    if (_cachedAllCards != null && _lastCardsStateHash == currentHash) {
      return _cachedAllCards!;
    }

    // Compute and cache
    _cachedAllCards = cardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .toList();
    _lastCardsStateHash = currentHash;

    // Also rebuild the cards-by-shift lookup
    _cachedCardsByShift = {};
    for (final card in _cachedAllCards!) {
      if (!card.isApproved) continue;
      final key = '${card.shiftDate}_${card.shift.shiftName}';
      _cachedCardsByShift!.putIfAbsent(key, () => []).add(card);
    }

    return _cachedAllCards!;
  }

  /// Move timeline to previous 5 days
  void _navigateToPreviousDays() {
    setState(() {
      _timelineCenterDate = _timelineCenterDate.subtract(const Duration(days: 5));
    });
  }

  /// Move timeline to next 5 days
  void _navigateToNextDays() {
    setState(() {
      _timelineCenterDate = _timelineCenterDate.add(const Duration(days: 5));
    });
  }

  /// Format date for display (e.g., "Tue, 18 Jun 2025")
  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday, ${date.day} $month ${date.year}';
  }

  /// Format time range (e.g., "09:00 – 13:00")
  String _formatTimeRange(DateTime start, DateTime end) {
    final startStr = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endStr = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startStr – $endStr';
  }

  /// Get cards for a specific shift from manager cards data
  ///
  /// OPTIMIZED: Uses cached lookup map instead of filtering all cards each time
  /// Note: RPC doesn't return shift_id, so we match by:
  /// - shiftDate (exact match)
  /// - shiftName (exact match)
  /// - isApproved = true (only approved cards)
  List<ShiftCard> _getCardsForShift(
    ManagerShiftCardsState? cardsState,
    String shiftName,
    String shiftDate,
  ) {
    if (cardsState == null) return [];

    // Ensure cache is populated
    _getAllCards(cardsState);

    // O(1) lookup instead of O(n) filtering
    final key = '${shiftDate}_$shiftName';
    return _cachedCardsByShift?[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final stores = _extractStores(appState.user, appState.companyChoosen);

    // If no store selected, show store selector only (if multiple stores exist)
    if (widget.selectedStoreId == null || widget.selectedStoreId!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stores.length > 1) ...[
              _buildStoreSelector(stores),
              const SizedBox(height: TossSpacing.space6),
            ],
            const Expanded(
              child: Center(
                child: Text('Please select a store'),
              ),
            ),
          ],
        ),
      );
    }

    // Watch monthly shift status for current activity data
    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));

    // Watch manager cards for attendance data (on-time/late/not-checked-in)
    final managerCardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));

    // Watch shift metadata for all available shifts (including those with 0 requests)
    final shiftMetadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));

    // Check loading states - show loading until ALL data is ready
    final isMonthlyStatusLoading = monthlyStatusState.isLoading;
    final isManagerCardsLoading = managerCardsState.isLoading;
    final isMetadataLoading = shiftMetadataAsync.isLoading;

    // Show loading view until all data is ready
    if (isMonthlyStatusLoading || isManagerCardsLoading || isMetadataLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoreSelector(stores),
            const Expanded(
              child: TossLoadingView(
                message: 'Loading shift data...',
              ),
            ),
          ],
        ),
      );
    }

    // All data is ready - extract values
    final allDailyShifts = monthlyStatusState.allMonthlyStatuses
        .expand((status) => status.dailyShifts)
        .toList();
    final shiftMetadata = shiftMetadataAsync.valueOrNull;

    // ✅ UseCase: Find current activity shift
    final findCurrentShiftUseCase = ref.watch(findCurrentShiftUseCaseProvider);
    final currentActivityShift = findCurrentShiftUseCase(allDailyShifts);

    // ✅ UseCase: Find upcoming shift (next after current activity)
    final findUpcomingShiftUseCase = ref.watch(findUpcomingShiftUseCaseProvider);
    final upcomingShift = findUpcomingShiftUseCase(allDailyShifts, currentActivityShift);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1️⃣ Store Selector Dropdown (hide if only 1 store)
          if (stores.length > 1) ...[
            _buildStoreSelector(stores),
            const SizedBox(height: TossSpacing.space6),
          ],

          // 2️⃣ Currently Active Section
          _buildSectionLabel('Currently Active'),
          const SizedBox(height: TossSpacing.space2),
          _buildCurrentActivityCard(currentActivityShift, managerCardsState, allDailyShifts),
          const SizedBox(height: TossSpacing.space6),

          // 3️⃣ Upcoming Section
          _buildSectionLabel('Upcoming'),
          const SizedBox(height: TossSpacing.space2),
          _buildUpcomingCard(upcomingShift),
          const SizedBox(height: TossSpacing.space6),

          // 4️⃣ Need Attention Section (Timeline View)
          _buildNeedAttentionTimeline(managerCardsState, monthlyStatusState, shiftMetadata),
        ],
      ),
    );
  }

  /// Build section label
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TossTextStyles.labelMedium.copyWith(
        color: TossColors.gray600,
      ),
    );
  }

  /// Build Current Activity card with real data
  Widget _buildCurrentActivityCard(
    ShiftWithRequests? currentShift,
    ManagerShiftCardsState? managerCardsState,
    List<DailyShiftData> allDailyShifts,
  ) {
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

    final shift = currentShift.shift;
    // Use actual approved employees count instead of required staff count
    final targetCount = currentShift.approvedRequests.length;

    // Get cards for this specific shift from manager_shift_get_cards_v3 data
    // Match by shiftName since RPC doesn't return shift_id
    final shiftDate = '${shift.planStartTime.year}-${shift.planStartTime.month.toString().padLeft(2, '0')}-${shift.planStartTime.day.toString().padLeft(2, '0')}';
    final cardsForShift = _getCardsForShift(managerCardsState, shift.shiftName ?? '', shiftDate);

    // ✅ UseCase: Calculate attendance status with consecutive shift support
    // OPTIMIZED: Use cached allCards instead of recomputing
    final allCards = _getAllCards(managerCardsState);
    final allCardsEntity = allCards.isNotEmpty
        ? ManagerShiftCards(
            storeId: widget.selectedStoreId ?? '',
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

    // Build employee lists for snapshot
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
      date: _formatDate(shift.planStartTime),
      shiftName: shift.shiftName ?? 'Unnamed Shift',
      timeRange: _formatTimeRange(shift.planStartTime, shift.planEndTime),
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
      onEmployeeTap: (card) => _handleEmployeeTap(card, shift, allCards),
    );
  }

  /// Build Upcoming card with real data
  Widget _buildUpcomingCard(ShiftWithRequests? upcomingShift) {
    // If no upcoming shift, show placeholder
    if (upcomingShift == null) {
      return ShiftInfoCard(
        date: 'No upcoming shifts',
        shiftName: '-',
        timeRange: '-',
        type: ShiftCardType.upcoming,
        statusLabel: '0/0 assigned',
        statusType: ShiftStatusType.neutral,
        staffList: [],
      );
    }

    final shift = upcomingShift.shift;
    final approvedCount = upcomingShift.approvedRequests.length;
    final targetCount = shift.targetCount;

    // Build staff list from approved requests
    final staffList = upcomingShift.approvedRequests.map((req) => StaffMember(
      name: req.employee.userName,
      avatarUrl: req.employee.profileImage,
    )).toList();

    return ShiftInfoCard(
      date: _formatDate(shift.planStartTime),
      shiftName: shift.shiftName ?? 'Unnamed Shift',
      timeRange: _formatTimeRange(shift.planStartTime, shift.planEndTime),
      type: ShiftCardType.upcoming,
      statusLabel: '$approvedCount/$targetCount assigned',
      statusType: ShiftStatusType.neutral,
      staffList: staffList,
    );
  }

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
  ///    - Compare business hours vs approved shift coverage
  ///    - Only shows gap if no shift with approved employees covers that time
  ///    - Replaces old "understaffed" logic which counted per-shift
  List<AttentionItemData> _getAttentionItems(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
    ShiftMetadata? shiftMetadata, {
    List<BusinessHours>? businessHours,
  }) {
    // Compute cache hash from input data AND storeId
    // Include storeId to invalidate cache when store changes
    final storeHash = widget.selectedStoreId?.hashCode ?? 0;
    final cardsHash = managerCardsState?.dataByMonth.values
        .fold<int>(0, (sum, m) => sum + m.cards.length) ?? 0;
    final statusHash = monthlyStatusState?.allMonthlyStatuses
        .fold<int>(0, (sum, s) => sum + s.dailyShifts.length) ?? 0;
    final metadataHash = shiftMetadata?.activeShifts.length ?? 0;
    final businessHoursHash = businessHours?.length ?? 0;

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
        }) ?? 0;

    final currentHash = storeHash + cardsHash * 10000 + statusHash * 100 + metadataHash + problemHash + businessHoursHash;

    // Return cached result if inputs haven't changed
    if (_cachedAttentionItems != null && _lastAttentionInputsHash == currentHash) {
      return _cachedAttentionItems!;
    }

    final List<AttentionItemData> items = [];

    // 1. Get attention items from manager cards (approved cards only)
    // Use problem_details_v2 exclusively (same as Problems tab)
    final allCards = _getAllCards(managerCardsState);
    final approvedCards = allCards.where((card) => card.isApproved).toList();

    // Pre-compute consecutive end times for all staff+date combinations (same as problemStatusProvider)
    final Map<String, DateTime> consecutiveEndTimeMap = {};
    final Map<String, List<DateTime>> staffDateEndTimes = {};

    for (final card in approvedCards) {
      final endTime = _parseShiftEndTime(card.shiftEndTime);
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
      final dateStr = _formatDate(shiftDate);
      final timeStr = _formatTimeRange(card.shift.planStartTime, card.shift.planEndTime);

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
      final hasOvertime = pd.problems.any((p) => p.type == 'overtime' && !p.isSolved);
      final hasReported = pd.problems.any((p) => p.type == 'reported' && !p.isSolved);
      final reportedProblem = pd.problems.where((p) => p.type == 'reported').firstOrNull;
      final lateProblem = pd.problems.where((p) => p.type == 'late').firstOrNull;
      final overtimeProblem = pd.problems.where((p) => p.type == 'overtime').firstOrNull;

      // Common navigation data for staff items
      AttentionItemData createStaffAttentionItem({
        required AttentionType type,
        required String subtext,
        int? lateMinutes,
        int? overtimeMinutes,
        String? reportReason,
      }) {
        return AttentionItemData(
          type: type,
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
          isConfirmed: card.confirmedStartTime != null || card.confirmedEndTime != null,
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
          overtimeMinute: overtimeMinutes ?? overtimeProblem?.actualMinutes ?? 0,
          avatarUrl: card.employee.profileImage,
          shiftDate: shiftDate,
          shiftName: card.shift.shiftName,
          shiftTimeRange: timeStr,
          isShiftProblem: false,
          shiftEndTime: shiftEndTime,
        );
      }

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
                ? (mins > 0 ? '$hours hrs $mins mins overtime' : '$hours hrs overtime')
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
          createStaffAttentionItem(
            type: problemType,
            subtext: subtext,
            lateMinutes: lateMinutes,
            overtimeMinutes: overtimeMinutes,
            reportReason: reportReason,
          ),
        );
      }
    }

    // 2. Coverage Gap Detection (replaces old understaffed logic)
    // Compare business hours vs approved shift coverage
    // Only shows gap when no approved shift covers that time
    // Note: 'now' already defined above for problem filtering
    //
    // OPTIMIZATION:
    // - Only check dates that exist in RPC data (들어온 데이터만)
    // - Skip past dates
    // - For TODAY: only check gaps AFTER current time (현재 시간 이후만)

    if (businessHours != null && businessHours.isNotEmpty && monthlyStatusState != null) {
      final today = DateTime(now.year, now.month, now.day);

      // Get current time in minutes from midnight (for today's time-based filtering)
      final currentTimeMinutes = now.hour * 60 + now.minute;

      // Collect all dates from RPC data and their coverage
      final Map<String, List<TimeRange>> approvedCoverageByDate = {};
      final Set<String> allDatesInData = {};

      for (final monthlyStatus in monthlyStatusState.allMonthlyStatuses) {
        for (final dailyData in monthlyStatus.dailyShifts) {
          // Record this date exists in data
          allDatesInData.add(dailyData.date);

          for (final shiftWithReqs in dailyData.shifts) {
            // Only count shifts with at least 1 approved employee
            if (shiftWithReqs.approvedRequests.isEmpty) continue;

            final shift = shiftWithReqs.shift;
            final startTime = _extractTimeStr(shift.planStartTime);
            final endTime = _extractTimeStr(shift.planEndTime);

            if (startTime != null && endTime != null) {
              approvedCoverageByDate
                  .putIfAbsent(dailyData.date, () => [])
                  .add(TimeRange.fromTimeStrings(startTime, endTime));
            }
          }
        }
      }

      // Check each date that exists in RPC data (들어온 데이터만 체크)
      for (final dateStr in allDatesInData) {
        final parsedDate = DateTime.tryParse(dateStr);
        if (parsedDate == null) continue;

        final normalizedDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

        // Skip past dates
        if (normalizedDate.isBefore(today)) continue;

        // Get business hours for this day
        final dayHours = BusinessHours.getForDate(businessHours, normalizedDate);
        if (dayHours == null || !dayHours.isOpen) continue;

        final businessRange = dayHours.toTimeRange();
        if (businessRange == null) continue;

        // Get approved coverage for this date
        final coverage = approvedCoverageByDate[dateStr] ?? [];

        // Calculate gaps
        var gaps = TimeRange.findGaps(businessRange, coverage);

        // For TODAY: filter out gaps that end before current time
        // Only show gaps that are still relevant (after current time)
        final isToday = normalizedDate.year == today.year &&
            normalizedDate.month == today.month &&
            normalizedDate.day == today.day;

        if (isToday && gaps.isNotEmpty) {
          gaps = gaps.where((gap) {
            // Keep gap if its end time is after current time
            // gap.endMinutes can exceed 1440 for overnight, so normalize
            final gapEndMinutes = gap.endMinutes % 1440;
            return gapEndMinutes > currentTimeMinutes || gap.endMinutes > 1440;
          }).toList();
        }

        if (gaps.isNotEmpty) {
          // Format gap summary
          final gapSummary = gaps.map((g) =>
            '${g.toTimeString()}-${g.toEndTimeString()}'
          ).join(', ');

          items.add(AttentionItemData(
            type: AttentionType.understaffed,
            title: 'Schedule Gap',
            date: _formatDate(normalizedDate),
            time: '${businessRange.toTimeString()} – ${businessRange.toEndTimeString()}',
            subtext: 'Uncovered: $gapSummary',
            isShiftProblem: true,
            shiftDate: normalizedDate,
            shiftName: 'Coverage Gap',
            shiftTimeRange: '${businessRange.toTimeString()} – ${businessRange.toEndTimeString()}',
          ));
        }
      }
    }

    // Cache the result for next build
    _cachedAttentionItems = items;
    _lastAttentionInputsHash = currentHash;

    return items;
  }

  /// Extract HH:mm time string from DateTime
  String? _extractTimeStr(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Build Need Attention Timeline (new design)
  ///
  /// Shows a 5-day timeline with:
  /// - Orange dots = Coverage gaps (tap → Schedule tab)
  /// - Red dots = Staff problems (tap → Problems tab)
  /// - Pagination: `< 7 more` and `5 more >` buttons
  Widget _buildNeedAttentionTimeline(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
    ShiftMetadata? shiftMetadata,
  ) {
    // Watch business hours from store_shift feature
    // This is already cached by the provider, so no additional RPC call
    final businessHoursAsync = ref.watch(businessHoursProvider);
    final businessHours = businessHoursAsync.valueOrNull ?? BusinessHours.defaultHours();

    final attentionItems = _getAttentionItems(
      managerCardsState,
      monthlyStatusState,
      shiftMetadata,
      businessHours: businessHours,
    );

    // Get pre-computed problem count from problemStatusProvider (O(1) - already cached)
    // This ensures consistency with Problems tab and avoids redundant calculations
    final int? precomputedProblemCount;
    if (widget.selectedStoreId != null) {
      final problemData = ref.watch(problemStatusProvider(ProblemStatusKey(
        storeId: widget.selectedStoreId!,
        focusedMonth: DateTime.now(), // Overview uses current month
      )));
      precomputedProblemCount = problemData.thisMonthCount;
    } else {
      precomputedProblemCount = null;
    }

    return AttentionTimeline(
      items: attentionItems,
      centerDate: _timelineCenterDate,
      precomputedProblemCount: precomputedProblemCount,
      onDateTap: (date, hasProblem) {
        // Tap on date circle: if has problems → Problems tab, otherwise → Schedule tab
        if (hasProblem) {
          widget.onNavigateToProblems?.call(date);
        } else {
          widget.onNavigateToSchedule?.call(date);
        }
      },
      onScheduleTap: (date) {
        // Navigate to Schedule tab with the selected date
        widget.onNavigateToSchedule?.call(date);
      },
      onProblemTap: (date) {
        // Navigate to Problems tab with the selected date
        widget.onNavigateToProblems?.call(date);
      },
      onPrevious: _navigateToPreviousDays,
      onNext: _navigateToNextDays,
    );
  }

  /// Handle employee tap from snapshot metrics - navigate to staff detail page
  Future<void> _handleEmployeeTap(ShiftCard card, Shift shift, List<ShiftCard> allCards) async {
    // Parse shift end time and find consecutive end time
    // For consecutive shifts (e.g., Morning 10-14 + Afternoon 14-18),
    // use the LAST shift's end time (18:00) for all shifts
    final currentShiftEndTime = _parseShiftEndTime(card.shiftEndTime);
    final shiftEndTime = _findConsecutiveEndTime(
      staffId: card.employee.userId,
      shiftDate: card.shiftDate,
      currentShiftEndTime: currentShiftEndTime,
      allCards: allCards,
    );

    // Extract values from problem_details_v2 (no legacy fields)
    final pd = card.problemDetails;
    final hasLate = pd?.problems.any((p) => p.type == 'late' && !p.isSolved) ?? false;
    final hasOvertime = pd?.problems.any((p) => p.type == 'overtime' && !p.isSolved) ?? false;
    final hasReported = pd?.problems.any((p) => p.type == 'reported' && !p.isSolved) ?? false;
    final reportedProblem = pd?.problems.where((p) => p.type == 'reported').firstOrNull;
    final lateProblem = pd?.problems.where((p) => p.type == 'late').firstOrNull;
    final overtimeProblem = pd?.problems.where((p) => p.type == 'overtime').firstOrNull;

    // Create StaffTimeRecord from ShiftCard (using problem_details_v2)
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

    // Format shift date for display
    final shiftDateStr = DateFormat('EEE, d MMM yyyy').format(shift.planStartTime);

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => StaffTimelogDetailPage(
          staffRecord: staffRecord,
          shiftName: shift.shiftName ?? 'Shift',
          shiftDate: shiftDateStr,
          shiftTimeRange: _formatTimeRange(shift.planStartTime, shift.planEndTime),
        ),
      ),
    );

    // If save was successful, force refresh the data
    if (result == true && widget.selectedStoreId != null) {
      ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).loadMonth(
        month: DateTime.now(),
        forceRefresh: true,
      );
      ref.invalidate(monthlyShiftStatusProvider(widget.selectedStoreId!));
    }
  }

  /// Build store selector dropdown (same as Schedule tab)
  Widget _buildStoreSelector(List<dynamic> stores) {
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
          // Notify parent of store change with the new store ID
          widget.onStoreChanged?.call(newValue);
        }
      },
    );
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
      case 'no_check_in':  // fallback for safety
        return AttentionType.noCheckIn;
      case 'no_checkout':
      case 'no_check_out':  // fallback for safety
        return AttentionType.noCheckOut;
      case 'early_leave':
      case 'early_check_out':  // fallback for safety
        return AttentionType.earlyCheckOut;
      case 'absence':
        return AttentionType.noCheckIn;  // Map absence to noCheckIn (same as Problems tab)
      default:
        return null;
    }
  }

  /// Parse shift end time string to DateTime
  /// Format: "2025-12-08 18:00" or "2025-12-08T18:00"
  DateTime? _parseShiftEndTime(String? shiftEndTimeStr) {
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

  /// Find the last consecutive shift end time for a staff member on a given date
  /// Returns the end time of the last shift of the day for this staff member
  DateTime? _findConsecutiveEndTime({
    required String staffId,
    required String shiftDate,
    required DateTime? currentShiftEndTime,
    required List<ShiftCard> allCards,
  }) {
    if (currentShiftEndTime == null) return null;

    // Find all shifts for this staff member on the same date
    final staffShiftsOnDate = allCards
        .where((c) => c.employee.userId == staffId && c.shiftDate == shiftDate)
        .toList();

    if (staffShiftsOnDate.isEmpty) return currentShiftEndTime;

    // Parse all shift end times and sort
    final shiftEndTimes = <DateTime>[];
    for (final card in staffShiftsOnDate) {
      final endTime = _parseShiftEndTime(card.shiftEndTime);
      if (endTime != null) {
        shiftEndTimes.add(endTime);
      }
    }

    if (shiftEndTimes.isEmpty) return currentShiftEndTime;

    // Sort by time and return the latest
    shiftEndTimes.sort();
    return shiftEndTimes.last;
  }

  /// Extract stores from user data for the currently selected company
  List<dynamic> _extractStores(Map<String, dynamic> userData, String selectedCompanyId) {
    if (userData.isEmpty || selectedCompanyId.isEmpty) return [];

    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      // Find the company matching the selected company ID
      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        final companyId = companyMap['company_id']?.toString() ?? '';
        if (companyId == selectedCompanyId) {
          final stores = companyMap['stores'] as List<dynamic>?;
          return stores ?? [];
        }
      }

      // Fallback: if no matching company found, return empty
      return [];
    } catch (e) {
      return [];
    }
  }
}
