// lib/features/sales_invoice/di/sales_invoice_providers.dart
//
// Centralized Dependency Injection for sales_invoice feature
// All DataSource, Repository providers in one place
// Following Clean Architecture 2025 with @riverpod

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Layer
import '../data/datasources/invoice_remote_datasource.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/repositories/invoice_repository_impl.dart';
import '../data/repositories/product_repository_impl.dart';
import '../data/repositories/sales_journal_repository_impl.dart';

// Domain Layer
import '../domain/repositories/invoice_repository.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/repositories/sales_journal_repository.dart';
import '../domain/usecases/create_invoice_usecase.dart';
import '../domain/usecases/create_sales_journal_usecase.dart';
import '../domain/usecases/get_cash_locations_usecase.dart';
import '../domain/usecases/get_currency_data_usecase.dart';
import '../domain/usecases/get_invoice_list_usecase.dart';

part 'sales_invoice_providers.g.dart';

// ============================================================================
// TIER 1: INFRASTRUCTURE - External Dependencies
// ============================================================================

/// Supabase Client Provider
/// Singleton instance for all database operations
@riverpod
SupabaseClient salesInvoiceSupabaseClient(Ref ref) {
  return Supabase.instance.client;
}

// ============================================================================
// TIER 2: DATA SOURCES - Database Communication
// ============================================================================

/// Invoice Remote DataSource
/// Handles all invoice-related Supabase operations
@riverpod
InvoiceRemoteDataSource invoiceRemoteDataSource(Ref ref) {
  final client = ref.watch(salesInvoiceSupabaseClientProvider);
  return InvoiceRemoteDataSource(client);
}

/// Product Remote DataSource
/// Handles all product-related Supabase operations
@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  final client = ref.watch(salesInvoiceSupabaseClientProvider);
  return ProductRemoteDataSource(client);
}

// ============================================================================
// TIER 3: REPOSITORIES - Domain Interface Implementations
// ============================================================================

/// Invoice Repository
/// Implements domain InvoiceRepository interface
@riverpod
InvoiceRepository invoiceRepository(Ref ref) {
  final dataSource = ref.watch(invoiceRemoteDataSourceProvider);
  return InvoiceRepositoryImpl(dataSource);
}

/// Product Repository
/// Implements domain ProductRepository interface
@riverpod
ProductRepository productRepository(Ref ref) {
  final dataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
}

/// Sales Journal Repository
/// Implements domain SalesJournalRepository interface
@riverpod
SalesJournalRepository salesJournalRepository(Ref ref) {
  final client = ref.watch(salesInvoiceSupabaseClientProvider);
  return SalesJournalRepositoryImpl(client);
}

// ============================================================================
// TIER 4: USE CASES - Business Logic
// ============================================================================

/// Get Currency Data UseCase
@riverpod
GetCurrencyDataUseCase getCurrencyDataUseCase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetCurrencyDataUseCase(repository: repository);
}

/// Get Cash Locations UseCase
@riverpod
GetCashLocationsUseCase getCashLocationsUseCase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetCashLocationsUseCase(repository: repository);
}

/// Create Sales Journal UseCase
@riverpod
CreateSalesJournalUseCase createSalesJournalUseCase(Ref ref) {
  final repository = ref.watch(salesJournalRepositoryProvider);
  return CreateSalesJournalUseCase(repository: repository);
}

/// Get Invoice List UseCase
@riverpod
GetInvoiceListUseCase getInvoiceListUseCase(Ref ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return GetInvoiceListUseCase(invoiceRepository: repository);
}

/// Create Invoice UseCase
@riverpod
CreateInvoiceUseCase createInvoiceUseCase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return CreateInvoiceUseCase(productRepository: repository);
}
