import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/optimization_datasource.dart';
import '../data/repositories/optimization_repository_impl.dart';
import '../domain/repositories/optimization_repository.dart';

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Optimization DataSource Provider
final optimizationDatasourceProvider = Provider<OptimizationDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return OptimizationDatasource(client);
});

/// Optimization Repository Provider
final optimizationRepositoryProvider = Provider<OptimizationRepository>((ref) {
  final datasource = ref.watch(optimizationDatasourceProvider);
  return OptimizationRepositoryImpl(datasource);
});
