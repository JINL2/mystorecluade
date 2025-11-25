/// Manager Shift Cards Provider
///
/// Manages shift cards data (approved and pending cards).
/// Provides month-based caching with debug logging.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../domain/entities/manager_shift_cards.dart';
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
      print('📦 ManagerCards: Skipping load for $monthKey (already cached)');
      return;
    }

    print('🔄 ManagerCards: Loading data for $monthKey (storeId: $_storeId, companyId: $_companyId)');
    state = state.copyWith(isLoading: true, error: null);

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

      print('✅ ManagerCards: Loaded ${data.approvedCards.length} approved, ${data.pendingCards.length} pending');

      final newDataByMonth = Map<String, ManagerShiftCards>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      state = state.copyWith(
        dataByMonth: newDataByMonth,
        isLoading: false,
      );
    } catch (e) {
      print('❌ ManagerCards: Error loading data: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear data for a specific month
  void clearMonth(String monthKey) {
    final newDataByMonth = Map<String, ManagerShiftCards>.from(state.dataByMonth);
    newDataByMonth.remove(monthKey);
    state = state.copyWith(dataByMonth: newDataByMonth);
  }

  /// Clear all loaded data
  void clearAll() {
    state = const ManagerShiftCardsState();
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
  final timezone = (appState.user['timezone'] as String?) ?? 'UTC';

  return ManagerShiftCardsNotifier(useCase, companyId, storeId, timezone);
});
