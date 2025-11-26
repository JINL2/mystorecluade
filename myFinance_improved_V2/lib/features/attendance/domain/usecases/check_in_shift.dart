import '../entities/attendance_location.dart';
import '../entities/check_in_result.dart';
import '../repositories/attendance_repository.dart';

/// Check in to shift via QR code
///
/// Matches RPC: update_shift_requests_v6
///
/// ✅ Clean Architecture: Returns Domain Entity (CheckInResult) instead of Map
class CheckInShift {
  final AttendanceRepository _repository;

  CheckInShift(this._repository);

  /// Perform check-in or check-out action
  ///
  /// Returns [CheckInResult] with action details and timestamp
  Future<CheckInResult> call({
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
