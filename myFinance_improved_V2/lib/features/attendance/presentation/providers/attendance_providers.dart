import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/base_currency.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/user_shift_stats.dart';
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

import 'repository_providers.dart';

// Re-export repository provider
export 'repository_providers.dart' show attendanceRepositoryProvider;

part 'attendance_providers.g.dart';

// ========================================
// Use Case Providers (@riverpod)
// ========================================

/// Check in shift use case provider
@riverpod
CheckInShift checkInShift(CheckInShiftRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return CheckInShift(repository);
}

/// Register shift request use case provider
@riverpod
RegisterShiftRequest registerShiftRequest(RegisterShiftRequestRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return RegisterShiftRequest(repository);
}

/// Get shift metadata use case provider
@riverpod
GetShiftMetadata getShiftMetadata(GetShiftMetadataRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetShiftMetadata(repository);
}

/// Get monthly shift status use case provider
@riverpod
GetMonthlyShiftStatus getMonthlyShiftStatus(GetMonthlyShiftStatusRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetMonthlyShiftStatus(repository);
}

/// Delete shift request use case provider
@riverpod
DeleteShiftRequest deleteShiftRequest(DeleteShiftRequestRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return DeleteShiftRequest(repository);
}

/// Report shift issue use case provider
@riverpod
ReportShiftIssue reportShiftIssue(ReportShiftIssueRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return ReportShiftIssue(repository);
}

/// Get user shift cards use case provider
@riverpod
GetUserShiftCards getUserShiftCards(GetUserShiftCardsRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetUserShiftCards(repository);
}

/// Update shift card after scan use case provider
@riverpod
UpdateShiftCardAfterScan updateShiftCardAfterScan(UpdateShiftCardAfterScanRef ref) {
  return UpdateShiftCardAfterScan();
}

/// Get base currency use case provider
@riverpod
GetBaseCurrency getBaseCurrencyUseCase(GetBaseCurrencyUseCaseRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetBaseCurrency(repository);
}

/// Get user shift stats use case provider
@riverpod
GetUserShiftStats getUserShiftStatsUseCase(GetUserShiftStatsUseCaseRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return GetUserShiftStats(repository);
}

// ========================================
// Presentation Layer Providers (@riverpod)
// ========================================

/// Provider for current shift status
/// Uses Either pattern - throws exception on Left for AsyncValue.error handling
@riverpod
Future<ShiftCard?> currentShift(CurrentShiftRef ref) async {
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

  final result = await getUserShiftCards(
    requestTime: requestTime,
    userId: userId,
    companyId: companyId,
    storeId: storeId,
    timezone: timezone,
  );

  // Either pattern: fold Left to throw, Right to return data
  return result.fold(
    (failure) => throw Exception(failure.message),
    (shiftCards) {
      // Return the first shift that is currently active (checked in but not checked out)
      if (shiftCards.isEmpty) return null;

      return shiftCards.firstWhere(
        (card) => card.isCheckedIn && !card.isCheckedOut,
        orElse: () => shiftCards.first,
      );
    },
  );
}

/// Provider for checking if user is currently working
@riverpod
bool isWorking(IsWorkingRef ref) {
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
}

/// Provider for monthly shift cards (Week/Month view용)
/// Parameter: String (년-월 형식, e.g., "2025-11")
/// DateTime 대신 String을 사용하여 동일한 월에 대해 캐싱 및 리빌드 방지
/// Uses Either pattern - throws exception on Left for AsyncValue.error handling
@riverpod
Future<List<ShiftCard>> monthlyShiftCards(
  MonthlyShiftCardsRef ref,
  String yearMonth,
) async {
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

  final result = await getUserShiftCards(
    requestTime: requestTime,
    userId: userId,
    companyId: companyId,
    storeId: storeId,
    timezone: timezone,
  );

  // Either pattern: fold Left to throw, Right to return data
  return result.fold(
    (failure) => throw Exception(failure.message),
    (shiftCards) => shiftCards,
  );
}

/// Provider for base currency (fetches company's base currency symbol)
/// Used to display currency symbol in salary and payment sections
/// Uses Either pattern - returns null on Left for graceful degradation
@riverpod
Future<BaseCurrency?> baseCurrency(BaseCurrencyRef ref) async {
  final getBaseCurrency = ref.read(getBaseCurrencyUseCaseProvider);
  final appState = ref.read(appStateProvider);

  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return null;
  }

  final result = await getBaseCurrency(companyId: companyId);

  // Either pattern: fold Left to null (graceful degradation), Right to return data
  return result.fold(
    (failure) => null, // Return null on error, UI can show default symbol
    (currency) => currency,
  );
}

/// Provider for user shift stats (Stats tab data)
/// Fetches salary info, period stats, and weekly payments from user_shift_stats RPC
/// Uses Either pattern - throws exception on Left for AsyncValue.error handling
@riverpod
Future<UserShiftStats?> userShiftStats(UserShiftStatsRef ref) async {
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

  final result = await getUserShiftStats(
    requestTime: requestTime,
    userId: userId,
    companyId: companyId,
    storeId: storeId,
    timezone: timezone,
  );

  // Either pattern: fold Left to throw, Right to return data
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
}

/// Provider for tracking store change loading state
/// When true, show loading overlay in attendance main page
final attendanceStoreLoadingProvider = StateProvider<bool>((ref) => false);
