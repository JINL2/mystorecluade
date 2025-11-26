import '../entities/attendance_location.dart';
import '../repositories/attendance_repository.dart';

/// Check in to shift via QR code
///
/// Matches RPC: update_shift_requests_v6
class CheckInShift {
  final AttendanceRepository _repository;

  CheckInShift(this._repository);

  Future<Map<String, dynamic>?> call({
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  }) {
    return _repository.updateShiftRequest(
      userId: userId,
      storeId: storeId,
      timestamp: timestamp,
      location: location,
      timezone: timezone,
    );
  }
}
