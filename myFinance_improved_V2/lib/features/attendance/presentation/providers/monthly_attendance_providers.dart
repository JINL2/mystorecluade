import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../data/datasources/monthly_attendance_datasource.dart';
import '../../data/repositories/monthly_attendance_repository_impl.dart';
import '../../domain/entities/monthly_attendance.dart';
import '../../domain/repositories/monthly_attendance_repository.dart';

part 'monthly_attendance_providers.g.dart';

// ========================================
// Infrastructure Providers
// ========================================

/// Monthly Attendance DataSource Provider
@riverpod
MonthlyAttendanceDataSource monthlyAttendanceDataSource(
  MonthlyAttendanceDataSourceRef ref,
) {
  final client = Supabase.instance.client;
  return MonthlyAttendanceDataSourceImpl(client);
}

/// Monthly Attendance Repository Provider
@riverpod
MonthlyAttendanceRepository monthlyAttendanceRepository(
  MonthlyAttendanceRepositoryRef ref,
) {
  final dataSource = ref.watch(monthlyAttendanceDataSourceProvider);
  return MonthlyAttendanceRepositoryImpl(dataSource);
}

// ========================================
// User Salary Type Provider
// ========================================

/// 현재 사용자의 급여 타입 조회
///
/// Returns: 'monthly' | 'hourly' | null
///
/// user_salaries 테이블에서 조회
@riverpod
Future<String?> userSalaryType(UserSalaryTypeRef ref) async {
  final authStateAsync = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final companyId = appState.companyChoosen;

  if (userId == null || companyId.isEmpty) return null;

  try {
    final client = Supabase.instance.client;
    final result = await client
        .from('user_salaries')
        .select('salary_type')
        .eq('user_id', userId)
        .eq('company_id', companyId)
        .maybeSingle();

    return result?['salary_type'] as String? ?? 'hourly';
  } catch (e) {
    // 에러 시 기본값 hourly 반환
    return 'hourly';
  }
}

/// 현재 사용자가 Monthly 직원인지 확인
@riverpod
Future<bool> isMonthlyEmployee(IsMonthlyEmployeeRef ref) async {
  final salaryType = await ref.watch(userSalaryTypeProvider.future);
  return salaryType == 'monthly';
}

// ========================================
// Monthly Attendance Data Providers
// ========================================

/// 오늘 출석 정보 조회
@riverpod
Future<MonthlyAttendance?> todayMonthlyAttendance(
  TodayMonthlyAttendanceRef ref,
) async {
  final repository = ref.watch(monthlyAttendanceRepositoryProvider);
  final authStateAsync = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final companyId = appState.companyChoosen;

  if (userId == null || companyId.isEmpty) return null;

  final result = await repository.getTodayAttendance(
    userId: userId,
    companyId: companyId,
  );

  return result.fold(
    (failure) => null,
    (attendance) => attendance,
  );
}

/// 월간 출석 통계 조회
///
/// Parameter: "2025-12" 형식
@riverpod
Future<MonthlyAttendanceStats?> monthlyAttendanceStats(
  MonthlyAttendanceStatsRef ref,
  String yearMonth,
) async {
  final repository = ref.watch(monthlyAttendanceRepositoryProvider);
  final authStateAsync = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final companyId = appState.companyChoosen;

  if (userId == null || companyId.isEmpty) return null;

  // Parse year-month
  final parts = yearMonth.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);

  final result = await repository.getStats(
    userId: userId,
    companyId: companyId,
    year: year,
    month: month,
  );

  return result.fold(
    (failure) => null,
    (stats) => stats,
  );
}

/// 현재 월 출석 통계 조회 (간편 버전)
@riverpod
Future<MonthlyAttendanceStats?> currentMonthlyStats(
  CurrentMonthlyStatsRef ref,
) async {
  final now = DateTime.now();
  final yearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  return ref.watch(monthlyAttendanceStatsProvider(yearMonth).future);
}

/// 월간 출석 목록 조회 (캘린더용)
///
/// Parameter: "2025-12" 형식
@riverpod
Future<List<MonthlyAttendance>> monthlyAttendanceList(
  MonthlyAttendanceListRef ref,
  String yearMonth,
) async {
  final repository = ref.watch(monthlyAttendanceRepositoryProvider);
  final authStateAsync = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);

  final user = authStateAsync.value;
  final userId = user?.id;
  final companyId = appState.companyChoosen;

  if (userId == null || companyId.isEmpty) return [];

  // Parse year-month
  final parts = yearMonth.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);

  final result = await repository.getList(
    userId: userId,
    companyId: companyId,
    year: year,
    month: month,
  );

  return result.fold(
    (failure) => [],
    (list) => list,
  );
}

// ========================================
// Check-in/Check-out Actions
// ========================================

/// Monthly 체크인/체크아웃 Notifier
///
/// 사용법:
/// ```dart
/// final notifier = ref.read(monthlyCheckNotifierProvider.notifier);
/// final result = await notifier.checkIn(storeId: storeId);
/// ```
@riverpod
class MonthlyCheckNotifier extends _$MonthlyCheckNotifier {
  @override
  AsyncValue<MonthlyCheckResult?> build() {
    return const AsyncValue.data(null);
  }

  /// 체크인
  Future<MonthlyCheckResult> checkIn({String? storeId}) async {
    state = const AsyncValue.loading();

    final repository = ref.read(monthlyAttendanceRepositoryProvider);
    final authStateAsync = ref.read(authStateProvider);
    final appState = ref.read(appStateProvider);

    final user = authStateAsync.value;
    final userId = user?.id;
    final companyId = appState.companyChoosen;

    if (userId == null || companyId.isEmpty) {
      final errorResult = MonthlyCheckResult(
        success: false,
        error: 'INVALID_USER',
        message: 'User not authenticated',
      );
      state = AsyncValue.data(errorResult);
      return errorResult;
    }

    final result = await repository.checkIn(
      userId: userId,
      companyId: companyId,
      storeId: storeId,
    );

    return result.fold(
      (failure) {
        final errorResult = MonthlyCheckResult(
          success: false,
          error: failure.code,
          message: failure.message,
        );
        state = AsyncValue.data(errorResult);
        return errorResult;
      },
      (checkResult) {
        state = AsyncValue.data(checkResult);
        // 성공 시 관련 provider 갱신
        ref.invalidate(todayMonthlyAttendanceProvider);
        ref.invalidate(currentMonthlyStatsProvider);
        return checkResult;
      },
    );
  }

  /// 체크아웃
  Future<MonthlyCheckResult> checkOut() async {
    state = const AsyncValue.loading();

    final repository = ref.read(monthlyAttendanceRepositoryProvider);
    final authStateAsync = ref.read(authStateProvider);
    final appState = ref.read(appStateProvider);

    final user = authStateAsync.value;
    final userId = user?.id;
    final companyId = appState.companyChoosen;

    if (userId == null || companyId.isEmpty) {
      final errorResult = MonthlyCheckResult(
        success: false,
        error: 'INVALID_USER',
        message: 'User not authenticated',
      );
      state = AsyncValue.data(errorResult);
      return errorResult;
    }

    final result = await repository.checkOut(
      userId: userId,
      companyId: companyId,
    );

    return result.fold(
      (failure) {
        final errorResult = MonthlyCheckResult(
          success: false,
          error: failure.code,
          message: failure.message,
        );
        state = AsyncValue.data(errorResult);
        return errorResult;
      },
      (checkResult) {
        state = AsyncValue.data(checkResult);
        // 성공 시 관련 provider 갱신
        ref.invalidate(todayMonthlyAttendanceProvider);
        ref.invalidate(currentMonthlyStatsProvider);
        return checkResult;
      },
    );
  }
}
