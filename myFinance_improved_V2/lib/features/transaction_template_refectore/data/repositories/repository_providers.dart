/// Repository Providers - Dependency injection IMPLEMENTATIONS for data layer
///
/// Purpose: Provides concrete implementations of repositories:
/// - Template repository with caching and data source coordination
/// - Transaction repository for RPC-based transaction creation
/// - Cache repository for high-performance template caching
/// - Data sources for direct Supabase interaction
///
/// Clean Architecture: DATA LAYER - Dependency Injection IMPLEMENTATIONS
///
/// NOTE: These providers override the abstract providers from Domain layer.
/// Presentation layer should import from domain/providers/repository_providers.dart,
/// NOT from this file.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/repository_providers.dart' as domain_providers;
import '../../domain/repositories/template_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/template_data_source.dart';
import '../cache/template_cache_repository.dart';
import 'supabase_template_repository.dart';
import 'supabase_transaction_repository.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';

/// Supabase service provider (Data layer internal)
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Template data source provider (Data layer internal)
final templateDataSourceProvider = Provider<TemplateDataSource>((ref) {
  return TemplateDataSource(ref.read(supabaseServiceProvider));
});

/// Template cache repository provider (Data layer internal)
final templateCacheRepositoryProvider = Provider<TemplateCacheRepository>((ref) {
  return TemplateCacheRepository();
});

/// Template repository IMPLEMENTATION
///
/// Overrides the abstract provider from Domain layer with concrete implementation.
/// This is the actual provider that gets used at runtime.
final templateRepositoryImplProvider = Provider<TemplateRepository>((ref) {
  return SupabaseTemplateRepository(
    dataSource: ref.read(templateDataSourceProvider),
    cacheRepository: ref.read(templateCacheRepositoryProvider),
  );
});

/// Transaction repository IMPLEMENTATION
///
/// Overrides the abstract provider from Domain layer with concrete implementation.
final transactionRepositoryImplProvider = Provider<TransactionRepository>((ref) {
  return SupabaseTransactionRepository(
    supabaseService: ref.read(supabaseServiceProvider),
  );
});

/// Override configurations for Domain providers
///
/// These should be applied in ProviderScope overrides at app initialization.
/// Example in main.dart:
/// ```dart
/// ProviderScope(
///   overrides: repositoryProviderOverrides,
///   child: MyApp(),
/// )
/// ```
final repositoryProviderOverrides = [
  domain_providers.templateRepositoryProvider.overrideWithProvider(templateRepositoryImplProvider),
  domain_providers.transactionRepositoryProvider.overrideWithProvider(transactionRepositoryImplProvider),
];

/// Convenience provider for Supabase template repository with additional methods
final supabaseTemplateRepositoryProvider = Provider<SupabaseTemplateRepository>((ref) {
  return SupabaseTemplateRepository(
    dataSource: ref.read(templateDataSourceProvider),
    cacheRepository: ref.read(templateCacheRepositoryProvider),
  );
});

/// Convenience provider for Supabase transaction repository with additional methods
final supabaseTransactionRepositoryProvider = Provider<SupabaseTransactionRepository>((ref) {
  return SupabaseTransactionRepository(
    supabaseService: ref.read(supabaseServiceProvider),
  );
});