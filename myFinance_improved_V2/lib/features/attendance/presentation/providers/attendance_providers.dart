import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/providers/attendance_repository_provider.dart';
import '../../domain/usecases/check_in_shift.dart';
import '../../domain/usecases/delete_shift_request.dart';
import '../../domain/usecases/get_monthly_shift_status.dart';
import '../../domain/usecases/get_monthly_shift_status_raw.dart';
import '../../domain/usecases/get_shift_metadata.dart';
import '../../domain/usecases/get_shift_overview.dart';
import '../../domain/usecases/get_user_shift_cards.dart';
import '../../domain/usecases/register_shift_request.dart';
import '../../domain/usecases/report_shift_issue.dart';
import '../../domain/usecases/update_shift_card_after_scan.dart';
import '../../domain/value_objects/month_bounds.dart';
import 'states/shift_overview_state.dart';

// ========================================
// CLEAN ARCHITECTURE COMPLIANCE ✅
// ========================================
//
// Presentation layer structure (IMPROVED):
// - Imports repository provider from DOMAIN layer (attendance_repository_provider.dart)
// - Data layer provides concrete implementation through override in main.dart
// - Presentation layer depends ONLY on Domain (UseCases, Entities, Repository interfaces)
//
// Dependency Flow:
// Presentation → Domain Providers → Domain Interfaces
//                     ↑
//              Data Implementation (injected via ProviderScope.overrides)
//
// Clean Architecture Benefits:
// ✅ Presentation does NOT import Data layer at all
// ✅ Presentation only knows about Domain interfaces
// ✅ Data layer can be swapped without affecting Presentation
// ✅ Easy to mock repositories for testing
//
// Implementation:
// 1. Domain defines: attendanceRepositoryProvider (throws UnimplementedError)
// 2. Data provides: attendanceRepositoryProviderImpl (concrete implementation)
// 3. main.dart overrides: attendanceRepositoryProvider with attendanceRepositoryProviderImpl
// 4. Presentation uses: attendanceRepositoryProvider (gets Data's implementation)
//

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

/// Get monthly shift status raw use case provider
/// Returns raw JSON with nested shifts array for UI display
final getMonthlyShiftStatusRawProvider =
    Provider<GetMonthlyShiftStatusRaw>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetMonthlyShiftStatusRaw(repository);
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

/// Update shift card after scan use case provider
final updateShiftCardAfterScanProvider = Provider<UpdateShiftCardAfterScan>((ref) {
  return UpdateShiftCardAfterScan();
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

      // IMPORTANT: RPC functions require UTC timestamp with last moment of month
      // Use MonthBounds Value Object for month boundary calculation
      final now = DateTime.now();
      final monthBounds = MonthBounds.fromDate(now);
      final requestTime = monthBounds.lastMomentUtcFormatted; // "yyyy-MM-dd HH:mm:ss" in UTC
      final timezone = DateTimeUtils.getLocalTimezone(); // User's local timezone

      final overview = await getShiftOverview(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
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

