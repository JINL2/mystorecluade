import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/invoice_remote_datasource.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../repositories/invoice_repository.dart';
import '../repositories/product_repository.dart';

/// Domain Repository Providers - Dependency Injection for sales_invoice module
///
/// Purpose: Repository providers for Clean Architecture compliance
/// - Provides concrete implementations from Data layer
/// - Presentation layer imports from Domain layer (this file)
/// - Maintains Clean Architecture dependency rules
///
/// Clean Architecture: DOMAIN LAYER - Dependency Injection
///
/// Usage: Import this file in Presentation layer

/// Supabase client provider (Internal)
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Invoice remote data source provider (Internal)
final _invoiceRemoteDataSourceProvider = Provider<InvoiceRemoteDataSource>((ref) {
  final client = ref.read(_supabaseClientProvider);
  return InvoiceRemoteDataSource(client);
});

/// Product remote data source provider (Internal)
final _productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  final client = ref.read(_supabaseClientProvider);
  return ProductRemoteDataSource(client);
});

/// Invoice repository provider
///
/// Provides InvoiceRepositoryImpl implementation.
/// Presentation layer should use this provider.
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final dataSource = ref.read(_invoiceRemoteDataSourceProvider);
  return InvoiceRepositoryImpl(dataSource);
});

/// Product repository provider
///
/// Provides ProductRepositoryImpl implementation.
/// Presentation layer should use this provider.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.read(_productRemoteDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
});
