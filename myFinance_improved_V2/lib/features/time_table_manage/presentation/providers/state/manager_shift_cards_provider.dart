/// Manager Shift Cards Provider
///
/// Manages shift cards data (approved and pending cards).
/// Provides month-based caching with debug logging.
library;

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/manager_shift_cards.dart';
import '../../../domain/entities/problem_details.dart';
import '../../../domain/usecases/get_manager_shift_cards.dart';
import '../states/time_table_state.dart';
import '../usecase/time_table_usecase_providers.dart';

/// Manager Shift Cards Notifier
///
/// Features:
/// - Month-based caching
/// - Debug logging for data loading
/// - Selective month clearing
/// - Lazy loading with skip logic
class ManagerShiftCardsNotifier extends StateNotifier<ManagerShiftCardsState> {
  final GetManagerShiftCards _getManagerShiftCardsUseCase;
  final String _companyId;
  final String _storeId;
  final String _timezone;

  ManagerShiftCardsNotifier(
    this._getManagerShiftCardsUseCase,
    this._companyId,
    this._storeId,
    this._timezone,
  ) : super(const ManagerShiftCardsState());

  /// Safely update state - avoids "setState during build" errors
  /// by deferring state updates if called during widget build phase
  void _safeSetState(ManagerShiftCardsState newState) {
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

  /// Load manager shift cards for a specific month
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

    _safeSetState(state.copyWith(isLoading: true, error: null));

    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);

      final startDate = '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
      final endDate = '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';

      final data = await _getManagerShiftCardsUseCase(
        GetManagerShiftCardsParams(
          startDate: startDate,
          endDate: endDate,
          companyId: _companyId,
          storeId: _storeId,
          timezone: _timezone,
        ),
      );

      final newDataByMonth = Map<String, ManagerShiftCards>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      _safeSetState(state.copyWith(
        dataByMonth: newDataByMonth,
        isLoading: false,
      ));
    } catch (e) {
      _safeSetState(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Clear data for a specific month
  void clearMonth(String monthKey) {
    final newDataByMonth = Map<String, ManagerShiftCards>.from(state.dataByMonth);
    newDataByMonth.remove(monthKey);
    _safeSetState(state.copyWith(dataByMonth: newDataByMonth));
  }

  /// Clear all loaded data
  void clearAll() {
    _safeSetState(const ManagerShiftCardsState());
  }

  /// Partial Update: Update a single card's approval status
  ///
  /// Instead of reloading all data, this method updates only the affected
  /// card in the cached state. This is much more efficient than calling
  /// loadMonth(forceRefresh: true) after every approve/remove action.
  ///
  /// Parameters:
  /// - [shiftRequestId]: The ID of the shift request to update
  /// - [isApproved]: The new approval status
  /// - [shiftDate]: The date of the shift (yyyy-MM-dd format) for finding the correct month
  void updateCardApproval({
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
    if (monthData == null) return;

    // Find and update the card
    final updatedCards = monthData.cards.map((card) {
      if (card.shiftRequestId == shiftRequestId) {
        return card.copyWith(isApproved: isApproved);
      }
      return card;
    }).toList();

    // Update state with modified cards
    final updatedMonthData = monthData.copyWith(cards: updatedCards);
    final newDataByMonth = Map<String, ManagerShiftCards>.from(state.dataByMonth);
    newDataByMonth[monthKey] = updatedMonthData;

    _safeSetState(state.copyWith(dataByMonth: newDataByMonth));
  }

  /// Partial Update: Update a single card's problem data after save
  ///
  /// Called after StaffTimelogDetailPage saves changes via inputCardV5.
  /// Updates the cached card with new problem data without RPC call.
  ///
  /// Parameters:
  /// - [shiftRequestId]: The ID of the shift request to update
  /// - [shiftDate]: The date of the shift (yyyy-MM-dd format)
  /// - [isProblemSolved]: Whether problems are now solved (optional)
  /// - [isReportedSolved]: Whether report is solved (optional)
  /// - [confirmedStartTime]: New confirmed start time (optional)
  /// - [confirmedEndTime]: New confirmed end time (optional)
  /// - [bonusAmount]: New bonus amount (optional)
  void updateCardProblemData({
    required String shiftRequestId,
    required String shiftDate,
    bool? isProblemSolved,
    bool? isReportedSolved,
    String? confirmedStartTime,
    String? confirmedEndTime,
    double? bonusAmount,
  }) {
    if (!mounted) return;

    // Parse month from shiftDate (yyyy-MM-dd)
    final parts = shiftDate.split('-');
    if (parts.length < 2) return;
    final monthKey = '${parts[0]}-${parts[1]}';

    // Get current month data
    final monthData = state.dataByMonth[monthKey];
    if (monthData == null) return;

    // Find and update the card
    final updatedCards = monthData.cards.map((card) {
      if (card.shiftRequestId == shiftRequestId) {
        // Build updated problem details
        var updatedProblemDetails = card.problemDetails;

        if (updatedProblemDetails != null && (isProblemSolved == true || isReportedSolved != null)) {
          // Update individual problem items' isSolved status
          final updatedProblems = updatedProblemDetails.problems.map((problem) {
            if (isProblemSolved == true && problem.type != 'reported') {
              // Mark non-report problems as solved
              return ProblemItem(
                type: problem.type,
                actualMinutes: problem.actualMinutes,
                payrollMinutes: problem.payrollMinutes,
                isPayrollAdjusted: problem.isPayrollAdjusted,
                reason: problem.reason,
                reportedAt: problem.reportedAt,
                isSolved: true,
              );
            } else if (isReportedSolved != null && problem.type == 'reported') {
              // Update report solved status
              return ProblemItem(
                type: problem.type,
                actualMinutes: problem.actualMinutes,
                payrollMinutes: problem.payrollMinutes,
                isPayrollAdjusted: problem.isPayrollAdjusted,
                reason: problem.reason,
                reportedAt: problem.reportedAt,
                isSolved: isReportedSolved,
              );
            }
            return problem;
          }).toList();

          // Check if all problems are now solved
          final allSolved = updatedProblems.every((p) => p.isSolved);

          updatedProblemDetails = ProblemDetails(
            hasLate: updatedProblemDetails.hasLate,
            hasOvertime: updatedProblemDetails.hasOvertime,
            hasReported: updatedProblemDetails.hasReported,
            hasNoCheckout: updatedProblemDetails.hasNoCheckout,
            hasAbsence: updatedProblemDetails.hasAbsence,
            hasEarlyLeave: updatedProblemDetails.hasEarlyLeave,
            hasLocationIssue: updatedProblemDetails.hasLocationIssue,
            hasPayrollLate: updatedProblemDetails.hasPayrollLate,
            hasPayrollOvertime: updatedProblemDetails.hasPayrollOvertime,
            hasPayrollEarlyLeave: updatedProblemDetails.hasPayrollEarlyLeave,
            problemCount: updatedProblemDetails.problemCount,
            isSolved: allSolved,
            detectedAt: updatedProblemDetails.detectedAt,
            problems: updatedProblems,
          );
        }

        return card.copyWith(
          problemDetails: updatedProblemDetails,
          confirmedStartRaw: confirmedStartTime ?? card.confirmedStartRaw,
          confirmedEndRaw: confirmedEndTime ?? card.confirmedEndRaw,
          bonusAmount: bonusAmount ?? card.bonusAmount,
        );
      }
      return card;
    }).toList();

    // Update state with modified cards
    final updatedMonthData = monthData.copyWith(cards: updatedCards);
    final newDataByMonth = Map<String, ManagerShiftCards>.from(state.dataByMonth);
    newDataByMonth[monthKey] = updatedMonthData;

    _safeSetState(state.copyWith(dataByMonth: newDataByMonth));
  }
}

/// Manager Shift Cards Provider
///
/// Usage:
/// ```dart
/// final cards = ref.watch(managerCardsProvider(storeId));
/// await cards.notifier.loadMonth(month: DateTime.now());
/// final monthData = cards.dataByMonth[monthKey];
/// ```
final managerCardsProvider = StateNotifierProvider.family<
    ManagerShiftCardsNotifier,
    ManagerShiftCardsState,
    String>((ref, storeId) {
  final useCase = ref.watch(getManagerShiftCardsUseCaseProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  // Use device local timezone instead of user DB timezone
  final timezone = DateTimeUtils.getLocalTimezone();

  return ManagerShiftCardsNotifier(useCase, companyId, storeId, timezone);
});
