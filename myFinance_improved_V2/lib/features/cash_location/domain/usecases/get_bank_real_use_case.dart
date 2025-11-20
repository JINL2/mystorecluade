import '../entities/bank_real_entry.dart';
import '../repositories/cash_location_repository.dart';
import '../value_objects/bank_real_params.dart';
import 'use_case.dart';

/// Use case for getting bank real entries
class GetBankRealUseCase implements UseCase<List<BankRealEntry>, BankRealParams> {
  final CashLocationRepository repository;

  GetBankRealUseCase(this.repository);

  @override
  Future<List<BankRealEntry>> call(BankRealParams params) async {
    return repository.getBankReal(
      companyId: params.companyId,
      storeId: params.storeId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
