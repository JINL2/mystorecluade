import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../app/providers/auth_providers.dart';
import '../../../../domain/entities/shift_card.dart';
import '../../../../domain/entities/shift_overview.dart';
import '../../../providers/attendance_providers.dart';

/// Controller for AttendanceContent state and business logic
class AttendanceContentController {
  final WidgetRef ref;

  // Cache for monthly overview data - key is "yyyy-MM" format
  final Map<String, Map<String, dynamic>> _monthlyOverviewCache = {};

  // Cache for monthly cards data - key is "yyyy-MM" format
  final Map<String, List<Map<String, dynamic>>> _monthlyCardsCache = {};

  // Track which months have been loaded
  final Set<String> _loadedMonths = {};

  // ALL shift cards data accumulated across all loaded months
  List<Map<String, dynamic>> allShiftCardsData = [];

  // Current displayed month overview
  Map<String, dynamic>? shiftOverviewData;

  String? currentDisplayedMonth;

  AttendanceContentController(this.ref);

  /// Format shift time range from shiftStartTime and shiftEndTime
  /// e.g., "2025-06-01T14:00:00", "2025-06-01T18:00:00" -> "14:00 ~ 18:00"
  String _formatShiftTimeRange(String shiftStartTime, String shiftEndTime) {
    try {
      if (shiftStartTime.isEmpty || shiftEndTime.isEmpty) {
        return '--:-- ~ --:--';
      }
      final startDateTime = DateTime.parse(shiftStartTime);
      final endDateTime = DateTime.parse(shiftEndTime);
      final startStr = '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';
      final endStr = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';
      return '$startStr ~ $endStr';
    } catch (e) {
      return '--:-- ~ --:--';
    }
  }

  /// Get filtered cards for current view
  List<Map<String, dynamic>> get shiftCardsData => allShiftCardsData;

  /// Fetch month data with caching
  Future<Map<String, dynamic>> fetchMonthData(
    DateTime targetDate, {
    bool forceRefresh = false,
  }) async {
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';

    // Check cache
    bool hasOverview = _monthlyOverviewCache.containsKey(monthKey);
    bool hasCards = _monthlyCardsCache.containsKey(monthKey);

    if (hasOverview && hasCards && !forceRefresh) {
      // Return cached data
      shiftOverviewData = _monthlyOverviewCache[monthKey];
      currentDisplayedMonth = monthKey;

      // Rebuild allShiftCardsData from cached data
      _rebuildAllShiftCardsData();

      return {
        'success': true,
        'fromCache': true,
        'shiftStatus': _calculateShiftStatus(monthKey),
      };
    }

    // Fetch fresh data
    try {
      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      final appState = ref.read(appStateProvider);

      final getShiftOverview = ref.read(getShiftOverviewProvider);
      final getUserShiftCards = ref.read(getUserShiftCardsProvider);

      final userId = user?.id;
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (userId == null || companyId.isEmpty || storeId.isEmpty) {
        return {
          'success': false,
          'error': 'Please select a company and store',
        };
      }

      // Calculate last day of month for RPC
      final lastDayOfMonth = DateTime(targetDate.year, targetDate.month + 1, 0);
      final requestTime = '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')} 23:59:59';
      final timezone = 'Asia/Seoul'; // TODO: Get from user settings

      // Parallel API calls
      final overviewFuture = getShiftOverview(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      final cardsFuture = getUserShiftCards(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      final results = await Future.wait<dynamic>([
        overviewFuture,
        cardsFuture,
      ]);

      // Convert entities to maps
      final overviewEntity = results[0] as ShiftOverview;
      final overviewResponse = {
        'request_month': overviewEntity.requestMonth,
        'actual_work_days': overviewEntity.actualWorkDays,
        'actual_work_hours': overviewEntity.actualWorkHours,
        'estimated_salary': overviewEntity.estimatedSalary,
        'currency_symbol': overviewEntity.currencySymbol,
        'salary_amount': overviewEntity.salaryAmount,
        'salary_type': overviewEntity.salaryType,
        'late_deduction_total': overviewEntity.lateDeductionTotal,
        'overtime_total': overviewEntity.overtimeTotal,
        'salary_stores': overviewEntity.salaryStores.map((s) => {
          'store_id': s.storeId,
          'store_name': s.storeName,
          'estimated_salary': s.estimatedSalary,
        }).toList(),
      };
      final cardsEntityList = results[1] as List<ShiftCard>;
      final cardsResponse = cardsEntityList.map((card) => card.toJson()).toList();

      // Cache the data
      _monthlyOverviewCache[monthKey] = overviewResponse;
      _monthlyCardsCache[monthKey] = List<Map<String, dynamic>>.from(cardsResponse);
      _loadedMonths.add(monthKey);

      // Update current state
      shiftOverviewData = overviewResponse;
      currentDisplayedMonth = monthKey;

      // Rebuild all cards data
      _rebuildAllShiftCardsData();

      return {
        'success': true,
        'fromCache': false,
        'shiftStatus': _calculateShiftStatus(monthKey),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error loading data: ${e.toString()}',
      };
    }
  }

  /// Rebuild allShiftCardsData from all cached months
  void _rebuildAllShiftCardsData() {
    allShiftCardsData.clear();

    for (final cachedMonth in _monthlyCardsCache.keys) {
      final monthCards = _monthlyCardsCache[cachedMonth]!;
      allShiftCardsData.addAll(monthCards);
    }

    // Sort by date (descending)
    allShiftCardsData.sort((a, b) {
      final dateA = (a['request_date'] ?? '') as String;
      final dateB = (b['request_date'] ?? '') as String;
      return dateB.compareTo(dateA);
    });
  }

  /// Calculate shift status for current month
  String _calculateShiftStatus(String monthKey) {
    final now = DateTime.now();
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    if (monthKey != currentMonthKey) {
      return 'off_duty';
    }

    // Check today's shifts
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final todayShifts = allShiftCardsData.where((card) => card['request_date'] == todayStr).toList();

    if (todayShifts.isEmpty) {
      return 'off_duty';
    }

    // Filter approved shifts
    final approvedShifts = todayShifts.where((shift) =>
      shift['is_approved'] == true || shift['approval_status'] == 'approved',
    ).toList();

    if (approvedShifts.isEmpty) {
      return 'scheduled';
    }

    // Check working status
    bool isCurrentlyWorking = approvedShifts.any((shift) =>
      shift['confirm_start_time'] != null && shift['confirm_end_time'] == null,
    );

    bool allApprovedShiftsFinished = approvedShifts.every((shift) =>
      shift['confirm_start_time'] != null && shift['confirm_end_time'] != null,
    );

    bool anyApprovedShiftStarted = approvedShifts.any((shift) =>
      shift['confirm_start_time'] != null,
    );

    if (isCurrentlyWorking) {
      return 'working';
    } else if (allApprovedShiftsFinished && anyApprovedShiftStarted) {
      return 'finished';
    } else {
      return 'scheduled';
    }
  }

  /// Update local state after QR scan
  void updateLocalStateAfterQRScan(Map<String, dynamic> scanResult) {
    final requestDate = scanResult['request_date'] ?? '';
    final action = scanResult['action'] ?? '';
    final timestamp = scanResult['timestamp'] ?? DateTime.now().toUtc().toIso8601String();

    final existingCardIndex = allShiftCardsData.indexWhere((card) {
      return card['request_date'] == requestDate;
    });

    if (existingCardIndex != -1) {
      final existingCard = allShiftCardsData[existingCardIndex];

      if (action == 'check_in') {
        existingCard['actual_start_time'] = timestamp;
        existingCard['confirm_start_time'] = timestamp;
        existingCard['actual_end_time'] = null;
        existingCard['confirm_end_time'] = null;
      } else if (action == 'check_out') {
        existingCard['actual_end_time'] = timestamp;
        existingCard['confirm_end_time'] = timestamp;
      }

      allShiftCardsData[existingCardIndex] = existingCard;
    } else {
      // Create new card
      final newCard = {
        'request_date': requestDate,
        'shift_request_id': scanResult['shift_request_id'] ?? '',
        'shift_name': scanResult['shift_name'] ?? 'Shift',
        'shift_start_time': scanResult['shift_start_time'] ?? '09:00:00',
        'shift_end_time': scanResult['shift_end_time'] ?? '18:00:00',
        'is_approved': true,
        'actual_start_time': action == 'check_in' ? timestamp : null,
        'confirm_start_time': action == 'check_in' ? timestamp : null,
        'actual_end_time': action == 'check_out' ? timestamp : null,
        'confirm_end_time': action == 'check_out' ? timestamp : null,
      };

      allShiftCardsData.add(newCard);
    }
  }

  /// Clear all caches
  void clearCaches() {
    allShiftCardsData.clear();
    _monthlyOverviewCache.clear();
    _monthlyCardsCache.clear();
    _loadedMonths.clear();
  }

  /// Get week schedule for center date
  List<Map<String, dynamic>> getWeekSchedule(DateTime centerDate) {
    List<Map<String, dynamic>> schedule = [];

    for (int i = -3; i <= 3; i++) {
      final date = centerDate.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final shiftsForDate = allShiftCardsData.where(
        (card) => card['request_date'] == dateStr,
      ).toList();

      if (shiftsForDate.isNotEmpty) {
        final shiftCard = shiftsForDate.first;
        // Format shift time from shift_start_time and shift_end_time
        final shiftTime = _formatShiftTimeRange(
          shiftCard['shift_start_time']?.toString() ?? '',
          shiftCard['shift_end_time']?.toString() ?? '',
        );
        final actualStart = shiftCard['confirm_start_time'];
        final actualEnd = shiftCard['confirm_end_time'];

        final hasApprovedShift = shiftsForDate.any((card) {
          final isApproved = card['is_approved'];
          final approvalStatus = card['approval_status'];
          return (isApproved == true) || (approvalStatus == 'approved');
        });

        final hasNonApprovedShift = shiftsForDate.any((card) {
          final isApproved = card['is_approved'];
          final approvalStatus = card['approval_status'];
          return (isApproved != true) && (approvalStatus != 'approved');
        });

        schedule.add({
          'date': date,
          'hasShift': true,
          'shiftCount': shiftsForDate.length,
          'worked': actualStart != null,
          'hasApprovedShift': hasApprovedShift,
          'hasNonApprovedShift': hasNonApprovedShift,
          'shift': shiftTime,
          'actualStart': actualStart,
          'actualEnd': actualEnd,
          'lateMinutes': shiftCard['late_minutes'] ?? 0,
          'overtimeMinutes': shiftCard['overtime_minutes'] ?? 0,
          'allShifts': shiftsForDate,
        });
      } else {
        schedule.add({
          'date': date,
          'hasShift': false,
          'worked': false,
          'hasApprovedShift': false,
          'hasNonApprovedShift': false,
          'shift': '',
        });
      }
    }

    return schedule;
  }
}
