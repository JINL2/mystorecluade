import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/supply_chain_datasource.dart';
import '../data/repositories/supply_chain_repository_impl.dart';
import '../domain/repositories/supply_chain_repository.dart';

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Supply Chain DataSource Provider
final supplyChainDatasourceProvider = Provider<SupplyChainDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupplyChainDatasource(client);
});

/// Supply Chain Repository Provider
final supplyChainRepositoryProvider = Provider<SupplyChainRepository>((ref) {
  final datasource = ref.watch(supplyChainDatasourceProvider);
  return SupplyChainRepositoryImpl(datasource);
});
