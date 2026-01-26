import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/monitoring/sentry_config.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../providers/attendance_providers.dart';

/// Schedule Month Data Controller
///
/// Handles month view data fetching and caching for MyScheduleTab:
/// - Shift metadata loading (once per store)
/// - Monthly shift status caching (per month)
///
/// This separates data management logic from the UI widget,
/// reducing MyScheduleTab complexity.
class ScheduleMonthDataController extends ChangeNotifier {
  final WidgetRef _ref;

  // Month view data state - Map-based caching for multiple months
  final Map<String, List<MonthlyShiftStatus>> _monthlyShiftStatusCache = {};
  final Set<String> _loadingMonths = {};
  List<ShiftMetadata>? _shiftMetadata;
  bool _isLoadingMetadata = false;

  ScheduleMonthDataController(this._ref);

  /// Get cached shift metadata
  List<ShiftMetadata>? get shiftMetadata => _shiftMetadata;

  /// Check if metadata is loading
  bool get isLoadingMetadata => _isLoadingMetadata;

  /// Get month key in "YYYY-MM" format
  String getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  /// Get combined monthly shift status from cache
  List<MonthlyShiftStatus> getMonthlyShiftStatusFromCache() {
    final allData = <MonthlyShiftStatus>[];
    for (final entry in _monthlyShiftStatusCache.entries) {
      allData.addAll(entry.value);
    }
    return allData;
  }

  /// Check if month data is cached
  bool isMonthCached(DateTime date) {
    return _monthlyShiftStatusCache.containsKey(getMonthKey(date));
  }

  /// Check if month is currently loading
  bool isMonthLoading(DateTime date) {
    return _loadingMonths.contains(getMonthKey(date));
  }

  /// Fetch shift metadata (only once, doesn't change per month)
  Future<void> fetchShiftMetadataIfNeeded() async {
    if (_shiftMetadata != null || _isLoadingMetadata) return;

    final appState = _ref.read(appStateProvider);
    final storeId = appState.storeChoosen;

    if (storeId.isEmpty) return;

    _isLoadingMetadata = true;
    notifyListeners();

    try {
      final getShiftMetadata = _ref.read(getShiftMetadataProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final result = await getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      // Either pattern: fold to handle success/failure
      result.fold(
        (failure) {
          _shiftMetadata = [];
          _isLoadingMetadata = false;
          notifyListeners();
        },
        (data) {
          _shiftMetadata = data;
          _isLoadingMetadata = false;
          notifyListeners();
        },
      );
    } catch (e, stackTrace) {
      _isLoadingMetadata = false;
      notifyListeners();
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'ScheduleMonthDataController.fetchShiftMetadataIfNeeded failed',
      );
    }
  }

  /// Fetch monthly shift status with caching
  /// Only calls RPC if data for the month is not already cached
  Future<void> fetchMonthlyShiftStatusIfNeeded(DateTime date) async {
    final monthKey = getMonthKey(date);

    // Check if already cached
    if (_monthlyShiftStatusCache.containsKey(monthKey)) {
      return;
    }

    // Check if already loading
    if (_loadingMonths.contains(monthKey)) {
      return;
    }

    final appState = _ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    if (storeId.isEmpty || companyId.isEmpty) return;

    _loadingMonths.add(monthKey);
    notifyListeners();

    try {
      final getMonthlyShiftStatus = _ref.read(getMonthlyShiftStatusProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final targetDate = DateTime(date.year, date.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      final eitherResult = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      // Either pattern: fold to handle success/failure
      eitherResult.fold(
        (failure) {
          // On failure, cache empty list to avoid repeated calls
          _monthlyShiftStatusCache[monthKey] = [];
          notifyListeners();
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
              if (rMonth != monthKey &&
                  !_monthlyShiftStatusCache.containsKey(rMonth)) {
                otherMonths.putIfAbsent(rMonth, () => []).add(r);
              }
            }
          }
          for (final entry in otherMonths.entries) {
            _monthlyShiftStatusCache[entry.key] = entry.value;
          }

          notifyListeners();
        },
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'ScheduleMonthDataController.fetchMonthlyShiftStatusIfNeeded failed',
        extra: {'monthKey': monthKey},
      );
    } finally {
      _loadingMonths.remove(monthKey);
      notifyListeners();
    }
  }

  /// Fetch both shift metadata and monthly shift status for Month view
  Future<void> fetchMonthViewData(DateTime currentMonth) async {
    await fetchShiftMetadataIfNeeded();
    await fetchMonthlyShiftStatusIfNeeded(currentMonth);
  }

  /// Clear all cached data (useful when store changes)
  void clearCache() {
    _monthlyShiftStatusCache.clear();
    _shiftMetadata = null;
    _isLoadingMetadata = false;
    _loadingMonths.clear();
    notifyListeners();
  }
}
