// lib/features/cash_ending/presentation/providers/repository_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/bank_remote_datasource.dart';
import '../../data/datasources/cash_ending_remote_datasource.dart';
import '../../data/datasources/currency_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/stock_flow_remote_datasource.dart';
import '../../data/datasources/vault_remote_datasource.dart';
import '../../data/repositories/bank_repository_impl.dart';
import '../../data/repositories/cash_ending_repository_impl.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/stock_flow_repository_impl.dart';
import '../../data/repositories/vault_repository_impl.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import '../../domain/repositories/vault_repository.dart';

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

/// Provider for Stock Flow Remote Data Source
final stockFlowRemoteDataSourceProvider = Provider<StockFlowRemoteDataSource>((ref) {
  return StockFlowRemoteDataSource();
});

/// Provider for Stock Flow Repository
final stockFlowRepositoryProvider = Provider<StockFlowRepository>((ref) {
  final dataSource = ref.watch(stockFlowRemoteDataSourceProvider);
  return StockFlowRepositoryImpl(dataSource);
});

/// Provider for Bank Remote Data Source
final bankRemoteDataSourceProvider = Provider<BankRemoteDataSource>((ref) {
  return BankRemoteDataSource();
});

/// Provider for Bank Repository
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  final dataSource = ref.watch(bankRemoteDataSourceProvider);
  return BankRepositoryImpl(remoteDataSource: dataSource);
});

/// Provider for Vault Remote Data Source
final vaultRemoteDataSourceProvider = Provider<VaultRemoteDataSource>((ref) {
  return VaultRemoteDataSource();
});

/// Provider for Vault Repository
final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  final dataSource = ref.watch(vaultRemoteDataSourceProvider);
  return VaultRepositoryImpl(remoteDataSource: dataSource);
});
