import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/account_mapping_datasource.dart';
import '../data/datasources/counter_party_data_source.dart';
import '../data/repositories/account_mapping_repository_impl.dart';
import '../data/repositories/counter_party_repository_impl.dart';
import '../domain/repositories/account_mapping_repository.dart';
import '../domain/repositories/counter_party_repository.dart';
import '../domain/usecases/calculate_counter_party_stats.dart';
import '../domain/usecases/create_account_mapping_usecase.dart';
import '../domain/usecases/delete_account_mapping_usecase.dart';
import '../domain/usecases/get_account_mappings_usecase.dart';
import '../domain/usecases/sort_counter_parties.dart';

// ============================================================================
// Infrastructure Providers (Data Layer Dependencies)
// ============================================================================

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Data source provider
final counterPartyDataSourceProvider = Provider<CounterPartyDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CounterPartyDataSource(client);
});

/// Repository provider (implements Domain interface)
final counterPartyRepositoryProvider = Provider<CounterPartyRepository>((ref) {
  final dataSource = ref.watch(counterPartyDataSourceProvider);
  return CounterPartyRepositoryImpl(dataSource);
});

// ============================================================================
// Domain UseCases
// ============================================================================

/// UseCase: Calculate counter party statistics
final calculateCounterPartyStatsProvider = Provider<CalculateCounterPartyStats>((ref) {
  return CalculateCounterPartyStats();
});

/// UseCase: Sort counter parties
final sortCounterPartiesProvider = Provider<SortCounterParties>((ref) {
  return SortCounterParties();
});

// ============================================================================
// Account Mapping Providers
// ============================================================================

/// Account Mapping Data Source Provider
final accountMappingDataSourceProvider = Provider<AccountMappingDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AccountMappingDataSource(client);
});

/// Account Mapping Repository Provider
final accountMappingRepositoryProvider = Provider<AccountMappingRepository>((ref) {
  final dataSource = ref.watch(accountMappingDataSourceProvider);
  return AccountMappingRepositoryImpl(dataSource);
});

/// UseCase: Get Account Mappings
final getAccountMappingsUseCaseProvider = Provider<GetAccountMappingsUseCase>((ref) {
  final repository = ref.watch(accountMappingRepositoryProvider);
  return GetAccountMappingsUseCase(repository);
});

/// UseCase: Create Account Mapping
final createAccountMappingUseCaseProvider = Provider<CreateAccountMappingUseCase>((ref) {
  final repository = ref.watch(accountMappingRepositoryProvider);
  return CreateAccountMappingUseCase(repository);
});

/// UseCase: Delete Account Mapping
final deleteAccountMappingUseCaseProvider = Provider<DeleteAccountMappingUseCase>((ref) {
  final repository = ref.watch(accountMappingRepositoryProvider);
  return DeleteAccountMappingUseCase(repository);
});
