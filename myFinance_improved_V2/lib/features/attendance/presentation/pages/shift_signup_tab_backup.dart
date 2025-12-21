import 'dart:developer' as developer;

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

  // Monthly shift status data cache - key: "yyyy-MM" format
  final Map<String, List<MonthlyShiftStatus>> _monthlyShiftStatusCache = {};
  // Track which months are currently being loaded
  final Set<String> _loadingMonths = {};

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

  /// Get month key for caching (yyyy-MM format)
  String _getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    developer.log('[ShiftSignupTab] _loadInitialData called', name: 'ShiftSignupTab');

    // Get selected store from app state
    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    developer.log('[ShiftSignupTab] selectedStoreId: $selectedStoreId', name: 'ShiftSignupTab');

    if (selectedStoreId != null) {
      await _fetchShiftMetadata(selectedStoreId!);
      // Fetch monthly shift status for current month
      await _fetchMonthlyShiftStatusIfNeeded(selectedDate);
    }
  }

  Future<void> _fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;

    setState(() {
      isLoadingMetadata = true;
    });

    try {
      final getShiftMetadata = ref.read(getShiftMetadataProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final response = await getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      if (mounted) {
        setState(() {
          shiftMetadata = response;
          isLoadingMetadata = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          isLoadingMetadata = false;
          shiftMetadata = [];
        });
      }
    }
  }

  /// Fetch monthly shift status only if not already cached
  Future<void> _fetchMonthlyShiftStatusIfNeeded(DateTime date) async {
    final monthKey = _getMonthKey(date);

    developer.log('[ShiftSignupTab] _fetchMonthlyShiftStatusIfNeeded called for monthKey: $monthKey', name: 'ShiftSignupTab');

    // Skip if already cached or currently loading
    if (_monthlyShiftStatusCache.containsKey(monthKey)) {
      developer.log('[ShiftSignupTab] SKIP - monthKey $monthKey already cached', name: 'ShiftSignupTab');
      return;
    }
    if (_loadingMonths.contains(monthKey)) {
      developer.log('[ShiftSignupTab] SKIP - monthKey $monthKey already loading', name: 'ShiftSignupTab');
      return;
    }

    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    developer.log('[ShiftSignupTab] storeId: $storeId, companyId: $companyId', name: 'ShiftSignupTab');

    if (storeId.isEmpty || companyId.isEmpty) {
      developer.log('[ShiftSignupTab] SKIP - storeId or companyId empty', name: 'ShiftSignupTab');
      return;
    }

    _loadingMonths.add(monthKey);
    if (mounted) setState(() {});

    try {
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);
      final timezone = DateTimeUtils.getLocalTimezone();

      // Use the 15th of the month to ensure we're in the middle of the target month
      final targetDate = DateTime(date.year, date.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      developer.log('[ShiftSignupTab] Calling RPC get_monthly_shift_status_manager_v4', name: 'ShiftSignupTab');
      developer.log('[ShiftSignupTab] params: storeId=$storeId, companyId=$companyId, requestTime=$requestTime, timezone=$timezone', name: 'ShiftSignupTab');

      final response = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      developer.log('[ShiftSignupTab] RPC response received: ${response.length} items', name: 'ShiftSignupTab');
      for (final status in response) {
        developer.log('[ShiftSignupTab] - date: ${status.requestDate}, shifts: ${status.shifts.length}, approved: ${status.totalApproved}, pending: ${status.totalPending}', name: 'ShiftSignupTab');
      }

      if (mounted) {
        setState(() {
          _monthlyShiftStatusCache[monthKey] = response;
          _loadingMonths.remove(monthKey);
        });
        developer.log('[ShiftSignupTab] Cache updated for monthKey: $monthKey', name: 'ShiftSignupTab');
      }
    } catch (e) {
      developer.log('[ShiftSignupTab] RPC ERROR: $e', name: 'ShiftSignupTab');
      _loadingMonths.remove(monthKey);
      if (mounted) setState(() {});
    }
  }

  /// Get monthly shift status for a specific date from cache
  MonthlyShiftStatus? _getShiftStatusForDate(DateTime date) {
    final monthKey = _getMonthKey(date);
    final monthData = _monthlyShiftStatusCache[monthKey];
    if (monthData == null) {
      developer.log('[ShiftSignupTab] _getShiftStatusForDate: No cache for monthKey $monthKey', name: 'ShiftSignupTab');
      return null;
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    try {
      final result = monthData.firstWhere((status) => status.requestDate == dateStr);
      developer.log('[ShiftSignupTab] _getShiftStatusForDate: Found data for $dateStr - shifts: ${result.shifts.length}', name: 'ShiftSignupTab');
      return result;
    } catch (_) {
      developer.log('[ShiftSignupTab] _getShiftStatusForDate: No data found for $dateStr in cache', name: 'ShiftSignupTab');
      return null;
    }
  }

  // Get active shifts for display
  List<ShiftMetadata> _getActiveShifts() {
    if (shiftMetadata == null) {
      return [];
    }

    return shiftMetadata!.where((shift) => shift.isActive).toList();
  }

  /// Get dates where user has approved shifts (for blue border on date circles)
  Set<DateTime> _getDatesWithUserApproved() {
    final result = <DateTime>{};
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;

    // Check each day of the current week
    for (int i = 0; i < 7; i++) {
      final date = weekStartDate.add(Duration(days: i));
      final status = _getShiftStatusForDate(date);
      if (status != null) {
        // Check if current user has approved shift on this date
        for (final shift in status.shifts) {
          final hasUserApproved = shift.approvedEmployees.any(
            (emp) => emp.userId == currentUserId,
          );
          if (hasUserApproved) {
            result.add(DateTime(date.year, date.month, date.day));
            break;
          }
        }
      }
    }

    return result;
  }

  /// Get shift availability map for week dates (for blue/gray dots)
  Map<DateTime, ShiftAvailabilityStatus> _getShiftAvailabilityMap() {
    final result = <DateTime, ShiftAvailabilityStatus>{};

    // Check each day of the current week
    for (int i = 0; i < 7; i++) {
      final date = weekStartDate.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final status = _getShiftStatusForDate(date);

      if (status != null && status.shifts.isNotEmpty) {
        // Check if any shift has available slots
        bool hasAvailableSlots = false;
        for (final shift in status.shifts) {
          if (shift.hasAvailableSlots) {
            hasAvailableSlots = true;
            break;
          }
        }

        result[normalizedDate] = hasAvailableSlots
            ? ShiftAvailabilityStatus.available
            : ShiftAvailabilityStatus.full;
      }
    }

    return result;
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

  // Navigation methods (matches My Schedule tab logic)
  void _goToPreviousWeek() {
    final oldWeekStart = weekStartDate;
    setState(() {
      _currentWeekOffset--;
      selectedDate = weekStartDate; // Select Monday of new week
    });
    // Check if month changed and fetch data if needed
    _checkAndFetchForWeek(oldWeekStart, weekStartDate);
  }

  void _goToCurrentWeek() {
    final oldWeekStart = weekStartDate;
    setState(() {
      _currentWeekOffset = 0;
      selectedDate = DateTime.now();
    });
    // Check if month changed and fetch data if needed
    _checkAndFetchForWeek(oldWeekStart, weekStartDate);
  }

  void _goToNextWeek() {
    final oldWeekStart = weekStartDate;
    setState(() {
      _currentWeekOffset++;
      selectedDate = weekStartDate; // Select Monday of new week
    });
    // Check if month changed and fetch data if needed
    _checkAndFetchForWeek(oldWeekStart, weekStartDate);
  }

  /// Check if week navigation crosses month boundary and fetch data for new months
  void _checkAndFetchForWeek(DateTime oldWeekStart, DateTime newWeekStart) {
    developer.log('[ShiftSignupTab] _checkAndFetchForWeek called', name: 'ShiftSignupTab');
    developer.log('[ShiftSignupTab] oldWeekStart: $oldWeekStart, newWeekStart: $newWeekStart', name: 'ShiftSignupTab');

    // Collect all months that the new week spans
    final monthsToCheck = <String>{};
    for (int i = 0; i < 7; i++) {
      final date = newWeekStart.add(Duration(days: i));
      monthsToCheck.add(_getMonthKey(date));
    }

    developer.log('[ShiftSignupTab] monthsToCheck: $monthsToCheck', name: 'ShiftSignupTab');
    developer.log('[ShiftSignupTab] cached months: ${_monthlyShiftStatusCache.keys.toList()}', name: 'ShiftSignupTab');

    // Fetch data for any months not yet cached
    for (final monthKey in monthsToCheck) {
      if (!_monthlyShiftStatusCache.containsKey(monthKey)) {
        developer.log('[ShiftSignupTab] Need to fetch monthKey: $monthKey', name: 'ShiftSignupTab');
        // Parse month key to get a date in that month
        final parts = monthKey.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        _fetchMonthlyShiftStatusIfNeeded(DateTime(year, month, 15));
      } else {
        developer.log('[ShiftSignupTab] Already cached monthKey: $monthKey', name: 'ShiftSignupTab');
      }
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  /// Get DailyShift data for a specific shift on selected date from RPC data
  DailyShift? _getDailyShiftForMetadata(ShiftMetadata shift) {
    final status = _getShiftStatusForDate(selectedDate);
    if (status == null) return null;

    try {
      return status.shifts.firstWhere((s) => s.shiftId == shift.shiftId);
    } catch (_) {
      return null;
    }
  }

  /// Determine shift status based on RPC data and user's applied shifts
  ShiftSignupStatus _getShiftStatus(ShiftMetadata shift) {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    final dailyShift = _getDailyShiftForMetadata(shift);

    // Check if user has applied locally (optimistic update)
    if (appliedShiftIds.contains(shift.shiftId)) {
      return ShiftSignupStatus.applied;
    }

    // Check if user is on waitlist locally
    if (waitlistedShiftIds.contains(shift.shiftId)) {
      return ShiftSignupStatus.onWaitlist;
    }

    // Check RPC data if available
    if (dailyShift != null) {
      // Check if current user is approved (assigned)
      final isUserApproved = dailyShift.approvedEmployees.any(
        (emp) => emp.userId == currentUserId,
      );
      if (isUserApproved) {
        return ShiftSignupStatus.assigned;
      }

      // Check if current user is pending (applied)
      final isUserPending = dailyShift.pendingEmployees.any(
        (emp) => emp.userId == currentUserId,
      );
      if (isUserPending) {
        return ShiftSignupStatus.applied;
      }

      // Check if shift is full (no available slots)
      if (!dailyShift.hasAvailableSlots) {
        return ShiftSignupStatus.waitlist;
      }
    }

    // Default: available for signup
    return ShiftSignupStatus.available;
  }

  /// Get pending (applied but not approved) count from RPC data
  int _getAppliedCount(ShiftMetadata shift) {
    final dailyShift = _getDailyShiftForMetadata(shift);
    if (dailyShift == null) return 0;
    return dailyShift.pendingCount;
  }

  /// Check if current user has applied to this shift
  bool _getUserApplied(ShiftMetadata shift) {
    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    final dailyShift = _getDailyShiftForMetadata(shift);

    // Check local state first (optimistic update)
    if (appliedShiftIds.contains(shift.shiftId)) {
      return true;
    }

    // Check RPC data
    if (dailyShift != null) {
      return dailyShift.pendingEmployees.any((emp) => emp.userId == currentUserId);
    }

    return false;
  }

  /// Get approved (filled) slots count from RPC data
  int _getFilledSlots(ShiftMetadata shift) {
    final dailyShift = _getDailyShiftForMetadata(shift);
    if (dailyShift == null) return 0;
    return dailyShift.approvedCount;
  }

  /// Get avatar URLs for employees who applied/approved for this shift
  List<String> _getEmployeeAvatars(ShiftMetadata shift) {
    final dailyShift = _getDailyShiftForMetadata(shift);
    if (dailyShift == null) return [];

    final avatars = <String>[];

    // Add approved employees first
    for (final emp in dailyShift.approvedEmployees) {
      if (emp.profileImage != null && emp.profileImage!.isNotEmpty) {
        avatars.add(emp.profileImage!);
      }
      if (avatars.length >= 4) break;
    }

    // Then add pending employees if we have room
    if (avatars.length < 4) {
      for (final emp in dailyShift.pendingEmployees) {
        if (emp.profileImage != null && emp.profileImage!.isNotEmpty) {
          avatars.add(emp.profileImage!);
        }
        if (avatars.length >= 4) break;
      }
    }

    return avatars;
  }

  // Format time range and convert from UTC to local time
  String _formatTimeRange(String startTime, String endTime) {
    try {
      // Parse "HH:mm:ss" format
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');

      if (startParts.length >= 2 && endParts.length >= 2) {
        // Create UTC DateTime objects
        final now = DateTime.now();
        final startUtc = DateTime.utc(
          now.year,
          now.month,
          now.day,
          int.parse(startParts[0]),
          int.parse(startParts[1]),
        );
        final endUtc = DateTime.utc(
          now.year,
          now.month,
          now.day,
          int.parse(endParts[0]),
          int.parse(endParts[1]),
        );

        // Convert to local time
        final startLocal = startUtc.toLocal();
        final endLocal = endUtc.toLocal();

        // Format as HH:MM
        final start = '${startLocal.hour.toString().padLeft(2, '0')}:${startLocal.minute.toString().padLeft(2, '0')}';
        final end = '${endLocal.hour.toString().padLeft(2, '0')}:${endLocal.minute.toString().padLeft(2, '0')}';

        return '$start - $end';
      }
    } catch (_) {
      // Fallback below
    }

    // Fallback: just trim to HH:MM
    final start = startTime.substring(0, 5);
    final end = endTime.substring(0, 5);
    return '$start - $end';
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
                        final status = _getShiftStatus(shift);
                        final filledSlots = _getFilledSlots(shift);
                        final totalSlots = shift.numberShift ?? 3;
                        final appliedCount = _getAppliedCount(shift);
                        final userApplied = _getUserApplied(shift);
                        final avatars = _getEmployeeAvatars(shift);

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
                            assignedUserAvatars: avatars.isNotEmpty ? avatars : null,
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
  void _handleApply(ShiftMetadata shift) {
    setState(() {
      appliedShiftIds.add(shift.shiftId);
    });
    // TODO: Implement backend API call to apply for shift
  }

  void _handleWaitlist(ShiftMetadata shift) {
    setState(() {
      waitlistedShiftIds.add(shift.shiftId);
    });
    // TODO: Implement backend API call to join waitlist
  }

  void _handleLeaveWaitlist(ShiftMetadata shift) {
    setState(() {
      waitlistedShiftIds.remove(shift.shiftId);
    });
    // TODO: Implement backend API call to leave waitlist
  }

  void _handleWithdraw(ShiftMetadata shift) {
    setState(() {
      appliedShiftIds.remove(shift.shiftId);
    });
    // TODO: Implement backend API call to withdraw from shift
  }

  void _handleShiftTap(ShiftMetadata shift) {
    // TODO: Navigate to shift detail page
  }

  // Show applied users bottom sheet
  void _handleViewAppliedUsers(ShiftMetadata shift) {
    // Mock data - replace with real data from backend
    final mockAppliedUsers = [
      {'id': '1', 'name': 'John Doe', 'avatar': 'https://i.pravatar.cc/150?img=1'},
      {'id': '2', 'name': 'Jane Smith', 'avatar': 'https://i.pravatar.cc/150?img=2'},
      {'id': '3', 'name': 'Mike Johnson', 'avatar': 'https://i.pravatar.cc/150?img=3'},
      {'id': '4', 'name': 'Sarah Williams', 'avatar': 'https://i.pravatar.cc/150?img=4'},
    ];

    final items = mockAppliedUsers.map((user) {
      return TossSelectionItem.fromGeneric(
        id: user['id'] as String,
        title: user['name'] as String,
        avatarUrl: user['avatar'] as String,
      );
    }).toList();

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Applied Users',
      items: items,
      showSubtitle: false,
      borderBottomWidth: 0,
      onItemSelected: (_) {
        // Optional: Navigate to user profile or show more details
      },
    );
  }
}
