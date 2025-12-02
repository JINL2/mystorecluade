/// UseCase providers for sales invoice
///
/// Provides UseCase instances with proper dependency injection.
/// This follows Clean Architecture by separating business logic (UseCases)
/// from presentation concerns (Providers/Notifiers).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_invoice_usecase.dart';
import '../../domain/usecases/create_sales_journal_usecase.dart';
import '../../domain/usecases/get_cash_locations_usecase.dart';
import '../../domain/usecases/get_currency_data_usecase.dart';
import '../../domain/usecases/get_invoice_list_usecase.dart';
import '../../domain/usecases/get_product_list_usecase.dart';
import '../../domain/usecases/get_products_for_sales_usecase.dart';
import 'invoice_providers.dart';
import 'product_providers.dart';
import 'sales_journal_providers.dart';

// ============================================================================
// UseCase Providers
// ============================================================================

/// Get products for sales use case provider
final getProductsForSalesUseCaseProvider = Provider<GetProductsForSalesUseCase>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return GetProductsForSalesUseCase(repository: repository);
});

/// Get currency data use case provider
final getCurrencyDataUseCaseProvider = Provider<GetCurrencyDataUseCase>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return GetCurrencyDataUseCase(repository: repository);
});

/// Get cash locations use case provider
final getCashLocationsUseCaseProvider = Provider<GetCashLocationsUseCase>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return GetCashLocationsUseCase(repository: repository);
});

/// Create sales journal use case provider
final createSalesJournalUseCaseProvider = Provider<CreateSalesJournalUseCase>((ref) {
  final repository = ref.read(salesJournalRepositoryProvider);
  return CreateSalesJournalUseCase(repository: repository);
});

/// Get invoice list use case provider
final getInvoiceListUseCaseProvider = Provider<GetInvoiceListUseCase>((ref) {
  final repository = ref.read(invoiceRepositoryProvider);
  return GetInvoiceListUseCase(invoiceRepository: repository);
});

/// Get product list use case provider
final getProductListUseCaseProvider = Provider<GetProductListUseCase>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return GetProductListUseCase(productRepository: repository);
});

/// Create invoice use case provider
final createInvoiceUseCaseProvider = Provider<CreateInvoiceUseCase>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return CreateInvoiceUseCase(productRepository: repository);
});
