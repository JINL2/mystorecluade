import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/attendance_location.dart';
import '../../domain/entities/base_currency.dart';
import '../../domain/entities/check_in_result.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/shift_card.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/entities/shift_request.dart';
import '../../domain/entities/user_shift_stats.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_datasource.dart';
import '../models/base_currency_model.dart';
import '../models/check_in_result_model.dart';
import '../models/monthly_shift_status_model.dart';
import '../models/shift_card_model.dart';
import '../models/shift_metadata_model.dart';
import '../models/shift_request_model.dart';
import '../models/user_shift_stats_model.dart';

/// Attendance Repository Implementation
///
/// Implements the AttendanceRepository interface using AttendanceDatasource.
/// Uses Either<Failure, T> pattern for error handling.
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDatasource _datasource;

  AttendanceRepositoryImpl({required AttendanceDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<Failure, CheckInResult>> updateShiftRequest({
    required String shiftRequestId,
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  }) async {
    try {
      final json = await _datasource.updateShiftRequest(
        shiftRequestId: shiftRequestId,
        userId: userId,
        storeId: storeId,
        timestamp: timestamp,
        location: location,
        timezone: timezone,
      );

      return Right(CheckInResultModel.fromJson(json ?? {}).toEntity());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'UPDATE_SHIFT_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ShiftCard>>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    String? storeId,
    required String timezone,
  }) async {
    try {
      final jsonList = await _datasource.getUserShiftCards(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      return Right(
        jsonList.map((json) => ShiftCardModel.fromJson(json).toEntity()).toList(),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'GET_SHIFT_CARDS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> reportShiftIssue({
    required String shiftRequestId,
    required String reportReason,
    required String time,
    required String timezone,
  }) async {
    try {
      final result = await _datasource.reportShiftIssue(
        shiftRequestId: shiftRequestId,
        reportReason: reportReason,
        time: time,
        timezone: timezone,
      );

      return Right(result);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'REPORT_ISSUE_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ShiftMetadata>>> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) async {
    try {
      final jsonList = await _datasource.getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      return Right(
        jsonList.map((json) => ShiftMetadataModel.fromJson(json).toEntity()).toList(),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'GET_METADATA_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyShiftStatus>>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) async {
    try {
      final jsonList = await _datasource.getMonthlyShiftStatusManager(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      return Right(
        jsonList.map((json) => MonthlyShiftStatusModel.fromJson(json).toEntity()).toList(),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'GET_MONTHLY_STATUS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, ShiftRequest?>> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) async {
    try {
      final json = await _datasource.insertShiftRequest(
        userId: userId,
        shiftId: shiftId,
        storeId: storeId,
        startTime: startTime,
        endTime: endTime,
        timezone: timezone,
      );

      return Right(json != null ? ShiftRequestModel.fromJson(json).toEntity() : null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'INSERT_SHIFT_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) async {
    try {
      await _datasource.deleteShiftRequest(
        userId: userId,
        shiftId: shiftId,
        startTime: startTime,
        endTime: endTime,
        timezone: timezone,
      );

      return const Right(unit);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'DELETE_SHIFT_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, BaseCurrency>> getBaseCurrency({
    required String companyId,
  }) async {
    try {
      final json = await _datasource.getBaseCurrency(
        companyId: companyId,
      );

      return Right(BaseCurrencyModel.fromRpcResponse(json).toEntity());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'GET_CURRENCY_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, UserShiftStats>> getUserShiftStats({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final json = await _datasource.getUserShiftStats(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      return Right(UserShiftStatsModel.fromJson(json).toEntity());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'POSTGREST_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'GET_STATS_ERROR',
      ));
    }
  }
}
