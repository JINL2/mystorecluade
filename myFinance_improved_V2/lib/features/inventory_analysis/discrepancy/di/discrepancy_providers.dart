import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/discrepancy_datasource.dart';
import '../data/repositories/discrepancy_repository_impl.dart';
import '../domain/repositories/discrepancy_repository.dart';

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Discrepancy DataSource Provider
final discrepancyDatasourceProvider = Provider<DiscrepancyDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DiscrepancyDatasource(client);
});

/// Discrepancy Repository Provider
final discrepancyRepositoryProvider = Provider<DiscrepancyRepository>((ref) {
  final datasource = ref.watch(discrepancyDatasourceProvider);
  return DiscrepancyRepositoryImpl(datasource);
});
