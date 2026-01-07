/// Monthly Shift Status Provider
///
/// Manages monthly shift status data with caching per month.
/// Loads data from RPC and caches results to avoid redundant API calls.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../core/utils/retry_helper.dart';
import '../../../domain/entities/daily_shift_data.dart';
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

  /// Safely update state - avoids "setState during build" errors
  /// by deferring state updates if called during widget build phase
  void _safeSetState(MonthlyShiftStatusState newState) {
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

      _safeSetState(state.copyWith(
        dataByMonth: newDataByMonth,
        loadedMonths: newLoadedMonths,
        isLoading: false,
      ));
      debugPrint('   ✅ State updated - loadedMonths: $newLoadedMonths');
    } catch (e) {
      debugPrint('   ❌ [monthlyShiftStatusProvider] Failed after retries: $e');
      _safeSetState(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Get data for a specific month
  List<MonthlyShiftStatus>? getMonthData(DateTime month) {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return state.dataByMonth[monthKey];
  }

  /// Clear all loaded data
  void clearAll() {
    if (!mounted) return;
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
    if (!mounted) return;

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
            newApprovedRequests.add(request.copyWith(
              isApproved: true,
              approvedAt: DateTime.now(),
            ));
          } else if (!isApproved && approvedIndex != -1) {
            // Move from approved to pending
            final request = newApprovedRequests.removeAt(approvedIndex);
            newPendingRequests.add(request.copyWith(
              isApproved: false,
              approvedAt: null,
            ));
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
  // ✅ FIX: Use select to only rebuild when companyChoosen actually changes
  // Previously used ref.watch(appStateProvider) which caused rebuilds on ANY appState change
  final companyId = ref.watch(appStateProvider.select((s) => s.companyChoosen));

  return MonthlyShiftStatusNotifier(useCase, companyId, storeId);
});
