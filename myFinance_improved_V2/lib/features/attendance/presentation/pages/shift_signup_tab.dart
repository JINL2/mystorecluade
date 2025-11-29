import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../../shared/widgets/toss/toss_week_navigation.dart';
import '../../../../shared/widgets/toss/week_dates_picker.dart';
import '../../../attendance/domain/entities/monthly_shift_status.dart';
import '../../../attendance/domain/entities/shift_metadata.dart';
import '../providers/attendance_providers.dart';
import '../widgets/shift_signup/shift_signup_card.dart';

/// ShiftSignupTab - Shift registration page with new UI design
///
/// Design Pattern:
/// - Week navigation (< Previous week | This week • 10-16 Jun | Next week >)
/// - 7 date circles (Mon-Sun) with blue dots for dates with available shifts
/// - "Available Shifts on {date}" header
/// - Shift cards with 4 states: Available, Waitlist, Applied, Assigned
class ShiftSignupTab extends ConsumerStatefulWidget {
  const ShiftSignupTab({super.key});

  @override
  ConsumerState<ShiftSignupTab> createState() => _ShiftSignupTabState();
}

class _ShiftSignupTabState extends ConsumerState<ShiftSignupTab>
    with AutomaticKeepAliveClientMixin {
  DateTime selectedDate = DateTime.now();
  int _currentWeekOffset = 0; // 0 = current week, -1 = prev, +1 = next
  String? selectedStoreId;
  List<ShiftMetadata>? shiftMetadata;
  bool isLoadingMetadata = false;

  // Monthly shift status data for dates with shifts indicator
  List<MonthlyShiftStatus>? monthlyShiftStatus;

  // Track which shifts the user has applied to
  Set<String> appliedShiftIds = {};

  // Track which shifts the user has joined waitlist for
  Set<String> waitlistedShiftIds = {};

  // Keep state alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  // Computed property: Get Monday of the current week (matches My Schedule tab logic)
  DateTime get weekStartDate {
    final currentWeek = DateTime.now().add(Duration(days: _currentWeekOffset * 7));
    final weekday = currentWeek.weekday; // 1=Mon, 7=Sun
    final monday = currentWeek.subtract(Duration(days: weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Get selected store from app state
    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    if (selectedStoreId != null) {
      await Future.wait([
        _fetchShiftMetadata(selectedStoreId!),
        _fetchMonthlyShiftStatus(),
      ]);
    }
  }

  Future<void> _fetchMonthlyShiftStatus() async {
    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    if (storeId.isEmpty || companyId.isEmpty) return;

    try {
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);

      // Use the middle of the selected month to ensure we fetch the entire month's data
      // RPC v3 uses requestTime to determine the month range
      // Using mid-month (15th) ensures we get data for the entire month
      // Format: "yyyy-MM-dd HH:mm:ss" in user's local time
      final now = DateTime.now();
      // Use the later of: current time or selected date (to fetch future month data)
      final baseDate = selectedDate.isAfter(now) ? selectedDate : now;
      // Use the 15th of the month to ensure full month coverage
      final targetDate = DateTime(baseDate.year, baseDate.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      // Get user's local timezone from device
      final timezone = DateTimeUtils.getLocalTimezone();

      print('📅 Fetching monthly shift status: requestTime=$requestTime, timezone=$timezone');

      final response = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      // Debug: Print response data
      print('📊 Monthly Shift Status fetched: ${response.length} days');
      for (final day in response) {
        print('  📅 ${day.requestDate}: ${day.shifts.length} shifts');
        for (final shift in day.shifts) {
          print('    - [${shift.shiftId}] ${shift.shiftName}: approved=${shift.approvedCount}/${shift.requiredEmployees}, pending=${shift.pendingCount}');
          print('      approvedEmployees: ${shift.approvedEmployees.map((e) => e.userId).toList()}');
          print('      pendingEmployees: ${shift.pendingEmployees.map((e) => e.userId).toList()}');
        }
      }

      if (mounted) {
        setState(() {
          monthlyShiftStatus = response;
        });
      }
    } catch (e) {
      print('❌ Error fetching monthly shift status: $e');
    }
  }

  Future<void> _fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;

    setState(() {
      isLoadingMetadata = true;
    });

    try {
      final getShiftMetadata = ref.read(getShiftMetadataProvider);
      final response = await getShiftMetadata(
        storeId: storeId,
        timezone: 'Asia/Seoul', // TODO: Get from user settings
      );

      // Debug: Print shift details including IDs
      print('📋 Shift Metadata fetched:');
      for (var shift in response) {
        print('  [${shift.shiftId}] ${shift.shiftName}: ${shift.startTime} - ${shift.endTime}');
      }

      if (mounted) {
        setState(() {
          shiftMetadata = response;
          isLoadingMetadata = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching shift metadata: $e');
      if (mounted) {
        setState(() {
          isLoadingMetadata = false;
          shiftMetadata = [];
        });
      }
    }
  }

  // Get active shifts for display
  List<ShiftMetadata> _getActiveShifts() {
    if (shiftMetadata == null) {
      print('⚠️ shiftMetadata is null');
      return [];
    }

    final activeShifts = shiftMetadata!.where((shift) => shift.isActive).toList();
    print('📊 Active shifts count: ${activeShifts.length} / ${shiftMetadata!.length}');

    if (activeShifts.isEmpty && shiftMetadata!.isNotEmpty) {
      print('⚠️ No active shifts found. All shifts are inactive.');
      for (var shift in shiftMetadata!) {
        print('  - ${shift.shiftName}: isActive = ${shift.isActive}');
      }
    }

    return activeShifts;
  }

  // Get dates where current user has approved shifts (for blue border)
  Set<DateTime> _getDatesWithUserApproved() {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) {
      return {};
    }

    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;

    if (currentUserId.isEmpty) {
      return {};
    }

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Set<DateTime> datesWithUserApproved = {};

    for (final dayStatus in monthlyShiftStatus!) {
      try {
        final date = DateTime.parse(dayStatus.requestDate);
        final normalizedDate = DateTime(date.year, date.month, date.day);
        final weekEnd = weekStartDate.add(const Duration(days: 6));

        // Only for dates from today onwards within the week
        if (!date.isBefore(weekStartDate) &&
            !date.isAfter(weekEnd) &&
            !normalizedDate.isBefore(todayNormalized)) {
          // Check if current user has any approved shift on this date
          for (final shift in dayStatus.shifts) {
            if (shift.approvedEmployees.any((emp) => emp.userId == currentUserId)) {
              datesWithUserApproved.add(normalizedDate);
              break;
            }
          }
        }
      } catch (e) {
        print('Error parsing date for user approved: ${dayStatus.requestDate}');
      }
    }

    return datesWithUserApproved;
  }

  // Get shift availability status for each date (for dots)
  // Blue dot: has available slots (approvedCount < requiredEmployees)
  // Gray dot: full (approvedCount >= requiredEmployees)
  // Only for dates from today onwards
  //
  // Logic:
  // 1. If shiftMetadata exists, all future dates within the week have shifts available
  // 2. Check monthlyShiftStatus for actual approved counts to determine if full
  Map<DateTime, ShiftAvailabilityStatus> _getShiftAvailabilityMap() {
    // If no shift metadata, no shifts are defined for this store
    if (shiftMetadata == null || shiftMetadata!.isEmpty) {
      return {};
    }

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Map<DateTime, ShiftAvailabilityStatus> availabilityMap = {};

    // Build a map of date -> MonthlyShiftStatus for quick lookup
    final Map<String, MonthlyShiftStatus> statusByDate = {};
    if (monthlyShiftStatus != null) {
      for (final dayStatus in monthlyShiftStatus!) {
        statusByDate[dayStatus.requestDate] = dayStatus;
      }
    }

    // Iterate through all dates in the current week
    for (int i = 0; i < 7; i++) {
      final date = weekStartDate.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Only for dates from today onwards
      if (normalizedDate.isBefore(todayNormalized)) {
        continue;
      }

      // Format date to match monthlyShiftStatus format (yyyy-MM-dd)
      final dateString =
          '${normalizedDate.year}-${normalizedDate.month.toString().padLeft(2, '0')}-${normalizedDate.day.toString().padLeft(2, '0')}';

      // Check if we have status data for this date
      final dayStatus = statusByDate[dateString];

      if (dayStatus != null && dayStatus.shifts.isNotEmpty) {
        // We have actual data - check if any shift has available slots
        bool hasAvailableSlots = false;
        for (final shift in dayStatus.shifts) {
          if (shift.hasAvailableSlots) {
            hasAvailableSlots = true;
            break;
          }
        }
        availabilityMap[normalizedDate] = hasAvailableSlots
            ? ShiftAvailabilityStatus.available
            : ShiftAvailabilityStatus.full;
      } else {
        // No status data - shifts exist (from shiftMetadata) but no one has applied yet
        // This means all slots are available (blue dot)
        availabilityMap[normalizedDate] = ShiftAvailabilityStatus.available;
      }
    }

    return availabilityMap;
  }

  // Format week label (matches My Schedule tab logic)
  String _getWeekLabel() {
    if (_currentWeekOffset == 0) {
      return 'This week';
    } else if (_currentWeekOffset < 0) {
      return 'Previous week';
    } else {
      return 'Next week';
    }
  }

  // Format date range (e.g., "10 - 16 Jun")
  String _getDateRange() {
    final start = weekStartDate;
    final end = weekStartDate.add(const Duration(days: 6));

    final startDay = start.day;
    final endDay = end.day;
    final month = DateFormat.MMM().format(end); // Use end month

    return '$startDay - $endDay $month';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Navigation methods (matches My Schedule tab logic)
  void _goToPreviousWeek() {
    setState(() {
      _currentWeekOffset--;
      selectedDate = weekStartDate; // Select Monday of new week
    });
    // Always refetch to ensure we have the correct data for the new week
    _fetchMonthlyShiftStatus();
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentWeekOffset = 0;
      selectedDate = DateTime.now();
    });
    // Always refetch to ensure we have the correct data for the new week
    _fetchMonthlyShiftStatus();
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekOffset++;
      selectedDate = weekStartDate; // Select Monday of new week
    });
    // Always refetch to ensure we have the correct data for the new week
    _fetchMonthlyShiftStatus();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  // Get DailyShift data for selected date and shift
  DailyShift? _getDailyShiftData(String shiftId) {
    if (monthlyShiftStatus == null) return null;

    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    for (final dayStatus in monthlyShiftStatus!) {
      if (dayStatus.requestDate == dateStr) {
        for (final shift in dayStatus.shifts) {
          if (shift.shiftId == shiftId) {
            return shift;
          }
        }
      }
    }
    return null;
  }

  // Determine shift status based on real data
  ShiftSignupStatus _getShiftStatus(ShiftMetadata shift, int index) {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    final dailyShift = _getDailyShiftData(shift.shiftId);

    if (dailyShift == null) {
      // No data for this shift on selected date - available
      return ShiftSignupStatus.available;
    }

    // Check if user is in approved employees
    final isApproved = dailyShift.approvedEmployees.any((e) => e.userId == currentUserId);
    if (isApproved) {
      return ShiftSignupStatus.assigned;
    }

    // Check if user is in pending employees
    final isPending = dailyShift.pendingEmployees.any((e) => e.userId == currentUserId);
    if (isPending) {
      return ShiftSignupStatus.applied;
    }

    // Check if shift is full (no available slots)
    if (!dailyShift.hasAvailableSlots) {
      return ShiftSignupStatus.waitlist;
    }

    return ShiftSignupStatus.available;
  }

  // Check if user applied to this shift (pending status)
  bool _getUserApplied(ShiftMetadata shift) {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    final dailyShift = _getDailyShiftData(shift.shiftId);

    if (dailyShift == null) return false;

    return dailyShift.pendingEmployees.any((e) => e.userId == currentUserId);
  }

  /// Format time range from "HH:mm:ss" to "HH:mm - HH:mm"
  /// RPC returns local time, no conversion needed
  String _formatTimeRange(String startTime, String endTime) {
    try {
      // Extract HH:mm from "HH:mm:ss" format
      final start = startTime.length >= 5 ? startTime.substring(0, 5) : startTime;
      final end = endTime.length >= 5 ? endTime.substring(0, 5) : endTime;
      return '$start - $end';
    } catch (e) {
      print('Error formatting time range: $e');
      return '$startTime - $endTime';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (isLoadingMetadata) {
      return const Center(child: TossLoadingView());
    }

    final shifts = _getActiveShifts();
    final datesWithUserApproved = _getDatesWithUserApproved();
    final shiftAvailabilityMap = _getShiftAvailabilityMap();

    return Container(
      color: TossColors.background,
      child: CustomScrollView(
        slivers: [
          // Week Navigation
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TossWeekNavigation(
                weekLabel: _getWeekLabel(),
                dateRange: _getDateRange(),
                onPrevWeek: _goToPreviousWeek,
                onCurrentWeek: _goToCurrentWeek,
                onNextWeek: _goToNextWeek,
              ),
            ),
          ),

          // Week Dates Picker (7 circles)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: WeekDatesPicker(
                selectedDate: selectedDate,
                weekStartDate: weekStartDate,
                datesWithUserApproved: datesWithUserApproved,
                shiftAvailabilityMap: shiftAvailabilityMap,
                onDateSelected: _onDateSelected,
              ),
            ),
          ),

          // "Available Shifts on {date}" header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'Available Shifts on ${DateFormat.MMMd().format(selectedDate)}',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // Shift Cards List
          shifts.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No shifts available',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final shift = shifts[index];
                        final dailyShift = _getDailyShiftData(shift.shiftId);
                        final status = _getShiftStatus(shift, index);
                        final filledSlots = dailyShift?.approvedCount ?? 0;
                        final totalSlots = dailyShift?.requiredEmployees ?? shift.numberShift ?? 1;
                        final appliedCount = (dailyShift?.approvedCount ?? 0) + (dailyShift?.pendingCount ?? 0);
                        final userApplied = _getUserApplied(shift);

                        // Get all employees' profile images (approved + pending)
                        final allEmployees = [
                          ...?dailyShift?.approvedEmployees,
                          ...?dailyShift?.pendingEmployees,
                        ];
                        final assignedAvatars = allEmployees
                            .where((e) => e.profileImage != null && e.profileImage!.isNotEmpty)
                            .map((e) => e.profileImage!)
                            .toList();

                        // Get store name from app state
                        final appState = ref.read(appStateProvider);
                        final storeName = appState.storeName.isNotEmpty ? appState.storeName : 'Store';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ShiftSignupCard(
                            shiftType: shift.shiftName,
                            timeRange: _formatTimeRange(shift.startTime, shift.endTime),
                            location: storeName,
                            status: status,
                            filledSlots: filledSlots,
                            totalSlots: totalSlots,
                            appliedCount: appliedCount,
                            userApplied: userApplied,
                            assignedUserAvatars: assignedAvatars.isNotEmpty
                                ? assignedAvatars
                                : null,
                            onApply: status == ShiftSignupStatus.available
                                ? () => _handleApply(shift)
                                : null,
                            onWaitlist: status == ShiftSignupStatus.waitlist
                                ? () => _handleWaitlist(shift)
                                : null,
                            onLeaveWaitlist: status == ShiftSignupStatus.onWaitlist
                                ? () => _handleLeaveWaitlist(shift)
                                : null,
                            onWithdraw: status == ShiftSignupStatus.applied
                                ? () => _handleWithdraw(shift)
                                : null,
                            onTap: () => _handleShiftTap(shift),
                            onViewAppliedUsers: (status == ShiftSignupStatus.assigned || appliedCount > 0 || userApplied)
                                ? () => _handleViewAppliedUsers(shift)
                                : null,
                          ),
                        );
                      },
                      childCount: shifts.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Shift action handlers
  Future<void> _handleApply(ShiftMetadata shift) async {
    print('🟢 _handleApply called for shift: ${shift.shiftName}');

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final storeId = appState.storeChoosen;

    print('🟢 userId: $userId, storeId: $storeId');

    if (userId.isEmpty || storeId.isEmpty) {
      print('❌ userId or storeId is empty, returning early');
      return;
    }

    // Use user's device current time with selected date
    final now = DateTime.now();
    final requestDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );
    final requestTime = DateTimeUtils.toLocalWithOffset(requestDateTime);
    final timezone = DateTimeUtils.getLocalTimezone();

    print('🟢 Calling insert_shift_request_v4:');
    print('   - userId: $userId');
    print('   - shiftId: ${shift.shiftId}');
    print('   - storeId: $storeId');
    print('   - requestTime: $requestTime');
    print('   - timezone: $timezone');

    try {
      final registerShiftRequest = ref.read(registerShiftRequestProvider);
      await registerShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        storeId: storeId,
        requestTime: requestTime,
        timezone: timezone,
      );

      print('✅ insert_shift_request_v4 succeeded');

      // Update local state instead of RPC refresh
      _addCurrentUserToPending(shift.shiftId);
    } catch (e) {
      print('❌ Error applying to shift: $e');
    }
  }

  Future<void> _handleWaitlist(ShiftMetadata shift) async {
    print('🟡 _handleWaitlist called for shift: ${shift.shiftName}');

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final storeId = appState.storeChoosen;

    print('🟡 userId: $userId, storeId: $storeId');

    if (userId.isEmpty || storeId.isEmpty) {
      print('❌ userId or storeId is empty, returning early');
      return;
    }

    // Use user's device current time with selected date
    final now = DateTime.now();
    final requestDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );
    final requestTime = DateTimeUtils.toLocalWithOffset(requestDateTime);
    final timezone = DateTimeUtils.getLocalTimezone();

    print('🟡 Calling insert_shift_request_v4 (waitlist):');
    print('   - userId: $userId');
    print('   - shiftId: ${shift.shiftId}');
    print('   - storeId: $storeId');
    print('   - requestTime: $requestTime');
    print('   - timezone: $timezone');

    try {
      final registerShiftRequest = ref.read(registerShiftRequestProvider);
      await registerShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        storeId: storeId,
        requestTime: requestTime,
        timezone: timezone,
      );

      print('✅ insert_shift_request_v4 (waitlist) succeeded');

      // Update local state instead of RPC refresh
      _addCurrentUserToPending(shift.shiftId);
    } catch (e) {
      print('❌ Error joining waitlist: $e');
    }
  }

  void _handleLeaveWaitlist(ShiftMetadata shift) {
    // Use same logic as withdraw since it's the same RPC
    _handleWithdraw(shift);
  }

  Future<void> _handleWithdraw(ShiftMetadata shift) async {
    print('🔴 _handleWithdraw called for shift: ${shift.shiftName}');

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    print('🔴 userId: $userId');

    if (userId.isEmpty) {
      print('❌ userId is empty, returning early');
      return;
    }

    // Use user's device current time with selected date
    final now = DateTime.now();
    final requestDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );
    final requestTime = DateTimeUtils.toLocalWithOffset(requestDateTime);
    final timezone = DateTimeUtils.getLocalTimezone();

    print('🔴 Calling delete_shift_request_v2:');
    print('   - userId: $userId');
    print('   - shiftId: ${shift.shiftId}');
    print('   - requestTime: $requestTime');
    print('   - timezone: $timezone');
    print('   - selectedDate: $selectedDate');

    try {
      final deleteShiftRequest = ref.read(deleteShiftRequestProvider);
      await deleteShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        requestTime: requestTime,
        timezone: timezone,
      );

      print('✅ delete_shift_request_v2 succeeded');

      // Update local state instead of RPC refresh
      _removeCurrentUserFromPending(shift.shiftId);
    } catch (e) {
      print('❌ Error withdrawing from shift: $e');
    }
  }

  // Helper: Add current user to pending employees in local state
  void _addCurrentUserToPending(String shiftId) {
    if (monthlyShiftStatus == null) return;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final userDisplayData = ref.read(userDisplayDataProvider);
    final userName = '${userDisplayData['user_first_name'] ?? ''} ${userDisplayData['user_last_name'] ?? ''}'.trim();
    final profileImage = userDisplayData['profile_image'] as String? ?? '';

    // Create new EmployeeStatus for current user
    final currentUserEmployee = EmployeeStatus(
      userId: userId,
      userName: userName.isEmpty ? 'You' : userName,
      profileImage: profileImage.isNotEmpty ? profileImage : null,
    );

    // Find the date string for selected date
    final dateString = DateTimeUtils.toDateOnly(selectedDate);

    // Update monthlyShiftStatus
    final updatedStatus = monthlyShiftStatus!.map((dayStatus) {
      if (dayStatus.requestDate == dateString) {
        // Update the specific shift
        final updatedShifts = dayStatus.shifts.map((dailyShift) {
          if (dailyShift.shiftId == shiftId) {
            // Add user to pending employees
            final updatedPendingEmployees = [...dailyShift.pendingEmployees, currentUserEmployee];
            return dailyShift.copyWith(
              pendingEmployees: updatedPendingEmployees,
              pendingCount: dailyShift.pendingCount + 1,
            );
          }
          return dailyShift;
        }).toList();

        return dayStatus.copyWith(
          shifts: updatedShifts,
          totalPending: dayStatus.totalPending + 1,
        );
      }
      return dayStatus;
    }).toList();

    // If no existing day status for this date, create one
    final hasDateStatus = updatedStatus.any((s) => s.requestDate == dateString);
    if (!hasDateStatus) {
      // Find shift metadata for this shift
      final shiftMeta = shiftMetadata?.firstWhere(
        (s) => s.shiftId == shiftId,
        orElse: () => shiftMetadata!.first,
      );

      final newDayStatus = MonthlyShiftStatus(
        requestDate: dateString,
        totalPending: 1,
        totalApproved: 0,
        shifts: [
          DailyShift(
            shiftId: shiftId,
            shiftName: shiftMeta?.shiftName,
            requiredEmployees: shiftMeta?.numberShift ?? 1,
            pendingCount: 1,
            approvedCount: 0,
            pendingEmployees: [currentUserEmployee],
            approvedEmployees: [],
          ),
        ],
      );
      updatedStatus.add(newDayStatus);
    }

    setState(() {
      monthlyShiftStatus = updatedStatus;
    });

    print('✅ Local state updated: added user to pending');
  }

  // Helper: Remove current user from pending employees in local state
  // Note: Approved/Assigned users cannot withdraw - only pending users can
  void _removeCurrentUserFromPending(String shiftId) {
    if (monthlyShiftStatus == null) return;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    // Find the date string for selected date
    final dateString = DateTimeUtils.toDateOnly(selectedDate);

    // Update monthlyShiftStatus
    final updatedStatus = monthlyShiftStatus!.map((dayStatus) {
      if (dayStatus.requestDate == dateString) {
        int totalPendingRemoved = 0;

        // Update the specific shift
        final updatedShifts = dayStatus.shifts.map((dailyShift) {
          if (dailyShift.shiftId == shiftId) {
            // Remove user from pending employees only
            // Approved/Assigned users cannot withdraw
            final updatedPendingEmployees = dailyShift.pendingEmployees
                .where((e) => e.userId != userId)
                .toList();
            final pendingRemovedCount = dailyShift.pendingEmployees.length - updatedPendingEmployees.length;
            totalPendingRemoved += pendingRemovedCount;

            return dailyShift.copyWith(
              pendingEmployees: updatedPendingEmployees,
              pendingCount: dailyShift.pendingCount - pendingRemovedCount,
            );
          }
          return dailyShift;
        }).toList();

        return dayStatus.copyWith(
          shifts: updatedShifts,
          totalPending: dayStatus.totalPending - totalPendingRemoved,
        );
      }
      return dayStatus;
    }).toList();

    setState(() {
      monthlyShiftStatus = updatedStatus;
    });

    print('✅ Local state updated: removed user from pending');
  }

  void _handleShiftTap(ShiftMetadata shift) {
    print('Tapped shift: ${shift.shiftName}');
    // TODO: Navigate to shift detail page
  }

  // Show applied users bottom sheet
  void _handleViewAppliedUsers(ShiftMetadata shift) {
    // Get real data from monthlyShiftStatus
    final dailyShift = _getDailyShiftData(shift.shiftId);
    final approvedEmployees = dailyShift?.approvedEmployees ?? [];
    final pendingEmployees = dailyShift?.pendingEmployees ?? [];

    // Combine approved and pending employees with status subtitle
    final items = <TossSelectionItem>[
      ...approvedEmployees.map((employee) {
        return TossSelectionItem.fromGeneric(
          id: employee.userId,
          title: employee.userName,
          subtitle: 'Assigned',
          avatarUrl: employee.profileImage,
        );
      }),
      ...pendingEmployees.map((employee) {
        return TossSelectionItem.fromGeneric(
          id: employee.userId,
          title: employee.userName,
          subtitle: 'Applied',
          avatarUrl: employee.profileImage,
        );
      }),
    ];

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Applied Users',
      items: items,
      showSubtitle: true,
      subtitlePosition: 'right', // Show status on right side of row
      borderBottomWidth: 0, // Remove divider lines
      onItemSelected: (item) {
        // Optional: Navigate to user profile or show more details
        print('Selected user: ${item.title}');
      },
    );
  }
}
