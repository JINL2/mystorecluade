import '../repositories/attendance_repository.dart';

/// Delete a shift request
///
/// Direct database operation on shift_requests table
class DeleteShiftRequest {
  final AttendanceRepository _repository;

  DeleteShiftRequest(this._repository);

  Future<void> call({
    required String userId,
    required String shiftId,
    required String requestDate,
  }) {
    return _repository.deleteShiftRequest(
      userId: userId,
      shiftId: shiftId,
      requestDate: requestDate,
    );
  }
}
