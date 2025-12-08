import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../attendance/domain/entities/monthly_shift_status.dart';
import '../../../attendance/domain/entities/shift_metadata.dart';
import '../providers/attendance_providers.dart';
import '../widgets/shift_signup/shift_signup_date_picker.dart';
import '../widgets/shift_signup/shift_signup_helpers.dart';
import '../widgets/shift_signup/shift_signup_list.dart';
import '../widgets/shift_signup/shift_signup_week_header.dart';

/// ShiftSignupTab - Refactored shift registration page
///
/// **Architecture:**
/// - Main coordinator: manages state and data fetching (this file, <400 lines)
/// - UI Components: extracted to separate widgets for reusability
///   - ShiftSignupWeekHeader: week navigation
///   - ShiftSignupDatePicker: 7-day date selector
///   - ShiftSignupList: shift cards list
///   - ShiftSignupHelpers: utility functions
///
/// **Design Pattern:**
/// - Composition over inheritance
/// - Single responsibility per component
/// - Follows Toss design system
class ShiftSignupTab extends ConsumerStatefulWidget {
  const ShiftSignupTab({super.key});

  @override
  ConsumerState<ShiftSignupTab> createState() => _ShiftSignupTabState();
}

class _ShiftSignupTabState extends ConsumerState<ShiftSignupTab>
    with AutomaticKeepAliveClientMixin {
  // State
  DateTime selectedDate = DateTime.now();
  int _currentWeekOffset = 0;
  String? selectedStoreId;
  List<ShiftMetadata>? shiftMetadata;
  bool isLoadingMetadata = false;

  // Monthly shift status cache - key: "yyyy-MM" format
  final Map<String, List<MonthlyShiftStatus>> _monthlyShiftStatusCache = {};
  final Set<String> _loadingMonths = {};

  // User actions tracking (optimistic updates)
  Set<String> appliedShiftIds = {};
  Set<String> waitlistedShiftIds = {};

  @override
  bool get wantKeepAlive => true;

  /// Get Monday of the current week
  DateTime get weekStartDate {
    final currentWeek = DateTime.now().add(Duration(days: _currentWeekOffset * 7));
    final weekday = currentWeek.weekday;
    final monday = currentWeek.subtract(Duration(days: weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // ==================== DATA FETCHING ====================

  Future<void> _loadInitialData() async {
    developer.log('[ShiftSignupTab] _loadInitialData', name: 'ShiftSignupTab');

    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    if (selectedStoreId != null) {
      await _fetchShiftMetadata(selectedStoreId!);
      await _fetchMonthlyShiftStatusIfNeeded(selectedDate);
    }
  }

  Future<void> _fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;

    setState(() => isLoadingMetadata = true);

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

  Future<void> _fetchMonthlyShiftStatusIfNeeded(DateTime date) async {
    final monthKey = ShiftSignupHelpers.getMonthKey(date);

    if (_monthlyShiftStatusCache.containsKey(monthKey) ||
        _loadingMonths.contains(monthKey)) {
      return;
    }

    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    if (storeId.isEmpty || companyId.isEmpty) return;

    _loadingMonths.add(monthKey);
    if (mounted) setState(() {});

    try {
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final targetDate = DateTime(date.year, date.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      final response = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      if (mounted) {
        setState(() {
          _monthlyShiftStatusCache[monthKey] = response;
          _loadingMonths.remove(monthKey);
        });
      }
    } catch (e) {
      developer.log('[ShiftSignupTab] RPC ERROR: $e', name: 'ShiftSignupTab');
      _loadingMonths.remove(monthKey);
      if (mounted) setState(() {});
    }
  }

  // ==================== NAVIGATION ====================

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekOffset--;
      selectedDate = weekStartDate;
    });
    _fetchMonthlyShiftStatusIfNeeded(selectedDate);
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentWeekOffset = 0;
      selectedDate = DateTime.now();
    });
    _fetchMonthlyShiftStatusIfNeeded(selectedDate);
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekOffset++;
      selectedDate = weekStartDate;
    });
    _fetchMonthlyShiftStatusIfNeeded(selectedDate);
  }

  void _onDateSelected(DateTime date) {
    setState(() => selectedDate = date);
    _fetchMonthlyShiftStatusIfNeeded(date);
  }

  // ==================== DATA HELPERS ====================

  List<ShiftMetadata> _getActiveShifts() {
    if (shiftMetadata == null) return [];
    return shiftMetadata!.where((shift) => shift.isActive).toList();
  }

  // ==================== ACTION HANDLERS ====================

  void _handleApply(ShiftMetadata shift) {
    setState(() => appliedShiftIds.add(shift.shiftId));
    // TODO: Implement backend API call
  }

  void _handleWaitlist(ShiftMetadata shift) {
    setState(() => waitlistedShiftIds.add(shift.shiftId));
    // TODO: Implement backend API call
  }

  void _handleLeaveWaitlist(ShiftMetadata shift) {
    setState(() => waitlistedShiftIds.remove(shift.shiftId));
    // TODO: Implement backend API call
  }

  void _handleWithdraw(ShiftMetadata shift) {
    setState(() => appliedShiftIds.remove(shift.shiftId));
    // TODO: Implement backend API call
  }

  void _handleShiftTap(ShiftMetadata shift) {
    // TODO: Navigate to shift detail page
  }

  void _handleViewAppliedUsers(ShiftMetadata shift) {
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
      onItemSelected: (_) {},
    );
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoadingMetadata) {
      return const Center(child: TossLoadingView());
    }

    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;
    final storeName = appState.storeName.isNotEmpty ? appState.storeName : 'Store';

    final shifts = _getActiveShifts();
    final datesWithUserApproved = ShiftSignupHelpers.getDatesWithUserApproved(
      weekStartDate,
      currentUserId,
      _monthlyShiftStatusCache,
    );
    final datesWithShifts = ShiftSignupHelpers.getShiftAvailabilityMap(
      weekStartDate,
      _monthlyShiftStatusCache,
    );

    return Container(
      color: TossColors.background,
      child: CustomScrollView(
        slivers: [
          // Week Navigation Header
          SliverToBoxAdapter(
            child: ShiftSignupWeekHeader(
              weekLabel: ShiftSignupHelpers.getWeekLabel(_currentWeekOffset),
              dateRange: ShiftSignupHelpers.getDateRange(weekStartDate),
              canGoPrevious: true,
              canGoNext: true,
              onPreviousWeek: _goToPreviousWeek,
              onNextWeek: _goToNextWeek,
            ),
          ),

          // 7-Day Date Picker
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ShiftSignupDatePicker(
                weekStartDate: weekStartDate,
                selectedDate: selectedDate,
                datesWithShifts: datesWithShifts,
                datesWithUserApproved: datesWithUserApproved,
                onDateSelected: _onDateSelected,
              ),
            ),
          ),

          // Shift List
          SliverFillRemaining(
            child: ShiftSignupList(
              selectedDate: selectedDate,
              shifts: shifts,
              storeName: storeName,
              getShiftStatus: (shift) => ShiftSignupHelpers.getShiftStatus(
                shift,
                selectedDate,
                currentUserId,
                appliedShiftIds,
                waitlistedShiftIds,
                _monthlyShiftStatusCache,
              ),
              getFilledSlots: (shift) => ShiftSignupHelpers.getFilledSlots(
                shift,
                selectedDate,
                _monthlyShiftStatusCache,
              ),
              getAppliedCount: (shift) => ShiftSignupHelpers.getAppliedCount(
                shift,
                selectedDate,
                _monthlyShiftStatusCache,
              ),
              getUserApplied: (shift) => ShiftSignupHelpers.getUserApplied(
                shift,
                selectedDate,
                currentUserId,
                appliedShiftIds,
                _monthlyShiftStatusCache,
              ),
              getEmployeeAvatars: (shift) => ShiftSignupHelpers.getEmployeeAvatars(
                shift,
                selectedDate,
                _monthlyShiftStatusCache,
              ),
              formatTimeRange: ShiftSignupHelpers.formatTimeRange,
              onApply: _handleApply,
              onWaitlist: _handleWaitlist,
              onLeaveWaitlist: _handleLeaveWaitlist,
              onWithdraw: _handleWithdraw,
              onShiftTap: _handleShiftTap,
              onViewAppliedUsers: _handleViewAppliedUsers,
            ),
          ),
        ],
      ),
    );
  }
}
