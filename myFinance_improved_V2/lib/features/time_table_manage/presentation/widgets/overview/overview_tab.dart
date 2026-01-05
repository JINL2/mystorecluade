import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/manager_shift_cards.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/manager_memo.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../pages/staff_timelog_detail_page.dart';
import '../../providers/states/time_table_state.dart';
import '../../providers/time_table_providers.dart';
import '../timesheets/staff_timelog_card.dart';
import 'attention_items_builder.dart';
import 'attention_timeline.dart';
import 'overview_helpers.dart';
import 'shift_info_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

class _OverviewTabState extends ConsumerState<OverviewTab>
    with OverviewHelpersMixin {
  /// Center date for the attention timeline (defaults to today)
  late DateTime _timelineCenterDate;

  /// Attention items builder (handles complex attention item logic)
  late AttentionItemsBuilder _attentionItemsBuilder;

  @override
  void initState() {
    super.initState();
    _timelineCenterDate = DateTime.now();
    _attentionItemsBuilder = AttentionItemsBuilder(
      selectedStoreId: widget.selectedStoreId,
    );
  }

  @override
  void didUpdateWidget(OverviewTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update builder when store changes
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _attentionItemsBuilder = AttentionItemsBuilder(
        selectedStoreId: widget.selectedStoreId,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final stores = extractStores(appState.user, appState.companyChoosen);

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

    // Check loading states
    final isMonthlyStatusLoading = monthlyStatusState.isLoading;
    final isManagerCardsLoading = managerCardsState.isLoading;
    final isMetadataLoading = shiftMetadataAsync.isLoading;

    // ✅ FIX: Check if we have cached data
    // Only show full loading view for INITIAL load (no cached data)
    // During refresh, keep showing cached data to prevent "data disappearing" UX issue
    final hasMonthlyData = monthlyStatusState.dataByMonth.isNotEmpty;
    final hasCardsData = managerCardsState.dataByMonth.isNotEmpty;
    final hasMetadata = shiftMetadataAsync.valueOrNull != null;
    final hasCachedData = hasMonthlyData || hasCardsData || hasMetadata;

    final isInitialLoading = (isMonthlyStatusLoading || isManagerCardsLoading || isMetadataLoading) && !hasCachedData;

    // Show loading view ONLY for initial load (no cached data yet)
    if (isInitialLoading) {
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
    final cardsForShift = getCardsForShift(managerCardsState, shift.shiftName ?? '', shiftDate);

    // ✅ UseCase: Calculate attendance status with consecutive shift support
    // OPTIMIZED: Use cached allCards instead of recomputing
    final allCards = getAllCards(managerCardsState);
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
      date: formatDate(shift.planStartTime),
      shiftName: shift.shiftName ?? 'Unnamed Shift',
      timeRange: formatTimeRange(shift.planStartTime, shift.planEndTime),
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
      date: formatDate(shift.planStartTime),
      shiftName: shift.shiftName ?? 'Unnamed Shift',
      timeRange: formatTimeRange(shift.planStartTime, shift.planEndTime),
      type: ShiftCardType.upcoming,
      statusLabel: '$approvedCount/$targetCount assigned',
      statusType: ShiftStatusType.neutral,
      staffList: staffList,
    );
  }

  /// Build Need Attention Timeline (new design)
  ///
  /// Shows a 5-day timeline with:
  /// - Orange dots = Coverage gaps (tap → Schedule tab)
  /// - Red dots = Staff problems (tap → Problems tab)
  /// - Pagination: `< 7 more` and `5 more >` buttons
  ///
  /// OPTIMIZATION: Uses centralized coverageGapProvider for consistent data
  /// across Overview and Schedule tabs. Single source of truth for:
  /// - Business hours (no default value fallback during loading)
  /// - Coverage gap calculation
  /// - TODAY time-based filtering
  Widget _buildNeedAttentionTimeline(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
    ShiftMetadata? shiftMetadata,
  ) {
    // Use centralized coverage gap provider for consistent data across tabs
    // This provider handles business hours fetching internally and waits for loading
    CoverageGapState? coverageGapState;
    if (widget.selectedStoreId != null) {
      final now = DateTime.now();
      final state = ref.watch(monthCoverageGapProvider(MonthCoverageGapKey(
        storeId: widget.selectedStoreId!,
        year: now.year,
        month: now.month,
      )));

      // If coverage gap provider is still loading, show loading state
      if (state.isLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: TossLoadingView.inline(size: 24),
        );
      }
      coverageGapState = state;
    }

    final attentionItems = _attentionItemsBuilder.getAttentionItems(
      managerCardsState: managerCardsState,
      monthlyStatusState: monthlyStatusState,
      shiftMetadata: shiftMetadata,
      getAllCards: getAllCards,
      formatDate: formatDate,
      formatTimeRange: formatTimeRange,
      parseShiftEndTime: parseShiftEndTime,
      coverageGapState: coverageGapState,
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
    final currentShiftEndTime = parseShiftEndTime(card.shiftEndTime);
    final shiftEndTime = findConsecutiveEndTime(
      staffId: card.employee.userId,
      shiftDate: card.shiftDate,
      currentShiftEndTime: currentShiftEndTime,
      allCards: allCards,
    );

    // Extract values from problem_details_v2 (no legacy fields)
    final pd = card.problemDetails;
    final hasLate = pd?.problems.any((p) => p.type == 'late' && p.isSolved != true) ?? false;
    final hasOvertime = pd?.problems.any((p) => p.type == 'overtime' && p.isSolved != true) ?? false;
    final hasReported = pd?.problems.any((p) => p.type == 'reported' && p.isSolved != true) ?? false;
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

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute<Map<String, dynamic>>(
        builder: (context) => StaffTimelogDetailPage(
          staffRecord: staffRecord,
          shiftName: shift.shiftName ?? 'Shift',
          shiftDate: shiftDateStr,
          shiftTimeRange: formatTimeRange(shift.planStartTime, shift.planEndTime),
        ),
      ),
    );

    // ✅ Partial Update: Update only the affected card in cache
    // Instead of forceRefresh which reloads ALL data, we update the single modified card
    if (result != null && result['success'] == true && widget.selectedStoreId != null) {
      // Build ManagerMemo from result if memo was added
      final memoText = result['managerMemo'] as String?;
      ManagerMemo? newMemo;
      if (memoText != null && memoText.isNotEmpty) {
        newMemo = ManagerMemo(
          type: 'note',
          content: memoText,
          createdAt: DateTime.now().toIso8601String(),
          createdBy: null,
        );
      }

      // Parse shiftDate from display format (e.g., "Mon, 6 Jan 2025") to yyyy-MM-dd
      final parsedDate = DateFormat('EEE, d MMM yyyy').parse(result['shiftDate'] as String);
      final shiftDateFormatted = DateFormat('yyyy-MM-dd').format(parsedDate);

      ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).updateCardProblemData(
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

}
