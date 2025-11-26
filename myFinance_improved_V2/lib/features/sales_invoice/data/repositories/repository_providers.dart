/// Data Layer Repository Providers for sales_invoice module
///
/// This file contains the concrete implementations and their dependencies.
/// Domain layer should re-export these providers, not import them directly.
///
/// Clean Architecture: DATA LAYER - Concrete Implementations
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/invoice_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/invoice_remote_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import 'invoice_repository_impl.dart';
import 'product_repository_impl.dart';

// ============================================================================
// Internal Providers (Private - used only within this file)
// ============================================================================

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

// ============================================================================
// Public Repository Providers (Exposed to Domain layer)
// ============================================================================

/// Invoice repository provider
///
/// Provides InvoiceRepositoryImpl implementation.
/// Domain layer should re-export this provider.
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final dataSource = ref.read(_invoiceRemoteDataSourceProvider);
  return InvoiceRepositoryImpl(dataSource);
});

/// Product repository provider
///
/// Provides ProductRepositoryImpl implementation.
/// Domain layer should re-export this provider.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.read(_productRemoteDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
});
