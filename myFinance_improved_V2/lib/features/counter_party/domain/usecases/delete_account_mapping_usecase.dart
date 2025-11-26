import '../repositories/account_mapping_repository.dart';

/// UseCase: Delete Account Mapping
///
/// Soft deletes an account mapping.
class DeleteAccountMappingUseCase {
  final AccountMappingRepository repository;

  DeleteAccountMappingUseCase(this.repository);

  /// Execute the use case
  Future<bool> call({
    required String mappingId,
  }) async {
    return await repository.deleteAccountMapping(
      mappingId: mappingId,
    );
  }
}
