import '../entities/cash_real_entry.dart';
import '../repositories/cash_location_repository.dart';
import '../value_objects/cash_real_params.dart';
import 'use_case.dart';

/// Use case for getting cash real entries
class GetCashRealUseCase implements UseCase<List<CashRealEntry>, CashRealParams> {
  final CashLocationRepository repository;

  GetCashRealUseCase(this.repository);

  @override
  Future<List<CashRealEntry>> call(CashRealParams params) async {
    return repository.getCashReal(
      companyId: params.companyId,
      storeId: params.storeId,
      locationType: params.locationType,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
