import '../repositories/attendance_repository.dart';

/// Get monthly shift status for manager view
///
/// Matches RPC: get_monthly_shift_status_manager
class GetMonthlyShiftStatus {
  final AttendanceRepository _repository;

  GetMonthlyShiftStatus(this._repository);

  Future<List<Map<String, dynamic>>> call({
    required String storeId,
    required String companyId,
    required String requestDate,
  }) {
    return _repository.getMonthlyShiftStatusManager(
      storeId: storeId,
      companyId: companyId,
      requestDate: requestDate,
    );
  }
}
