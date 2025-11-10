import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/time_table_datasource.dart';
import '../../data/repositories/time_table_repository_impl.dart';
import '../../domain/entities/manager_overview.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/repositories/time_table_repository.dart';
import '../../domain/usecases/add_bonus.dart';
import '../../domain/usecases/create_shift.dart';
import '../../domain/usecases/delete_shift.dart';
import '../../domain/usecases/delete_shift_tag.dart';
import '../../domain/usecases/get_available_employees.dart';
import '../../domain/usecases/get_manager_overview.dart';
import '../../domain/usecases/get_manager_shift_cards.dart';
import '../../domain/usecases/get_monthly_shift_status.dart';
import '../../domain/usecases/get_schedule_data.dart';
import '../../domain/usecases/get_shift_metadata.dart';
import '../../domain/usecases/get_tags_by_card_id.dart';
import '../../domain/usecases/input_card.dart';
import '../../domain/usecases/insert_schedule.dart';
import '../../domain/usecases/insert_shift_schedule.dart';
import '../../domain/usecases/process_bulk_approval.dart';
import '../../domain/usecases/toggle_shift_approval.dart';
import '../../domain/usecases/update_bonus_amount.dart';
import '../../domain/usecases/update_shift.dart';
import 'states/time_table_state.dart';

// ============================================================================
// Data Layer Providers
// ============================================================================

/// Supabase Client Provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Time Table Datasource Provider
final timeTableDatasourceProvider = Provider<TimeTableDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return TimeTableDatasource(client);
});

/// Time Table Repository Provider
final timeTableRepositoryProvider = Provider<TimeTableRepository>((ref) {
  final datasource = ref.watch(timeTableDatasourceProvider);
  return TimeTableRepositoryImpl(datasource);
});

// ============================================================================
// UseCase Providers
// ============================================================================

/// Get Shift Metadata UseCase Provider
final getShiftMetadataUseCaseProvider = Provider<GetShiftMetadata>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetShiftMetadata(repository);
});

/// Get Monthly Shift Status UseCase Provider
final getMonthlyShiftStatusUseCaseProvider =
    Provider<GetMonthlyShiftStatus>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetMonthlyShiftStatus(repository);
});

/// Get Manager Overview UseCase Provider
final getManagerOverviewUseCaseProvider = Provider<GetManagerOverview>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetManagerOverview(repository);
});

/// Get Manager Shift Cards UseCase Provider
final getManagerShiftCardsUseCaseProvider =
    Provider<GetManagerShiftCards>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetManagerShiftCards(repository);
});

/// Toggle Shift Approval UseCase Provider
final toggleShiftApprovalUseCaseProvider =
    Provider<ToggleShiftApproval>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return ToggleShiftApproval(repository);
});

/// Create Shift UseCase Provider
final createShiftUseCaseProvider = Provider<CreateShift>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return CreateShift(repository);
});

/// Delete Shift UseCase Provider
final deleteShiftUseCaseProvider = Provider<DeleteShift>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return DeleteShift(repository);
});

/// Delete Shift Tag UseCase Provider
final deleteShiftTagUseCaseProvider = Provider<DeleteShiftTag>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return DeleteShiftTag(repository);
});

/// Get Available Employees UseCase Provider
final getAvailableEmployeesUseCaseProvider =
    Provider<GetAvailableEmployees>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetAvailableEmployees(repository);
});

/// Insert Shift Schedule UseCase Provider
final insertShiftScheduleUseCaseProvider =
    Provider<InsertShiftSchedule>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return InsertShiftSchedule(repository);
});

/// Get Schedule Data UseCase Provider
final getScheduleDataUseCaseProvider = Provider<GetScheduleData>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetScheduleData(repository);
});

/// Insert Schedule UseCase Provider
final insertScheduleUseCaseProvider = Provider<InsertSchedule>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return InsertSchedule(repository);
});

/// Process Bulk Approval UseCase Provider
final processBulkApprovalUseCaseProvider =
    Provider<ProcessBulkApproval>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return ProcessBulkApproval(repository);
});

/// Update Shift UseCase Provider
final updateShiftUseCaseProvider = Provider<UpdateShift>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return UpdateShift(repository);
});

/// Input Card UseCase Provider
final inputCardUseCaseProvider = Provider<InputCard>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return InputCard(repository);
});

/// Get Tags By Card ID UseCase Provider
final getTagsByCardIdUseCaseProvider = Provider<GetTagsByCardId>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetTagsByCardId(repository);
});

/// Add Bonus UseCase Provider
final addBonusUseCaseProvider = Provider<AddBonus>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return AddBonus(repository);
});

/// Update Bonus Amount UseCase Provider
final updateBonusAmountUseCaseProvider = Provider<UpdateBonusAmount>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return UpdateBonusAmount(repository);
});

// ============================================================================
// Presentation Layer State Providers
// ============================================================================

/// Selected Date Provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Selected Store ID Provider
final selectedStoreIdProvider = StateProvider<String?>((ref) {
  return null;
});

/// Focused Month Provider (for calendar navigation)
final focusedMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Tab Controller Index Provider
final tabIndexProvider = StateProvider<int>((ref) {
  return 0; // 0 = Schedule, 1 = Overview
});

// ============================================================================
// Shift Metadata Provider
// ============================================================================

/// Shift Metadata Provider
///
/// Loads shift metadata for a given store ID
final shiftMetadataProvider =
    FutureProvider.family<ShiftMetadata, String>((ref, storeId) async {
  if (storeId.isEmpty) {
    throw Exception('Store ID is required');
  }

  final useCase = ref.watch(getShiftMetadataUseCaseProvider);
  return await useCase(GetShiftMetadataParams(storeId: storeId));
});

// ============================================================================
// Monthly Shift Status Provider
// ============================================================================

/// Monthly Shift Status Notifier
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
      // Format as first day of month
      final requestDate =
          '${month.year}-${month.month.toString().padLeft(2, '0')}-01';

      final data = await _getMonthlyShiftStatusUseCase(
        GetMonthlyShiftStatusParams(
          requestDate: requestDate,
          companyId: _companyId,
          storeId: _storeId,
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
final monthlyShiftStatusProvider = StateNotifierProvider.family<
    MonthlyShiftStatusNotifier,
    MonthlyShiftStatusState,
    String>((ref, storeId) {
  final useCase = ref.watch(getMonthlyShiftStatusUseCaseProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  return MonthlyShiftStatusNotifier(useCase, companyId, storeId);
});

// ============================================================================
// Manager Overview Provider
// ============================================================================

/// Manager Overview Notifier
class ManagerOverviewNotifier extends StateNotifier<ManagerOverviewState> {
  final GetManagerOverview _getManagerOverviewUseCase;
  final String _companyId;
  final String _storeId;

  ManagerOverviewNotifier(
    this._getManagerOverviewUseCase,
    this._companyId,
    this._storeId,
  ) : super(const ManagerOverviewState());

  /// Load manager overview for a specific month
  Future<void> loadMonth({
    required DateTime month,
    bool forceRefresh = false,
  }) async {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';

    // Skip if already loaded (unless force refresh)
    if (!forceRefresh && state.dataByMonth.containsKey(monthKey)) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);

      final startDate = '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
      final endDate = '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';

      final data = await _getManagerOverviewUseCase(
        GetManagerOverviewParams(
          startDate: startDate,
          endDate: endDate,
          companyId: _companyId,
          storeId: _storeId,
        ),
      );

      final newDataByMonth = Map<String, ManagerOverview>.from(state.dataByMonth);
      newDataByMonth[monthKey] = data;

      state = state.copyWith(
        dataByMonth: newDataByMonth,
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
  ManagerOverview? getMonthData(DateTime month) {
    final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return state.dataByMonth[monthKey];
  }

  /// Clear all loaded data
  void clearAll() {
    state = const ManagerOverviewState();
  }
}

/// Manager Overview Provider
final managerOverviewProvider = StateNotifierProvider.family<
    ManagerOverviewNotifier,
    ManagerOverviewState,
    String>((ref, storeId) {
  final useCase = ref.watch(getManagerOverviewUseCaseProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  return ManagerOverviewNotifier(useCase, companyId, storeId);
});

// ============================================================================
// Selected Shift Requests Provider (for multi-select approval)
// ============================================================================

/// Selected Shift Requests Notifier
class SelectedShiftRequestsNotifier
    extends StateNotifier<SelectedShiftRequestsState> {
  SelectedShiftRequestsNotifier() : super(const SelectedShiftRequestsState());

  void toggleSelection(String shiftRequestId, bool isApproved) {
    final newSelectedIds = Set<String>.from(state.selectedIds);
    final newApprovalStates = Map<String, bool>.from(state.approvalStates);

    if (newSelectedIds.contains(shiftRequestId)) {
      newSelectedIds.remove(shiftRequestId);
      newApprovalStates.remove(shiftRequestId);
    } else {
      newSelectedIds.add(shiftRequestId);
      newApprovalStates[shiftRequestId] = isApproved;
    }

    state = state.copyWith(
      selectedIds: newSelectedIds,
      approvalStates: newApprovalStates,
    );
  }

  void clearAll() {
    state = const SelectedShiftRequestsState();
  }

  bool isSelected(String shiftRequestId) {
    return state.selectedIds.contains(shiftRequestId);
  }
}

/// Selected Shift Requests Provider
final selectedShiftRequestsProvider = StateNotifierProvider<
    SelectedShiftRequestsNotifier,
    SelectedShiftRequestsState>((ref) {
  return SelectedShiftRequestsNotifier();
});
