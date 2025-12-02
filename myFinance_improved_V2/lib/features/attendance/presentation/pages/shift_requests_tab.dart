import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
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
    selectedStoreId = _controller.getSelectedStoreId();

    if (selectedStoreId != null) {
      await Future.wait([
        _fetchShiftMetadata(selectedStoreId!),
        _fetchMonthlyShiftStatus(),
      ]);
    }
  }

  Future<void> _fetchMonthlyShiftStatus() async {
    final result = await _controller.fetchMonthlyShiftStatus(selectedDate);
    if (mounted && result != null) {
      setState(() {
        monthlyShiftStatus = result;
      });
    }
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
    setState(() {
      _currentWeekOffset--;
      selectedDate = weekStartDate;
    });
    _fetchMonthlyShiftStatus();
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentWeekOffset = 0;
      selectedDate = DateTime.now();
    });
    _fetchMonthlyShiftStatus();
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekOffset++;
      selectedDate = weekStartDate;
    });
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
    print('[ShiftRequestsTab] _executeWithLoading called for shiftId: $shiftId');

    if (_loadingShiftId != null) {
      print('[ShiftRequestsTab] Already processing, skipping. Current _loadingShiftId: $_loadingShiftId');
      return;
    }

    print('[ShiftRequestsTab] Setting loading state...');
    setState(() {
      _loadingShiftId = shiftId;
    });

    try {
      print('[ShiftRequestsTab] Calling action...');
      await action();
      print('[ShiftRequestsTab] Action completed successfully');
    } catch (e) {
      print('[ShiftRequestsTab] Action error: $e');
    } finally {
      if (mounted) {
        print('[ShiftRequestsTab] Clearing loading state');
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

                        // DEBUG: Log status for each shift
                        print('[ShiftRequestsTab] === ShiftCard Build ===');
                        print('[ShiftRequestsTab] shift.shiftName: ${shift.shiftName}');
                        print('[ShiftRequestsTab] shift.shiftId: ${shift.shiftId}');
                        print('[ShiftRequestsTab] status: $status');
                        print('[ShiftRequestsTab] currentUserId: $currentUserId');
                        print('[ShiftRequestsTab] dailyShift: ${dailyShift != null}');
                        if (dailyShift != null) {
                          print('[ShiftRequestsTab] approvedEmployees: ${dailyShift.approvedEmployees.map((e) => e.userId).toList()}');
                          print('[ShiftRequestsTab] pendingEmployees: ${dailyShift.pendingEmployees.map((e) => e.userId).toList()}');
                        }
                        print('[ShiftRequestsTab] onWithdraw will be: ${status == ShiftSignupStatus.applied ? "SET" : "NULL"}');

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
