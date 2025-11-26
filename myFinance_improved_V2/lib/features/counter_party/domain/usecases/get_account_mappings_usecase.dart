import '../entities/account_mapping.dart';
import '../repositories/account_mapping_repository.dart';

/// UseCase: Get Account Mappings
///
/// Retrieves all account mappings for a specific counterparty with enriched display data.
class GetAccountMappingsUseCase {
  final AccountMappingRepository repository;

  GetAccountMappingsUseCase(this.repository);

  /// Execute the use case
  Future<List<AccountMapping>> call({
    required String counterpartyId,
  }) async {
    return await repository.getAccountMappings(
      counterpartyId: counterpartyId,
    );
  }
}
