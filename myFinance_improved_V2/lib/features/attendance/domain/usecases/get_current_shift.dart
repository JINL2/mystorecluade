import '../repositories/attendance_repository.dart';

/// Get current active shift for a user
///
/// Returns the currently active shift if any
class GetCurrentShift {
  final AttendanceRepository _repository;

  GetCurrentShift(this._repository);

  Future<Map<String, dynamic>?> call({
    required String userId,
    required String storeId,
  }) {
    return _repository.getCurrentShift(
      userId: userId,
      storeId: storeId,
    );
  }
}
