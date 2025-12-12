/// Domain Repository Providers - Dependency Injection for transaction_template_refectore module
///
/// Purpose: Repository providers for Clean Architecture compliance
/// - Provides concrete implementations from Data layer
/// - Presentation layer imports from Domain layer (this file)
/// - Maintains Clean Architecture dependency rules
///
/// Clean Architecture: DOMAIN LAYER - Dependency Injection
///
/// Usage: Import this file in Presentation layer
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/template_repository.dart';
import '../repositories/transaction_repository.dart';
import '../../data/repositories/supabase_template_repository.dart';
import '../../data/repositories/supabase_transaction_repository.dart';
import '../../data/services/template_data_service.dart';
import '../../data/cache/template_cache_repository.dart';
import 'package:myfinance_improved/data/services/supabase_service.dart';

/// Supabase service provider (Internal)
final _supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Template data service provider (Internal)
final _templateDataServiceProvider = Provider<TemplateDataService>((ref) {
  return TemplateDataService(ref.read(_supabaseServiceProvider));
});

/// Template cache repository provider (Internal)
final _templateCacheRepositoryProvider = Provider<TemplateCacheRepository>((ref) {
  return TemplateCacheRepository();
});

/// Template repository provider
///
/// Provides SupabaseTemplateRepository implementation.
/// Presentation layer should use this provider.
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return SupabaseTemplateRepository(
    dataService: ref.read(_templateDataServiceProvider),
    cacheRepository: ref.read(_templateCacheRepositoryProvider),
  );
});

/// Transaction repository provider
///
/// Provides SupabaseTransactionRepository implementation.
/// Presentation layer should use this provider.
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return SupabaseTransactionRepository(
    supabaseService: ref.read(_supabaseServiceProvider),
  );
});
