/// UseCase providers for sale_product payment feature
///
/// Provides UseCase instances with proper dependency injection.
/// This follows Clean Architecture by separating business logic (UseCases)
/// from presentation concerns (Providers/Notifiers).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/sale_product_providers.dart';
import '../../domain/usecases/create_sales_journal_usecase.dart';
import '../../domain/usecases/get_cash_locations_usecase.dart';
import '../../domain/usecases/get_currency_data_usecase.dart';

// ============================================================================
// UseCase Providers
// ============================================================================

/// Get currency data use case provider
final getCurrencyDataUseCaseProvider = Provider<GetCurrencyDataUseCase>((ref) {
  final repository = ref.read(paymentRepositoryProvider);
  return GetCurrencyDataUseCase(repository: repository);
});

/// Get cash locations use case provider
final getCashLocationsUseCaseProvider = Provider<GetCashLocationsUseCase>((ref) {
  final repository = ref.read(paymentRepositoryProvider);
  return GetCashLocationsUseCase(repository: repository);
});

/// Create sales journal use case provider
final createSalesJournalUseCaseProvider = Provider<CreateSalesJournalUseCase>((ref) {
  final repository = ref.read(salesJournalRepositoryProvider);
  return CreateSalesJournalUseCase(repository: repository);
});
