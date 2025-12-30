/// Repository Providers - Dependency Injection for transaction_template module
///
/// Purpose: Repository providers for Clean Architecture compliance
/// - Provides concrete implementations from Data layer
/// - Presentation layer imports this file for repository instances
/// - Maintains Clean Architecture dependency rules (Presentation → Data → Domain)
///
/// Clean Architecture: DATA LAYER - Dependency Injection
///
/// Usage: Import this file in Presentation layer
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';

import '../../domain/repositories/template_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../cache/template_cache_repository.dart';
import '../datasources/template_data_source.dart';
import '../repositories/template_repository_impl.dart';
import '../repositories/transaction_repository_impl.dart';
import '../services/template_rpc_service.dart';

/// Supabase service provider (Internal)
final _supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Template data source provider
///
/// Exposed for RPC calls (get_template_for_usage, create_transaction_from_template)
/// Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md
final templateDataSourceProvider = Provider<TemplateDataSource>((ref) {
  return TemplateDataSource(ref.read(_supabaseServiceProvider));
});

/// Template cache repository provider (Internal)
final _templateCacheRepositoryProvider = Provider<TemplateCacheRepository>((ref) {
  return TemplateCacheRepository();
});

/// Template repository provider
///
/// Provides TemplateRepositoryImpl implementation.
/// Presentation layer should use this provider.
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepositoryImpl(
    dataSource: ref.read(templateDataSourceProvider),
    cacheRepository: ref.read(_templateCacheRepositoryProvider),
  );
});

/// Transaction repository provider
///
/// Provides TransactionRepositoryImpl implementation.
/// Presentation layer should use this provider.
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    supabaseService: ref.read(_supabaseServiceProvider),
  );
});

/// Template RPC Service provider
///
/// Provides TemplateRpcService for direct RPC transaction creation.
/// Uses insert_journal_with_everything_utc RPC instead of create_transaction_from_template.
/// Reference: docs/TEMPLATE_USAGE_REFACTORING_PLAN.md
final templateRpcServiceProvider = Provider<TemplateRpcService>((ref) {
  return TemplateRpcService(ref.read(_supabaseServiceProvider));
});
