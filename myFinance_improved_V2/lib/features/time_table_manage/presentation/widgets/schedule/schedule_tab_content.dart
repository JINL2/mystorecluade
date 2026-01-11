import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/index.dart';
import '../../models/schedule_models.dart';
import '../../providers/state/coverage_gap_provider.dart';
import '../../providers/time_table_providers.dart';
import 'mixins/schedule_approval_handler.dart';
import 'mixins/schedule_date_helpers.dart';
import 'schedule_shift_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/skeleton/toss_list_skeleton.dart';

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

class _ScheduleTabContentState extends ConsumerState<ScheduleTabContent>
    with ScheduleDateHelpersMixin, ScheduleApprovalHandlerMixin {
  late DateTime _currentWeekStart;
  late DateTime _selectedDate;
  bool _isExpanded = false; // Toggle between week and month view

  // Mixin requirements
  @override
  String? get selectedStoreId => widget.selectedStoreId;

  @override
  DateTime get selectedDate => _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _currentWeekStart = getWeekStart(_selectedDate);

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
        _currentWeekStart = getWeekStart(_selectedDate);
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
          // Extra spacing above Store
          const SizedBox(height: TossSpacing.space4),
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
                        weekLabel: getWeekLabel(_currentWeekStart),
                        dateRange: formatWeekRange(_currentWeekStart),
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
                  size: TossSpacing.iconLG,
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
                  _currentWeekStart = getWeekStart(date);
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
            'Shifts for ${formatSelectedDate(_selectedDate)}',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray600,
              fontWeight: TossFontWeight.semibold,
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
        const TossListSkeleton(
          itemCount: 3,
          style: ListSkeletonStyle.standard,
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
        onApprove: (shiftRequestId) => handleApprove(shiftRequestId),
        onRemove: (shiftRequestId) => handleRemove(shiftRequestId),
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
            size: TossSpacing.icon3XL,
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
      _currentWeekStart = getWeekStart(today);
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
        startTime: formatTime(shiftMeta.startTime),
        endTime: formatTime(shiftMeta.endTime),
        assignedCount: assignedEmployees.length,
        maxCapacity: shiftMeta.targetCount,
        assignedEmployees: assignedEmployees,
        applicants: applicants,
        waitlist: [], // No waitlist in current domain model
      );
    }).toList();
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
                    fontWeight: TossFontWeight.semibold,
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
