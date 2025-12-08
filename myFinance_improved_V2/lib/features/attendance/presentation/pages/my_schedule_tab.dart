import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/shift_metadata.dart';
import '../providers/attendance_providers.dart';
import 'utils/schedule_date_utils.dart';
import 'utils/schedule_month_builder.dart';
import 'utils/schedule_shift_finder.dart';
import 'utils/schedule_week_builder.dart';
import 'widgets/schedule_header.dart';
import 'widgets/schedule_month_view.dart';
import 'widgets/schedule_week_view.dart';

export 'widgets/schedule_header.dart' show ViewMode;

/// MyScheduleTab - Main tab with Week/Month view switching
///
/// Features:
/// - Segmented control to switch between Week and Month views
/// - Featured "Today's Shift" card
/// - Week view: Week navigation + shift list
/// - Month view: Month navigation + calendar + filtered shift list
class MyScheduleTab extends ConsumerStatefulWidget {
  final TabController? tabController;

  const MyScheduleTab({super.key, this.tabController});

  @override
  ConsumerState<MyScheduleTab> createState() => _MyScheduleTabState();
}

class _MyScheduleTabState extends ConsumerState<MyScheduleTab> {
  // View mode state
  ViewMode _viewMode = ViewMode.week;

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
      final metadata = await getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      if (mounted) {
        setState(() {
          _shiftMetadata = metadata;
          _isLoadingMetadata = false;
        });
      }
    } catch (e) {
      debugPrint('[MyScheduleTab] _fetchShiftMetadataIfNeeded ERROR: $e');
      _isLoadingMetadata = false;
    }
  }

  /// Fetch monthly shift status with caching
  /// Only calls RPC if data for the month is not already cached
  Future<void> _fetchMonthlyShiftStatusIfNeeded(DateTime date) async {
    final monthKey = _getMonthKey(date);
    debugPrint('[MyScheduleTab] _fetchMonthlyShiftStatusIfNeeded called for monthKey: $monthKey');

    // Check if already cached
    if (_monthlyShiftStatusCache.containsKey(monthKey)) {
      debugPrint('[MyScheduleTab] Cache HIT for month: $monthKey');
      return;
    }

    // Check if already loading
    if (_loadingMonths.contains(monthKey)) {
      debugPrint('[MyScheduleTab] Already loading month: $monthKey, skipping');
      return;
    }

    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    if (storeId.isEmpty || companyId.isEmpty) return;

    debugPrint('[MyScheduleTab] Cache MISS for month: $monthKey, calling RPC...');
    _loadingMonths.add(monthKey);

    try {
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final targetDate = DateTime(date.year, date.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      final result = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      debugPrint('[MyScheduleTab] RPC completed for month: $monthKey, got ${result.length} records');

      if (mounted) {
        // Cache the result by month
        final monthData = result.where((r) {
          if (r.requestDate.length >= 7) {
            return r.requestDate.substring(0, 7) == monthKey;
          }
          return false;
        }).toList();

        _monthlyShiftStatusCache[monthKey] = monthData;
        debugPrint('[MyScheduleTab] Cached ${monthData.length} records for month: $monthKey');

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
          debugPrint('[MyScheduleTab] Also cached ${entry.value.length} records for month: ${entry.key}');
        }

        setState(() {});
      }
    } catch (e) {
      debugPrint('[MyScheduleTab] _fetchMonthlyShiftStatusIfNeeded ERROR: $e');
    } finally {
      _loadingMonths.remove(monthKey);
    }
  }

  /// Fetch shift metadata and monthly shift status for Month view calendar indicators
  Future<void> _fetchMonthViewData() async {
    final yearMonth = _getMonthKey(_currentMonth);
    debugPrint('[MyScheduleTab] _fetchMonthViewData called for month: $yearMonth');

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

      // Also refresh the week view if applicable
      if (_viewMode == ViewMode.week) {
        final weekYearMonth = '${_currentWeek.year}-${_currentWeek.month.toString().padLeft(2, '0')}';
        if (weekYearMonth != currentYearMonth) {
          ref.invalidate(monthlyShiftCardsProvider(weekYearMonth));
        }
      }

      // Refresh month view if applicable
      if (_viewMode == ViewMode.month) {
        final monthYearMonth = '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';
        if (monthYearMonth != currentYearMonth) {
          ref.invalidate(monthlyShiftCardsProvider(monthYearMonth));
        }
      }

      // Also invalidate previous month (for night shift edge cases)
      final prevMonth = DateTime(now.year, now.month - 1, 1);
      final prevYearMonth = '${prevMonth.year}-${prevMonth.month.toString().padLeft(2, '0')}';
      ref.invalidate(monthlyShiftCardsProvider(prevYearMonth));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _viewMode == ViewMode.week ? _buildWeekView() : _buildMonthView();
  }

  Widget _buildWeekView() {
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

    // Also check the primary week data to see if there are any shifts at all
    return primaryShiftCardsAsync.when(
      data: (primaryShiftCards) {
        return todayShiftCardsAsync.when(
          data: (todayShiftCards) {
            final todayShift = ScheduleShiftFinder.findTodayShift(todayShiftCards);
            final upcomingShift = todayShift == null
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
              return _buildEmptyStateOnly();
            }

            // Otherwise show normal UI
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScheduleHeader(
                    cardKey: _todayShiftCardKey,
                    viewMode: _viewMode,
                    todayShift: todayShift,
                    upcomingShift: upcomingShift,
                    onCheckIn: () => _navigateToQRScanner(),
                    onCheckOut: () => _navigateToQRScanner(),
                    onGoToShiftSignUp: _goToShiftSignUpTab,
                    onViewModeChanged: (mode) {
                      setState(() => _viewMode = mode);
                    },
                  ),
                  Expanded(
                    child: _buildWeekShiftsList(
                      weekRange: weekRange,
                      primaryAsync: primaryShiftCardsAsync,
                      secondaryAsync: secondaryShiftCardsAsync,
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildEmptyStateOnly(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _buildEmptyStateOnly(),
    );
  }

  Widget _buildMonthView() {
    // Use year-month string key to prevent infinite rebuilds
    final yearMonth = _getMonthKey(_currentMonth);
    final shiftCardsAsync = ref.watch(monthlyShiftCardsProvider(yearMonth));

    // Also get today's month data for the header (in case current month is different)
    final now = DateTime.now();
    final todayYearMonth = _getMonthKey(now);
    final todayShiftCardsAsync = ref.watch(monthlyShiftCardsProvider(todayYearMonth));

    // Get monthly shift status from cache for calendar indicators
    final monthlyShiftStatus = _getMonthlyShiftStatusFromCache();

    // Trigger fetch of month view data if not already cached
    if (!_monthlyShiftStatusCache.containsKey(yearMonth) && !_loadingMonths.contains(yearMonth)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchMonthViewData();
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Common Header (Today's Shift Card + Toggle) - Fixed
          todayShiftCardsAsync.when(
            data: (todayShiftCards) {
              final todayShift = ScheduleShiftFinder.findTodayShift(todayShiftCards);
              final upcomingShift = todayShift == null
                  ? ScheduleShiftFinder.findClosestUpcomingShift(todayShiftCards)
                  : null;
              return ScheduleHeader(
                cardKey: _todayShiftCardKey,
                viewMode: _viewMode,
                todayShift: todayShift,
                upcomingShift: upcomingShift,
                onCheckIn: () => _navigateToQRScanner(),
                onCheckOut: () => _navigateToQRScanner(),
                onGoToShiftSignUp: _goToShiftSignUpTab,
                onViewModeChanged: (mode) {
                  setState(() => _viewMode = mode);
                },
              );
            },
            loading: () => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: null,
              onCheckIn: () => _navigateToQRScanner(),
              onCheckOut: () => _navigateToQRScanner(),
              onGoToShiftSignUp: _goToShiftSignUpTab,
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),
            error: (_, __) => ScheduleHeader(
              cardKey: _todayShiftCardKey,
              viewMode: _viewMode,
              todayShift: null,
              onCheckIn: () => _navigateToQRScanner(),
              onCheckOut: () => _navigateToQRScanner(),
              onGoToShiftSignUp: _goToShiftSignUpTab,
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),
          ),

          // Month View (contains scrollable shift list)
          Expanded(
            child: shiftCardsAsync.when(
              data: (shiftCards) => ScheduleMonthView(
                currentMonth: _currentMonth,
                selectedDate: _selectedDate,
                monthOffset: _currentMonthOffset,
                shiftsInMonth: ScheduleMonthBuilder.buildShiftsInMonth(
                  currentMonth: _currentMonth,
                  shiftMetadata: _shiftMetadata,
                  monthlyShiftStatus: monthlyShiftStatus,
                ),
                userApprovedDates: ScheduleMonthBuilder.buildUserApprovedDates(
                  currentMonth: _currentMonth,
                  monthlyShiftStatus: monthlyShiftStatus,
                  currentUserId: ref.read(appStateProvider).userId,
                ),
                dayShifts: ScheduleMonthBuilder.buildDayShifts(
                  context,
                  _selectedDate,
                  shiftCards,
                ),
                onNavigate: _navigateMonth,
                onDateSelected: _handleDateSelected,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state only (no header, no navigation)
  Widget _buildEmptyStateOnly() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: TossColors.gray400,
            size: 48,
          ),
          SizedBox(height: TossSpacing.space3),
          Text(
            'You have no shift',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TossSpacing.space1),
          TextButton(
            onPressed: _goToShiftSignUpTab,
            child: Text(
              'Go to shift sign up',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build week shifts list widget
  /// Handles merging data from two months when week spans across month boundary
  Widget _buildWeekShiftsList({
    required DateTimeRange weekRange,
    required AsyncValue<List<ShiftCard>> primaryAsync,
    AsyncValue<List<ShiftCard>>? secondaryAsync,
  }) {
    // If no secondary month needed, just use primary
    if (secondaryAsync == null) {
      return primaryAsync.when(
        data: (shiftCards) {
          final result = ScheduleWeekBuilder.buildWeekShiftsWithIndex(
            context,
            weekRange,
            shiftCards,
          );
          return ScheduleWeekView(
            currentWeek: _currentWeek,
            weekOffset: _currentWeekOffset,
            shifts: result.shifts,
            closestUpcomingIndex: result.closestUpcomingIndex,
            onNavigate: _navigateWeek,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      );
    }

    // Need to merge data from two months
    return primaryAsync.when(
      data: (primaryCards) {
        return secondaryAsync.when(
          data: (secondaryCards) {
            // Merge and deduplicate by shiftRequestId
            final mergedCards = ScheduleShiftFinder.mergeShiftCards(primaryCards, secondaryCards);
            final result = ScheduleWeekBuilder.buildWeekShiftsWithIndex(
              context,
              weekRange,
              mergedCards,
            );
            return ScheduleWeekView(
              currentWeek: _currentWeek,
              weekOffset: _currentWeekOffset,
              shifts: result.shifts,
              closestUpcomingIndex: result.closestUpcomingIndex,
              onNavigate: _navigateWeek,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
