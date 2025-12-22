import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/attendance_location.dart';
import '../entities/check_in_result.dart';
import '../repositories/attendance_repository.dart';

/// Check in to shift via QR code
///
/// Matches RPC: update_shift_requests_v7
///
/// Clean Architecture: Returns Either<Failure, CheckInResult>
class CheckInShift {
  final AttendanceRepository _repository;

  CheckInShift(this._repository);

  /// Perform check-in or check-out action
  ///
  /// [shiftRequestId] - Shift request ID (from user_shift_cards_v4)
  /// Returns Either<Failure, CheckInResult> with action details and timestamp
  Future<Either<Failure, CheckInResult>> call({
    required String shiftRequestId,
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  }) {
    return _repository.updateShiftRequest(
      shiftRequestId: shiftRequestId,
      userId: userId,
      storeId: storeId,
      timestamp: timestamp,
      location: location,
      timezone: timezone,
    );
  }
}
