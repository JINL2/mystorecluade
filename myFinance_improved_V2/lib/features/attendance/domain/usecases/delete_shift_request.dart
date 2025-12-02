import '../repositories/attendance_repository.dart';

/// Delete a shift request
///
/// Matches RPC: delete_shift_request_v3
class DeleteShiftRequest {
  final AttendanceRepository _repository;

  DeleteShiftRequest(this._repository);

  Future<void> call({
    required String userId,
    required String shiftId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) {
    return _repository.deleteShiftRequest(
      userId: userId,
      shiftId: shiftId,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
    );
  }
}
