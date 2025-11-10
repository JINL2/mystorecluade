import '../entities/attendance_location.dart';
import '../entities/shift_card_data.dart';
import '../repositories/attendance_repository.dart';

/// Check in to shift via QR code (strongly typed)
///
/// Matches RPC: update_shift_requests_v4
class CheckInShift {
  final AttendanceRepository _repository;

  CheckInShift(this._repository);

  Future<ShiftCardData> call({
    required String userId,
    required String storeId,
    required String requestDate,
    required String timestamp,
    required AttendanceLocation location,
  }) {
    return _repository.updateShiftRequest(
      userId: userId,
      storeId: storeId,
      requestDate: requestDate,
      timestamp: timestamp,
      location: location,
    );
  }
}
