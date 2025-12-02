import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
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
  const MyScheduleTab({super.key});

  @override
  ConsumerState<MyScheduleTab> createState() => _MyScheduleTabState();
}

class _MyScheduleTabState extends ConsumerState<MyScheduleTab> {
  // View mode state
  ViewMode _viewMode = ViewMode.week;

  // Navigation state
  int _currentWeekOffset = 0; // 0 = current week, -1 = prev, +1 = next
  int _currentMonthOffset = 0; // 0 = current month, -1 = prev, +1 = next

  // Selection state (for Month view)
  DateTime _selectedDate = DateTime.now();

  // GlobalKey to measure Today's shift card height
  final GlobalKey _todayShiftCardKey = GlobalKey();

  // Month view data state
  List<MonthlyShiftStatus>? _monthlyShiftStatus;
  List<ShiftMetadata>? _shiftMetadata;
  bool _isLoadingMonthData = false;
  String? _loadedMonthKey; // Track which month data is loaded for

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

  /// Fetch shift metadata and monthly shift status for Month view calendar indicators
  Future<void> _fetchMonthViewData() async {
    final yearMonth = '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';

    // Skip if already loading or already loaded for this month
    if (_isLoadingMonthData || _loadedMonthKey == yearMonth) {
      return;
    }

    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    if (storeId.isEmpty || companyId.isEmpty) return;

    setState(() {
      _isLoadingMonthData = true;
    });

    try {
      // Fetch shift metadata
      final getShiftMetadata = ref.read(getShiftMetadataProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final metadata = await getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      // Fetch monthly shift status
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);
      final targetDate = DateTime(_currentMonth.year, _currentMonth.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      final status = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      if (mounted) {
        setState(() {
          _shiftMetadata = metadata;
          _monthlyShiftStatus = status;
          _loadedMonthKey = yearMonth;
          _isLoadingMonthData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMonthData = false;
        });
      }
    }
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
              onViewModeChanged: (mode) {
                setState(() => _viewMode = mode);
              },
            ),
          ),

          // Week View (contains scrollable shift list)
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
  }

  Widget _buildMonthView() {
    // Use year-month string key to prevent infinite rebuilds
    final yearMonth = '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}';
    final shiftCardsAsync = ref.watch(monthlyShiftCardsProvider(yearMonth));

    // Also get today's month data for the header (in case current month is different)
    final now = DateTime.now();
    final todayYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final todayShiftCardsAsync = ref.watch(monthlyShiftCardsProvider(todayYearMonth));

    // Trigger fetch of month view data if not already loaded
    if (_loadedMonthKey != yearMonth && !_isLoadingMonthData) {
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
                  monthlyShiftStatus: _monthlyShiftStatus,
                ),
                userApprovedDates: ScheduleMonthBuilder.buildUserApprovedDates(
                  currentMonth: _currentMonth,
                  monthlyShiftStatus: _monthlyShiftStatus,
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
