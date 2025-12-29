import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../di/counter_party_providers.dart';
import '../../domain/entities/account_mapping.dart';

part 'account_mapping_providers.g.dart';

// ============================================================================
// Account Mappings List Provider
// ============================================================================

/// Provider for fetching account mappings for a counterparty
@riverpod
Future<List<AccountMapping>> accountMappings(
  AccountMappingsRef ref,
  String counterpartyId,
) async {
  final useCase = ref.watch(getAccountMappingsUseCaseProvider);
  return await useCase(counterpartyId: counterpartyId);
}

// ============================================================================
// Available Accounts Provider (for dropdowns)
// ============================================================================

/// Provider for fetching available accounts for mapping
@riverpod
Future<List<Map<String, dynamic>>> availableAccounts(
  AvailableAccountsRef ref,
  String companyId,
) async {
  final repository = ref.watch(accountMappingRepositoryProvider);
  return await repository.getAvailableAccounts(companyId: companyId);
}

// ============================================================================
// Linked Company Info Provider
// ============================================================================

/// Provider for fetching linked company information
@riverpod
Future<Map<String, dynamic>?> linkedCompanyInfo(
  LinkedCompanyInfoRef ref,
  String counterpartyId,
) async {
  final repository = ref.watch(accountMappingRepositoryProvider);
  return await repository.getLinkedCompanyInfo(counterpartyId: counterpartyId);
}

// ============================================================================
// Linked Company Accounts Provider
// ============================================================================

/// Provider for fetching available accounts for the linked company
@riverpod
Future<List<Map<String, dynamic>>> linkedCompanyAccounts(
  LinkedCompanyAccountsRef ref,
  String linkedCompanyId,
) async {
  final repository = ref.watch(accountMappingRepositoryProvider);
  return await repository.getAvailableAccounts(companyId: linkedCompanyId);
}

// ============================================================================
// Create Account Mapping Provider
// ============================================================================

/// Provider for creating a new account mapping
@riverpod
Future<AccountMapping> createAccountMapping(
  CreateAccountMappingRef ref,
  CreateAccountMappingParams params,
) async {
  final useCase = ref.watch(createAccountMappingUseCaseProvider);

  final result = await useCase(
    myCompanyId: params.myCompanyId,
    myAccountId: params.myAccountId,
    counterpartyId: params.counterpartyId,
    linkedAccountId: params.linkedAccountId,
    direction: params.direction,
    createdBy: params.createdBy,
  );

  // Invalidate the list to refresh
  ref.invalidate(accountMappingsProvider(params.counterpartyId));

  return result;
}

// ============================================================================
// Delete Account Mapping Provider
// ============================================================================

/// Provider for deleting an account mapping
@riverpod
Future<bool> deleteAccountMapping(
  DeleteAccountMappingRef ref,
  DeleteAccountMappingParams params,
) async {
  final useCase = ref.watch(deleteAccountMappingUseCaseProvider);

  final result = await useCase(mappingId: params.mappingId);

  // Invalidate the list to refresh
  ref.invalidate(accountMappingsProvider(params.counterpartyId));

  return result;
}

// ============================================================================
// Parameter Classes (for @riverpod with multiple params)
// ============================================================================

class CreateAccountMappingParams {
  final String myCompanyId;
  final String myAccountId;
  final String counterpartyId;
  final String linkedAccountId;
  final String direction;
  final String? createdBy;

  const CreateAccountMappingParams({
    required this.myCompanyId,
    required this.myAccountId,
    required this.counterpartyId,
    required this.linkedAccountId,
    required this.direction,
    this.createdBy,
  });
}

class DeleteAccountMappingParams {
  final String mappingId;
  final String counterpartyId;

  const DeleteAccountMappingParams({
    required this.mappingId,
    required this.counterpartyId,
  });
}
