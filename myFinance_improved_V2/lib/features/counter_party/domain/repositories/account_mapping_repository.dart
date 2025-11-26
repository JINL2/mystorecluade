import '../entities/account_mapping.dart';

/// Account Mapping Repository Interface
///
/// Defines operations for managing account mappings between internal companies.
abstract class AccountMappingRepository {
  /// Get all account mappings for a counterparty
  Future<List<AccountMapping>> getAccountMappings({
    required String counterpartyId,
  });

  /// Get a single account mapping by ID
  Future<AccountMapping?> getAccountMappingById({
    required String mappingId,
  });

  /// Create a new account mapping
  /// V1 uses 'bidirectional' as default direction
  Future<AccountMapping> createAccountMapping({
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
    required String linkedAccountId,
    String direction = 'bidirectional',
    String? createdBy,
  });

  /// Update an existing account mapping
  Future<AccountMapping> updateAccountMapping({
    required String mappingId,
    required String myAccountId,
    required String linkedAccountId,
    required String direction,
  });

  /// Delete (soft delete) an account mapping
  Future<bool> deleteAccountMapping({
    required String mappingId,
  });

  /// Check if an account mapping already exists
  Future<bool> mappingExists({
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
  });

  /// Get available accounts for mapping dropdown
  Future<List<Map<String, dynamic>>> getAvailableAccounts({
    required String companyId,
  });

  /// Get linked company info for the counterparty
  Future<Map<String, dynamic>?> getLinkedCompanyInfo({
    required String counterpartyId,
  });
}
