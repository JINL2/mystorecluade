import '../entities/shift_card_data.dart';
import '../repositories/attendance_repository.dart';

/// Register a new shift request (strongly typed)
///
/// Matches RPC: insert_shift_request_v2
class RegisterShiftRequest {
  final AttendanceRepository _repository;

  RegisterShiftRequest(this._repository);

  Future<ShiftCardData?> call({
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
