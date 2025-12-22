import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/shift_request.dart';
import '../repositories/attendance_repository.dart';

/// Insert a new shift request
///
/// Matches RPC: insert_shift_request_v6
///
/// Clean Architecture: Returns Either<Failure, ShiftRequest?>
class InsertShiftRequest {
  final AttendanceRepository _repository;

  InsertShiftRequest(this._repository);

  Future<Either<Failure, ShiftRequest?>> call({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) {
    return _repository.insertShiftRequest(
      userId: userId,
      shiftId: shiftId,
      storeId: storeId,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
    );
  }
}
