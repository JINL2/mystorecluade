import '../repositories/attendance_repository.dart';

/// Get monthly shift status as raw JSON for UI display
///
/// Returns the raw nested structure from RPC without entity conversion.
/// Use when UI needs to access the nested shifts array directly.
class GetMonthlyShiftStatusRaw {
  final AttendanceRepository _repository;

  GetMonthlyShiftStatusRaw(this._repository);

  Future<List<Map<String, dynamic>>> call({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) {
    return _repository.getMonthlyShiftStatusRaw(
      storeId: storeId,
      companyId: companyId,
      requestTime: requestTime,
      timezone: timezone,
    );
  }
}
