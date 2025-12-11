import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/manager_shift_cards.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../pages/staff_timelog_detail_page.dart';
import '../../providers/states/time_table_state.dart';
import '../../providers/time_table_providers.dart';
import 'attention_card.dart';
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

  const OverviewTab({
    super.key,
    required this.selectedStoreId,
    required this.onStoreSelectorTap,
    this.onStoreChanged,
    this.onNavigateToSchedule,
  });

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> {
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

    // Get all cards from all months
    final allCards = cardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .toList();

    // Filter by shift date, shift name, and approved status
    return allCards.where((card) {
      return card.shiftDate == shiftDate &&
          card.shift.shiftName == shiftName &&
          card.isApproved;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final stores = _extractStores(appState.user, appState.companyChoosen);

    // Watch monthly shift status for current activity data
    final monthlyStatusState = widget.selectedStoreId != null
        ? ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!))
        : null;
    final allDailyShifts = monthlyStatusState?.allMonthlyStatuses
        .expand((status) => status.dailyShifts)
        .toList() ?? [];

    // Watch manager cards for attendance data (on-time/late/not-checked-in)
    final managerCardsState = widget.selectedStoreId != null
        ? ref.watch(managerCardsProvider(widget.selectedStoreId!))
        : null;

    // Watch shift metadata for all available shifts (including those with 0 requests)
    final shiftMetadataAsync = widget.selectedStoreId != null
        ? ref.watch(shiftMetadataProvider(widget.selectedStoreId!))
        : null;
    final shiftMetadata = shiftMetadataAsync?.valueOrNull;

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
          // 1️⃣ Store Selector Dropdown (same as Schedule tab)
          _buildStoreSelector(stores),
          const SizedBox(height: TossSpacing.space6),

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

          // 4️⃣ Need Attention Section
          _buildNeedAttentionHeader(managerCardsState, monthlyStatusState, shiftMetadata),
          const SizedBox(height: TossSpacing.space2),
          _buildNeedAttentionScroll(managerCardsState, monthlyStatusState, shiftMetadata),
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
    // Extract all cards from managerCardsState for UseCase
    final allCards = managerCardsState?.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .toList();
    final allCardsEntity = allCards != null
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
      onEmployeeTap: (card) => _handleEmployeeTap(card, shift, allCards ?? []),
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

  /// Build Need Attention header (without "See All" button)
  Widget _buildNeedAttentionHeader(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
    ShiftMetadata? shiftMetadata,
  ) {
    final attentionItems = _getAttentionItems(managerCardsState, monthlyStatusState, shiftMetadata);
    // Filter to show only yesterday, today, tomorrow
    final filteredItems = _filterByRecentDates(attentionItems);
    final count = filteredItems.length;

    return Text(
      'Need Attention ($count)',
      style: TossTextStyles.labelMedium.copyWith(
        color: TossColors.gray600,
      ),
    );
  }

  /// Filter attention items to show only yesterday, today, and tomorrow
  List<AttentionItemData> _filterByRecentDates(List<AttentionItemData> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    return items.where((item) {
      if (item.shiftDate == null) return false;
      final itemDate = DateTime(
        item.shiftDate!.year,
        item.shiftDate!.month,
        item.shiftDate!.day,
      );
      return itemDate.isAtSameMomentAs(yesterday) ||
          itemDate.isAtSameMomentAs(today) ||
          itemDate.isAtSameMomentAs(tomorrow);
    }).toList();
  }

  /// Get attention items from real data
  ///
  /// Sources:
  /// 1. manager_shift_get_cards_v4 (is_approved = true):
  ///    - Late: is_late = true (show late_minute)
  ///    - Problem: is_problem = true AND is_problem_solved = false
  ///    - Reported: is_reported = true AND is_problem_solved = false
  ///    - Overtime: is_overtime = true (show overtime_minute)
  /// 2. get_monthly_shift_status_manager_v4 + get_shift_metadata_v2_utc:
  ///    - Understaffed: total_required > total_approved
  ///    - Including shifts with 0 requests (from metadata)
  List<AttentionItemData> _getAttentionItems(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
    ShiftMetadata? shiftMetadata,
  ) {
    final List<AttentionItemData> items = [];

    // 1. Get attention items from manager cards (approved cards only)
    if (managerCardsState != null) {
      final allCards = managerCardsState.dataByMonth.values
          .expand((managerCards) => managerCards.cards)
          .where((card) => card.isApproved)
          .toList();

      for (final card in allCards) {
        final shiftDate = DateTime.tryParse(card.shiftDate) ?? DateTime.now();
        final dateStr = _formatDate(shiftDate);
        final timeStr = _formatTimeRange(card.shift.planStartTime, card.shift.planEndTime);

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

        // Common navigation data for staff items
        AttentionItemData createStaffAttentionItem({
          required AttentionType type,
          required String subtext,
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
            isLate: card.isLate,
            isOvertime: card.isOverTime,
            isConfirmed: card.confirmedStartTime != null || card.confirmedEndTime != null,
            actualStart: card.actualStartTime?.toIso8601String(),
            actualEnd: card.actualEndTime?.toIso8601String(),
            confirmStartTime: card.confirmedStartTime?.toIso8601String(),
            confirmEndTime: card.confirmedEndTime?.toIso8601String(),
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
            avatarUrl: card.employee.profileImage,
            shiftDate: shiftDate,
            shiftName: card.shift.shiftName,
            shiftTimeRange: timeStr,
            isShiftProblem: false,
            shiftEndTime: shiftEndTime,
          );
        }

        // Late: is_late = true
        if (card.isLate) {
          items.add(createStaffAttentionItem(
            type: AttentionType.late,
            subtext: '${card.lateMinute} mins late',
          ));
        }

        // Problem: is_problem = true AND is_problem_solved = false AND is_reported = false
        // Skip if isReported is true (will be shown as Reported instead)
        if (card.hasProblem && !card.isProblemSolved && !card.isReported) {
          items.add(createStaffAttentionItem(
            type: AttentionType.problem,
            subtext: card.problemType ?? 'Has problem',
          ));
        }

        // Reported: is_reported = true AND is_problem_solved = false
        if (card.isReported && !card.isProblemSolved) {
          items.add(createStaffAttentionItem(
            type: AttentionType.reported,
            subtext: card.reportReason ?? 'Reported',
          ));
        }

        // Overtime: is_overtime = true
        if (card.isOverTime) {
          final hours = card.overTimeMinute ~/ 60;
          final mins = card.overTimeMinute % 60;
          final overtimeStr = hours > 0
              ? (mins > 0 ? '$hours hrs $mins mins overtime' : '$hours hrs overtime')
              : '${card.overTimeMinute} mins overtime';
          items.add(createStaffAttentionItem(
            type: AttentionType.overtime,
            subtext: overtimeStr,
          ));
        }
      }
    }

    // 2. Get understaffed shifts from monthly status (shifts with at least 1 request)
    // Build a set of (date, shiftId) pairs that have been processed
    final Set<String> processedShifts = {};

    if (monthlyStatusState != null) {
      for (final monthlyStatus in monthlyStatusState.allMonthlyStatuses) {
        for (final dailyData in monthlyStatus.dailyShifts) {
          for (final shiftWithReqs in dailyData.shifts) {
            final shift = shiftWithReqs.shift;
            final totalRequired = shift.targetCount;
            final totalApproved = shiftWithReqs.approvedRequests.length;

            // Mark this shift as processed for this date
            final shiftKey = '${dailyData.date}_${shift.shiftId}';
            processedShifts.add(shiftKey);

            // Understaffed: total_required > total_approved
            if (totalRequired > totalApproved) {
              items.add(AttentionItemData(
                type: AttentionType.understaffed,
                title: shift.shiftName ?? 'Unnamed Shift',
                date: _formatDate(shift.planStartTime),
                time: _formatTimeRange(shift.planStartTime, shift.planEndTime),
                subtext: '$totalApproved/$totalRequired assigned',
                // Understaffed is shift-level problem, not staff-level
                isShiftProblem: true,
                shiftDate: shift.planStartTime,
                shiftName: shift.shiftName,
                shiftTimeRange: _formatTimeRange(shift.planStartTime, shift.planEndTime),
              ));
            }
          }
        }
      }
    }

    // 3. Get understaffed shifts with 0 requests (from metadata)
    // These shifts don't appear in monthly_status because no one has applied
    if (shiftMetadata != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final tomorrow = today.add(const Duration(days: 1));

      // Check for each active shift if it has any requests for yesterday/today/tomorrow
      for (final metaShift in shiftMetadata.activeShifts) {
        // Skip shifts that don't require staff
        if (metaShift.targetCount <= 0) continue;

        // Check for each relevant date
        for (final date in [yesterday, today, tomorrow]) {
          final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final shiftKey = '${dateStr}_${metaShift.shiftId}';

          // Skip if this shift was already processed (has at least 1 request)
          if (processedShifts.contains(shiftKey)) continue;

          // This shift has 0 requests for this date - it's understaffed!
          // Parse shift start time from metadata for shiftDate
          final shiftDateTime = _parseTimeString(metaShift.startTime, date);

          items.add(AttentionItemData(
            type: AttentionType.understaffed,
            title: metaShift.shiftName,
            date: _formatDate(date),
            time: _formatTimeRangeFromStrings(metaShift.startTime, metaShift.endTime),
            subtext: '0/${metaShift.targetCount} assigned',
            isShiftProblem: true,
            shiftDate: shiftDateTime,
            shiftName: metaShift.shiftName,
            shiftTimeRange: _formatTimeRangeFromStrings(metaShift.startTime, metaShift.endTime),
          ));
        }
      }
    }

    return items;
  }

  /// Parse time string (HH:mm or HH:mm:ss) to DateTime on a specific date
  DateTime _parseTimeString(String timeStr, DateTime date) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      return date;
    }
  }

  /// Format time range from time strings (HH:mm format)
  String _formatTimeRangeFromStrings(String startTime, String endTime) {
    // Extract HH:mm from the time strings (might be HH:mm:ss+TZ format)
    String extractTime(String time) {
      // Handle formats like "10:00:00+07" or "10:00"
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
      return time;
    }
    return '${extractTime(startTime)} – ${extractTime(endTime)}';
  }

  /// Build Need Attention horizontal scroll
  Widget _buildNeedAttentionScroll(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
    ShiftMetadata? shiftMetadata,
  ) {
    final attentionItems = _getAttentionItems(managerCardsState, monthlyStatusState, shiftMetadata);
    // Filter to show only yesterday, today, tomorrow
    final filteredItems = _filterByRecentDates(attentionItems);

    if (filteredItems.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text('No items need attention'),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filteredItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: TossSpacing.space3),
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return AttentionCard(
            item: item,
            onTap: () => _handleAttentionItemTap(item),
          );
        },
      ),
    );
  }

  /// Handle attention item tap - navigate to detail page if it's a staff issue
  Future<void> _handleAttentionItemTap(AttentionItemData item) async {
    // For shift-level issues (understaffed), navigate to Schedule tab with the date
    if (item.isShiftProblem) {
      if (item.shiftDate != null && widget.onNavigateToSchedule != null) {
        widget.onNavigateToSchedule!(item.shiftDate!);
      }
      return;
    }

    // For staff-level issues (late, overtime, problem, reported), navigate to detail page
    if (item.shiftRequestId == null) return;

    // Create StaffTimeRecord from AttentionItemData
    final staffRecord = StaffTimeRecord(
      staffId: item.staffId ?? '',
      staffName: item.title,
      avatarUrl: item.avatarUrl,
      clockIn: item.clockIn ?? '--:--',
      clockOut: item.clockOut ?? '--:--',
      isLate: item.isLate,
      isOvertime: item.isOvertime,
      needsConfirm: !item.isConfirmed,
      isConfirmed: item.isConfirmed,
      shiftRequestId: item.shiftRequestId,
      actualStart: item.actualStart,
      actualEnd: item.actualEnd,
      confirmStartTime: item.confirmStartTime,
      confirmEndTime: item.confirmEndTime,
      isReported: item.isReported,
      reportReason: item.reportReason,
      isProblemSolved: item.isProblemSolved,
      bonusAmount: item.bonusAmount,
      salaryType: item.salaryType,
      salaryAmount: item.salaryAmount,
      basePay: item.basePay,
      totalPayWithBonus: item.totalPayWithBonus,
      paidHour: item.paidHour,
      lateMinute: item.lateMinute,
      overtimeMinute: item.overtimeMinute,
      // v4: New fields
      isReportedSolved: item.isReportedSolved,
      managerMemos: item.managerMemos,
      shiftEndTime: item.shiftEndTime,
    );

    // Format shift date for display
    final shiftDateStr = item.shiftDate != null
        ? DateFormat('EEE, d MMM yyyy').format(item.shiftDate!)
        : item.date;

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => StaffTimelogDetailPage(
          staffRecord: staffRecord,
          shiftName: item.shiftName ?? 'Shift',
          shiftDate: shiftDateStr,
          shiftTimeRange: item.shiftTimeRange ?? item.time,
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

    // Create StaffTimeRecord from ShiftCard
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
      isLate: card.isLate,
      isOvertime: card.isOverTime,
      needsConfirm: card.confirmedStartTime == null && card.confirmedEndTime == null,
      isConfirmed: card.confirmedStartTime != null || card.confirmedEndTime != null,
      shiftRequestId: card.shiftRequestId,
      actualStart: card.actualStartTime?.toIso8601String(),
      actualEnd: card.actualEndTime?.toIso8601String(),
      confirmStartTime: card.confirmedStartTime?.toIso8601String(),
      confirmEndTime: card.confirmedEndTime?.toIso8601String(),
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
      shiftEndTime: shiftEndTime,
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
