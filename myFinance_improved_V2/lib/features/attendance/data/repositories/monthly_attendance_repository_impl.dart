import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/monthly_attendance.dart';
import '../../domain/repositories/monthly_attendance_repository.dart';
import '../datasources/monthly_attendance_datasource.dart';

/// Monthly Attendance Repository 구현
///
/// DataSource를 사용하여 RPC 호출 후 Either<Failure, T> 반환
class MonthlyAttendanceRepositoryImpl implements MonthlyAttendanceRepository {
  final MonthlyAttendanceDataSource _dataSource;

  MonthlyAttendanceRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, MonthlyCheckResult>> checkIn({
    required String userId,
    required String companyId,
    String? storeId,
  }) async {
    try {
      final result = await _dataSource.checkIn(
        userId: userId,
        companyId: companyId,
        storeId: storeId,
      );

      final entity = result.toEntity();

      if (!entity.success) {
        return Left(ServerFailure(
          message: entity.message ?? 'Check-in failed',
          code: entity.error ?? 'UNKNOWN',
        ));
      }

      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'UNKNOWN'));
    }
  }

  @override
  Future<Either<Failure, MonthlyCheckResult>> checkOut({
    required String userId,
    required String companyId,
  }) async {
    try {
      final result = await _dataSource.checkOut(
        userId: userId,
        companyId: companyId,
      );

      final entity = result.toEntity();

      if (!entity.success) {
        return Left(ServerFailure(
          message: entity.message ?? 'Check-out failed',
          code: entity.error ?? 'UNKNOWN',
        ));
      }

      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'UNKNOWN'));
    }
  }

  @override
  Future<Either<Failure, MonthlyAttendanceStats>> getStats({
    required String userId,
    required String companyId,
    int? year,
    int? month,
  }) async {
    try {
      final result = await _dataSource.getStats(
        userId: userId,
        companyId: companyId,
        year: year,
        month: month,
      );

      if (!result.success) {
        return Left(ServerFailure(
          message: result.message ?? 'Failed to get stats',
          code: result.error ?? 'UNKNOWN',
        ));
      }

      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'UNKNOWN'));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyAttendance>>> getList({
    required String userId,
    required String companyId,
    required int year,
    required int month,
  }) async {
    try {
      final result = await _dataSource.getList(
        userId: userId,
        companyId: companyId,
        year: year,
        month: month,
      );

      if (!result.success) {
        return Left(ServerFailure(
          message: result.message ?? 'Failed to get list',
          code: result.error ?? 'UNKNOWN',
        ));
      }

      return Right(result.toEntityList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'UNKNOWN'));
    }
  }

  @override
  Future<Either<Failure, MonthlyAttendance?>> getTodayAttendance({
    required String userId,
    required String companyId,
  }) async {
    try {
      final result = await _dataSource.getStats(
        userId: userId,
        companyId: companyId,
      );

      if (!result.success) {
        return Left(ServerFailure(
          message: result.message ?? 'Failed to get today attendance',
          code: result.error ?? 'UNKNOWN',
        ));
      }

      final stats = result.toEntity();

      return Right(stats.today);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'UNKNOWN'));
    }
  }
}
