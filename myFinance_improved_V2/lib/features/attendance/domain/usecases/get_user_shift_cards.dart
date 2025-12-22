import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/shift_card.dart';
import '../repositories/attendance_repository.dart';

/// Get user shift cards for the month
///
/// Matches RPC: user_shift_cards_v6
/// v6: storeId optional - null이면 회사 전체 조회
///
/// Clean Architecture: Returns Either<Failure, List<ShiftCard>>
class GetUserShiftCards {
  final AttendanceRepository _repository;

  GetUserShiftCards(this._repository);

  Future<Either<Failure, List<ShiftCard>>> call({
    required String requestTime,
    required String userId,
    required String companyId,
    String? storeId, // Optional: null이면 회사 전체
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
