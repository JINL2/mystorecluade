/// Manager Shift Cards Provider
///
/// Manages shift cards data (approved and pending cards).
/// Provides month-based caching with debug logging.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../core/utils/retry_helper.dart';
import '../../../domain/entities/manager_memo.dart';
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

  /// Format number with comma separators (e.g., 150000 → "150,000")
  static String _formatNumber(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    final length = str.length;
    for (var i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

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

    // 🔍 DEBUG: loadMonth called
    debugPrint('📥 [managerCardsProvider] loadMonth called - monthKey: $monthKey, forceRefresh: $forceRefresh');
    debugPrint('   📦 Current cache keys: ${state.dataByMonth.keys.toList()}');

    // Skip if already loaded (unless force refresh)
    if (!forceRefresh && state.dataByMonth.containsKey(monthKey)) {
      debugPrint('   ✅ Using cached data for month: $monthKey');
      return;
    }

    debugPrint('   🌐 Fetching from server...');
    _safeSetState(state.copyWith(isLoading: true, error: null));

    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);

      final startDate = '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
      final endDate = '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';

      // ✅ Retry with exponential backoff (max 3 retries: 1s, 2s, 4s)
      final data = await RetryHelper.withRetry(
        () => _getManagerShiftCardsUseCase(
          GetManagerShiftCardsParams(
            startDate: startDate,
            endDate: endDate,
            companyId: _companyId,
            storeId: _storeId,
            timezone: _timezone,
          ),
        ),
        config: RetryConfig.rpc,
        onRetry: (attempt, error) {
          debugPrint('   ⚠️ [managerCardsProvider] Retry $attempt for $monthKey: $error');
        },
      );

      final newDataByMonth = Map<String, ManagerShiftCards>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      _safeSetState(state.copyWith(
        dataByMonth: newDataByMonth,
        isLoading: false,
      ));
    } catch (e) {
      debugPrint('   ❌ [managerCardsProvider] Failed after retries: $e');
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
    debugPrint('🗑️ [managerCardsProvider] clearAll called - clearing ${state.dataByMonth.keys.length} months');
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
  /// v7: Now also calculates and updates salary fields (paidHour, basePay, totalPayWithBonus)
  /// when confirmed times change, ensuring UI shows correct values after save.
  ///
  /// Parameters:
  /// - [shiftRequestId]: The ID of the shift request to update
  /// - [shiftDate]: The date of the shift (yyyy-MM-dd format)
  /// - [isProblemSolved]: Whether problems are now solved (optional)
  /// - [isReportedSolved]: Whether report is solved (optional)
  /// - [confirmedStartTime]: New confirmed start time HH:mm:ss (optional)
  /// - [confirmedEndTime]: New confirmed end time HH:mm:ss (optional)
  /// - [bonusAmount]: New bonus amount (optional)
  /// - [newManagerMemo]: New manager memo to append (optional)
  /// - [calculatedPaidHour]: Pre-calculated paid hours from caller (optional)
  void updateCardProblemData({
    required String shiftRequestId,
    required String shiftDate,
    bool? isProblemSolved,
    bool? isReportedSolved,
    String? confirmedStartTime,
    String? confirmedEndTime,
    double? bonusAmount,
    ManagerMemo? newManagerMemo,
    double? calculatedPaidHour,
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
          final allSolved = updatedProblems.every((p) => p.isSolved == true);

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

        // Build updated managerMemos list (append new memo if provided)
        final updatedManagerMemos = newManagerMemo != null
            ? [...card.managerMemos, newManagerMemo]
            : card.managerMemos;

        // v7: Calculate salary fields when paidHour is provided
        double? newPaidHour = calculatedPaidHour;
        String? newBasePay;
        String? newTotalPayWithBonus;

        if (newPaidHour != null) {
          // Get hourly rate from existing salaryAmount
          final salaryAmountStr = card.salaryAmount;
          if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
            final hourlyRate = double.tryParse(salaryAmountStr.replaceAll(',', '')) ?? 0;
            if (hourlyRate > 0) {
              final basePayCalc = (newPaidHour * hourlyRate).toInt();
              final finalBonus = bonusAmount ?? card.bonusAmount ?? 0;
              final totalPayCalc = basePayCalc + finalBonus.toInt();

              // Format with comma separators
              newBasePay = _formatNumber(basePayCalc);
              newTotalPayWithBonus = _formatNumber(totalPayCalc);
            }
          }
        }

        return card.copyWith(
          problemDetails: updatedProblemDetails,
          confirmedStartRaw: confirmedStartTime ?? card.confirmedStartRaw,
          confirmedEndRaw: confirmedEndTime ?? card.confirmedEndRaw,
          bonusAmount: bonusAmount ?? card.bonusAmount,
          managerMemos: updatedManagerMemos,
          paidHour: newPaidHour ?? card.paidHour,
          basePay: newBasePay ?? card.basePay,
          totalPayWithBonus: newTotalPayWithBonus ?? card.totalPayWithBonus,
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
  // ✅ FIX: Use select to only rebuild when companyChoosen actually changes
  // Previously used ref.watch(appStateProvider) which caused rebuilds on ANY appState change
  // (e.g., storeChoosen, user data updates) leading to cache data loss
  final companyId = ref.watch(appStateProvider.select((s) => s.companyChoosen));
  // Use device local timezone instead of user DB timezone
  final timezone = DateTimeUtils.getLocalTimezone();

  // 🔍 DEBUG: Provider being created/recreated
  debugPrint('🔄 [managerCardsProvider] CREATED - storeId: $storeId, companyId: $companyId');

  return ManagerShiftCardsNotifier(useCase, companyId, storeId, timezone);
});
