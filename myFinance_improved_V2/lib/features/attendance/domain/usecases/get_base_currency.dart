import '../entities/base_currency.dart';
import '../repositories/attendance_repository.dart';

/// Get base currency for a company
///
/// Matches RPC: get_base_currency
class GetBaseCurrency {
  final AttendanceRepository _repository;

  GetBaseCurrency(this._repository);

  Future<BaseCurrency> call({
    required String companyId,
  }) {
    return _repository.getBaseCurrency(
      companyId: companyId,
    );
  }
}
