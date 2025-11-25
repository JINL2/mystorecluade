/// Monthly Shift Status Provider
///
/// Manages monthly shift status data with caching per month.
/// Loads data from RPC and caches results to avoid redundant API calls.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/usecases/get_monthly_shift_status.dart';
import '../states/time_table_state.dart';
import '../usecase/time_table_usecase_providers.dart';

/// Monthly Shift Status Notifier
///
/// Features:
/// - Lazy loading per month
/// - Caching to prevent redundant API calls
/// - Force refresh capability
/// - Multi-month support (RPC returns current + next month)
class MonthlyShiftStatusNotifier
    extends StateNotifier<MonthlyShiftStatusState> {
  final GetMonthlyShiftStatus _getMonthlyShiftStatusUseCase;
  final String _companyId;
  final String _storeId;

  MonthlyShiftStatusNotifier(
    this._getMonthlyShiftStatusUseCase,
    this._companyId,
    this._storeId,
  ) : super(const MonthlyShiftStatusState());

  /// Load monthly shift status for a specific month
  ///
  /// Parameters:
  /// - [month]: Target month to load
  /// - [forceRefresh]: If true, reload even if already cached
  Future<void> loadMonth({
    required DateTime month,
    bool forceRefresh = false,
  }) async {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';

    // Skip if already loaded (unless force refresh)
    if (!forceRefresh && state.loadedMonths.contains(monthKey)) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Format as first day of month with time (UTC timestamp)
      final requestTime =
          '${month.year}-${month.month.toString().padLeft(2, '0')}-01 00:00:00';

      // Get user's local timezone
      final timezone = DateTimeUtils.getLocalTimezone();

      final data = await _getMonthlyShiftStatusUseCase(
        GetMonthlyShiftStatusParams(
          requestTime: requestTime,
          companyId: _companyId,
          storeId: _storeId,
          timezone: timezone,
        ),
      );

      // Update state with new data
      final newDataByMonth = Map<String, List<MonthlyShiftStatus>>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      final newLoadedMonths = Set<String>.from(state.loadedMonths);
      newLoadedMonths.add(monthKey);

      // Also mark next month as loaded if RPC returns 2 months
      final nextMonth = DateTime(month.year, month.month + 1);
      final nextMonthKey =
          '${nextMonth.year}-${nextMonth.month.toString().padLeft(2, '0')}';
      newLoadedMonths.add(nextMonthKey);

      state = state.copyWith(
        dataByMonth: newDataByMonth,
        loadedMonths: newLoadedMonths,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get data for a specific month
  List<MonthlyShiftStatus>? getMonthData(DateTime month) {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return state.dataByMonth[monthKey];
  }

  /// Clear all loaded data
  void clearAll() {
    state = const MonthlyShiftStatusState();
  }
}

/// Monthly Shift Status Provider
///
/// Usage:
/// ```dart
/// final statusNotifier = ref.watch(monthlyShiftStatusProvider(storeId));
/// await statusNotifier.notifier.loadMonth(month: DateTime.now());
/// final monthData = statusNotifier.notifier.getMonthData(DateTime.now());
/// ```
final monthlyShiftStatusProvider = StateNotifierProvider.family<
    MonthlyShiftStatusNotifier,
    MonthlyShiftStatusState,
    String>((ref, storeId) {
  final useCase = ref.watch(getMonthlyShiftStatusUseCaseProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  return MonthlyShiftStatusNotifier(useCase, companyId, storeId);
});
