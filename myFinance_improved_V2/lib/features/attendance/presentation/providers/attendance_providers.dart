import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/utils/datetime_utils.dart';
// ✅ Clean Architecture: Import from Domain layer only
import '../../domain/entities/base_currency.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/user_shift_stats.dart';
import '../../domain/providers/attendance_repository_provider.dart';
import '../../domain/usecases/check_in_shift.dart';
import '../../domain/usecases/delete_shift_request.dart';
import '../../domain/usecases/get_base_currency.dart';
import '../../domain/usecases/get_monthly_shift_status.dart';
import '../../domain/usecases/get_shift_metadata.dart';
import '../../domain/usecases/get_user_shift_cards.dart';
import '../../domain/usecases/get_user_shift_stats.dart';
import '../../domain/usecases/register_shift_request.dart';
import '../../domain/usecases/report_shift_issue.dart';
import '../../domain/usecases/update_shift_card_after_scan.dart';

// ========================================
// Re-export Repository Provider (for complex operations)
// ========================================

/// Re-export repository provider from Domain layer
/// Use this ONLY for complex operations that combine multiple use cases
/// Prefer individual use case providers for simple operations
export '../../domain/providers/attendance_repository_provider.dart' show attendanceRepositoryProvider;

// ========================================
// Use Case Providers
// ========================================

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

/// Get base currency use case provider
final getBaseCurrencyUseCaseProvider = Provider<GetBaseCurrency>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetBaseCurrency(repository);
});

/// Get user shift stats use case provider
final getUserShiftStatsUseCaseProvider = Provider<GetUserShiftStats>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetUserShiftStats(repository);
});

// ========================================
// Presentation Layer Providers
// ========================================

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
  final requestTime = DateTimeUtils.toLocalWithOffset(now);
  final timezone = DateTimeUtils.getLocalTimezone();

  final shiftCards = await getUserShiftCards(
    requestTime: requestTime,
    userId: userId,
    companyId: companyId,
    storeId: storeId,
    timezone: timezone,
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

  return shiftCards;
});

/// Provider for base currency (fetches company's base currency symbol)
/// Used to display currency symbol in salary and payment sections
final baseCurrencyProvider = FutureProvider<BaseCurrency?>((ref) async {
  final getBaseCurrency = ref.read(getBaseCurrencyUseCaseProvider);
  final appState = ref.read(appStateProvider);

  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return null;
  }

  try {
    return await getBaseCurrency(companyId: companyId);
  } catch (e) {
    // Return null on error, UI can show default symbol
    return null;
  }
});

/// Provider for user shift stats (Stats tab data)
/// Fetches salary info, period stats, and weekly payments from user_shift_stats RPC
final userShiftStatsProvider = FutureProvider<UserShiftStats?>((ref) async {
  final getUserShiftStats = ref.read(getUserShiftStatsUseCaseProvider);
  final authStateAsync = ref.read(authStateProvider);
  final appState = ref.read(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;

  if (userId == null || companyId.isEmpty || storeId.isEmpty) {
    return null;
  }

  final requestTime = DateTimeUtils.toLocalWithOffset(DateTime.now());
  final timezone = DateTimeUtils.getLocalTimezone();

  return await getUserShiftStats(
    requestTime: requestTime,
    userId: userId,
    companyId: companyId,
    storeId: storeId,
    timezone: timezone,
  );
});

/// Provider for tracking store change loading state
/// When true, show loading overlay in attendance main page
final attendanceStoreLoadingProvider = StateProvider<bool>((ref) => false);
