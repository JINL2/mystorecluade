import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/monthly_attendance.dart';

/// Monthly 출퇴근 Repository Interface
///
/// Clean Architecture: Domain layer는 Data layer를 모름
/// 이 인터페이스를 Data layer에서 구현
abstract class MonthlyAttendanceRepository {
  /// Monthly 직원 체크인
  ///
  /// [userId] 사용자 ID
  /// [companyId] 회사 ID
  /// [storeId] QR 스캔한 매장 ID (optional)
  ///
  /// Returns: MonthlyCheckResult (성공/실패 정보 포함)
  Future<Either<Failure, MonthlyCheckResult>> checkIn({
    required String userId,
    required String companyId,
    String? storeId,
  });

  /// Monthly 직원 체크아웃
  ///
  /// [userId] 사용자 ID
  /// [companyId] 회사 ID
  ///
  /// Returns: MonthlyCheckResult (성공/실패 정보 포함)
  Future<Either<Failure, MonthlyCheckResult>> checkOut({
    required String userId,
    required String companyId,
  });

  /// 월간 출석 통계 조회
  ///
  /// [userId] 사용자 ID
  /// [companyId] 회사 ID
  /// [year] 연도 (optional, 기본값: 현재 연도)
  /// [month] 월 (optional, 기본값: 현재 월)
  ///
  /// Returns: MonthlyAttendanceStats
  Future<Either<Failure, MonthlyAttendanceStats>> getStats({
    required String userId,
    required String companyId,
    int? year,
    int? month,
  });

  /// 월간 출석 목록 조회 (캘린더용)
  ///
  /// [userId] 사용자 ID
  /// [companyId] 회사 ID
  /// [year] 연도
  /// [month] 월
  ///
  /// Returns: List<MonthlyAttendance>
  Future<Either<Failure, List<MonthlyAttendance>>> getList({
    required String userId,
    required String companyId,
    required int year,
    required int month,
  });

  /// 오늘 출석 정보 조회
  ///
  /// [userId] 사용자 ID
  /// [companyId] 회사 ID
  ///
  /// Returns: MonthlyAttendance? (오늘 기록 없으면 null)
  Future<Either<Failure, MonthlyAttendance?>> getTodayAttendance({
    required String userId,
    required String companyId,
  });
}
