import '../entities/monthly_shift_status.dart';
import '../repositories/attendance_repository.dart';

/// Get monthly shift status for manager view
///
/// Matches RPC: get_monthly_shift_status_manager_v2
class GetMonthlyShiftStatus {
  final AttendanceRepository _repository;

  GetMonthlyShiftStatus(this._repository);

  Future<List<MonthlyShiftStatus>> call({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) {
    return _repository.getMonthlyShiftStatusManager(
      storeId: storeId,
      companyId: companyId,
      requestTime: requestTime,
      timezone: timezone,
    );
  }
}
