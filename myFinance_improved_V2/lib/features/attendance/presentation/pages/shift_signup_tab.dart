import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../../shared/widgets/toss/toss_week_navigation.dart';
import '../../../../shared/widgets/toss/week_dates_picker.dart';
import '../../../attendance/domain/entities/shift_metadata.dart';
import '../providers/attendance_providers.dart';
import '../widgets/shift_signup/shift_signup_card.dart';

/// ShiftSignupTab - Shift registration page with new UI design
///
/// Design Pattern:
/// - Week navigation (< Previous week | This week • 10-16 Jun | Next week >)
/// - 7 date circles (Mon-Sun) with blue dots for dates with available shifts
/// - "Available Shifts on {date}" header
/// - Shift cards with 3 states: Available, Applied, Assigned
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

  // Track which shifts the user has applied to
  Set<String> appliedShiftIds = {};

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
      await _fetchShiftMetadata(selectedStoreId!);
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

      // Debug: Print shift times
      print('📋 Shift Metadata fetched:');
      for (var shift in response) {
        print('  ${shift.shiftName}: ${shift.startTime} - ${shift.endTime}');
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

  // Get dates with assigned shifts (blue circle border)
  // TODO: Replace with real data from backend
  Set<DateTime> get datesWithAssignedShifts {
    // Mock: Days where user is assigned
    return {
      weekStartDate, // Monday - assigned
      weekStartDate.add(const Duration(days: 4)), // Friday - assigned
    };
  }

  // Get dates with available shifts (blue dot)
  // TODO: Replace with real data from backend
  Set<DateTime> get datesWithAvailableShifts {
    // Mock: Days with available shifts
    return {
      weekStartDate.add(const Duration(days: 1)), // Tuesday - available
      weekStartDate.add(const Duration(days: 3)), // Thursday - available
    };
  }

  // Get dates with all shifts full (gray dot)
  // TODO: Replace with real data from backend
  Set<DateTime> get datesWithFullShifts {
    // Mock: Days with all shifts full
    return {
      weekStartDate.add(const Duration(days: 2)), // Wednesday - full
      weekStartDate.add(const Duration(days: 5)), // Saturday - full
    };
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
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentWeekOffset = 0;
      selectedDate = DateTime.now();
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekOffset++;
      selectedDate = weekStartDate; // Select Monday of new week
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  // Determine shift status based on user's applied shifts
  ShiftSignupStatus _getShiftStatus(ShiftMetadata shift, int index) {
    final shiftId = shift.shiftId;

    // Check if user has applied to this shift
    if (appliedShiftIds.contains(shiftId)) {
      return ShiftSignupStatus.applied;
    }

    // Mock: Demo other variations for testing
    // TODO: Replace with real data from backend
    switch (index % 3) {
      case 0:
        return ShiftSignupStatus.available;
      case 1:
        return ShiftSignupStatus.available; // With appliedCount
      case 2:
        return ShiftSignupStatus.assigned;
      default:
        return ShiftSignupStatus.available;
    }
  }

  // Mock: Get applied count
  int _getAppliedCount(int index) {
    return index % 5 == 1 ? 1 : 0; // Only variation #2 has applied count
  }

  // Check if user applied to this shift
  bool _getUserApplied(ShiftMetadata shift) {
    return appliedShiftIds.contains(shift.shiftId);
  }

  // Mock: Get filled slots count
  // TODO: Replace with real data from shift assignments
  int _getFilledSlots(ShiftMetadata shift, int index) {
    final total = shift.numberShift ?? 3;
    // Variation #3 (assigned) should be full
    if (index % 3 == 2) {
      return total; // Full
    }
    // Others partially filled
    return (total * 0.3).round();
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
    } catch (e) {
      print('Error formatting time range: $e');
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
                datesWithAssignedShifts: datesWithAssignedShifts,
                datesWithAvailableShifts: datesWithAvailableShifts,
                datesWithFullShifts: datesWithFullShifts,
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
                        final status = _getShiftStatus(shift, index);
                        final filledSlots = _getFilledSlots(shift, index);
                        final totalSlots = shift.numberShift ?? 3;
                        final appliedCount = _getAppliedCount(index);
                        final userApplied = _getUserApplied(shift);

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
                            assignedUserAvatars: (status == ShiftSignupStatus.assigned || appliedCount > 0 || userApplied)
                                ? ['https://i.pravatar.cc/150?img=1', 'https://i.pravatar.cc/150?img=2']
                                : null,
                            onApply: status == ShiftSignupStatus.available
                                ? () => _handleApply(shift)
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
    print('Apply to shift: ${shift.shiftName}');
    setState(() {
      appliedShiftIds.add(shift.shiftId);
    });
    // TODO: Implement backend API call to apply for shift
  }

  void _handleWithdraw(ShiftMetadata shift) {
    print('Withdraw from shift: ${shift.shiftName}');
    setState(() {
      appliedShiftIds.remove(shift.shiftId);
    });
    // TODO: Implement backend API call to withdraw from shift
  }

  void _handleShiftTap(ShiftMetadata shift) {
    print('Tapped shift: ${shift.shiftName}');
    // TODO: Navigate to shift detail page
  }

  // Show applied users bottom sheet
  void _handleViewAppliedUsers(ShiftMetadata shift) {
    // Mock data - replace with real data from backend
    final mockAppliedUsers = [
      {'id': '1', 'name': 'John Doe', 'avatar': 'https://i.pravatar.cc/150?img=1', 'isAssigned': true},
      {'id': '2', 'name': 'Jane Smith', 'avatar': 'https://i.pravatar.cc/150?img=2', 'isAssigned': false},
      {'id': '3', 'name': 'Mike Johnson', 'avatar': 'https://i.pravatar.cc/150?img=3', 'isAssigned': true},
      {'id': '4', 'name': 'Sarah Williams', 'avatar': 'https://i.pravatar.cc/150?img=4', 'isAssigned': true},
    ];

    // Sort: assigned users first, then applied users
    mockAppliedUsers.sort((a, b) {
      final aAssigned = a['isAssigned'] as bool;
      final bAssigned = b['isAssigned'] as bool;
      if (aAssigned && !bAssigned) return -1;
      if (!aAssigned && bAssigned) return 1;
      return 0;
    });

    final items = mockAppliedUsers.map((user) {
      final isAssigned = user['isAssigned'] as bool;
      return TossSelectionItem.fromGeneric(
        id: user['id'] as String,
        title: user['name'] as String,
        avatarUrl: user['avatar'] as String,
        trailing: isAssigned
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                border: Border.all(color: TossColors.gray200, width: 1),
              ),
              child: Text(
                'Assigned',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
      );
    }).toList();

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Applied Users',
      items: items,
      showSubtitle: false,
      borderBottomWidth: 0, // Remove divider lines
      onItemSelected: (item) {
        // Optional: Navigate to user profile or show more details
        print('Selected user: ${item.title}');
      },
    );
  }
}
