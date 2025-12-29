import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import '../../../domain/entities/manager_memo.dart';
import '../../providers/time_table_providers.dart';
import 'problems_section.dart';
import 'timelogs_section.dart';
import 'store_selector.dart';
import 'timesheets_helpers.dart';

/// Timesheets tab - Problems view for attendance tracking
class TimesheetsTab extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final void Function(String storeId)? onStoreChanged;
  /// Callback to navigate to Schedule tab with a specific date
  final void Function(DateTime date)? onNavigateToSchedule;
  /// Initial filter to apply when tab is shown (e.g., 'this_month')
  final String? initialFilter;
  /// Selected date (shared with parent and other tabs)
  final DateTime selectedDate;
  /// Focused month (shared with parent and other tabs)
  final DateTime focusedMonth;
  /// Callback when date is selected
  final void Function(DateTime date)? onDateSelected;
  /// Callback when previous month is tapped
  final Future<void> Function()? onPreviousMonth;
  /// Callback when next month is tapped
  final Future<void> Function()? onNextMonth;

  const TimesheetsTab({
    super.key,
    this.selectedStoreId,
    this.onStoreChanged,
    this.onNavigateToSchedule,
    this.initialFilter,
    required this.selectedDate,
    required this.focusedMonth,
    this.onDateSelected,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  @override
  ConsumerState<TimesheetsTab> createState() => _TimesheetsTabState();
}

class _TimesheetsTabState extends ConsumerState<TimesheetsTab>
    with TimesheetsHelpersMixin {
  String? selectedFilter = 'this_month'; // 'today', 'this_week', 'this_month' - default to this_month for consistency with Overview
  bool _isExpanded = false; // Toggle between week and month view

  @override
  void initState() {
    super.initState();

    // Apply initial filter if provided
    if (widget.initialFilter != null) {
      selectedFilter = widget.initialFilter;
    }

    // Note: Data loading is handled by parent page (time_table_manage_page.dart)
    // Parent calls fetchManagerCards(forceRefresh: true) on page entry
    // We don't load data here to avoid duplicate RPC calls and race conditions
  }

  /// Get Monday of the week for current selected date
  DateTime get _currentWeekStart => getWeekStart(widget.selectedDate);

  /// Toggle between week and month view
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  /// Set the filter programmatically (called from parent)
  void setFilter(String filter) {
    if (mounted) {
      setState(() {
        selectedFilter = filter;
      });
    }
  }

  @override
  void didUpdateWidget(TimesheetsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if store changed - force refresh to get new store's data
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _loadMonthData(forceRefresh: true);
    }
    // Reload data if month changed
    if (widget.focusedMonth.month != oldWidget.focusedMonth.month ||
        widget.focusedMonth.year != oldWidget.focusedMonth.year) {
      _loadMonthData();
    }
    // Update filter if initialFilter changed
    if (widget.initialFilter != null && widget.initialFilter != oldWidget.initialFilter) {
      setState(() {
        selectedFilter = widget.initialFilter;
      });
    }
  }

  /// Load manager cards data for current selected date's month
  /// [forceRefresh] - If true, reload even if data is cached (use after save operations)
  void _loadMonthData({bool forceRefresh = false}) {
    if (widget.selectedStoreId == null) return;

    // Load manager cards (for time details)
    ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: widget.focusedMonth,
      forceRefresh: forceRefresh,
    );

    // Load monthly shift status (for understaffed detection)
    ref.read(monthlyShiftStatusProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: widget.focusedMonth,
      forceRefresh: forceRefresh,
    );

    // Also invalidate shift metadata to ensure fresh data
    ref.invalidate(shiftMetadataProvider(widget.selectedStoreId!));
  }

  /// Change week
  void _changeWeek(int days) {
    final newSelectedDate = widget.selectedDate.add(Duration(days: days));
    widget.onDateSelected?.call(newSelectedDate);
  }

  /// Jump to current week
  void _jumpToToday() {
    widget.onDateSelected?.call(DateTime.now());
  }

  /// Handle save result from detail page (update cached data)
  void _handleSaveResult(String shiftRequestId, String shiftDate, Map<String, dynamic> result) {
    if (widget.selectedStoreId == null) return;

    // Build ManagerMemo from result if memo was added
    final memoText = result['managerMemo'] as String?;
    ManagerMemo? newMemo;
    if (memoText != null && memoText.isNotEmpty) {
      newMemo = ManagerMemo(
        type: 'note',
        content: memoText,
        createdAt: DateTime.now().toIso8601String(),
        createdBy: null,
      );
    }

    ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).updateCardProblemData(
      shiftRequestId: result['shiftRequestId'] as String,
      shiftDate: shiftDate,
      isProblemSolved: result['isProblemSolved'] as bool?,
      isReportedSolved: result['isReportedSolved'] as bool?,
      confirmedStartTime: result['confirmedStartTime'] as String?,
      confirmedEndTime: result['confirmedEndTime'] as String?,
      bonusAmount: result['bonusAmount'] as double?,
      newManagerMemo: newMemo,
      calculatedPaidHour: result['calculatedPaidHour'] as double?,
    );
  }

  /// Handle save result from shift section (update cached data)
  void _handleShiftSaveResult(Map<String, dynamic> result) {
    if (widget.selectedStoreId == null) return;

    // Build ManagerMemo from result if memo was added
    final memoText = result['managerMemo'] as String?;
    ManagerMemo? newMemo;
    if (memoText != null && memoText.isNotEmpty) {
      newMemo = ManagerMemo(
        type: 'note',
        content: memoText,
        createdAt: DateTime.now().toIso8601String(),
        createdBy: null,
      );
    }

    ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).updateCardProblemData(
      shiftRequestId: result['shiftRequestId'] as String,
      shiftDate: result['shiftDate'] as String,
      isProblemSolved: result['isProblemSolved'] as bool?,
      isReportedSolved: result['isReportedSolved'] as bool?,
      confirmedStartTime: result['confirmedStartTime'] as String?,
      confirmedEndTime: result['confirmedEndTime'] as String?,
      bonusAmount: result['bonusAmount'] as double?,
      newManagerMemo: newMemo,
      calculatedPaidHour: result['calculatedPaidHour'] as double?,
    );
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: TossSpacing.space3);

    // Get data using mixin helper methods
    final allProblems = getProblemsFromRealData(
      storeId: widget.selectedStoreId,
      focusedMonth: widget.focusedMonth,
    );
    final filteredProblems = getFilteredProblems(selectedFilter ?? 'today', allProblems);
    final shifts = getShiftsForSelectedDate(
      storeId: widget.selectedStoreId,
      selectedDate: widget.selectedDate,
      focusedMonth: widget.focusedMonth,
    );
    final problemStatusByDate = getProblemStatusByDate(widget.selectedStoreId, widget.focusedMonth);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TossSpacing.space2),

          // Store selector (with padding)
          Padding(
            padding: horizontalPadding,
            child: StoreSelector(
              selectedStoreId: widget.selectedStoreId,
              onStoreChanged: widget.onStoreChanged,
            ),
          ),

          // Gray divider after store selector (full width)
          const GrayDividerSpace(),

          // Problems Section (with padding)
          Padding(
            padding: horizontalPadding,
            child: ProblemsSection(
              selectedFilter: selectedFilter,
              onFilterChanged: (value) {
                setState(() {
                  selectedFilter = value;
                });
              },
              allProblems: allProblems,
              filteredProblems: filteredProblems,
              todayCount: getProblemCount('today', widget.selectedStoreId, widget.focusedMonth),
              thisWeekCount: getProblemCount('this_week', widget.selectedStoreId, widget.focusedMonth),
              thisMonthCount: getProblemCount('this_month', widget.selectedStoreId, widget.focusedMonth),
              onNavigateToSchedule: widget.onNavigateToSchedule,
              selectedStoreId: widget.selectedStoreId,
              onSaveResult: _handleSaveResult,
            ),
          ),

          // Gray divider before week navigation (full width)
          const GrayDividerSpace(),

          // Timelogs Section (with padding)
          Padding(
            padding: horizontalPadding,
            child: TimelogsSection(
              selectedDate: widget.selectedDate,
              focusedMonth: widget.focusedMonth,
              weekStartDate: _currentWeekStart,
              isExpanded: _isExpanded,
              onToggleExpanded: _toggleExpanded,
              onDateSelected: (date) => widget.onDateSelected?.call(date),
              onPreviousMonth: widget.onPreviousMonth,
              onNextMonth: widget.onNextMonth,
              onJumpToToday: _jumpToToday,
              onChangeWeek: _changeWeek,
              weekLabel: getWeekLabel(_currentWeekStart),
              weekRange: formatWeekRange(_currentWeekStart),
              shifts: shifts,
              problemStatusByDate: problemStatusByDate,
              onSaveResult: _handleShiftSaveResult,
            ),
          ),
        ],
      ),
    );
  }
}
