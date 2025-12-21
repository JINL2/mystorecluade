import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_week_navigation.dart';
import '../../../../shared/widgets/toss/week_dates_picker.dart';
import '../../../attendance/domain/entities/monthly_shift_status.dart';
import '../../../attendance/domain/entities/shift_metadata.dart';
import '../widgets/shift_requests/shift_availability_helper.dart';
import '../widgets/shift_requests/shift_requests_actions.dart';
import '../widgets/shift_requests/shift_requests_controller.dart';
import '../widgets/shift_requests/shift_status_helper.dart';
import '../widgets/shift_signup/shift_signup_card.dart';

/// ShiftRequestsTab - Shift requests page with new UI design
///
/// Design Pattern:
/// - Week navigation (< Previous week | This week • 10-16 Jun | Next week >)
/// - 7 date circles (Mon-Sun) with blue dots for dates with available shifts
/// - "Available Shifts on {date}" header
/// - Shift cards with 4 states: Available, Waitlist, Applied, Assigned
class ShiftRequestsTab extends ConsumerStatefulWidget {
  const ShiftRequestsTab({super.key});

  @override
  ConsumerState<ShiftRequestsTab> createState() => _ShiftRequestsTabState();
}

class _ShiftRequestsTabState extends ConsumerState<ShiftRequestsTab>
    with AutomaticKeepAliveClientMixin {
  DateTime selectedDate = DateTime.now();
  int _currentWeekOffset = 0;
  String? selectedStoreId;
  List<ShiftMetadata>? shiftMetadata;
  bool isLoadingMetadata = false;
  List<MonthlyShiftStatus>? monthlyShiftStatus;

  /// Track which shift is currently processing (loading)
  String? _loadingShiftId;

  late ShiftRequestsController _controller;

  /// Cache for monthly shift status data - key is "YYYY-MM" format
  final Map<String, List<MonthlyShiftStatus>> _monthlyShiftStatusCache = {};

  /// Track which months are currently being loaded to prevent duplicate requests
  final Set<String> _loadingMonths = {};

  @override
  bool get wantKeepAlive => true;

  DateTime get weekStartDate => _controller.getWeekStartDate(_currentWeekOffset);

  @override
  void initState() {
    super.initState();
    _controller = ShiftRequestsController(ref: ref);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    debugPrint('[ShiftRequestsTab] _loadInitialData started');
    selectedStoreId = _controller.getSelectedStoreId();
    debugPrint('[ShiftRequestsTab] _loadInitialData: selectedStoreId=$selectedStoreId');

    if (selectedStoreId != null) {
      debugPrint('[ShiftRequestsTab] _loadInitialData: fetching shift metadata and monthly shift status');
      await Future.wait([
        _fetchShiftMetadata(selectedStoreId!),
        _fetchMonthlyShiftStatus(),
      ]);
      debugPrint('[ShiftRequestsTab] _loadInitialData completed');
    } else {
      debugPrint('[ShiftRequestsTab] _loadInitialData: no store selected, skipping data fetch');
    }
  }

  /// Get month key in "YYYY-MM" format
  String _getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  /// Fetch monthly shift status with caching
  /// Only calls RPC if data for the month is not already cached
  Future<void> _fetchMonthlyShiftStatusIfNeeded(DateTime date) async {
    final monthKey = _getMonthKey(date);
    debugPrint('[ShiftRequestsTab] _fetchMonthlyShiftStatusIfNeeded called for date: $date, monthKey: $monthKey');

    // Check if already cached
    if (_monthlyShiftStatusCache.containsKey(monthKey)) {
      debugPrint('[ShiftRequestsTab] Cache HIT for month: $monthKey');
      _updateMonthlyShiftStatusFromCache();
      return;
    }

    // Check if already loading
    if (_loadingMonths.contains(monthKey)) {
      debugPrint('[ShiftRequestsTab] Already loading month: $monthKey, skipping duplicate request');
      return;
    }

    debugPrint('[ShiftRequestsTab] Cache MISS for month: $monthKey, calling RPC...');
    _loadingMonths.add(monthKey);

    try {
      final result = await _controller.fetchMonthlyShiftStatus(date);
      debugPrint('[ShiftRequestsTab] RPC completed for month: $monthKey, got ${result?.length ?? 0} records');

      // Log each record's date for debugging
      if (result != null && result.isNotEmpty) {
        final dates = result.map((r) => r.requestDate).toList();
        debugPrint('[ShiftRequestsTab] RPC returned dates: $dates');

        // Check which months are actually in the response
        final months = <String>{};
        for (final r in result) {
          if (r.requestDate.length >= 7) {
            months.add(r.requestDate.substring(0, 7));
          }
        }
        debugPrint('[ShiftRequestsTab] RPC returned months in data: $months');
      }

      if (mounted && result != null) {
        // Cache the result by extracting data for the requested month only
        final monthData = result.where((r) {
          if (r.requestDate.length >= 7) {
            return r.requestDate.substring(0, 7) == monthKey;
          }
          return false;
        }).toList();

        _monthlyShiftStatusCache[monthKey] = monthData;
        debugPrint('[ShiftRequestsTab] Cached ${monthData.length} records for month: $monthKey');

        // Also cache data for other months that came in the response
        final otherMonths = <String, List<MonthlyShiftStatus>>{};
        for (final r in result) {
          if (r.requestDate.length >= 7) {
            final rMonth = r.requestDate.substring(0, 7);
            if (rMonth != monthKey && !_monthlyShiftStatusCache.containsKey(rMonth)) {
              otherMonths.putIfAbsent(rMonth, () => []).add(r);
            }
          }
        }
        for (final entry in otherMonths.entries) {
          _monthlyShiftStatusCache[entry.key] = entry.value;
          debugPrint('[ShiftRequestsTab] Also cached ${entry.value.length} records for month: ${entry.key}');
        }

        // Update the current monthlyShiftStatus from cache
        _updateMonthlyShiftStatusFromCache();
      }
    } finally {
      _loadingMonths.remove(monthKey);
    }
  }

  /// Update monthlyShiftStatus by combining all cached data
  void _updateMonthlyShiftStatusFromCache() {
    final allData = <MonthlyShiftStatus>[];
    for (final entry in _monthlyShiftStatusCache.entries) {
      allData.addAll(entry.value);
    }
    debugPrint('[ShiftRequestsTab] _updateMonthlyShiftStatusFromCache: Combined ${allData.length} records from ${_monthlyShiftStatusCache.length} cached months');

    setState(() {
      monthlyShiftStatus = allData;
    });
  }

  /// Check if week crosses month boundary and fetch data if needed
  Future<void> _checkAndFetchForWeek(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final startMonthKey = _getMonthKey(weekStart);
    final endMonthKey = _getMonthKey(weekEnd);

    debugPrint('[ShiftRequestsTab] _checkAndFetchForWeek: weekStart=$weekStart, weekEnd=$weekEnd');
    debugPrint('[ShiftRequestsTab] _checkAndFetchForWeek: startMonth=$startMonthKey, endMonth=$endMonthKey');

    // Fetch start month if not cached
    await _fetchMonthlyShiftStatusIfNeeded(weekStart);

    // If week crosses month boundary, also fetch end month
    if (startMonthKey != endMonthKey) {
      debugPrint('[ShiftRequestsTab] Week crosses month boundary, fetching end month: $endMonthKey');
      await _fetchMonthlyShiftStatusIfNeeded(weekEnd);
    }
  }

  Future<void> _fetchMonthlyShiftStatus() async {
    debugPrint('[ShiftRequestsTab] _fetchMonthlyShiftStatus called (legacy method, forwarding to cache-aware method)');
    await _checkAndFetchForWeek(weekStartDate);
  }

  Future<void> _fetchShiftMetadata(String storeId) async {
    setState(() {
      isLoadingMetadata = true;
    });

    final result = await _controller.fetchShiftMetadata(storeId);
    if (mounted) {
      setState(() {
        shiftMetadata = result;
        isLoadingMetadata = false;
      });
    }
  }

  void _goToPreviousWeek() {
    debugPrint('[ShiftRequestsTab] _goToPreviousWeek: current offset=$_currentWeekOffset');
    final previousMonth = _getMonthKey(weekStartDate);
    setState(() {
      _currentWeekOffset--;
      selectedDate = weekStartDate;
    });
    final newMonth = _getMonthKey(weekStartDate);
    debugPrint('[ShiftRequestsTab] _goToPreviousWeek: new offset=$_currentWeekOffset, previousMonth=$previousMonth, newMonth=$newMonth');
    _fetchMonthlyShiftStatus();
  }

  void _goToCurrentWeek() {
    debugPrint('[ShiftRequestsTab] _goToCurrentWeek called');
    setState(() {
      _currentWeekOffset = 0;
      selectedDate = DateTime.now();
    });
    debugPrint('[ShiftRequestsTab] _goToCurrentWeek: reset to offset=0, selectedDate=$selectedDate');
    _fetchMonthlyShiftStatus();
  }

  void _goToNextWeek() {
    debugPrint('[ShiftRequestsTab] _goToNextWeek: current offset=$_currentWeekOffset');
    final previousMonth = _getMonthKey(weekStartDate);
    setState(() {
      _currentWeekOffset++;
      selectedDate = weekStartDate;
    });
    final newMonth = _getMonthKey(weekStartDate);
    debugPrint('[ShiftRequestsTab] _goToNextWeek: new offset=$_currentWeekOffset, previousMonth=$previousMonth, newMonth=$newMonth');
    _fetchMonthlyShiftStatus();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _updateMonthlyShiftStatus(List<MonthlyShiftStatus> status) {
    setState(() {
      monthlyShiftStatus = status;
    });
  }

  /// Wrap action with loading state management
  Future<void> _executeWithLoading(String shiftId, Future<void> Function() action) async {
    if (_loadingShiftId != null) return;

    setState(() {
      _loadingShiftId = shiftId;
    });

    try {
      await action();
    } catch (e) {
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: e.toString().replaceAll('Exception: ', ''),
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingShiftId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoadingMetadata) {
      return const Center(child: TossLoadingView());
    }

    final currentUserId = _controller.getCurrentUserId();
    final storeName = _controller.getStoreName();
    final shifts = _controller.getActiveShifts(shiftMetadata);

    // Create helpers
    final statusHelper = ShiftStatusHelper(
      monthlyShiftStatus: monthlyShiftStatus,
      currentUserId: currentUserId,
    );

    final availabilityHelper = ShiftAvailabilityHelper(
      monthlyShiftStatus: monthlyShiftStatus,
      shiftMetadata: shiftMetadata,
      currentUserId: currentUserId,
    );

    final actions = ShiftRequestsActions(
      ref: ref,
      selectedDate: selectedDate,
      monthlyShiftStatus: monthlyShiftStatus,
      shiftMetadata: shiftMetadata,
      onStatusUpdate: _updateMonthlyShiftStatus,
    );

    final datesWithUserApproved = availabilityHelper.getDatesWithUserApproved(weekStartDate);
    final shiftAvailabilityMap = availabilityHelper.getShiftAvailabilityMap(weekStartDate);

    return Container(
      color: TossColors.background,
      child: CustomScrollView(
        slivers: [
          // Week Navigation
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TossWeekNavigation(
                weekLabel: _controller.getWeekLabel(_currentWeekOffset),
                dateRange: _controller.getDateRange(weekStartDate),
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
                        final dailyShift = statusHelper.getDailyShiftData(shift.shiftId, selectedDate);
                        final status = statusHelper.getShiftStatus(shift, selectedDate);
                        final filledSlots = dailyShift?.approvedCount ?? 0;
                        final totalSlots = dailyShift?.requiredEmployees ?? shift.numberShift ?? 1;
                        final appliedCount = (dailyShift?.approvedCount ?? 0) + (dailyShift?.pendingCount ?? 0);
                        final userApplied = statusHelper.getUserApplied(shift, selectedDate);

                        // Get all employees' profile images (approved + pending)
                        final allEmployees = [
                          ...?dailyShift?.approvedEmployees,
                          ...?dailyShift?.pendingEmployees,
                        ];
                        final assignedAvatars = allEmployees
                            .map((e) => (e.profileImage?.isNotEmpty ?? false) ? e.profileImage! : '')
                            .toList();

                        final isLoading = _loadingShiftId == shift.shiftId;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ShiftSignupCard(
                            shiftType: shift.shiftName,
                            timeRange: ShiftStatusHelper.formatTimeRange(shift.startTime, shift.endTime),
                            location: storeName,
                            status: status,
                            filledSlots: filledSlots,
                            totalSlots: totalSlots,
                            appliedCount: appliedCount,
                            userApplied: userApplied,
                            assignedUserAvatars: assignedAvatars.isNotEmpty ? assignedAvatars : null,
                            isLoading: isLoading,
                            onApply: status == ShiftSignupStatus.available
                                ? () => _executeWithLoading(shift.shiftId, () => actions.handleApply(shift))
                                : null,
                            onWaitlist: status == ShiftSignupStatus.waitlist
                                ? () => _executeWithLoading(shift.shiftId, () => actions.handleWaitlist(shift))
                                : null,
                            onLeaveWaitlist: status == ShiftSignupStatus.onWaitlist
                                ? () => _executeWithLoading(shift.shiftId, () => actions.handleLeaveWaitlist(shift))
                                : null,
                            onWithdraw: status == ShiftSignupStatus.applied
                                ? () => _executeWithLoading(shift.shiftId, () => actions.handleWithdraw(shift))
                                : null,
                            onTap: () => actions.handleShiftTap(shift),
                            onViewAppliedUsers: (status == ShiftSignupStatus.assigned || appliedCount > 0 || userApplied)
                                ? () => actions.handleViewAppliedUsers(context, shift, dailyShift)
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
}
