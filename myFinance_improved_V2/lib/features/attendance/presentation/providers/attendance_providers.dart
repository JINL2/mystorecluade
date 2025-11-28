import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../data/providers/attendance_data_providers.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/usecases/check_in_shift.dart';
import '../../domain/usecases/delete_shift_request.dart';
import '../../domain/usecases/get_monthly_shift_status.dart';
import '../../domain/usecases/get_shift_metadata.dart';
import '../../domain/usecases/get_shift_overview.dart';
import '../../domain/usecases/get_user_shift_cards.dart';
import '../../domain/usecases/register_shift_request.dart';
import '../../domain/usecases/report_shift_issue.dart';
import '../../domain/usecases/update_shift_card_after_scan.dart';
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

      // IMPORTANT: RPC functions require the LAST day of the month as p_request_time
      final now = DateTime.now();
      // Calculate the last day of the current month
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
      final requestTime =
          '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')} 23:59:59';

      final overview = await getShiftOverview(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: 'Asia/Seoul', // TODO: Get from user settings
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
    FutureProvider<ShiftCard?>((ref) async {
  final getUserShiftCards = ref.read(getUserShiftCardsProvider);
  final authStateAsync = ref.read(authStateProvider);
  final appState = ref.read(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;

  if (userId == null || companyId.isEmpty || storeId.isEmpty) {
    return null;
  }

  final now = DateTime.now();
  final requestTime =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

  final shiftCards = await getUserShiftCards(
    requestTime: requestTime,
    userId: userId,
    companyId: companyId,
    storeId: storeId,
    timezone: 'Asia/Seoul', // TODO: Get from user settings
  );

  // Return the first shift that is currently active (checked in but not checked out)
  if (shiftCards.isEmpty) return null;

  return shiftCards.firstWhere(
    (card) => card.isCheckedIn && !card.isCheckedOut,
    orElse: () => shiftCards.first,
  );
});

/// Provider for checking if user is currently working
final isWorkingProvider = Provider<bool>((ref) {
  final currentShift = ref.watch(currentShiftProvider);

  return currentShift.when(
    data: (shift) {
      if (shift == null) return false;
      // Check if user has checked in but not checked out
      return shift.isCheckedIn && !shift.isCheckedOut;
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider for monthly shift cards (Week/Month view용)
/// Parameter: String (년-월 형식, e.g., "2025-11")
/// DateTime 대신 String을 사용하여 동일한 월에 대해 캐싱 및 리빌드 방지
final monthlyShiftCardsProvider =
    FutureProvider.family<List<ShiftCard>, String>((ref, yearMonth) async {
  final getUserShiftCards = ref.read(getUserShiftCardsProvider);
  final authStateAsync = ref.read(authStateProvider);
  final appState = ref.read(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;

  if (userId == null || companyId.isEmpty || storeId.isEmpty) {
    return [];
  }

  // Parse year-month string (e.g., "2025-11")
  final parts = yearMonth.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);

  // Calculate the last day of the month for RPC
  // Use toLocalWithOffset for proper timezone format (e.g., "2025-11-30T23:59:59+09:00")
  final lastDayOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);
  final requestTime = DateTimeUtils.toLocalWithOffset(lastDayOfMonth);
  final timezone = DateTimeUtils.getLocalTimezone();

  final shiftCards = await getUserShiftCards(
    requestTime: requestTime,
    userId: userId,
    companyId: companyId,
    storeId: storeId,
    timezone: timezone,
  );

  // ✅ Debug: Log loaded shift cards
  assert(() {
    // ignore: avoid_print
    print('📅 [monthlyShiftCardsProvider] Loaded ${shiftCards.length} cards for $yearMonth');
    for (final card in shiftCards) {
      // ignore: avoid_print
      print('  - ${card.requestDate}: ${card.shiftTime}');
    }
    return true;
  }());

  return shiftCards;
});
