import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/shift_metadata.dart';
import '../providers/attendance_providers.dart';
import 'dialogs/shift_detail_dialog.dart';
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

  DateTimeRange get _weekRange => _getWeekRange(_currentWeek);

  // Date calculation helpers
  DateTimeRange _getWeekRange(DateTime date) {
    final weekday = date.weekday; // 1=Mon, 7=Sun
    final monday = date.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateTimeRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

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

  // Find today's shift from the shift cards list
  // Only returns approved shifts
  // Handles night shifts: checks if today matches start_date OR end_date
  // When multiple shifts match today, returns the one closest to current time
  ShiftCard? _findTodayShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // First filter: collect all shifts that match today (start_date OR end_date)
    final todayShifts = <ShiftCard>[];

    for (final card in shiftCards) {
      // Only consider approved shifts
      if (!card.isApproved) continue;

      // Parse start and end datetime to check both dates (for night shifts)
      final startDateTime = _parseShiftDateTime(card.shiftStartTime);
      final endDateTime = _parseShiftDateTime(card.shiftEndTime);

      if (startDateTime == null || endDateTime == null) continue;

      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      final endDate = DateTime(endDateTime.year, endDateTime.month, endDateTime.day);

      // Check if today matches start_date OR end_date (for night shifts)
      if (_isSameDay(startDate, today) || _isSameDay(endDate, today)) {
        todayShifts.add(card);
      }
    }

    if (todayShifts.isEmpty) return null;
    if (todayShifts.length == 1) return todayShifts.first;

    // Second filter: find the shift closest to current time
    // Priority: ongoing shift > upcoming shift > past shift (closest to now)
    ShiftCard? closestShift;
    Duration? closestDuration;

    for (final card in todayShifts) {
      final startDateTime = _parseShiftDateTime(card.shiftStartTime)!;
      final endDateTime = _parseShiftDateTime(card.shiftEndTime)!;

      // Check if currently in progress (now is between start and end)
      if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
        // Ongoing shift has highest priority
        // If multiple ongoing shifts, return the one that started most recently
        if (closestShift == null) {
          closestShift = card;
          closestDuration = Duration.zero; // Mark as ongoing
        } else if (closestDuration == Duration.zero) {
          // Both are ongoing, pick the one that started later (more recent)
          final existingStart = _parseShiftDateTime(closestShift.shiftStartTime)!;
          if (startDateTime.isAfter(existingStart)) {
            closestShift = card;
          }
        }
        continue;
      }

      // Skip if we already have an ongoing shift
      if (closestDuration == Duration.zero) continue;

      // Calculate time distance from now
      Duration distance;
      if (now.isBefore(startDateTime)) {
        // Upcoming shift: distance to start time
        distance = startDateTime.difference(now);
      } else {
        // Past shift: distance from end time
        distance = now.difference(endDateTime);
      }

      if (closestDuration == null || distance < closestDuration) {
        closestDuration = distance;
        closestShift = card;
      }
    }

    return closestShift;
  }

  // Find the closest upcoming shift from actual data
  // Returns the specific ShiftCard (not just date) to handle multiple shifts on same day
  // Uses shift_start_time/shift_end_time instead of request_date
  ShiftCard? _findClosestUpcomingShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    ShiftCard? closestShift;
    DateTime? closestDateTime;

    for (final card in shiftCards) {
      // Only consider approved shifts that haven't started
      if (!card.isApproved || card.actualStartTime != null) continue;

      // Parse start and end datetime
      final startDateTime = _parseShiftDateTime(card.shiftStartTime);
      final endDateTime = _parseShiftDateTime(card.shiftEndTime);
      if (startDateTime == null || endDateTime == null) continue;

      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      final endDate = DateTime(endDateTime.year, endDateTime.month, endDateTime.day);

      // Skip if this is today's shift (start_date or end_date matches today)
      // This function only finds FUTURE shifts, not today's
      if (_isSameDay(startDate, today) || _isSameDay(endDate, today)) continue;

      // Only consider future shifts (start_date is after today)
      if (startDate.isAfter(today)) {
        if (closestDateTime == null || startDateTime.isBefore(closestDateTime)) {
          closestDateTime = startDateTime;
          closestShift = card;
        }
      }
    }

    return closestShift;
  }

  // Parse shift datetime from ISO format string (e.g., "2025-06-01T14:00:00")
  DateTime? _parseShiftDateTime(String dateTimeStr) {
    try {
      if (dateTimeStr.contains('T')) {
        return DateTime.parse(dateTimeStr);
      }
      if (dateTimeStr.contains(' ')) {
        return DateTime.parse(dateTimeStr.replaceFirst(' ', 'T'));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Determine ShiftCardStatus from ShiftCard data
  ShiftCardStatus _determineStatus(ShiftCard card, DateTime cardDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Future shift (hasn't come yet)
    if (cardDate.isAfter(today)) {
      return ShiftCardStatus.upcoming;
    }

    // Past or today's shift
    if (card.actualStartTime != null && card.actualEndTime != null) {
      // Check-in and check-out completed
      return card.isLate ? ShiftCardStatus.late : ShiftCardStatus.onTime;
    }

    if (card.actualStartTime != null && card.actualEndTime == null) {
      // Currently working (checked in but not out)
      return ShiftCardStatus.inProgress;
    }

    // Past date but no check-in
    if (cardDate.isBefore(today)) {
      return ShiftCardStatus.undone;
    }

    return ShiftCardStatus.upcoming;
  }

  // Format time range from shiftStartTime and shiftEndTime
  // (e.g., "2025-06-01T14:00:00", "2025-06-01T18:00:00" -> "2:00 PM - 6:00 PM")
  String _formatTimeRangeFromDateTime(String shiftStartTime, String shiftEndTime) {
    try {
      final startDateTime = _parseShiftDateTime(shiftStartTime);
      final endDateTime = _parseShiftDateTime(shiftEndTime);
      if (startDateTime == null || endDateTime == null) return '--:-- - --:--';

      final startTimeStr = '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';

      final formattedStart = _formatTime(startTimeStr);
      final formattedEnd = _formatTime(endTimeStr);
      return '$formattedStart - $formattedEnd';
    } catch (e) {
      return '--:-- - --:--';
    }
  }

  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24;
    }
  }

  // Navigate to QR Scanner for check-in/check-out
  // QR code contains store_id which will be used for update_shift_requests_v6 RPC
  // Works regardless of whether user has a shift today (for night shift workers)
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

  // Extract shift type from shiftStartTime (Morning/Afternoon/Evening based on start hour)
  String _extractShiftTypeFromDateTime(String shiftStartTime) {
    try {
      final startDateTime = _parseShiftDateTime(shiftStartTime);
      if (startDateTime == null) return 'Shift';

      final startHour = startDateTime.hour;
      if (startHour < 12) return 'Morning';
      if (startHour < 17) return 'Afternoon';
      return 'Evening';
    } catch (e) {
      return 'Shift';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _viewMode == ViewMode.week
        ? _buildWeekView()
        : _buildMonthView();
  }

  Widget _buildWeekView() {
    final weekRange = _weekRange;
    // Use year-month string key to prevent infinite rebuilds
    final yearMonth = '${_currentWeek.year}-${_currentWeek.month.toString().padLeft(2, '0')}';
    final shiftCardsAsync = ref.watch(monthlyShiftCardsProvider(yearMonth));

    // Also get today's month data for the header (in case current week is different month)
    final now = DateTime.now();
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
              final todayShift = _findTodayShift(todayShiftCards);
              final upcomingShift = todayShift == null ? _findClosestUpcomingShift(todayShiftCards) : null;
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
            child: shiftCardsAsync.when(
              data: (shiftCards) {
                final result = _buildWeekShiftsWithIndex(weekRange, shiftCards);
                return ScheduleWeekView(
                  currentWeek: _currentWeek,
                  weekOffset: _currentWeekOffset,
                  shifts: result.shifts,
                  closestUpcomingIndex: result.closestUpcomingIndex,
                  onNavigate: _navigateWeek,
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
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
      // Use addPostFrameCallback to avoid calling setState during build
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
              final todayShift = _findTodayShift(todayShiftCards);
              final upcomingShift = todayShift == null ? _findClosestUpcomingShift(todayShiftCards) : null;
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
                shiftsInMonth: _buildShiftsInMonth(shiftCards),
                userApprovedDates: _buildUserApprovedDates(),
                dayShifts: _buildDayShifts(_selectedDate, shiftCards),
                onNavigate: _navigateMonth,
                onDateSelected: _handleDateSelected,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build week shifts from real data
  // Returns (shifts, closestUpcomingIndex) for auto-scroll functionality
  // Uses shift_start_time instead of request_date for filtering and display
  ({List<Widget> shifts, int? closestUpcomingIndex}) _buildWeekShiftsWithIndex(
    DateTimeRange weekRange,
    List<ShiftCard> shiftCards,
  ) {
    final shifts = <Widget>[];
    final closestUpcomingShift = _findClosestUpcomingShift(shiftCards);
    int? closestUpcomingIndex;

    // Filter shifts within the week range and approved only
    // Use shift_start_time for date filtering
    final weekShifts = shiftCards.where((card) {
      final startDateTime = _parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) return false;
      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      // Only show approved shifts
      if (!card.isApproved) return false;
      return !startDate.isBefore(weekRange.start) && !startDate.isAfter(weekRange.end);
    }).toList();

    // Sort by date and time
    weekShifts.sort((a, b) {
      final dateTimeA = _parseShiftDateTime(a.shiftStartTime);
      final dateTimeB = _parseShiftDateTime(b.shiftStartTime);
      if (dateTimeA == null || dateTimeB == null) return 0;
      return dateTimeA.compareTo(dateTimeB);
    });

    for (int i = 0; i < weekShifts.length; i++) {
      final card = weekShifts[i];
      final startDateTime = _parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) continue;
      final cardDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

      final dayName = DateFormat.E().format(cardDate);
      final dayNumber = cardDate.day;
      final shiftType = _extractShiftTypeFromDateTime(card.shiftStartTime);
      final timeRange = _formatTimeRangeFromDateTime(card.shiftStartTime, card.shiftEndTime);
      final status = _determineStatus(card, cardDate);
      // Compare by ShiftCard identity (shiftRequestId) instead of just date
      final isClosest = closestUpcomingShift != null && card.shiftRequestId == closestUpcomingShift.shiftRequestId;

      // Track the index of closest upcoming shift for auto-scroll
      if (isClosest) {
        closestUpcomingIndex = shifts.length; // Current index in the shifts list
      }

      shifts.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TossWeekShiftCard(
            date: '$dayName $dayNumber',
            shiftType: shiftType,
            timeRange: timeRange,
            status: status,
            isClosestUpcoming: isClosest,
            onTap: () {
              ShiftDetailDialog.show(
                context,
                shiftCard: card,
              );
            },
          ),
        ),
      );
    }

    return (shifts: shifts, closestUpcomingIndex: closestUpcomingIndex);
  }

  /// Build shifts map for calendar display
  /// Returns Map<DateTime, bool> where:
  /// - true = has available slots (blue dot)
  /// - false = all shifts full (gray dot)
  /// - no entry = no shifts defined for that date (no dot)
  Map<DateTime, bool> _buildShiftsInMonth(List<ShiftCard> shiftCards) {
    // If no shift metadata, we can't show availability dots
    if (_shiftMetadata == null || _shiftMetadata!.isEmpty) {
      return {};
    }

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Map<DateTime, bool> shifts = {};

    // Build a map of date -> MonthlyShiftStatus for quick lookup
    final Map<String, MonthlyShiftStatus> statusByDate = {};
    if (_monthlyShiftStatus != null) {
      for (final dayStatus in _monthlyShiftStatus!) {
        statusByDate[dayStatus.requestDate] = dayStatus;
      }
    }

    // Get active shifts from metadata
    final activeShifts = _shiftMetadata!.where((s) => s.isActive).toList();
    if (activeShifts.isEmpty) return {};

    // Get the number of days in the current month
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    // Iterate through all dates in the current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Only show dots for dates from today onwards
      if (normalizedDate.isBefore(todayNormalized)) {
        continue;
      }

      // Format date to match monthlyShiftStatus format (yyyy-MM-dd)
      final dateString =
          '${normalizedDate.year}-${normalizedDate.month.toString().padLeft(2, '0')}-${normalizedDate.day.toString().padLeft(2, '0')}';

      // Check if we have status data for this date
      final dayStatus = statusByDate[dateString];

      // Total active shifts from metadata
      final totalShiftsFromMetadata = activeShifts.length;

      if (dayStatus != null && dayStatus.shifts.isNotEmpty) {
        // We have RPC data - but it may not include all shifts
        // RPC only returns shifts that have at least one applicant
        final shiftsInRpc = dayStatus.shifts.length;

        // Shifts not in RPC response = no applicants = available
        final shiftsNotInRpc = totalShiftsFromMetadata - shiftsInRpc;

        // If there are shifts not in RPC, they are available
        // If any shift in RPC has available slots, it's available
        // Only gray if ALL shifts are full
        final hasAvailableSlots = shiftsNotInRpc > 0 ||
            dayStatus.shifts.any((s) => s.hasAvailableSlots);

        shifts[normalizedDate] = hasAvailableSlots;
      } else {
        // No status data - shifts exist (from shiftMetadata) but no one has applied yet
        // This means all slots are available (blue dot)
        shifts[normalizedDate] = true;
      }
    }

    return shifts;
  }

  /// Build user approved dates set for calendar display (blue border)
  /// Returns Set<DateTime> of dates where current user has approved shifts
  Set<DateTime> _buildUserApprovedDates() {
    if (_monthlyShiftStatus == null || _monthlyShiftStatus!.isEmpty) {
      return {};
    }

    final appState = ref.read(appStateProvider);
    final currentUserId = appState.userId;

    if (currentUserId.isEmpty) return {};

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Set<DateTime> userApprovedDates = {};

    for (final dayStatus in _monthlyShiftStatus!) {
      try {
        final date = DateTime.parse(dayStatus.requestDate);
        final normalizedDate = DateTime(date.year, date.month, date.day);

        // Only for dates from today onwards in the current month
        if (normalizedDate.isBefore(todayNormalized)) continue;
        if (normalizedDate.year != _currentMonth.year ||
            normalizedDate.month != _currentMonth.month) continue;

        // Check if current user has any approved shift on this date
        for (final shift in dayStatus.shifts) {
          if (shift.approvedEmployees.any((emp) => emp.userId == currentUserId)) {
            userApprovedDates.add(normalizedDate);
            break;
          }
        }
      } catch (_) {
        // Error parsing date
      }
    }

    return userApprovedDates;
  }

  // Build day shifts for selected date
  // Uses shift_start_time instead of request_date for filtering
  List<Widget> _buildDayShifts(DateTime date, List<ShiftCard> shiftCards) {
    final shifts = <Widget>[];
    final closestUpcomingShift = _findClosestUpcomingShift(shiftCards);

    // Filter shifts for the selected date and approved only
    // Use shift_start_time for date filtering
    final dayShifts = shiftCards.where((card) {
      final startDateTime = _parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) return false;
      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      // Only show approved shifts
      if (!card.isApproved) return false;
      return _isSameDay(startDate, date);
    }).toList();

    // Sort by start time
    dayShifts.sort((a, b) {
      final dateTimeA = _parseShiftDateTime(a.shiftStartTime);
      final dateTimeB = _parseShiftDateTime(b.shiftStartTime);
      if (dateTimeA == null || dateTimeB == null) return 0;
      return dateTimeA.compareTo(dateTimeB);
    });

    if (dayShifts.isEmpty) {
      shifts.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No shifts scheduled for this day',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        ),
      );
      return shifts;
    }

    for (final card in dayShifts) {
      final startDateTime = _parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) continue;
      final cardDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

      final dayName = DateFormat.E().format(cardDate);
      final dayNumber = cardDate.day;
      final shiftType = _extractShiftTypeFromDateTime(card.shiftStartTime);
      final timeRange = _formatTimeRangeFromDateTime(card.shiftStartTime, card.shiftEndTime);
      final status = _determineStatus(card, cardDate);
      // Compare by ShiftCard identity (shiftRequestId) instead of just date
      final isClosest = closestUpcomingShift != null && card.shiftRequestId == closestUpcomingShift.shiftRequestId;

      shifts.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TossWeekShiftCard(
            date: '$dayName $dayNumber',
            shiftType: shiftType,
            timeRange: timeRange,
            status: status,
            isClosestUpcoming: isClosest,
            onTap: () {
              ShiftDetailDialog.show(
                context,
                shiftCard: card,
              );
            },
          ),
        ),
      );
    }

    return shifts;
  }
}
