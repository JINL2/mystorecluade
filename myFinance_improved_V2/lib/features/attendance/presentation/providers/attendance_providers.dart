import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../data/providers/attendance_data_providers.dart';
import '../../domain/usecases/check_in_shift.dart';
import '../../domain/usecases/delete_shift_request.dart';
import '../../domain/usecases/get_current_shift.dart';
import '../../domain/usecases/get_monthly_shift_status.dart';
import '../../domain/usecases/get_shift_metadata.dart';
import '../../domain/usecases/get_shift_overview.dart';
import '../../domain/usecases/get_user_shift_cards.dart';
import '../../domain/usecases/register_shift_request.dart';
import '../../domain/usecases/report_shift_issue.dart';
import 'states/shift_overview_state.dart';

// ========================================
// Re-export Repository Provider (for complex operations)
// ========================================

/// Re-export repository provider from data layer
/// Use this ONLY for complex operations that combine multiple use cases
/// Prefer individual use case providers for simple operations
export '../../data/providers/attendance_data_providers.dart' show attendanceRepositoryProvider;

// ========================================
// Use Case Providers
// ========================================

/// Get shift overview use case provider
final getShiftOverviewProvider = Provider<GetShiftOverview>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetShiftOverview(repository);
});

/// Check in shift use case provider
final checkInShiftProvider = Provider<CheckInShift>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return CheckInShift(repository);
});

/// Register shift request use case provider
final registerShiftRequestProvider = Provider<RegisterShiftRequest>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return RegisterShiftRequest(repository);
});

/// Get shift metadata use case provider
final getShiftMetadataProvider = Provider<GetShiftMetadata>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetShiftMetadata(repository);
});

/// Get monthly shift status use case provider
final getMonthlyShiftStatusProvider = Provider<GetMonthlyShiftStatus>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetMonthlyShiftStatus(repository);
});

/// Delete shift request use case provider
final deleteShiftRequestProvider = Provider<DeleteShiftRequest>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return DeleteShiftRequest(repository);
});

/// Report shift issue use case provider
final reportShiftIssueProvider = Provider<ReportShiftIssue>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return ReportShiftIssue(repository);
});

/// Get user shift cards use case provider
final getUserShiftCardsProvider = Provider<GetUserShiftCards>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetUserShiftCards(repository);
});

/// Get current shift use case provider
final getCurrentShiftProvider = Provider<GetCurrentShift>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetCurrentShift(repository);
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
      final getShiftOverview = ref.read(getShiftOverviewProvider);
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

      final overview = await getShiftOverview(
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
  final getCurrentShift = ref.read(getCurrentShiftProvider);
  final authStateAsync = ref.read(authStateProvider);
  final appState = ref.read(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final storeId = appState.storeChoosen;

  if (userId == null || storeId.isEmpty) {
    return null;
  }

  return await getCurrentShift(
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
