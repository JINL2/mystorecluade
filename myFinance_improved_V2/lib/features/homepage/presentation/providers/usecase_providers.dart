/// Use Case Providers for homepage module
///
/// This file contains all use case providers for the homepage feature.
/// Following Clean Architecture - providers belong in presentation layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/usecases/auto_select_company_store.dart';
import '../../domain/usecases/create_company.dart';
import '../../domain/usecases/create_store.dart';
import '../../domain/usecases/get_company_currency_types.dart';
import '../../domain/usecases/join_by_code.dart';

// ============================================================================
// Company Use Cases
// ============================================================================

/// Create Company Use Case provider
final createCompanyUseCaseProvider = Provider<CreateCompany>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return CreateCompany(repository);
});

/// Get Company Types and Currencies Use Case provider
final getCompanyCurrencyTypesUseCaseProvider = Provider<GetCompanyCurrencyTypes>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return GetCompanyCurrencyTypes(repository);
});

// ============================================================================
// Store Use Cases
// ============================================================================

/// Create Store Use Case provider
final createStoreUseCaseProvider = Provider<CreateStore>((ref) {
  final repository = ref.watch(storeRepositoryProvider);
  return CreateStore(repository);
});

// ============================================================================
// Join Use Cases
// ============================================================================

/// Join By Code Use Case provider
final joinByCodeUseCaseProvider = Provider<JoinByCode>((ref) {
  final repository = ref.watch(joinRepositoryProvider);
  return JoinByCode(repository);
});

// ============================================================================
// Selection Use Cases
// ============================================================================

