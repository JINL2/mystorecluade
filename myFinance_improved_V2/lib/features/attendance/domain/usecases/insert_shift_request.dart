import '../entities/shift_request.dart';
import '../repositories/attendance_repository.dart';

/// Insert a new shift request
class InsertShiftRequest {
  final AttendanceRepository _repository;

  InsertShiftRequest(this._repository);

  Future<ShiftRequest?> call({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
  }) {
    return _repository.insertShiftRequest(
      userId: userId,
      shiftId: shiftId,
      storeId: storeId,
      requestDate: requestDate,
    );
  }
}
