/// Company Presentation Layer Providers
///
/// This file contains presentation-specific providers for company feature.
/// It only imports from Domain layer (Use Cases and Entities).
///
/// Following Clean Architecture:
/// - NO imports from Data layer
/// - Only Domain layer imports allowed
///
/// Note: companyNotifierProvider is defined in notifier_providers.dart
/// to keep all StateNotifier providers in one place.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company_type.dart';
import '../../domain/entities/currency.dart';
import 'usecase_providers.dart';

// ============================================================================
// Presentation Layer Providers (UI State Management)
// ============================================================================

/// Company Types FutureProvider for dropdown
///
/// Fetches company types for UI dropdown selection.
/// Uses GetCompanyTypes use case from domain layer.
final companyTypesProvider = FutureProvider<List<CompanyType>>((ref) async {
  final getCompanyTypes = ref.watch(getCompanyTypesUseCaseProvider);
  final result = await getCompanyTypes();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (companyTypes) => companyTypes,
  );
});

/// Currencies FutureProvider for dropdown
///
/// Fetches currencies for UI dropdown selection.
/// Uses GetCurrencies use case from domain layer.
final currenciesProvider = FutureProvider<List<Currency>>((ref) async {
  final getCurrencies = ref.watch(getCurrenciesUseCaseProvider);
  final result = await getCurrencies();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (currencies) => currencies,
  );
});
