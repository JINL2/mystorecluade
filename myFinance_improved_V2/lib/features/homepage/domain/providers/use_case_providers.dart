/// Use Case Providers for homepage module
///
/// Provides dependency injection for use cases.
/// Following Clean Architecture pattern - Domain layer only depends on abstractions.
///
/// Import repositories through domain facade to maintain clean separation.
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../usecases/create_company.dart';
import '../usecases/create_store.dart';
import '../usecases/get_company_types.dart';
import '../usecases/get_currencies.dart';
import '../usecases/join_by_code.dart';
import 'repository_providers.dart';

// ============================================================================
// Company Use Case Providers
// ============================================================================

/// Create Company Use Case provider
final createCompanyUseCaseProvider = Provider<CreateCompany>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return CreateCompany(repository);
});

/// Get Company Types Use Case provider
final getCompanyTypesUseCaseProvider = Provider<GetCompanyTypes>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return GetCompanyTypes(repository);
});

/// Get Currencies Use Case provider
final getCurrenciesUseCaseProvider = Provider<GetCurrencies>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return GetCurrencies(repository);
});

// ============================================================================
// Store Use Case Providers
// ============================================================================

/// Create Store Use Case provider
final createStoreUseCaseProvider = Provider<CreateStore>((ref) {
  final repository = ref.watch(storeRepositoryProvider);
  return CreateStore(repository);
});

// ============================================================================
// Join Use Case Providers
// ============================================================================

/// Join By Code Use Case provider
final joinByCodeUseCaseProvider = Provider<JoinByCode>((ref) {
  final repository = ref.watch(joinRepositoryProvider);
  return JoinByCode(repository);
});
