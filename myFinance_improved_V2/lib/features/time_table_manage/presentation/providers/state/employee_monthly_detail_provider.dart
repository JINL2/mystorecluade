/// Employee Monthly Detail Provider
///
/// Manages employee monthly detail data for Employee Detail Page.
/// Includes shifts, audit logs, summary, and salary information.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../core/utils/retry_helper.dart';
import '../../../domain/entities/employee_monthly_detail.dart';
import '../repository_providers.dart';

// ============================================================================
// State Class
// ============================================================================

/// State for Employee Monthly Detail
class EmployeeMonthlyDetailState {
  final bool isLoading;
  final String? error;
  final Map<String, EmployeeMonthlyDetail> dataByMonth; // Key: 'userId_YYYY-MM'

  const EmployeeMonthlyDetailState({
    this.isLoading = false,
    this.error,
    this.dataByMonth = const {},
  });

  EmployeeMonthlyDetailState copyWith({
    bool? isLoading,
    String? error,
    Map<String, EmployeeMonthlyDetail>? dataByMonth,
  }) {
    return EmployeeMonthlyDetailState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      dataByMonth: dataByMonth ?? this.dataByMonth,
    );
  }

  /// Get data for a specific user and month
  EmployeeMonthlyDetail? getData(String userId, String yearMonth) {
    return dataByMonth['${userId}_$yearMonth'];
  }
}

// ============================================================================
// Notifier Class
// ============================================================================

/// Employee Monthly Detail Notifier
///
/// Features:
/// - User-month-based caching (key: userId_YYYY-MM)
/// - Debug logging for data loading
/// - Lazy loading with skip logic
class EmployeeMonthlyDetailNotifier
    extends StateNotifier<EmployeeMonthlyDetailState> {
  final Ref _ref;
  final String _companyId;
  final String _timezone;

  EmployeeMonthlyDetailNotifier(
    this._ref,
    this._companyId,
    this._timezone,
  ) : super(const EmployeeMonthlyDetailState());

  /// Load employee monthly detail
  ///
  /// Parameters:
  /// - [userId]: Employee user ID
  /// - [yearMonth]: Target month in 'YYYY-MM' format
  /// - [forceRefresh]: If true, reload even if already cached
  Future<EmployeeMonthlyDetail?> loadData({
    required String userId,
    required String yearMonth,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${userId}_$yearMonth';

    // 🔍 DEBUG: loadData called
    debugPrint('📥 [employeeMonthlyDetailProvider] loadData called - userId: $userId, yearMonth: $yearMonth');
    debugPrint('   📦 Current cache keys: ${state.dataByMonth.keys.toList()}');

    // Skip if already loaded (unless force refresh)
    if (!forceRefresh && state.dataByMonth.containsKey(cacheKey)) {
      debugPrint('   ✅ Using cached data for key: $cacheKey');
      return state.dataByMonth[cacheKey];
    }

    debugPrint('   🌐 Fetching from server...');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = _ref.read(timeTableRepositoryProvider);

      // ✅ Retry with exponential backoff (max 3 retries: 1s, 2s, 4s)
      final data = await RetryHelper.withRetry(
        () => repository.getEmployeeMonthlyDetailLog(
          userId: userId,
          companyId: _companyId,
          yearMonth: yearMonth,
          timezone: _timezone,
        ),
        config: RetryConfig.rpc,
        onRetry: (attempt, error) {
          debugPrint('   ⚠️ [employeeMonthlyDetailProvider] Retry $attempt for $cacheKey: $error');
        },
      );

      final newDataByMonth =
          Map<String, EmployeeMonthlyDetail>.from(state.dataByMonth);
      newDataByMonth[cacheKey] = data;

      state = state.copyWith(
        dataByMonth: newDataByMonth,
        isLoading: false,
      );

      debugPrint('   ✅ Data loaded successfully - shifts count: ${data.shifts.length}');
      return data;
    } catch (e) {
      debugPrint('   ❌ [employeeMonthlyDetailProvider] Failed after retries: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Clear data for a specific user and month
  void clearData(String userId, String yearMonth) {
    final cacheKey = '${userId}_$yearMonth';
    final newDataByMonth =
        Map<String, EmployeeMonthlyDetail>.from(state.dataByMonth);
    newDataByMonth.remove(cacheKey);
    state = state.copyWith(dataByMonth: newDataByMonth);
  }

  /// Clear all loaded data
  void clearAll() {
    debugPrint('🗑️ [employeeMonthlyDetailProvider] clearAll called - clearing ${state.dataByMonth.keys.length} entries');
    state = const EmployeeMonthlyDetailState();
  }

  /// Refresh data for a specific user and month
  Future<EmployeeMonthlyDetail?> refresh({
    required String userId,
    required String yearMonth,
  }) async {
    return loadData(userId: userId, yearMonth: yearMonth, forceRefresh: true);
  }
}

// ============================================================================
// Provider
// ============================================================================

/// Employee Monthly Detail Provider
///
/// Usage:
/// ```dart
/// final state = ref.watch(employeeMonthlyDetailProvider);
/// final notifier = ref.read(employeeMonthlyDetailProvider.notifier);
///
/// // Load data
/// await notifier.loadData(userId: '...', yearMonth: '2024-12');
///
/// // Get cached data
/// final data = state.getData(userId, '2024-12');
/// ```
final employeeMonthlyDetailProvider = StateNotifierProvider<
    EmployeeMonthlyDetailNotifier, EmployeeMonthlyDetailState>((ref) {
  // ✅ FIX: Use select to only rebuild when companyChoosen actually changes
  // Previously used ref.watch(appStateProvider) which caused rebuilds on ANY appState change
  // (e.g., storeChoosen, user data updates) leading to cache data loss
  final companyId = ref.watch(appStateProvider.select((s) => s.companyChoosen));
  final timezone = DateTimeUtils.getLocalTimezone();

  // 🔍 DEBUG: Provider being created/recreated
  debugPrint('🔄 [employeeMonthlyDetailProvider] CREATED - companyId: $companyId');

  return EmployeeMonthlyDetailNotifier(ref, companyId, timezone);
});

// ============================================================================
// Convenience Provider - Auto-loading
// ============================================================================

/// Parameters for employee monthly detail
class EmployeeMonthlyDetailParams {
  final String userId;
  final String yearMonth;

  const EmployeeMonthlyDetailParams({
    required this.userId,
    required this.yearMonth,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeMonthlyDetailParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          yearMonth == other.yearMonth;

  @override
  int get hashCode => userId.hashCode ^ yearMonth.hashCode;
}

/// Auto-loading provider for specific employee and month
///
/// Usage:
/// ```dart
/// final asyncData = ref.watch(employeeMonthlyDetailDataProvider(
///   EmployeeMonthlyDetailParams(userId: '...', yearMonth: '2024-12'),
/// ));
///
/// asyncData.when(
///   data: (detail) => ...,
///   loading: () => CircularProgressIndicator(),
///   error: (e, s) => Text('Error: $e'),
/// );
/// ```
final employeeMonthlyDetailDataProvider = FutureProvider.family<
    EmployeeMonthlyDetail?, EmployeeMonthlyDetailParams>((ref, params) async {
  final notifier = ref.read(employeeMonthlyDetailProvider.notifier);
  return notifier.loadData(
    userId: params.userId,
    yearMonth: params.yearMonth,
  );
});
