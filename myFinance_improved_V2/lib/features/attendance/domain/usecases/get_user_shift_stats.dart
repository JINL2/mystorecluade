import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_shift_stats.dart';
import '../repositories/attendance_repository.dart';

/// Get user shift statistics for Stats tab
///
/// Matches RPC: user_shift_stats
///
/// Clean Architecture: Returns Either<Failure, UserShiftStats>
class GetUserShiftStats {
  final AttendanceRepository _repository;

  GetUserShiftStats(this._repository);

  Future<Either<Failure, UserShiftStats>> call({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) {
    return _repository.getUserShiftStats(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );
  }
}
