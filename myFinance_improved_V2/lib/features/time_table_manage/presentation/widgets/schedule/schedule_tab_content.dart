import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../../shared/widgets/toss/toss_week_navigation.dart';
import '../../../../../shared/widgets/toss/week_dates_picker.dart';
import '../shift_management_card.dart';
import 'schedule_shift_card.dart';
import '../../models/schedule_models.dart';
import '../../providers/state/manager_shift_cards_provider.dart';
import '../../providers/state/shift_metadata_provider.dart';
import '../../providers/state/monthly_shift_status_provider.dart';
import '../../providers/time_table_providers.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/shift_metadata_item.dart';
import 'package:intl/intl.dart';

/// Schedule Tab Content - Redesigned
///
/// Displays weekly schedule view with shift management.
/// Shows shifts with applicants and waitlist in expandable cards.
class ScheduleTabContent extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final ScrollController scrollController;
  final String Function(int month) getMonthName;
  final VoidCallback onAddShiftTap;
  final void Function(DateTime date) onDateSelected;
  final Future<void> Function() onPreviousMonth;
  final Future<void> Function() onNextMonth;
  final Future<void> Function() onApprovalSuccess;
  final Future<void> Function() fetchMonthlyShiftStatus;
  final VoidCallback onStoreSelectorTap;
  final void Function(String storeId)? onStoreChanged;

  const ScheduleTabContent({
    super.key,
    required this.selectedStoreId,
    required this.selectedDate,
    required this.focusedMonth,
    required this.scrollController,
    required this.getMonthName,
    required this.onAddShiftTap,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onApprovalSuccess,
    required this.fetchMonthlyShiftStatus,
    required this.onStoreSelectorTap,
    this.onStoreChanged,
  });

  @override
  ConsumerState<ScheduleTabContent> createState() => _ScheduleTabContentState();
}

class _ScheduleTabContentState extends ConsumerState<ScheduleTabContent> {
  late DateTime _currentWeekStart;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _currentWeekStart = _getWeekStart(_selectedDate);

    // Load shift data for current month
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthData();
    });
  }

  /// Load shift cards data for current month
  void _loadMonthData() {
    if (widget.selectedStoreId == null) return;

    // Load shift cards (requests)
    ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: _selectedDate,
    );

    // Load shift metadata (available shifts)
    ref.invalidate(shiftMetadataProvider(widget.selectedStoreId!));
  }

  @override
  void didUpdateWidget(ScheduleTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate;
        _currentWeekStart = _getWeekStart(_selectedDate);
      });
      _loadMonthData();
    }

    // Reload if store changed
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _loadMonthData();
    }
  }

  /// Get Monday of the week for a given date
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday; // Monday = 1, Sunday = 7
    return date.subtract(Duration(days: weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];
    Map<String, dynamic>? selectedCompany;

    if (companies.isNotEmpty) {
      try {
        selectedCompany = companies.firstWhere(
          (c) => (c as Map<String, dynamic>)['company_id'] == appState.companyChoosen,
        ) as Map<String, dynamic>;
      } catch (e) {
        selectedCompany = companies.first as Map<String, dynamic>;
      }
    }

    final stores = (selectedCompany?['stores'] as List<dynamic>?) ?? [];

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector dropdown
          _buildStoreSelector(stores),

          const SizedBox(height: TossSpacing.space3),

          // Week navigation
          TossWeekNavigation(
            weekLabel: _getWeekLabel(),
            dateRange: _formatWeekRange(),
            onPrevWeek: () => _changeWeek(-7),
            onCurrentWeek: () => _jumpToToday(),
            onNextWeek: () => _changeWeek(7),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Week date picker
          WeekDatesPicker(
            selectedDate: _selectedDate,
            weekStartDate: _currentWeekStart,
            datesWithUserApproved: {}, // Remove blue circle border
            shiftAvailabilityMap: _getShiftAvailabilityMap(),
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
              widget.onDateSelected(date);
            },
          ),

          const SizedBox(height: TossSpacing.space4),

          // "Shifts for..." label
          Text(
            'Shifts for ${_formatSelectedDate()}',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Shift cards or empty state
          ..._buildShiftsList(),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  /// Build shifts list or empty/loading state
  List<Widget> _buildShiftsList() {
    if (widget.selectedStoreId == null) {
      return [
        _buildEmptyState('Please select a store'),
      ];
    }

    final cardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));

    // Show loading state
    if (cardsState.isLoading) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space8),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
            ),
          ),
        ),
      ];
    }

    // Show error state
    if (cardsState.error != null) {
      return [
        _buildEmptyState('Error loading shifts\n${cardsState.error}'),
      ];
    }

    final shifts = _getShiftsForSelectedDate();

    // Show empty state if no shifts
    if (shifts.isEmpty) {
      return [
        _buildEmptyState('No shifts scheduled for this day'),
      ];
    }

    // Show shift cards
    return shifts.map((shift) {
      // Convert ShiftData to format expected by ScheduleShiftCard
      final List<Map<String, dynamic>> assignedEmployees = [];

      // Add pending employees (applicants)
      for (final applicant in shift.applicants) {
        assignedEmployees.add({
          'user_name': applicant.name,
          'is_approved': false,
          'shift_request_id': applicant.id,
          'profile_image': applicant.avatarUrl,
        });
      }

      // Add approved employees
      for (final assigned in shift.assignedEmployees) {
        assignedEmployees.add({
          'user_name': assigned.name,
          'is_approved': true,
          'shift_request_id': assigned.id,
          'profile_image': assigned.avatarUrl,
        });
      }

      return ScheduleShiftCard(
        shiftId: shift.id,
        shiftName: shift.name,
        startTime: shift.startTime,
        endTime: shift.endTime,
        assignedEmployees: assignedEmployees,
        selectedShiftRequests: ref.watch(selectedShiftRequestsProvider).selectedIds,
        onEmployeeTap: (shiftRequestId, isApproved, actualRequestId) {
          ref.read(selectedShiftRequestsProvider.notifier).toggleSelection(
            shiftRequestId,
            isApproved,
            actualRequestId,
          );
        },
      );
    }).toList();
  }

  /// Build empty state widget
  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build store selector dropdown
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

  /// Get week label (e.g., "This week", "Next week", "Previous week", or "Week of 8 Dec")
  String _getWeekLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekStart = today.subtract(Duration(days: today.weekday - 1));

    // Check if _currentWeekStart is the same week as today
    if (_currentWeekStart.year == currentWeekStart.year &&
        _currentWeekStart.month == currentWeekStart.month &&
        _currentWeekStart.day == currentWeekStart.day) {
      return 'This week';
    }

    // Check if it's next week (7 days ahead)
    final nextWeekStart = currentWeekStart.add(const Duration(days: 7));
    if (_currentWeekStart.year == nextWeekStart.year &&
        _currentWeekStart.month == nextWeekStart.month &&
        _currentWeekStart.day == nextWeekStart.day) {
      return 'Next week';
    }

    // Check if it's previous week (7 days back)
    final previousWeekStart = currentWeekStart.subtract(const Duration(days: 7));
    if (_currentWeekStart.year == previousWeekStart.year &&
        _currentWeekStart.month == previousWeekStart.month &&
        _currentWeekStart.day == previousWeekStart.day) {
      return 'Previous week';
    }

    // Otherwise, return "Week of [date]"
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return 'Week of ${_currentWeekStart.day} ${months[_currentWeekStart.month - 1]}';
  }

  /// Format week range for navigation (e.g., "10-16 Jun")
  String _formatWeekRange() {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${_currentWeekStart.day}-${weekEnd.day} ${months[_currentWeekStart.month - 1]}';
  }

  /// Format selected date (e.g., "Wed, 12 Jun")
  String _formatSelectedDate() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dayName = weekdays[_selectedDate.weekday - 1];
    return '$dayName, ${_selectedDate.day} ${months[_selectedDate.month - 1]}';
  }

  /// Change week by number of days
  void _changeWeek(int days) {
    final newWeekStart = _currentWeekStart.add(Duration(days: days));
    final newSelectedDate = _selectedDate.add(Duration(days: days));

    setState(() {
      _currentWeekStart = newWeekStart;
      _selectedDate = newSelectedDate;
    });

    // Load new month data if month changed
    if (_selectedDate.month != newSelectedDate.month ||
        _selectedDate.year != newSelectedDate.year) {
      _loadMonthData();
    }

    widget.onDateSelected(_selectedDate);
  }

  /// Jump to today
  void _jumpToToday() {
    final today = DateTime.now();
    setState(() {
      _selectedDate = today;
      _currentWeekStart = _getWeekStart(today);
    });

    // Load current month data
    _loadMonthData();
    widget.onDateSelected(_selectedDate);
  }

  /// Get shift availability map for the week
  ///
  /// Logic:
  /// - Blue dot: total_required > total_approved (understaffed)
  /// - Gray dot: total_required <= total_approved (fully staffed)
  Map<DateTime, ShiftAvailabilityStatus> _getShiftAvailabilityMap() {
    if (widget.selectedStoreId == null) return {};

    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));
    final Map<DateTime, ShiftAvailabilityStatus> availabilityMap = {};

    // Get shift metadata for total_required when no requests exist
    final hasMetadata = metadataAsync.hasValue && metadataAsync.value != null;
    final activeShifts = hasMetadata ? metadataAsync.value!.activeShifts : <ShiftMetadataItem>[];

    // Check each day of the week
    for (int i = 0; i < 7; i++) {
      final date = _currentWeekStart.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      // Find daily shift data for this date
      final dailyShiftData = monthlyStatusState.allMonthlyStatuses
          .expand((status) => status.dailyShifts)
          .where((daily) => daily.date == dateStr)
          .firstOrNull;

      int totalRequired = 0;
      int totalApproved = 0;

      if (dailyShiftData != null && dailyShiftData.shifts.isNotEmpty) {
        // Has request data - use it
        for (final shiftWithReqs in dailyShiftData.shifts) {
          totalRequired += shiftWithReqs.shift.targetCount;
          totalApproved += shiftWithReqs.approvedRequests.length;
        }
      } else if (activeShifts.isNotEmpty) {
        // No request data but has active shifts - use metadata
        // All shifts are understaffed (0 approved, total_required from metadata)
        for (final shiftMeta in activeShifts) {
          totalRequired += shiftMeta.targetCount;
        }
        // totalApproved stays 0
      } else {
        // No shifts configured - no dot
        continue;
      }

      // Determine availability status
      if (totalRequired > totalApproved) {
        // Understaffed - blue dot
        availabilityMap[normalizedDate] = ShiftAvailabilityStatus.available;
      } else {
        // Fully staffed - gray dot
        availabilityMap[normalizedDate] = ShiftAvailabilityStatus.full;
      }
    }

    return availabilityMap;
  }

  /// Get shifts for selected date from real data
  /// Uses monthlyShiftStatusProvider which has employee data
  List<ShiftData> _getShiftsForSelectedDate() {
    if (widget.selectedStoreId == null) {
      return [];
    }

    // Get shift metadata (available shifts)
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));

    // Return empty if metadata still loading
    if (!metadataAsync.hasValue || metadataAsync.value == null) {
      return [];
    }

    final metadata = metadataAsync.value!;
    final activeShifts = metadata.activeShifts;

    // Get monthly shift status (has employee requests data)
    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Find the daily shift data for selected date
    final dailyShiftData = monthlyStatusState.allMonthlyStatuses
        .expand((status) => status.dailyShifts)
        .where((daily) => daily.date == selectedDateStr)
        .firstOrNull;

    // Create ShiftData for ALL active shifts
    return activeShifts.map((shiftMeta) {
      // Find shift with requests for this shift ID
      final shiftWithRequests = dailyShiftData?.shifts
          .where((s) => s.shift.shiftId == shiftMeta.shiftId)
          .firstOrNull;

      // Get approved employees
      final assignedEmployees = shiftWithRequests?.approvedRequests
              .map((req) => Employee(
                    id: req.employee.userId,
                    name: req.employee.userName,
                    avatarUrl: req.employee.profileImage ?? '',
                  ))
              .toList() ??
          [];

      // Get pending employees (applicants)
      final applicants = shiftWithRequests?.pendingRequests
              .map((req) => Employee(
                    id: req.employee.userId,
                    name: req.employee.userName,
                    avatarUrl: req.employee.profileImage ?? '',
                  ))
              .toList() ??
          [];

      return ShiftData(
        id: shiftMeta.shiftId,
        name: shiftMeta.shiftName,
        startTime: _formatTime(shiftMeta.startTime),
        endTime: _formatTime(shiftMeta.endTime),
        assignedCount: assignedEmployees.length,
        maxCapacity: shiftMeta.targetCount,
        assignedEmployees: assignedEmployees,
        applicants: applicants,
        waitlist: [], // No waitlist in current domain model
      );
    }).toList();
  }

  /// Format time string to HH:mm format
  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '--:--';

    try {
      // Remove timezone offset and seconds (e.g., "02:00:00+07" -> "02:00")
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
    } catch (e) {
      // Return original on error
    }

    return timeString;
  }

  /// Handle approve action
  void _handleApprove(Employee employee) {
    // TODO: Implement real approval logic with backend API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} approved (API integration needed)'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle overbook action
  void _handleOverbook(Employee employee) {
    // TODO: Implement real overbook logic with backend API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} overbooked (API integration needed)'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle remove from shift action
  void _handleRemove(Employee employee) {
    // TODO: Implement real remove logic with backend API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} removed (API integration needed)'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.gray700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
