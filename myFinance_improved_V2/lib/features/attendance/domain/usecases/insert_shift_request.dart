import '../entities/shift_request.dart';
import '../repositories/attendance_repository.dart';

/// Insert a new shift request
///
/// Matches RPC: insert_shift_request_v3
class InsertShiftRequest {
  final AttendanceRepository _repository;

  InsertShiftRequest(this._repository);

  Future<ShiftRequest?> call({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestTime,
    required String timezone,
  }) {
    return _repository.insertShiftRequest(
      userId: userId,
      shiftId: shiftId,
      storeId: storeId,
      requestTime: requestTime,
      timezone: timezone,
    );
  }
}
