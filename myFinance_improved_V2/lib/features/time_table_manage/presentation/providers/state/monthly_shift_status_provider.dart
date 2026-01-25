/// Monthly Shift Status Provider
///
/// Manages monthly shift status data with caching per month.
/// Loads data from RPC and caches results to avoid redundant API calls.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../core/utils/retry_helper.dart';
import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/usecases/get_monthly_shift_status.dart';
import '../states/time_table_state.dart';
import '../usecase/time_table_usecase_providers.dart';

part 'monthly_shift_status_provider.g.dart';

/// Monthly Shift Status Notifier
///
/// Features:
/// - Lazy loading per month
/// - Caching to prevent redundant API calls
/// - Force refresh capability
/// - Multi-month support (RPC returns current + next month)
@riverpod
class MonthlyShiftStatusNotifier extends _$MonthlyShiftStatusNotifier {
  late final String _storeId;

  @override
  MonthlyShiftStatusState build(String storeId) {
    _storeId = storeId;
    return const MonthlyShiftStatusState();
  }

  /// Get the UseCase from ref
  GetMonthlyShiftStatus get _getMonthlyShiftStatusUseCase =>
      ref.read(getMonthlyShiftStatusUseCaseProvider);

  /// Get company ID from app state
  String get _companyId =>
      ref.read(appStateProvider.select((s) => s.companyChoosen));

  /// Safely update state - avoids "setState during build" errors
  /// by deferring state updates if called during widget build phase
  void _safeSetState(MonthlyShiftStatusState newState) {
    // Check if we're in the middle of a build phase
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks) {
      // Defer state update to after the current frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        state = newState;
      });
    } else {
      state = newState;
    }
  }

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

    _safeSetState(state.copyWith(isLoading: true, error: null));

    try {
      // Create DateTime for first day of month
      final firstDayOfMonth = DateTime(month.year, month.month, 1);

      // Format as ISO 8601 with timezone offset (user's local time)
      final requestTime = DateTimeUtils.toLocalWithOffset(firstDayOfMonth);

      // Get user's local timezone
      final timezone = DateTimeUtils.getLocalTimezone();

      // ✅ Retry with exponential backoff (max 3 retries: 1s, 2s, 4s)
      final data = await RetryHelper.withRetry(
        () => _getMonthlyShiftStatusUseCase(
          GetMonthlyShiftStatusParams(
            requestTime: requestTime,
            companyId: _companyId,
            storeId: _storeId,
            timezone: timezone,
          ),
        ),
        config: RetryConfig.rpc,
        onRetry: (attempt, error) {
          debugPrint('   ⚠️ [monthlyShiftStatusProvider] Retry $attempt for $monthKey: $error');
        },
      );

      // Update state with new data
      debugPrint('   ✅ RPC SUCCESS - received ${data.length} MonthlyShiftStatus items');

      // Log pending requests count for debugging
      int totalPending = 0;
      for (final status in data) {
        for (final daily in status.dailyShifts) {
          for (final shift in daily.shifts) {
            totalPending += shift.pendingRequests.length;
          }
        }
      }
      debugPrint('   📊 Total pending requests in response: $totalPending');

      final newDataByMonth = Map<String, List<MonthlyShiftStatus>>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      final newLoadedMonths = Set<String>.from(state.loadedMonths);
      newLoadedMonths.add(monthKey);

      // Also mark next month as loaded if RPC returns 2 months
      final nextMonth = DateTime(month.year, month.month + 1);
      final nextMonthKey =
          '${nextMonth.year}-${nextMonth.month.toString().padLeft(2, '0')}';
      newLoadedMonths.add(nextMonthKey);

      _safeSetState(
        state.copyWith(
          dataByMonth: newDataByMonth,
          loadedMonths: newLoadedMonths,
          isLoading: false,
        ),
      );
      debugPrint('   ✅ State updated - loadedMonths: $newLoadedMonths');
    } catch (e) {
      debugPrint('   ❌ [monthlyShiftStatusProvider] Failed after retries: $e');
      _safeSetState(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
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
    _safeSetState(const MonthlyShiftStatusState());
  }

  /// Partial Update: Update a single shift request's approval status
  ///
  /// Instead of reloading all data, this method updates only the affected
  /// shift request in the cached state. This is much more efficient than
  /// calling loadMonth(forceRefresh: true) after every approve/remove action.
  ///
  /// Parameters:
  /// - [shiftRequestId]: The ID of the shift request to update
  /// - [isApproved]: The new approval status
  /// - [shiftDate]: The date of the shift (yyyy-MM-dd format) for finding the correct month
  void updateShiftRequestApproval({
    required String shiftRequestId,
    required bool isApproved,
    required String shiftDate,
  }) {

    // Parse month from shiftDate (yyyy-MM-dd)
    final parts = shiftDate.split('-');
    if (parts.length < 2) return;
    final monthKey = '${parts[0]}-${parts[1]}';

    // Get current month data
    final monthData = state.dataByMonth[monthKey];
    if (monthData == null || monthData.isEmpty) return;

    // Update the data
    final updatedMonthData = monthData.map((monthlyStatus) {
      final updatedDailyShifts = monthlyStatus.dailyShifts.map((dailyData) {
        if (dailyData.date != shiftDate) return dailyData;

        // Update shifts for this date
        final updatedShifts = dailyData.shifts.map((shiftWithReqs) {
          // Find the request in pending or approved lists
          final pendingIndex = shiftWithReqs.pendingRequests.indexWhere(
            (req) => req.shiftRequestId == shiftRequestId,
          );
          final approvedIndex = shiftWithReqs.approvedRequests.indexWhere(
            (req) => req.shiftRequestId == shiftRequestId,
          );

          if (pendingIndex == -1 && approvedIndex == -1) {
            return shiftWithReqs; // Request not found in this shift
          }

          // Move request between lists based on new approval status
          final newPendingRequests = List.of(shiftWithReqs.pendingRequests);
          final newApprovedRequests = List.of(shiftWithReqs.approvedRequests);

          if (isApproved && pendingIndex != -1) {
            // Move from pending to approved
            final request = newPendingRequests.removeAt(pendingIndex);
            newApprovedRequests.add(
              request.copyWith(
                isApproved: true,
                approvedAt: DateTime.now(),
              ),
            );
          } else if (!isApproved && approvedIndex != -1) {
            // Move from approved to pending
            final request = newApprovedRequests.removeAt(approvedIndex);
            newPendingRequests.add(
              request.copyWith(
                isApproved: false,
                approvedAt: null,
              ),
            );
          }

          return ShiftWithRequests(
            shift: shiftWithReqs.shift,
            pendingRequests: newPendingRequests,
            approvedRequests: newApprovedRequests,
          );
        }).toList();

        return DailyShiftData(date: dailyData.date, shifts: updatedShifts);
      }).toList();

      return MonthlyShiftStatus(
        month: monthlyStatus.month,
        dailyShifts: updatedDailyShifts,
        statistics: monthlyStatus.statistics,
      );
    }).toList();

    // Update state
    final newDataByMonth = Map<String, List<MonthlyShiftStatus>>.from(state.dataByMonth);
    newDataByMonth[monthKey] = updatedMonthData;

    _safeSetState(state.copyWith(dataByMonth: newDataByMonth));
  }
}

/// Legacy Monthly Shift Status Provider (deprecated alias)
///
/// @deprecated Use monthlyShiftStatusNotifierProvider instead.
/// This alias is kept for backward compatibility during migration.
///
/// Usage (new):
/// ```dart
/// final state = ref.watch(monthlyShiftStatusNotifierProvider(storeId));
/// ref.read(monthlyShiftStatusNotifierProvider(storeId).notifier).loadMonth(month: DateTime.now());
/// ```
@Deprecated('Use monthlyShiftStatusNotifierProvider instead')
const monthlyShiftStatusProvider = monthlyShiftStatusNotifierProvider;
