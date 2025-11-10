import '../repositories/attendance_repository.dart';

/// Get user shift cards for the month
///
/// Matches RPC: user_shift_cards or get_my_shift_cards
class GetUserShiftCards {
  final AttendanceRepository _repository;

  GetUserShiftCards(this._repository);

  Future<List<Map<String, dynamic>>> call({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  }) {
    return _repository.getUserShiftCards(
      requestDate: requestDate,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
    );
  }
}
