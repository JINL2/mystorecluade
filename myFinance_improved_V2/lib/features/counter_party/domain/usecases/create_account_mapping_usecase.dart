import '../entities/account_mapping.dart';
import '../repositories/account_mapping_repository.dart';

/// UseCase: Create Account Mapping
///
/// Creates a new account mapping with validation.
class CreateAccountMappingUseCase {
  final AccountMappingRepository repository;

  CreateAccountMappingUseCase(this.repository);

  /// Execute the use case
  /// V1 RPC handles duplicate checking, so we don't need to check here
  Future<AccountMapping> call({
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
    required String linkedAccountId,
    String direction = 'bidirectional',
    String? createdBy,
  }) async {
    return await repository.createAccountMapping(
      myCompanyId: myCompanyId,
      myAccountId: myAccountId,
      counterpartyId: counterpartyId,
      linkedAccountId: linkedAccountId,
      direction: direction,
      createdBy: createdBy,
    );
  }
}
