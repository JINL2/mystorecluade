import '../entities/monthly_shift_status.dart';
import '../repositories/attendance_repository.dart';

/// Get monthly shift status for user view (strongly typed)
///
/// Matches RPC: get_monthly_shift_status
class GetMonthlyShiftStatus {
  final AttendanceRepository _repository;

  GetMonthlyShiftStatus(this._repository);

  Future<List<MonthlyShiftStatus>> call({
    required String storeId,
    required String userId,
    required String requestDate,
  }) {
    return _repository.getMonthlyShiftStatus(
      storeId: storeId,
      userId: userId,
      requestDate: requestDate,
    );
  }
}
