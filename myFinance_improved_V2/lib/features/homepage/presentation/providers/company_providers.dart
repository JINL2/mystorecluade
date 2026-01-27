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

/// Combined provider for company types and currencies
/// Fetches both data types in a single RPC call for efficiency.
final _companyCurrencyTypesProvider = FutureProvider<(List<CompanyType>, List<Currency>)>((ref) async {
  final getCompanyCurrencyTypes = ref.watch(getCompanyCurrencyTypesUseCaseProvider);
  final result = await getCompanyCurrencyTypes();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

/// Company Types FutureProvider for dropdown
///
/// Fetches company types for UI dropdown selection.
/// Derived from combined provider for single RPC efficiency.
final companyTypesProvider = FutureProvider<List<CompanyType>>((ref) async {
  final (companyTypes, _) = await ref.watch(_companyCurrencyTypesProvider.future);
  return companyTypes;
});

/// Currencies FutureProvider for dropdown
///
/// Fetches currencies for UI dropdown selection.
/// Derived from combined provider for single RPC efficiency.
final currenciesProvider = FutureProvider<List<Currency>>((ref) async {
  final (_, currencies) = await ref.watch(_companyCurrencyTypesProvider.future);
  return currencies;
});
