import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../data/datasources/attendance_datasource.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'states/shift_overview_state.dart';

// ========================================
// Data Layer Providers
// ========================================

/// Supabase Client Provider
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Attendance Datasource Provider
final attendanceDatasourceProvider = Provider<AttendanceDatasource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return AttendanceDatasource(client);
});

/// Attendance Repository Provider
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final datasource = ref.watch(attendanceDatasourceProvider);
  return AttendanceRepositoryImpl(datasource: datasource);
});

// ========================================
// Presentation Layer Providers
// ========================================

/// Shift Overview Provider
final shiftOverviewProvider =
    StateNotifierProvider<ShiftOverviewNotifier, ShiftOverviewState>((ref) {
  // Watch app state changes to refresh when company/store changes
  ref.watch(appStateProvider);
  return ShiftOverviewNotifier(ref);
});

class ShiftOverviewNotifier extends StateNotifier<ShiftOverviewState> {
  final Ref ref;

  ShiftOverviewNotifier(this.ref) : super(ShiftOverviewState.initial()) {
    // Fetch data when provider is created or when company/store changes
    // Check if we have company and store selected before fetching
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isNotEmpty &&
        appState.storeChoosen.isNotEmpty) {
      fetchShiftOverview();
    }
  }

  Future<void> fetchShiftOverview() async {
    state = ShiftOverviewState.loading();

    try {
      final repository = ref.read(attendanceRepositoryProvider);
      final authStateAsync = ref.read(authStateProvider);
      final appState = ref.read(appStateProvider);

      // Get user ID from auth state
      final user = authStateAsync.value;
      final userId = user?.id;

      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not logged in',
        );
        return;
      }

      // Get company and store from app state
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Please select a company and store',
        );
        return;
      }

      // IMPORTANT: RPC functions require the LAST day of the month as p_request_date
      final now = DateTime.now();
      // Calculate the last day of the current month
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
      final requestDate =
          '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}';

      final overview = await repository.getUserShiftOverview(
        requestDate: requestDate,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
      );

      state = ShiftOverviewState(
        overview: overview,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await fetchShiftOverview();
  }
}

/// Provider for current shift status
final currentShiftProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final datasource = ref.read(attendanceDatasourceProvider);
  final authStateAsync = ref.read(authStateProvider);
  final appState = ref.read(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final storeId = appState.storeChoosen;

  if (userId == null || storeId.isEmpty) {
    return null;
  }

  return await datasource.getCurrentShift(
    userId: userId,
    storeId: storeId,
  );
});

/// Provider for checking if user is currently working
final isWorkingProvider = Provider<bool>((ref) {
  final currentShift = ref.watch(currentShiftProvider);

  return currentShift.when(
    data: (shift) {
      if (shift == null) return false;
      // Check if user has checked in but not checked out
      return shift['actual_start_time'] != null &&
          shift['actual_end_time'] == null;
    },
    loading: () => false,
    error: (_, __) => false,
  );
});
