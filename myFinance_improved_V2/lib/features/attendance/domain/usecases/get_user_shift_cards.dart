import '../entities/shift_card.dart';
import '../repositories/attendance_repository.dart';

/// Get user shift cards for the month
///
/// Matches RPC: user_shift_cards_v6
/// v6: storeId optional - null이면 회사 전체 조회
class GetUserShiftCards {
  final AttendanceRepository _repository;

  GetUserShiftCards(this._repository);

  Future<List<ShiftCard>> call({
    required String requestTime,
    required String userId,
    required String companyId,
    String? storeId,  // Optional: null이면 회사 전체
    required String timezone,
  }) {
    return _repository.getUserShiftCards(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );
  }
}
