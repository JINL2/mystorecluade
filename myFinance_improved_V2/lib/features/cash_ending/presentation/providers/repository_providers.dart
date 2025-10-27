// lib/features/cash_ending/presentation/providers/repository_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import '../../data/repositories/cash_ending_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../data/repositories/stock_flow_repository_impl.dart';
import '../../data/datasources/cash_ending_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/currency_remote_datasource.dart';
import '../../data/datasources/stock_flow_remote_datasource.dart';

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
