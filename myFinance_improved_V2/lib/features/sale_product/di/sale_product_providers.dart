import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/sales_product_remote_datasource.dart';
import '../data/repositories/sales_product_repository_impl.dart';
import '../domain/repositories/sales_product_repository.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Remote data source provider (internal - not exposed to presentation)
final _salesProductRemoteDataSourceProvider = Provider<SalesProductRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SalesProductRemoteDataSource(client);
});

/// Repository provider - exposes only the Domain interface
final salesProductRepositoryProvider = Provider<SalesProductRepository>((ref) {
  final dataSource = ref.watch(_salesProductRemoteDataSourceProvider);
  return SalesProductRepositoryImpl(dataSource);
});
