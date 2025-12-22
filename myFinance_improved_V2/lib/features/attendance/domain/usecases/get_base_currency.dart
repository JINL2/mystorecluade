import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/base_currency.dart';
import '../repositories/attendance_repository.dart';

/// Get base currency for a company
///
/// Matches RPC: get_base_currency
///
/// ✅ Clean Architecture: Returns Either<Failure, BaseCurrency>
class GetBaseCurrency {
  final AttendanceRepository _repository;

  GetBaseCurrency(this._repository);

  Future<Either<Failure, BaseCurrency>> call({
    required String companyId,
  }) {
    return _repository.getBaseCurrency(
      companyId: companyId,
    );
  }
}
