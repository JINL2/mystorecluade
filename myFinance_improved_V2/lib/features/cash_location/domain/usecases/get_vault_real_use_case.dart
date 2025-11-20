import '../entities/vault_real_entry.dart';
import '../repositories/cash_location_repository.dart';
import '../value_objects/vault_real_params.dart';
import 'use_case.dart';

/// Use case for getting vault real entries
class GetVaultRealUseCase implements UseCase<List<VaultRealEntry>, VaultRealParams> {
  final CashLocationRepository repository;

  GetVaultRealUseCase(this.repository);

  @override
  Future<List<VaultRealEntry>> call(VaultRealParams params) async {
    return repository.getVaultReal(
      companyId: params.companyId,
      storeId: params.storeId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
