/// Manager Overview Provider
///
/// Manages manager overview data (daily summaries and monthly stats).
/// Provides cached access to overview data by month.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../core/utils/retry_helper.dart';
import '../../../domain/entities/manager_overview.dart';
import '../../../domain/usecases/get_manager_overview.dart';
import '../states/time_table_state.dart';
import '../usecase/time_table_usecase_providers.dart';

/// Manager Overview Notifier
///
/// Features:
/// - Month-based caching
/// - Lazy loading
/// - Force refresh support
/// - Date range calculation (first day to last day of month)
class ManagerOverviewNotifier extends StateNotifier<ManagerOverviewState> {
  final GetManagerOverview _getManagerOverviewUseCase;
  final String _companyId;
  final String _storeId;
  final String _timezone;

  ManagerOverviewNotifier(
    this._getManagerOverviewUseCase,
    this._companyId,
    this._storeId,
    this._timezone,
  ) : super(const ManagerOverviewState());

  /// Safely update state - avoids "setState during build" errors
  /// by deferring state updates if called during widget build phase
  void _safeSetState(ManagerOverviewState newState) {
    if (!mounted) return;

    // Check if we're in the middle of a build phase
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks) {
      // Defer state update to after the current frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          state = newState;
        }
      });
    } else {
      state = newState;
    }
  }

  /// Load manager overview for a specific month
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
    if (!forceRefresh && state.dataByMonth.containsKey(monthKey)) {
      return;
    }

    debugPrint('📥 [managerOverviewProvider] loadMonth - monthKey: $monthKey');
    _safeSetState(state.copyWith(isLoading: true, error: null));

    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);

      final startDate = '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
      final endDate = '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';

      // ✅ Retry with exponential backoff (max 3 retries: 1s, 2s, 4s)
      final data = await RetryHelper.withRetry(
        () => _getManagerOverviewUseCase(
          GetManagerOverviewParams(
            startDate: startDate,
            endDate: endDate,
            companyId: _companyId,
            storeId: _storeId,
            timezone: _timezone,
          ),
        ),
        config: RetryConfig.rpc,
        onRetry: (attempt, error) {
          debugPrint('   ⚠️ [managerOverviewProvider] Retry $attempt for $monthKey: $error');
        },
      );

      final newDataByMonth = Map<String, ManagerOverview>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      _safeSetState(state.copyWith(
        dataByMonth: newDataByMonth,
        isLoading: false,
      ));
    } catch (e) {
      debugPrint('   ❌ [managerOverviewProvider] Failed after retries: $e');
      _safeSetState(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Get data for a specific month
  ManagerOverview? getMonthData(DateTime month) {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return state.dataByMonth[monthKey];
  }

  /// Clear all loaded data
  void clearAll() {
    _safeSetState(const ManagerOverviewState());
  }
}

/// Manager Overview Provider
///
/// Usage:
/// ```dart
/// final overview = ref.watch(managerOverviewProvider(storeId));
/// await overview.notifier.loadMonth(month: DateTime.now());
/// final monthData = overview.notifier.getMonthData(DateTime.now());
/// ```
final managerOverviewProvider = StateNotifierProvider.family<
    ManagerOverviewNotifier,
    ManagerOverviewState,
    String>((ref, storeId) {
  final useCase = ref.watch(getManagerOverviewUseCaseProvider);
  // ✅ FIX: Use select to only rebuild when companyChoosen actually changes
  // Previously used ref.watch(appStateProvider) which caused rebuilds on ANY appState change
  final companyId = ref.watch(appStateProvider.select((s) => s.companyChoosen));
  // Use device local timezone instead of user DB timezone
  final timezone = DateTimeUtils.getLocalTimezone();

  return ManagerOverviewNotifier(useCase, companyId, storeId, timezone);
});
