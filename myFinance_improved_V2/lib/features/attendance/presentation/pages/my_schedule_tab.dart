import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/monitoring/sentry_config.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/index.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/shift_metadata.dart';
import '../providers/attendance_providers.dart';
import '../widgets/check_in_out/dialogs/report_issue_dialog.dart';
import 'utils/schedule_date_utils.dart';
import 'utils/schedule_shift_finder.dart';
import '../../domain/entities/problem_details.dart';
import 'dialogs/shift_detail_dialog.dart';
import 'widgets/schedule_header.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'widgets/my_schedule/index.dart';

/// MyScheduleTab - Main tab with Week view and expandable Month calendar
///
/// Features:
/// - Featured "Today's Shift" card
/// - Week view: Week navigation + shift list (default)
/// - Month calendar: Tap calendar icon to expand/collapse
class MyScheduleTab extends ConsumerStatefulWidget {
  final TabController? tabController;
  final List<Map<String, dynamic>> stores;
  final String? selectedStoreId;
  final void Function(String)? onStoreChanged;

  const MyScheduleTab({
    super.key,
    this.tabController,
    this.stores = const [],
    this.selectedStoreId,
    this.onStoreChanged,
  });

  @override
  ConsumerState<MyScheduleTab> createState() => _MyScheduleTabState();
}

class _MyScheduleTabState extends ConsumerState<MyScheduleTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Calendar expanded state (false = week view, true = month calendar visible)
  bool _isExpanded = false;

  /// Navigate to Shift Sign Up tab (index 1)
  void _goToShiftSignUpTab() {
    widget.tabController?.animateTo(1);
  }

  // Navigation state
  int _currentWeekOffset = 0; // 0 = current week, -1 = prev, +1 = next
  int _currentMonthOffset = 0; // 0 = current month, -1 = prev, +1 = next

  // Selection state (for Month view)
  DateTime _selectedDate = DateTime.now();

  // GlobalKey to measure Today's shift card height
  final GlobalKey _todayShiftCardKey = GlobalKey();

  // Month view data state - Map-based caching for multiple months
  final Map<String, List<MonthlyShiftStatus>> _monthlyShiftStatusCache = {};
  final Set<String> _loadingMonths = {};
  List<ShiftMetadata>? _shiftMetadata;
  bool _isLoadingMetadata = false;

  // Computed properties
  DateTime get _currentWeek {
    return DateTime.now().add(Duration(days: _currentWeekOffset * 7));
  }

  DateTime get _currentMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + _currentMonthOffset, 1);
  }

  DateTimeRange get _weekRange => ScheduleDateUtils.getWeekRange(_currentWeek);

  // Navigation handlers
  void _navigateWeek(int offset) {
    if (offset == 0) {
      setState(() => _currentWeekOffset = 0);
    } else {
      setState(() => _currentWeekOffset += offset);
    }
  }

  void _navigateMonth(int offset) {
    if (offset == 0) {
      setState(() => _currentMonthOffset = 0);
    } else {
      setState(() => _currentMonthOffset += offset);
    }
    // Fetch new month data when navigating
    _fetchMonthViewData();
  }

  /// Get month key in "YYYY-MM" format
  String _getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  /// Get combined monthly shift status from cache
  List<MonthlyShiftStatus> _getMonthlyShiftStatusFromCache() {
    final allData = <MonthlyShiftStatus>[];
    for (final entry in _monthlyShiftStatusCache.entries) {
      allData.addAll(entry.value);
    }
    return allData;
  }

  /// Fetch shift metadata (only once, doesn't change per month)
  Future<void> _fetchShiftMetadataIfNeeded() async {
    if (_shiftMetadata != null || _isLoadingMetadata) return;

    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;

    if (storeId.isEmpty) return;

    _isLoadingMetadata = true;

    try {
      final getShiftMetadata = ref.read(getShiftMetadataProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final result = await getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      if (mounted) {
        // Either pattern: fold to handle success/failure
        result.fold(
          (failure) {
            setState(() {
              _shiftMetadata = [];
              _isLoadingMetadata = false;
            });
          },
          (data) {
            setState(() {
              _shiftMetadata = data;
              _isLoadingMetadata = false;
            });
          },
        );
      }
    } catch (e, stackTrace) {
      _isLoadingMetadata = false;
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'MyScheduleTab._fetchShiftMetadataIfNeeded failed',
      );
    }
  }

  /// Fetch monthly shift status with caching
  /// Only calls RPC if data for the month is not already cached
  Future<void> _fetchMonthlyShiftStatusIfNeeded(DateTime date) async {
    final monthKey = _getMonthKey(date);

    // Check if already cached
    if (_monthlyShiftStatusCache.containsKey(monthKey)) {
      return;
    }

    // Check if already loading
    if (_loadingMonths.contains(monthKey)) {
      return;
    }

    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    if (storeId.isEmpty || companyId.isEmpty) return;

    _loadingMonths.add(monthKey);

    try {
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final targetDate = DateTime(date.year, date.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      final eitherResult = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      if (mounted) {
        // Either pattern: fold to handle success/failure
        eitherResult.fold(
          (failure) {
            // On failure, cache empty list to avoid repeated calls
            _monthlyShiftStatusCache[monthKey] = [];
            setState(() {});
          },
          (result) {
            // Cache the result by month
            final monthData = result.where((r) {
              if (r.requestDate.length >= 7) {
                return r.requestDate.substring(0, 7) == monthKey;
              }
              return false;
            }).toList();

            _monthlyShiftStatusCache[monthKey] = monthData;

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
            }

            setState(() {});
          },
        );
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'MyScheduleTab._fetchMonthlyShiftStatusIfNeeded failed',
        extra: {'monthKey': monthKey},
      );
    } finally {
      _loadingMonths.remove(monthKey);
    }
  }

  /// Fetch shift metadata and monthly shift status for Month view calendar indicators
  Future<void> _fetchMonthViewData() async {
    // Fetch metadata if not already loaded
    await _fetchShiftMetadataIfNeeded();

    // Fetch monthly shift status if not cached
    await _fetchMonthlyShiftStatusIfNeeded(_currentMonth);
  }

  void _handleDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
  }

  // Navigate to QR Scanner for check-in/check-out
  Future<void> _navigateToQRScanner() async {
    final result = await context.push<Map<String, dynamic>>('/attendance/qr-scanner');

    // If QR scan was successful, refresh the shift cards data
    if (result != null && result['success'] == true) {
      // Invalidate providers to refresh data for all relevant months
      final now = DateTime.now();

      // Refresh current month
      final currentYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      ref.invalidate(monthlyShiftCardsProvider(currentYearMonth));

      // Also refresh the week view data
      final weekYearMonth = '${_currentWeek.year}-${_currentWeek.month.toString().padLeft(2, '0')}';
      if (weekYearMonth != currentYearMonth) {
        ref.invalidate(monthlyShiftCardsProvider(weekYearMonth));
      }

      // Refresh month view data if expanded
      if (_isExpanded) {
        final monthYearMonth = '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';
        if (monthYearMonth != currentYearMonth) {
          ref.invalidate(monthlyShiftCardsProvider(monthYearMonth));
        }
      }

      // Also invalidate previous month (for night shift edge cases)
      final prevMonth = DateTime(now.year, now.month - 1, 1);
      final prevYearMonth = '${prevMonth.year}-${prevMonth.month.toString().padLeft(2, '0')}';
      ref.invalidate(monthlyShiftCardsProvider(prevYearMonth));

      // Force rebuild to show loading state while new data is fetched
      if (mounted) {
        setState(() {});
      }
    }
  }

  // Show Report Issue dialog for current shift
  void _showReportIssueDialog(ShiftCard? currentShift) {
    if (currentShift == null) return;

    final shiftRequestId = currentShift.shiftRequestId;
    if (shiftRequestId.isEmpty) return;

    // Convert ShiftCard to Map for ReportIssueDialog
    final cardData = <String, dynamic>{
      'shift_request_id': currentShift.shiftRequestId,
      'request_date': currentShift.requestDate,
      'shift_name': currentShift.shiftName,
      'shift_start_time': currentShift.shiftStartTime,
      'shift_end_time': currentShift.shiftEndTime,
      'is_approved': currentShift.isApproved,
      'is_reported': currentShift.isReported,
      'is_problem_solved': currentShift.isProblemSolved,
    };

    ReportIssueDialog.show(
      context: context,
      ref: ref,
      shiftRequestId: shiftRequestId,
      cardData: cardData,
      onSuccess: () {
        // Refresh shift cards data after report
        final now = DateTime.now();
        final currentYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
        ref.invalidate(monthlyShiftCardsProvider(currentYearMonth));

        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  /// Toggle between week view and month calendar
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    // Fetch month data when expanding
    if (_isExpanded) {
      _fetchMonthViewData();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return _buildMainView();
  }

  /// Build main view with header, week navigation (+ optional month calendar), and shift list
  Widget _buildMainView() {
    final weekRange = _weekRange;
    final now = DateTime.now();

    // Check if week spans two months (e.g., Nov 29 - Dec 5)
    final startMonth = weekRange.start.month;
    final endMonth = weekRange.end.month;
    final startYear = weekRange.start.year;
    final endYear = weekRange.end.year;

    // Primary month (based on week's Monday)
    final primaryYearMonth = '$startYear-${startMonth.toString().padLeft(2, '0')}';
    final primaryShiftCardsAsync = ref.watch(monthlyShiftCardsProvider(primaryYearMonth));

    // Secondary month (if week spans two months)
    final needsSecondMonth = startMonth != endMonth || startYear != endYear;
    final secondaryYearMonth = needsSecondMonth
        ? '$endYear-${endMonth.toString().padLeft(2, '0')}'
        : null;
    final secondaryShiftCardsAsync = secondaryYearMonth != null
        ? ref.watch(monthlyShiftCardsProvider(secondaryYearMonth))
        : null;

    // Today's month data for the header
    final todayYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final todayShiftCardsAsync = ref.watch(monthlyShiftCardsProvider(todayYearMonth));

    // Month view data (for expanded calendar)
    final monthlyShiftStatus = _getMonthlyShiftStatusFromCache();

    // Also check the primary week data to see if there are any shifts at all
    return primaryShiftCardsAsync.when(
      data: (primaryShiftCards) {
        return todayShiftCardsAsync.when(
          data: (todayShiftCards) {
            // Use findCurrentShiftWithChainInfo for unified UI/QR logic
            // Returns both the shift and whether it's part of an in-progress chain
            final result = ScheduleShiftFinder.findCurrentShiftWithChainInfo(todayShiftCards);
            final currentShift = result.shift;
            final isPartOfInProgressChain = result.isPartOfInProgressChain;

            // Only show upcoming if no current shift (findCurrentShift handles completed->upcoming transition)
            final upcomingShift = currentShift == null
                ? ScheduleShiftFinder.findClosestUpcomingShift(todayShiftCards)
                : null;

            // Merge both data sources to check if user has ANY shifts at all
            final allShifts = [...todayShiftCards, ...primaryShiftCards];
            final uniqueShifts = <String, ShiftCard>{};
            for (final shift in allShifts) {
              uniqueShifts[shift.shiftRequestId] = shift;
            }

            // If no shifts at all across all checked periods, show only empty state
            if (uniqueShifts.isEmpty) {
              return ScheduleEmptyState(
                stores: widget.stores,
                selectedStoreId: widget.selectedStoreId,
                onStoreChanged: widget.onStoreChanged,
                onGoToShiftSignUp: _goToShiftSignUpTab,
              );
            }

            // Build scrollable view with header and content
            return _buildScrollableView(
              currentShift: currentShift,
              upcomingShift: upcomingShift,
              isPartOfInProgressChain: isPartOfInProgressChain,
              weekRange: weekRange,
              primaryAsync: primaryShiftCardsAsync,
              secondaryAsync: secondaryShiftCardsAsync,
              monthlyShiftStatus: monthlyShiftStatus,
              shiftCards: primaryShiftCards,
            );
          },
          loading: () => const TossLoadingView(),
          error: (_, __) => ScheduleEmptyState(
            stores: widget.stores,
            selectedStoreId: widget.selectedStoreId,
            onStoreChanged: widget.onStoreChanged,
            onGoToShiftSignUp: _goToShiftSignUpTab,
          ),
        );
      },
      loading: () => const TossLoadingView(),
      error: (_, __) => ScheduleEmptyState(
        stores: widget.stores,
        selectedStoreId: widget.selectedStoreId,
        onStoreChanged: widget.onStoreChanged,
        onGoToShiftSignUp: _goToShiftSignUpTab,
      ),
    );
  }

  /// Build scrollable view - entire page scrolls including header
  Widget _buildScrollableView({
    required ShiftCard? currentShift,
    required ShiftCard? upcomingShift,
    required bool isPartOfInProgressChain,
    required DateTimeRange weekRange,
    required AsyncValue<List<ShiftCard>> primaryAsync,
    AsyncValue<List<ShiftCard>>? secondaryAsync,
    required List<MonthlyShiftStatus> monthlyShiftStatus,
    required List<ShiftCard> shiftCards,
  }) {
    // Build problem status map for week dates picker
    final problemStatusMap = _buildProblemStatusMap(shiftCards);
    final unsolvedCount = _countUnsolvedProblems(shiftCards);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Extra spacing above Store
          const SizedBox(height: TossSpacing.space4),

          // ============================================
          // Store Selector (only if more than 1 store)
          // ============================================
          if (widget.stores.length > 1)
            Container(
              color: TossColors.white,
              padding: const EdgeInsets.fromLTRB(TossSpacing.space4, TossSpacing.space3, TossSpacing.space4, 0),
              child: TossDropdown<String>(
                label: 'Store',
                value: widget.selectedStoreId,
                items: widget.stores.map((store) {
                  return TossDropdownItem<String>(
                    value: store['store_id']?.toString() ?? '',
                    label: store['store_name']?.toString() ?? 'Unknown',
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    widget.onStoreChanged?.call(newValue);
                  }
                },
              ),
            ),
          // ============================================
          // Section 1: Current/Upcoming Shift (white background)
          // ============================================
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.only(left: TossSpacing.space4, right: TossSpacing.space4, top: TossSpacing.space4, bottom: TossSpacing.space2),
            child: ScheduleHeader(
              cardKey: _todayShiftCardKey,
              todayShift: currentShift,
              upcomingShift: upcomingShift,
              isPartOfInProgressChain: isPartOfInProgressChain,
              onCheckIn: () => _navigateToQRScanner(),
              onCheckOut: () => _navigateToQRScanner(),
              onGoToShiftSignUp: _goToShiftSignUpTab,
              onReportIssue: () => _showReportIssueDialog(currentShift ?? upcomingShift),
            ),
          ),

          // ============================================
          // Toss-style section divider (gray background)
          // ============================================
          const GrayDividerSpace(),

          // ============================================
          // Section 2: Week/Month Calendar Management (white background)
          // ============================================
          Container(
            color: TossColors.white,
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Week/Month Navigation with calendar toggle button
                if (_isExpanded)
                  ScheduleMonthNavigation(
                    currentMonth: _currentMonth,
                    unsolvedCount: unsolvedCount,
                    onPrevMonth: () => _navigateMonth(-1),
                    onCurrentMonth: () => _navigateMonth(0),
                    onNextMonth: () => _navigateMonth(1),
                    onToggleExpanded: _toggleExpanded,
                  )
                else
                  ScheduleWeekNavigation(
                    weekRange: weekRange,
                    currentWeekOffset: _currentWeekOffset,
                    unsolvedCount: unsolvedCount,
                    onPrevWeek: () => _navigateWeek(-1),
                    onCurrentWeek: () => _navigateWeek(0),
                    onNextWeek: () => _navigateWeek(1),
                    onToggleExpanded: _toggleExpanded,
                  ),
                SizedBox(height: TossSpacing.space3),

                // Week Dates Picker or Month Calendar
                if (_isExpanded) ...[
                  // Month Calendar (when expanded) - uses same problem status logic
                  MonthDatesPicker(
                    selectedDate: _selectedDate,
                    currentMonth: _currentMonth,
                    problemStatusByDate: problemStatusMap,
                    onDateSelected: _handleDateSelected,
                  ),
                ] else ...[
                  // Week Dates Picker (default)
                  WeekDatesPicker(
                    selectedDate: _selectedDate,
                    weekStartDate: weekRange.start,
                    problemStatusMap: problemStatusMap,
                    onDateSelected: _handleDateSelected,
                  ),
                ],
                SizedBox(height: TossSpacing.space4),

                // Selected date shifts label
                Text(
                  'Shifts for ${DateFormat('EEE, d MMM').format(_selectedDate)}',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),

                // Shift list for selected date
                SelectedDateShiftList(
                  shiftCards: shiftCards,
                  selectedDate: _selectedDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build problem status map from shift cards
  /// Maps date string "yyyy-MM-dd" to ProblemStatus
  Map<String, ProblemStatus> _buildProblemStatusMap(List<ShiftCard> shiftCards) {
    final Map<String, ProblemStatus> statusMap = {};

    for (final card in shiftCards) {
      if (!card.isApproved) continue;

      // Parse shift date from shiftStartTime
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) continue;

      final dateKey = DateFormat('yyyy-MM-dd').format(startDateTime);
      final pd = card.problemDetails;

      // Determine status for this shift
      // Priority: solved (green) > reported (orange) > unsolved problem (red) > has shift (blue)
      // Logic flow:
      // 1. is_solved = true -> Green (all problems resolved)
      // 2. has_reported = true && is_solved = false -> Orange (reported, waiting)
      // 3. problem_count > 0 && is_solved = false -> Red (unsolved problem)
      // 4. No problems -> Blue (just has shift)
      ProblemStatus shiftStatus;
      if (pd != null && pd.isSolved && pd.problemCount > 0) {
        // All problems solved -> Green
        shiftStatus = ProblemStatus.solved;
      } else if (pd != null && pd.hasReported && !pd.isSolved) {
        // Reported but not solved yet -> Orange (waiting for manager review)
        shiftStatus = ProblemStatus.unsolvedReport;
      } else if (pd != null && pd.problemCount > 0 && !pd.isSolved) {
        // Has unsolved problems (not reported) -> Red
        shiftStatus = ProblemStatus.unsolvedProblem;
      } else {
        // Has shift, no problems -> Blue
        shiftStatus = ProblemStatus.hasShift;
      }

      // Keep highest priority status for the date
      // Priority: unsolvedProblem > unsolvedReport > solved > hasShift
      final existing = statusMap[dateKey];
      if (existing == null) {
        statusMap[dateKey] = shiftStatus;
      } else {
        // Compare priority
        final priorityOrder = [
          ProblemStatus.unsolvedProblem, // highest
          ProblemStatus.unsolvedReport,
          ProblemStatus.solved,
          ProblemStatus.hasShift, // lowest
        ];
        final existingPriority = priorityOrder.indexOf(existing);
        final newPriority = priorityOrder.indexOf(shiftStatus);
        if (newPriority < existingPriority) {
          statusMap[dateKey] = shiftStatus;
        }
      }
    }

    return statusMap;
  }

  /// Count unsolved problems (red status) from shift cards
  /// These are shifts with problems that haven't been reported or solved
  int _countUnsolvedProblems(List<ShiftCard> shiftCards) {
    int count = 0;
    for (final card in shiftCards) {
      if (!card.isApproved) continue;
      final pd = card.problemDetails;
      // Count shifts with unsolved problems (not reported, not solved)
      if (pd != null && pd.problemCount > 0 && !pd.isSolved && !pd.hasReported) {
        count++;
      }
    }
    return count;
  }
}
