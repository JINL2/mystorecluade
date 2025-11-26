import '../entities/shift_overview.dart';
import '../repositories/attendance_repository.dart';

/// Get user shift overview for the month
///
/// Matches RPC: user_shift_overview_v3
class GetShiftOverview {
  final AttendanceRepository _repository;

  GetShiftOverview(this._repository);

  Future<ShiftOverview> call({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) {
    return _repository.getUserShiftOverview(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );
  }
}
