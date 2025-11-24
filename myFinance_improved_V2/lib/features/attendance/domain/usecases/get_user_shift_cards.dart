import '../entities/shift_card.dart';
import '../repositories/attendance_repository.dart';

/// Get user shift cards for the month
///
/// Matches RPC: user_shift_cards_v2
class GetUserShiftCards {
  final AttendanceRepository _repository;

  GetUserShiftCards(this._repository);

  Future<List<ShiftCard>> call({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
  }) {
    return _repository.getUserShiftCards(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
    );
  }
}
