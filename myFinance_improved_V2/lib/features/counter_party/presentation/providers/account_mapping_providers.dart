import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/counter_party_providers.dart';
import '../../domain/entities/account_mapping.dart';

// ============================================================================
// Account Mappings List Provider
// ============================================================================

/// Provider for fetching account mappings for a counterparty
final accountMappingsProvider =
    FutureProvider.family<List<AccountMapping>, String>((ref, counterpartyId) async {
  final useCase = ref.watch(getAccountMappingsUseCaseProvider);

  return await useCase(counterpartyId: counterpartyId);
});

// ============================================================================
// Available Accounts Provider (for dropdowns)
// ============================================================================

/// Provider for fetching available accounts for mapping
final availableAccountsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, companyId) async {
  final repository = ref.watch(accountMappingRepositoryProvider);

  return await repository.getAvailableAccounts(companyId: companyId);
});

// ============================================================================
// Linked Company Info Provider
// ============================================================================

/// Provider for fetching linked company information
final linkedCompanyInfoProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, counterpartyId) async {
  final repository = ref.watch(accountMappingRepositoryProvider);

  return await repository.getLinkedCompanyInfo(counterpartyId: counterpartyId);
});

// ============================================================================
// Linked Company Accounts Provider
// ============================================================================

/// Provider for fetching available accounts for the linked company
final linkedCompanyAccountsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, linkedCompanyId) async {
  final repository = ref.watch(accountMappingRepositoryProvider);

  return await repository.getAvailableAccounts(companyId: linkedCompanyId);
});

// ============================================================================
// Create Account Mapping Provider
// ============================================================================

/// Provider for creating a new account mapping
final createAccountMappingProvider = FutureProvider.family<
    AccountMapping,
    ({
      String myCompanyId,
      String myAccountId,
      String counterpartyId,
      String linkedAccountId,
      String direction,
      String? createdBy,
    })>((ref, params) async {
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
});

// ============================================================================
// Delete Account Mapping Provider
// ============================================================================

/// Provider for deleting an account mapping
final deleteAccountMappingProvider = FutureProvider.family<
    bool,
    ({
      String mappingId,
      String counterpartyId,
    })>((ref, params) async {
  final useCase = ref.watch(deleteAccountMappingUseCaseProvider);

  final result = await useCase(mappingId: params.mappingId);

  // Invalidate the list to refresh
  ref.invalidate(accountMappingsProvider(params.counterpartyId));

  return result;
});
