// lib/features/cash_ending/di/injection.dart
//
// Dependency Injection Container for Cash Ending Feature
//
// This file is in a separate DI layer to maintain Clean Architecture:
// - Presentation should NOT import Data layer directly
// - This file handles the wiring of implementations to interfaces

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/bank_remote_datasource.dart';
import '../data/datasources/cash_ending_remote_datasource.dart';
import '../data/datasources/currency_remote_datasource.dart';
import '../data/datasources/journal_remote_datasource.dart';
import '../data/datasources/location_remote_datasource.dart';
import '../data/datasources/stock_flow_remote_datasource.dart';
import '../data/datasources/vault_remote_datasource.dart';
import '../data/repositories/bank_repository_impl.dart';
import '../data/repositories/cash_ending_repository_impl.dart';
import '../data/repositories/currency_repository_impl.dart';
import '../data/repositories/journal_repository_impl.dart';
import '../data/repositories/location_repository_impl.dart';
import '../data/repositories/stock_flow_repository_impl.dart';
import '../data/repositories/vault_repository_impl.dart';
import '../domain/repositories/bank_repository.dart';
import '../domain/repositories/cash_ending_repository.dart';
import '../domain/repositories/currency_repository.dart';
import '../domain/repositories/journal_repository.dart';
import '../domain/repositories/location_repository.dart';
import '../domain/repositories/stock_flow_repository.dart';
import '../domain/repositories/vault_repository.dart';
import '../domain/usecases/create_error_adjustment_usecase.dart';
import '../domain/usecases/create_foreign_currency_translation_usecase.dart';
import '../domain/usecases/get_stock_flows_usecase.dart';
import '../domain/usecases/load_currencies_usecase.dart';
import '../domain/usecases/load_locations_usecase.dart';
import '../domain/usecases/load_recent_cash_endings_usecase.dart';
import '../domain/usecases/load_stores_usecase.dart';
import '../domain/usecases/save_cash_ending_usecase.dart';
import '../domain/usecases/select_store_usecase.dart';

// ============================================================================
// DATA SOURCES
// ============================================================================

/// Provider for Cash Ending Remote Data Source
final cashEndingRemoteDataSourceProvider = Provider<CashEndingRemoteDataSource>((ref) {
  return CashEndingRemoteDataSource();
});

/// Provider for Location Remote Data Source
final locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSource();
});

/// Provider for Currency Remote Data Source
final currencyRemoteDataSourceProvider = Provider<CurrencyRemoteDataSource>((ref) {
  return CurrencyRemoteDataSource();
});

/// Provider for Stock Flow Remote Data Source
final stockFlowRemoteDataSourceProvider = Provider<StockFlowRemoteDataSource>((ref) {
  return StockFlowRemoteDataSource();
});

/// Provider for Bank Remote Data Source
final bankRemoteDataSourceProvider = Provider<BankRemoteDataSource>((ref) {
  return BankRemoteDataSource();
});

/// Provider for Vault Remote Data Source
final vaultRemoteDataSourceProvider = Provider<VaultRemoteDataSource>((ref) {
  return VaultRemoteDataSource();
});

/// Provider for Journal Remote Data Source
final journalRemoteDataSourceProvider = Provider<JournalRemoteDataSource>((ref) {
  return JournalRemoteDataSource();
});

// ============================================================================
// REPOSITORIES (Domain Interfaces → Data Implementations)
// ============================================================================

/// Provider for Cash Ending Repository
final cashEndingRepositoryProvider = Provider<CashEndingRepository>((ref) {
  final dataSource = ref.watch(cashEndingRemoteDataSourceProvider);
  return CashEndingRepositoryImpl(remoteDataSource: dataSource);
});

/// Provider for Location Repository
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final dataSource = ref.watch(locationRemoteDataSourceProvider);
  return LocationRepositoryImpl(remoteDataSource: dataSource);
});

/// Provider for Currency Repository
final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  final dataSource = ref.watch(currencyRemoteDataSourceProvider);
  return CurrencyRepositoryImpl(remoteDataSource: dataSource);
});

/// Provider for Stock Flow Repository
final stockFlowRepositoryProvider = Provider<StockFlowRepository>((ref) {
  final dataSource = ref.watch(stockFlowRemoteDataSourceProvider);
  return StockFlowRepositoryImpl(dataSource);
});

/// Provider for Bank Repository
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  final dataSource = ref.watch(bankRemoteDataSourceProvider);
  final cashEndingDataSource = ref.watch(cashEndingRemoteDataSourceProvider);
  return BankRepositoryImpl(
    remoteDataSource: dataSource,
    cashEndingDataSource: cashEndingDataSource,
  );
});

/// Provider for Vault Repository
final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final dataSource = ref.watch(vaultRemoteDataSourceProvider);
  final cashEndingDataSource = ref.watch(cashEndingRemoteDataSourceProvider);
  return VaultRepositoryImpl(
    remoteDataSource: dataSource,
    cashEndingDataSource: cashEndingDataSource,
  );
});

/// Provider for Journal Repository
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final remoteDataSource = ref.watch(journalRemoteDataSourceProvider);
  return JournalRepositoryImpl(remoteDataSource: remoteDataSource);
});

// ============================================================================
// USE CASES (Domain Business Logic)
// ============================================================================

/// Provider for SelectStoreUseCase
final selectStoreUseCaseProvider = Provider<SelectStoreUseCase>((ref) {
  final locationRepository = ref.watch(locationRepositoryProvider);
  return SelectStoreUseCase(locationRepository);
});

/// Provider for LoadCurrenciesUseCase
final loadCurrenciesUseCaseProvider = Provider<LoadCurrenciesUseCase>((ref) {
  final currencyRepository = ref.watch(currencyRepositoryProvider);
  return LoadCurrenciesUseCase(currencyRepository);
});

/// Provider for SaveCashEndingUseCase
final saveCashEndingUseCaseProvider = Provider<SaveCashEndingUseCase>((ref) {
  final cashEndingRepository = ref.watch(cashEndingRepositoryProvider);
  return SaveCashEndingUseCase(cashEndingRepository);
});

/// Provider for GetStockFlowsUseCase
final getStockFlowsUseCaseProvider = Provider<GetStockFlowsUseCase>((ref) {
  final stockFlowRepository = ref.watch(stockFlowRepositoryProvider);
  return GetStockFlowsUseCase(stockFlowRepository);
});

/// Provider for LoadStoresUseCase
final loadStoresUseCaseProvider = Provider<LoadStoresUseCase>((ref) {
  final locationRepository = ref.watch(locationRepositoryProvider);
  return LoadStoresUseCase(locationRepository);
});

/// Provider for LoadLocationsUseCase
final loadLocationsUseCaseProvider = Provider<LoadLocationsUseCase>((ref) {
  final locationRepository = ref.watch(locationRepositoryProvider);
  return LoadLocationsUseCase(locationRepository);
});

/// Provider for LoadRecentCashEndingsUseCase
final loadRecentCashEndingsUseCaseProvider = Provider<LoadRecentCashEndingsUseCase>((ref) {
  final cashEndingRepository = ref.watch(cashEndingRepositoryProvider);
  return LoadRecentCashEndingsUseCase(cashEndingRepository);
});

/// Provider for CreateErrorAdjustmentUseCase
final errorAdjustmentUseCaseProvider = Provider<CreateErrorAdjustmentUseCase>((ref) {
  final repository = ref.watch(journalRepositoryProvider);
  return CreateErrorAdjustmentUseCase(repository);
});

/// Provider for CreateForeignCurrencyTranslationUseCase
final foreignCurrencyTranslationUseCaseProvider =
    Provider<CreateForeignCurrencyTranslationUseCase>((ref) {
  final repository = ref.watch(journalRepositoryProvider);
  return CreateForeignCurrencyTranslationUseCase(repository);
});
