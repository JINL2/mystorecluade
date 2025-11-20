import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/counter_party_data_source.dart';
import '../data/repositories/counter_party_repository_impl.dart';
import '../domain/repositories/counter_party_repository.dart';
import '../domain/usecases/calculate_counter_party_stats.dart';
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
