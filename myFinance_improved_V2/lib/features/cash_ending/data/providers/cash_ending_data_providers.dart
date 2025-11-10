// lib/features/cash_ending/domain/providers/repository_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Domain Layer - Repository Interfaces
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/vault_repository.dart';

// Data Layer - DataSources
import '../../data/datasources/cash_ending_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/currency_remote_datasource.dart';
import '../../data/datasources/stock_flow_remote_datasource.dart';
import '../../data/datasources/bank_remote_datasource.dart';
import '../../data/datasources/vault_remote_datasource.dart';

// Data Layer - Repository Implementations
import '../../data/repositories/cash_ending_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../data/repositories/stock_flow_repository_impl.dart';
import '../../data/repositories/bank_repository_impl.dart';
import '../../data/repositories/vault_repository_impl.dart';

/// Repository Providers for Cash Ending Module
///
/// Infrastructure layer that wires up dependencies.
/// This file belongs in infrastructure because it:
/// - Imports concrete implementations from data layer
/// - Creates instances with Supabase dependencies
/// - Provides dependency injection configuration
///
/// Clean Architecture layers:
/// - Domain: Interfaces (repositories, entities)
/// - Data: Implementations (datasources, repository impls, models)
/// - Infrastructure: Dependency wiring (THIS FILE)
/// - Presentation: UI and state management

// ============================================================================
// Internal Providers (Private - used only within this file)
// ============================================================================

/// Supabase Client Provider (Internal)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ============================================================================
// DataSource Providers (Internal)
// ============================================================================

/// Cash Ending DataSource Provider (Internal)
final _cashEndingRemoteDataSourceProvider = Provider<CashEndingRemoteDataSource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return CashEndingRemoteDataSource(client: client);
});

/// Location DataSource Provider (Internal)
final _locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return LocationRemoteDataSource(client: client);
});

/// Currency DataSource Provider (Internal)
final _currencyRemoteDataSourceProvider = Provider<CurrencyRemoteDataSource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return CurrencyRemoteDataSource(client: client);
});

/// Stock Flow DataSource Provider (Internal)
final _stockFlowRemoteDataSourceProvider = Provider<StockFlowRemoteDataSource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return StockFlowRemoteDataSource(client: client);
});

/// Bank DataSource Provider (Internal)
final _bankRemoteDataSourceProvider = Provider<BankRemoteDataSource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return BankRemoteDataSource(client: client);
});

/// Vault DataSource Provider (Internal)
final _vaultRemoteDataSourceProvider = Provider<VaultRemoteDataSource>((ref) {
  final client = ref.watch(_supabaseClientProvider);
  return VaultRemoteDataSource(client: client);
});

// ============================================================================
// Repository Providers (Public - Exposed to Presentation layer)
// ============================================================================

/// Cash Ending Repository Provider
///
/// Provides CashEndingRepositoryImpl implementation.
/// Presentation layer uses this through domain interface.
final cashEndingRepositoryProvider = Provider<CashEndingRepository>((ref) {
  final dataSource = ref.watch(_cashEndingRemoteDataSourceProvider);
  return CashEndingRepositoryImpl(remoteDataSource: dataSource);
});

/// Location Repository Provider
///
/// Provides LocationRepositoryImpl implementation.
/// Presentation layer uses this through domain interface.
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final dataSource = ref.watch(_locationRemoteDataSourceProvider);
  return LocationRepositoryImpl(remoteDataSource: dataSource);
});

/// Currency Repository Provider
///
/// Provides CurrencyRepositoryImpl implementation.
/// Presentation layer uses this through domain interface.
final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final dataSource = ref.watch(_currencyRemoteDataSourceProvider);
  return CurrencyRepositoryImpl(remoteDataSource: dataSource);
});

/// Stock Flow Repository Provider
///
/// Provides StockFlowRepositoryImpl implementation.
/// Presentation layer uses this through domain interface.
final stockFlowRepositoryProvider = Provider<StockFlowRepository>((ref) {
  final dataSource = ref.watch(_stockFlowRemoteDataSourceProvider);
  return StockFlowRepositoryImpl(dataSource);
});

/// Bank Repository Provider
///
/// Provides BankRepositoryImpl implementation.
/// Presentation layer uses this through domain interface.
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  final dataSource = ref.watch(_bankRemoteDataSourceProvider);
  return BankRepositoryImpl(remoteDataSource: dataSource);
});

/// Vault Repository Provider
///
/// Provides VaultRepositoryImpl implementation.
/// Presentation layer uses this through domain interface.
final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final dataSource = ref.watch(_vaultRemoteDataSourceProvider);
  return VaultRepositoryImpl(remoteDataSource: dataSource);
});
