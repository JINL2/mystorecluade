/// Manager Overview Provider
///
/// Manages manager overview data (daily summaries and monthly stats).
/// Provides cached access to overview data by month.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../core/utils/retry_helper.dart';
import '../../../domain/entities/manager_overview.dart';
import '../../../domain/usecases/get_manager_overview.dart';
import '../states/time_table_state.dart';
import '../usecase/time_table_usecase_providers.dart';

part 'manager_overview_provider.g.dart';

/// Manager Overview Notifier
///
/// Features:
/// - Month-based caching
/// - Lazy loading
/// - Force refresh support
/// - Date range calculation (first day to last day of month)
@riverpod
class ManagerOverviewNotifier extends _$ManagerOverviewNotifier {
  late final GetManagerOverview _getManagerOverviewUseCase;
  late final String _companyId;
  late final String _storeId;
  late final String _timezone;

  @override
  ManagerOverviewState build(String storeId) {
    _getManagerOverviewUseCase = ref.watch(getManagerOverviewUseCaseProvider);
    // Use select to only rebuild when companyChoosen actually changes
    _companyId = ref.watch(appStateProvider.select((s) => s.companyChoosen));
    _storeId = storeId;
    // Use device local timezone instead of user DB timezone
    _timezone = DateTimeUtils.getLocalTimezone();

    return const ManagerOverviewState();
  }

  /// Check if notifier is still active
  bool get _isMounted {
    try {
      // Access state to check if notifier is still active
      // ignore: unnecessary_statements
      state;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Safely update state - avoids "setState during build" errors
  /// by deferring state updates if called during widget build phase
  void _safeSetState(ManagerOverviewState newState) {
    if (!_isMounted) return;

    // Check if we're in the middle of a build phase
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks) {
      // Defer state update to after the current frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_isMounted) {
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

      _safeSetState(
        state.copyWith(
          dataByMonth: newDataByMonth,
          isLoading: false,
        ),
      );
    } catch (e) {
      debugPrint('   ❌ [managerOverviewProvider] Failed after retries: $e');
      _safeSetState(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
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

/// @deprecated Use [managerOverviewNotifierProvider] instead.
/// This alias is kept for backward compatibility during migration.
@Deprecated('Use managerOverviewNotifierProvider instead')
const managerOverviewProvider = managerOverviewNotifierProvider;
