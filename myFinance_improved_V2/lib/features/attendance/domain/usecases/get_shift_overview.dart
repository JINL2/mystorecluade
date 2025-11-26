import '../entities/shift_overview.dart';
import '../repositories/attendance_repository.dart';

/// Get user shift overview for the month
///
/// Matches RPC: user_shift_overview
class GetShiftOverview {
  final AttendanceRepository _repository;

  GetShiftOverview(this._repository);

  Future<ShiftOverview> call({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  }) {
    return _repository.getUserShiftOverview(
      requestDate: requestDate,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
    );
  }
}
