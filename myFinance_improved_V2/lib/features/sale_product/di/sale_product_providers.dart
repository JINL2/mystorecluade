import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Sources
import '../data/datasources/exchange_rate_datasource.dart';
import '../data/datasources/inventory_metadata_datasource.dart'
    hide InventoryMetadata, BrandMetadata, CategoryMetadata, ProductTypeMetadata,
    UnitMetadata, StatsMetadata, CurrencyMetadata, StoreInfoMetadata;
import '../data/datasources/payment_remote_datasource.dart';
import '../data/datasources/sales_product_remote_datasource.dart';

// Repository Implementations
import '../data/repositories/exchange_rate_repository_impl.dart';
import '../data/repositories/inventory_metadata_repository_impl.dart';
import '../data/repositories/payment_repository_impl.dart';
import '../data/repositories/sales_journal_repository_impl.dart';
import '../data/repositories/sales_product_repository_impl.dart';

// Domain Repository Interfaces
import '../domain/repositories/exchange_rate_repository.dart';
import '../domain/repositories/inventory_metadata_repository.dart';
import '../domain/repositories/payment_repository.dart';
import '../domain/repositories/sales_journal_repository.dart';
import '../domain/repositories/sales_product_repository.dart';

// ============================================================================
// Supabase Client Provider
// ============================================================================

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// Data Source Providers (Internal - not exposed to presentation)
// ============================================================================

/// Sales product remote data source provider
final _salesProductDataSourceProvider =
    Provider<SalesProductRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SalesProductRemoteDataSource(client);
});

/// Exchange rate data source provider
final _exchangeRateDataSourceProvider =
    Provider<ExchangeRateDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ExchangeRateDataSource(client);
});

/// Inventory metadata data source provider
final _inventoryMetadataDataSourceProvider =
    Provider<InventoryMetadataDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return InventoryMetadataDataSource(client);
});

/// Payment remote data source provider
final _paymentDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PaymentRemoteDataSource(client);
});

// ============================================================================
// Repository Providers - Expose only Domain interfaces
// ============================================================================

/// Sales product repository provider
final salesProductRepositoryProvider = Provider<SalesProductRepository>((ref) {
  final dataSource = ref.watch(_salesProductDataSourceProvider);
  return SalesProductRepositoryImpl(dataSource);
});

/// Exchange rate repository provider
final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  final dataSource = ref.watch(_exchangeRateDataSourceProvider);
  return ExchangeRateRepositoryImpl(dataSource);
});

/// Inventory metadata repository provider
final inventoryMetadataRepositoryProvider =
    Provider<InventoryMetadataRepository>((ref) {
  final dataSource = ref.watch(_inventoryMetadataDataSourceProvider);
  return InventoryMetadataRepositoryImpl(dataSource);
});

/// Payment repository provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dataSource = ref.watch(_paymentDataSourceProvider);
  return PaymentRepositoryImpl(dataSource);
});

/// Sales journal repository provider
final salesJournalRepositoryProvider = Provider<SalesJournalRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SalesJournalRepositoryImpl(client);
});
