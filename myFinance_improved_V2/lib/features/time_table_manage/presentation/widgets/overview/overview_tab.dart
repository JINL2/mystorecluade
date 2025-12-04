import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/shift_card.dart';
import '../../pages/attention_list_page.dart';
import '../../providers/states/time_table_state.dart';
import '../../providers/time_table_providers.dart';
import 'attention_card.dart';
import 'shift_info_card.dart';

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

  const OverviewTab({
    super.key,
    required this.selectedStoreId,
    required this.onStoreSelectorTap,
    this.onStoreChanged,
  });

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> {
  /// Find the current activity shift from monthly data
  /// Current activity = shift closest to now based on shift_start_time
  /// - If current time is within shift_start_time ~ shift_end_time, that's current
  /// - Otherwise, find the shift with smallest time difference to now
  ShiftWithRequests? _findCurrentActivityShift(List<DailyShiftData> allDailyShifts) {
    if (allDailyShifts.isEmpty) return null;

    final now = DateTime.now();
    ShiftWithRequests? currentShift;
    Duration? smallestDiff;

    for (final dailyData in allDailyShifts) {
      for (final shiftWithReqs in dailyData.shifts) {
        final startTime = shiftWithReqs.shift.planStartTime;
        final endTime = shiftWithReqs.shift.planEndTime;

        // If now is within the shift time range, this is the current activity
        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          return shiftWithReqs;
        }

        // Calculate time difference from shift_start_time to now
        final diff = startTime.difference(now).abs();

        if (smallestDiff == null || diff < smallestDiff) {
          smallestDiff = diff;
          currentShift = shiftWithReqs;
        }
      }
    }

    return currentShift;
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

  /// Find the upcoming shift (next shift after current activity)
  ShiftWithRequests? _findUpcomingShift(
    List<DailyShiftData> allDailyShifts,
    ShiftWithRequests? currentActivityShift,
  ) {
    if (allDailyShifts.isEmpty) return null;

    // Reference point: current activity's start time, or now if no current activity
    final referenceTime = currentActivityShift?.shift.planStartTime ?? DateTime.now();
    final currentShiftId = currentActivityShift?.shift.shiftId;

    ShiftWithRequests? upcomingShift;
    DateTime? earliestUpcoming;

    for (final dailyData in allDailyShifts) {
      for (final shiftWithReqs in dailyData.shifts) {
        final startTime = shiftWithReqs.shift.planStartTime;

        // Skip if this is the current activity shift
        if (currentShiftId != null && shiftWithReqs.shift.shiftId == currentShiftId) {
          continue;
        }

        // Skip if starts before or at the reference time
        if (startTime.isBefore(referenceTime) || startTime.isAtSameMomentAs(referenceTime)) {
          continue;
        }

        // Find the earliest shift after reference time
        if (earliestUpcoming == null || startTime.isBefore(earliestUpcoming)) {
          earliestUpcoming = startTime;
          upcomingShift = shiftWithReqs;
        }
      }
    }

    return upcomingShift;
  }

  /// Find consecutive shift chain for a given shift
  ///
  /// Consecutive shifts are connected when:
  /// - Previous shift's endTime == Current shift's startTime
  /// - Current shift's endTime == Next shift's startTime
  ///
  /// Returns list of shifts in the chain, ordered by start time
  List<ShiftWithRequests> _findConsecutiveShiftChain(
    List<DailyShiftData> allDailyShifts,
    ShiftWithRequests currentShift,
  ) {
    // Get all shifts flattened and sorted by start time
    final allShifts = allDailyShifts
        .expand((daily) => daily.shifts)
        .toList()
      ..sort((a, b) => a.shift.planStartTime.compareTo(b.shift.planStartTime));

    if (allShifts.isEmpty) return [currentShift];

    // Find current shift index
    final currentIndex = allShifts.indexWhere(
      (s) => s.shift.shiftId == currentShift.shift.shiftId,
    );
    if (currentIndex == -1) return [currentShift];

    final List<ShiftWithRequests> chain = [currentShift];

    // Look backwards for consecutive shifts
    for (int i = currentIndex - 1; i >= 0; i--) {
      final prevShift = allShifts[i];
      final nextInChain = chain.first;

      // Check if previous shift's end time matches next shift's start time
      if (_isConsecutive(prevShift.shift.planEndTime, nextInChain.shift.planStartTime)) {
        chain.insert(0, prevShift);
      } else {
        break; // Chain broken
      }
    }

    // Look forwards for consecutive shifts
    for (int i = currentIndex + 1; i < allShifts.length; i++) {
      final nextShift = allShifts[i];
      final prevInChain = chain.last;

      // Check if previous shift's end time matches next shift's start time
      if (_isConsecutive(prevInChain.shift.planEndTime, nextShift.shift.planStartTime)) {
        chain.add(nextShift);
      } else {
        break; // Chain broken
      }
    }

    return chain;
  }

  /// Check if two times are consecutive (exactly equal)
  bool _isConsecutive(DateTime endTime, DateTime startTime) {
    return endTime.hour == startTime.hour &&
        endTime.minute == startTime.minute &&
        endTime.year == startTime.year &&
        endTime.month == startTime.month &&
        endTime.day == startTime.day;
  }

  /// Get employee attendance status from the first shift in consecutive chain
  ///
  /// If employee worked consecutive shifts, their status from the first shift
  /// is inherited to subsequent shifts in the chain.
  ///
  /// Returns: 'onTime', 'late', 'notCheckedIn', or null if not found
  String? _getEmployeeStatusFromChain(
    String employeeName,
    List<ShiftWithRequests> shiftChain,
    ManagerShiftCardsState? cardsState,
  ) {
    if (shiftChain.isEmpty || cardsState == null) return null;

    // Check each shift in chain starting from the first
    for (final shiftWithReqs in shiftChain) {
      final shift = shiftWithReqs.shift;
      final shiftDate = '${shift.planStartTime.year}-${shift.planStartTime.month.toString().padLeft(2, '0')}-${shift.planStartTime.day.toString().padLeft(2, '0')}';

      final cardsForShift = _getCardsForShift(cardsState, shift.shiftName ?? '', shiftDate);

      // Find card for this employee
      final employeeCard = cardsForShift.where(
        (card) => card.employee.userName == employeeName,
      ).firstOrNull;

      if (employeeCard != null) {
        // Has check-in data
        if (employeeCard.actualStartTime != null || employeeCard.confirmedStartTime != null) {
          final checkInTime = employeeCard.actualStartTime ?? employeeCard.confirmedStartTime;
          if (employeeCard.isLate || (checkInTime != null && checkInTime.isAfter(shift.planStartTime))) {
            return 'late';
          } else {
            return 'onTime';
          }
        } else {
          return 'notCheckedIn';
        }
      }
    }

    return null; // Employee not found in chain
  }

  /// Calculate attendance status from ShiftCard data with consecutive shift support
  ///
  /// Logic based on manager_shift_get_cards_v3 RPC:
  /// - On-time: actualStartTime <= shift.planStartTime
  /// - Late: actualStartTime > shift.planStartTime (or isLate flag)
  /// - Not checked in: actualStartTime == null && confirmedStartTime == null
  ///
  /// For consecutive shifts: If employee has no data for current shift but
  /// was in a previous consecutive shift, inherit their status from the first shift.
  ({
    List<ShiftCard> onTime,
    List<ShiftCard> late,
    List<ShiftCard> notCheckedIn,
    int arrivedCount,
  }) _calculateAttendanceStatus(
    List<ShiftCard> cardsForShift,
    DateTime planStartTime, {
    List<ShiftWithRequests>? consecutiveChain,
    ShiftWithRequests? currentShiftWithReqs,
    ManagerShiftCardsState? cardsState,
  }) {
    final List<ShiftCard> onTimeCards = [];
    final List<ShiftCard> lateCards = [];
    final List<ShiftCard> notCheckedInCards = [];

    // Track processed employees to avoid duplicates
    final Set<String> processedEmployees = {};

    for (final card in cardsForShift) {
      processedEmployees.add(card.employee.userName);

      // Not checked in: both actualStartTime and confirmedStartTime are null
      if (card.actualStartTime == null && card.confirmedStartTime == null) {
        notCheckedInCards.add(card);
        continue;
      }

      // Use actualStartTime if available, otherwise use confirmedStartTime
      final checkInTime = card.actualStartTime ?? card.confirmedStartTime;

      if (checkInTime != null) {
        // Late: checkInTime > planStartTime (or isLate flag is true)
        if (card.isLate || checkInTime.isAfter(planStartTime)) {
          lateCards.add(card);
        } else {
          // On-time: checkInTime <= planStartTime
          onTimeCards.add(card);
        }
      }
    }

    // Handle consecutive shift inheritance
    // Check if there are employees in consecutive chain who should be in this shift
    if (consecutiveChain != null &&
        consecutiveChain.length > 1 &&
        currentShiftWithReqs != null &&
        cardsState != null) {
      // Get all approved employees for this shift (from monthly status)
      final approvedEmployeesForShift = currentShiftWithReqs.approvedRequests;

      for (final req in approvedEmployeesForShift) {
        final employeeName = req.employee.userName;

        // Skip if already processed
        if (processedEmployees.contains(employeeName)) continue;

        // Check if this employee has status from earlier in the chain
        final inheritedStatus = _getEmployeeStatusFromChain(
          employeeName,
          consecutiveChain,
          cardsState,
        );

        if (inheritedStatus != null) {
          // Create a synthetic card for display
          final syntheticCard = ShiftCard(
            shiftRequestId: req.shiftRequestId,
            employee: req.employee,
            shift: currentShiftWithReqs.shift,
            shiftDate: '${currentShiftWithReqs.shift.planStartTime.year}-${currentShiftWithReqs.shift.planStartTime.month.toString().padLeft(2, '0')}-${currentShiftWithReqs.shift.planStartTime.day.toString().padLeft(2, '0')}',
            isApproved: true,
            hasProblem: false,
            createdAt: DateTime.now(),
          );

          switch (inheritedStatus) {
            case 'onTime':
              onTimeCards.add(syntheticCard);
            case 'late':
              lateCards.add(syntheticCard);
            case 'notCheckedIn':
              notCheckedInCards.add(syntheticCard);
          }
          processedEmployees.add(employeeName);
        }
      }
    }

    return (
      onTime: onTimeCards,
      late: lateCards,
      notCheckedIn: notCheckedInCards,
      arrivedCount: onTimeCards.length + lateCards.length,
    );
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
    final stores = _extractStores(appState.user);

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

    // Find current activity shift
    final currentActivityShift = _findCurrentActivityShift(allDailyShifts);

    // Find upcoming shift (next after current activity)
    final upcomingShift = _findUpcomingShift(allDailyShifts, currentActivityShift);

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
          _buildNeedAttentionHeader(managerCardsState, monthlyStatusState),
          const SizedBox(height: TossSpacing.space2),
          _buildNeedAttentionScroll(managerCardsState, monthlyStatusState),
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
    final targetCount = shift.targetCount;

    // Get cards for this specific shift from manager_shift_get_cards_v3 data
    // Match by shiftName since RPC doesn't return shift_id
    final shiftDate = '${shift.planStartTime.year}-${shift.planStartTime.month.toString().padLeft(2, '0')}-${shift.planStartTime.day.toString().padLeft(2, '0')}';
    final cardsForShift = _getCardsForShift(managerCardsState, shift.shiftName ?? '', shiftDate);

    // Find consecutive shift chain for inheritance logic
    final consecutiveChain = _findConsecutiveShiftChain(allDailyShifts, currentShift);

    // Calculate attendance status with consecutive shift support
    final attendance = _calculateAttendanceStatus(
      cardsForShift,
      shift.planStartTime,
      consecutiveChain: consecutiveChain,
      currentShiftWithReqs: currentShift,
      cardsState: managerCardsState,
    );
    final arrivedCount = attendance.arrivedCount;

    // Build employee lists for snapshot
    final onTimeEmployees = attendance.onTime.map((card) => <String, dynamic>{
      'user_name': card.employee.userName,
      'profile_image': card.employee.profileImage ?? '',
    }).toList();

    final lateEmployees = attendance.late.map((card) => <String, dynamic>{
      'user_name': card.employee.userName,
      'profile_image': card.employee.profileImage ?? '',
    }).toList();

    final notCheckedInEmployees = attendance.notCheckedIn.map((card) => <String, dynamic>{
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
        ),
        late: SnapshotMetric(
          count: attendance.late.length,
          employees: lateEmployees,
        ),
        notCheckedIn: SnapshotMetric(
          count: attendance.notCheckedIn.length,
          employees: notCheckedInEmployees,
        ),
      ),
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

  /// Build Need Attention header with "See All" button
  Widget _buildNeedAttentionHeader(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
  ) {
    final attentionItems = _getAttentionItems(managerCardsState, monthlyStatusState);
    final count = attentionItems.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Need Attention ($count)',
          style: TossTextStyles.labelMedium.copyWith(
            color: TossColors.gray600,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => AttentionListPage(items: attentionItems),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'See All',
            style: TossTextStyles.button.copyWith(
              color: TossColors.primary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  /// Get attention items from real data
  ///
  /// Sources:
  /// 1. manager_shift_get_cards_v3 (is_approved = true):
  ///    - Late: is_late = true (show late_minute)
  ///    - Problem: is_problem = true AND is_problem_solved = false
  ///    - Reported: is_reported = true AND is_problem_solved = false
  ///    - Overtime: is_overtime = true (show overtime_minute)
  /// 2. get_monthly_shift_status_manager_v4:
  ///    - Understaffed: total_required > total_approved
  List<AttentionItemData> _getAttentionItems(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
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

        // Late: is_late = true
        if (card.isLate) {
          items.add(AttentionItemData(
            type: AttentionType.late,
            title: card.employee.userName,
            date: dateStr,
            time: timeStr,
            subtext: '${card.lateMinute} mins late',
          ));
        }

        // Problem: is_problem = true AND is_problem_solved = false
        if (card.hasProblem && !card.isProblemSolved) {
          items.add(AttentionItemData(
            type: AttentionType.problem,
            title: card.employee.userName,
            date: dateStr,
            time: timeStr,
            subtext: card.problemType ?? 'Has problem',
          ));
        }

        // Reported: is_reported = true AND is_problem_solved = false
        if (card.isReported && !card.isProblemSolved) {
          items.add(AttentionItemData(
            type: AttentionType.reported,
            title: card.employee.userName,
            date: dateStr,
            time: timeStr,
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
          items.add(AttentionItemData(
            type: AttentionType.overtime,
            title: card.employee.userName,
            date: dateStr,
            time: timeStr,
            subtext: overtimeStr,
          ));
        }
      }
    }

    // 2. Get understaffed shifts from monthly status
    if (monthlyStatusState != null) {
      for (final monthlyStatus in monthlyStatusState.allMonthlyStatuses) {
        for (final dailyData in monthlyStatus.dailyShifts) {
          for (final shiftWithReqs in dailyData.shifts) {
            final shift = shiftWithReqs.shift;
            final totalRequired = shift.targetCount;
            final totalApproved = shiftWithReqs.approvedRequests.length;

            // Understaffed: total_required > total_approved
            if (totalRequired > totalApproved) {
              items.add(AttentionItemData(
                type: AttentionType.understaffed,
                title: shift.shiftName ?? 'Unnamed Shift',
                date: _formatDate(shift.planStartTime),
                time: _formatTimeRange(shift.planStartTime, shift.planEndTime),
                subtext: '$totalApproved/$totalRequired assigned',
              ));
            }
          }
        }
      }
    }

    return items;
  }

  /// Build Need Attention horizontal scroll
  Widget _buildNeedAttentionScroll(
    ManagerShiftCardsState? managerCardsState,
    MonthlyShiftStatusState? monthlyStatusState,
  ) {
    final attentionItems = _getAttentionItems(managerCardsState, monthlyStatusState);

    if (attentionItems.isEmpty) {
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
        itemCount: attentionItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: TossSpacing.space3),
        itemBuilder: (context, index) {
          return AttentionCard(item: attentionItems[index]);
        },
      ),
    );
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

  /// Extract stores from user data
  List<dynamic> _extractStores(Map<String, dynamic> userData) {
    if (userData.isEmpty) return [];

    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      final firstCompany = companies[0] as Map<String, dynamic>;
      final stores = firstCompany['stores'] as List<dynamic>?;
      if (stores == null) return [];

      return stores;
    } catch (e) {
      return [];
    }
  }
}
