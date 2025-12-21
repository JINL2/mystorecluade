import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/month_dates_picker.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../../shared/widgets/toss/toss_week_navigation.dart';
import '../../../../../shared/widgets/toss/week_dates_picker.dart';
import '../../../domain/usecases/toggle_shift_approval.dart';
import '../../models/schedule_models.dart';
import '../../providers/state/coverage_gap_provider.dart';
import '../../providers/time_table_providers.dart';
import 'schedule_shift_card.dart';

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
  bool _isExpanded = false; // Toggle between week and month view

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _currentWeekStart = _getWeekStart(_selectedDate);

    // Note: Data loading is handled by parent page (time_table_manage_page.dart)
    // Parent calls fetchMonthlyShiftStatus(forceRefresh: true) on page entry
    // We don't load data here to avoid duplicate RPC calls and race conditions
  }

  /// Toggle between week and month view
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Load shift data for current month
  ///
  /// [forceRefresh]: If true, always fetch fresh data from RPC.
  /// Used when navigating to a different month that may not be cached.
  void _loadMonthData({bool forceRefresh = false}) {
    if (widget.selectedStoreId == null) return;

    // Load monthly shift status (employee data for shifts)
    // Only force refresh when explicitly requested (e.g., month change)
    ref.read(monthlyShiftStatusProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: _selectedDate,
      forceRefresh: forceRefresh,
    );

    // Note: shiftMetadataProvider is NOT invalidated here
    // It's store-level data that doesn't change with date/month
    // It's auto-loaded on first watch via FutureProvider
  }

  @override
  void didUpdateWidget(ScheduleTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate;
        _currentWeekStart = _getWeekStart(_selectedDate);
      });
      // Date changed within same store - load if month changed
      // Provider caching handles duplicate month requests
      _loadMonthData();
    }

    // Reload if store changed - force refresh to get new store's data
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _loadMonthData(forceRefresh: true);
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

    // Get stores from selected company only (no fallback to prevent showing wrong company's stores)
    List<dynamic> stores = [];
    if (companies.isNotEmpty && appState.companyChoosen.isNotEmpty) {
      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        if (companyMap['company_id']?.toString() == appState.companyChoosen) {
          stores = (companyMap['stores'] as List<dynamic>?) ?? [];
          break;
        }
      }
    }

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

          // Week/Month navigation with expand button
          Row(
            children: [
              Expanded(
                child: _isExpanded
                    ? _buildMonthNavigation()
                    : TossWeekNavigation(
                        weekLabel: _getWeekLabel(),
                        dateRange: _formatWeekRange(),
                        onPrevWeek: () => _changeWeek(-7),
                        onCurrentWeek: () => _jumpToToday(),
                        onNextWeek: () => _changeWeek(7),
                      ),
              ),
              // Expand/Collapse button - Calendar icon
              IconButton(
                onPressed: _toggleExpanded,
                icon: Icon(
                  _isExpanded ? Icons.calendar_view_week : Icons.calendar_month,
                  color: _isExpanded ? TossColors.primary : TossColors.gray600,
                  size: 24,
                ),
                tooltip: _isExpanded ? 'Show week view' : 'Show month view',
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Week or Month date picker
          if (_isExpanded)
            MonthDatesPicker(
              currentMonth: widget.focusedMonth,
              selectedDate: _selectedDate,
              problemStatusByDate: const {}, // Schedule tab doesn't use problem status
              shiftAvailabilityMap: _getMonthShiftAvailabilityMap(),
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  _currentWeekStart = _getWeekStart(date);
                });
                widget.onDateSelected(date);
              },
            )
          else
            WeekDatesPicker(
              selectedDate: _selectedDate,
              weekStartDate: _currentWeekStart,
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

    final monthlyStatusState = ref.watch(monthlyShiftStatusProvider(widget.selectedStoreId!));
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));

    // Show loading only on initial load (no data yet)
    // Once data is loaded, switching dates should be instant (no loading indicator)
    final isInitialLoading = monthlyStatusState.isLoading &&
        monthlyStatusState.allMonthlyStatuses.isEmpty;
    final isMetadataLoading = metadataAsync.isLoading && !metadataAsync.hasValue;

    if (isInitialLoading || isMetadataLoading) {
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
    if (monthlyStatusState.error != null && monthlyStatusState.allMonthlyStatuses.isEmpty) {
      return [
        _buildEmptyState('Error loading shift data\n${monthlyStatusState.error}'),
      ];
    }

    if (metadataAsync.hasError && !metadataAsync.hasValue) {
      return [
        _buildEmptyState('Error loading shift metadata\n${metadataAsync.error}'),
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
        maxCapacity: shift.maxCapacity,
        assignedEmployees: assignedEmployees,
        onApprove: (shiftRequestId) => _handleApprove(shiftRequestId),
        onRemove: (shiftRequestId) => _handleRemove(shiftRequestId),
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

  /// Get week label (e.g., "This week", "Next week", "Last week", or "Week 52")
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
      return 'Last week';
    }

    // Otherwise, return "Week [number]" (ISO week number)
    final weekNumber = _getIsoWeekNumber(_currentWeekStart);
    return 'Week $weekNumber';
  }

  /// Calculate ISO week number (1-53)
  /// ISO 8601: Week 1 is the week containing the first Thursday of the year
  int _getIsoWeekNumber(DateTime date) {
    // Find the Thursday of the current week
    final thursday = date.add(Duration(days: 4 - date.weekday));

    // Find January 1st of that Thursday's year
    final jan1 = DateTime(thursday.year, 1, 1);

    // Calculate the number of days from Jan 1 to the Thursday
    final daysDiff = thursday.difference(jan1).inDays;

    // Week number is (days / 7) + 1
    return (daysDiff / 7).floor() + 1;
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
    final oldSelectedDate = _selectedDate;
    final newWeekStart = _currentWeekStart.add(Duration(days: days));
    final newSelectedDate = _selectedDate.add(Duration(days: days));

    setState(() {
      _currentWeekStart = newWeekStart;
      _selectedDate = newSelectedDate;
    });

    // Load new month data if month changed
    if (oldSelectedDate.month != newSelectedDate.month ||
        oldSelectedDate.year != newSelectedDate.year) {
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
  /// Logic (coverage-based) - Uses CENTRALIZED coverageGapProvider:
  /// - Red dot: Coverage gap exists (business hours not fully covered by approved shifts)
  /// - No dot: No coverage gap OR store is closed
  /// - Past dates: No dot (only show today and future)
  ///
  /// OPTIMIZATION:
  /// - Uses centralized weekCoverageGapMapProvider for consistent data across tabs
  /// - For TODAY: only check gaps AFTER current time (현재 시간 이후만)
  /// - For FUTURE dates: check all gaps
  /// - Data is cached and shared with Overview tab
  Map<DateTime, ShiftAvailabilityStatus> _getShiftAvailabilityMap() {
    if (widget.selectedStoreId == null) return {};

    // Use centralized coverage gap provider - same data source as Overview tab
    final weekCoverageGaps = ref.watch(weekCoverageGapMapProvider(
      WeekCoverageGapKey(
        storeId: widget.selectedStoreId!,
        weekStart: _currentWeekStart,
      ),
    ));

    // Convert bool map to ShiftAvailabilityStatus map
    final Map<DateTime, ShiftAvailabilityStatus> availabilityMap = {};
    weekCoverageGaps.forEach((date, hasGap) {
      if (hasGap) {
        availabilityMap[date] = ShiftAvailabilityStatus.empty;
      }
    });

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

      // Get approved employees - use shiftRequestId for approval/removal operations
      final assignedEmployees = shiftWithRequests?.approvedRequests
              .map((req) => Employee(
                    id: req.shiftRequestId,
                    name: req.employee.userName,
                    avatarUrl: req.employee.profileImage ?? '',
                  ))
              .toList() ??
          [];

      // Get pending employees (applicants) - use shiftRequestId for approval operations
      final applicants = shiftWithRequests?.pendingRequests
              .map((req) => Employee(
                    id: req.shiftRequestId,
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

  /// Handle Approve button click
  ///
  /// Calls toggle_shift_approval_v3 RPC to approve a shift request.
  /// Local state is updated by ScheduleShiftCard for instant UI feedback.
  /// Uses Partial Update for cross-tab sync instead of full refresh.
  /// Returns true on success, false on failure.
  Future<bool> _handleApprove(String shiftRequestId) async {
    if (shiftRequestId.isEmpty) return false;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) return false;

    try {
      final useCase = ref.read(toggleShiftApprovalUseCaseProvider);
      await useCase(
        ToggleShiftApprovalParams(
          shiftRequestIds: [shiftRequestId],
          userId: userId,
        ),
      );

      // Partial Update: Update only the affected card instead of full refresh
      // This is much more efficient than loading all data again
      if (widget.selectedStoreId != null) {
        final shiftDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

        // Update MonthlyShiftStatus (Schedule tab data)
        ref.read(monthlyShiftStatusProvider(widget.selectedStoreId!).notifier)
            .updateShiftRequestApproval(
          shiftRequestId: shiftRequestId,
          isApproved: true,
          shiftDate: shiftDate,
        );

        // Update ManagerCards (Timesheets/Problems tab data)
        ref.read(managerCardsProvider(widget.selectedStoreId!).notifier)
            .updateCardApproval(
          shiftRequestId: shiftRequestId,
          isApproved: true,
          shiftDate: shiftDate,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle Remove button click from bottom sheet
  ///
  /// Calls toggle_shift_approval_v3 RPC to unapprove a shift request.
  /// Local state is updated by ScheduleShiftCard for instant UI feedback.
  /// Uses Partial Update for cross-tab sync instead of full refresh.
  /// Returns true on success, false on failure.
  Future<bool> _handleRemove(String shiftRequestId) async {
    if (shiftRequestId.isEmpty) return false;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) return false;

    try {
      final useCase = ref.read(toggleShiftApprovalUseCaseProvider);
      await useCase(
        ToggleShiftApprovalParams(
          shiftRequestIds: [shiftRequestId],
          userId: userId,
        ),
      );

      // Partial Update: Update only the affected card instead of full refresh
      // This is much more efficient than loading all data again
      if (widget.selectedStoreId != null) {
        final shiftDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

        // Update MonthlyShiftStatus (Schedule tab data)
        ref.read(monthlyShiftStatusProvider(widget.selectedStoreId!).notifier)
            .updateShiftRequestApproval(
          shiftRequestId: shiftRequestId,
          isApproved: false,
          shiftDate: shiftDate,
        );

        // Update ManagerCards (Timesheets/Problems tab data)
        ref.read(managerCardsProvider(widget.selectedStoreId!).notifier)
            .updateCardApproval(
          shiftRequestId: shiftRequestId,
          isApproved: false,
          shiftDate: shiftDate,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Build month navigation widget (same style as timesheets_tab.dart)
  Widget _buildMonthNavigation() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthName = months[widget.focusedMonth.month - 1];
    final year = widget.focusedMonth.year;

    return Row(
      children: [
        IconButton(
          onPressed: () => widget.onPreviousMonth(),
          icon: Icon(Icons.chevron_left, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _jumpToToday,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$monthName $year',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => widget.onNextMonth(),
          icon: Icon(Icons.chevron_right, color: TossColors.gray600),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  /// Get shift availability map for entire month
  ///
  /// Logic (coverage-based) - Uses CENTRALIZED coverageGapProvider:
  /// - Red dot: Coverage gap exists (business hours not fully covered by approved shifts)
  /// - No dot: No coverage gap OR store is closed
  /// - Past dates: No dot (only show today and future)
  ///
  /// OPTIMIZATION:
  /// - Uses centralized monthCoverageGapProvider for consistent data across tabs
  /// - For TODAY: only check gaps AFTER current time (현재 시간 이후만)
  /// - For FUTURE dates: check all gaps
  /// - Data is cached and shared with Overview tab
  Map<DateTime, ShiftAvailabilityStatus> _getMonthShiftAvailabilityMap() {
    if (widget.selectedStoreId == null) return {};

    // Use centralized coverage gap provider - same data source as Overview tab
    final monthCoverageGaps = ref.watch(monthCoverageGapProvider(
      MonthCoverageGapKey(
        storeId: widget.selectedStoreId!,
        year: widget.focusedMonth.year,
        month: widget.focusedMonth.month,
      ),
    ));

    // If still loading, return empty map
    if (monthCoverageGaps.isLoading) {
      return {};
    }

    // Convert CoverageGapState to ShiftAvailabilityStatus map
    final Map<DateTime, ShiftAvailabilityStatus> availabilityMap = {};
    monthCoverageGaps.gapsByDate.forEach((date, info) {
      if (info.hasGap) {
        availabilityMap[date] = ShiftAvailabilityStatus.empty;
      }
    });

    return availabilityMap;
  }
}
