import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/sales_datasource.dart';
import '../../data/repositories/sales_repository_impl.dart';
import '../../domain/repositories/sales_repository.dart';

part 'sales_di_provider.g.dart';

/// Supabase Client Provider
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Sales Datasource Provider
@riverpod
SalesDatasource salesDatasource(Ref ref) {
  return SalesDatasource(ref.watch(supabaseClientProvider));
}

/// Sales Repository Provider
@riverpod
SalesRepository salesRepository(Ref ref) {
  return SalesRepositoryImpl(ref.watch(salesDatasourceProvider));
}
