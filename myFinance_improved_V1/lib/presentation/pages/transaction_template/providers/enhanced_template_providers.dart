/// Enhanced Transaction Template Providers
/// Advanced provider system with intelligent caching, error recovery, and performance optimization
/// 
/// Features:
/// - Smart caching with stale-while-revalidate
/// - Automatic retry with exponential backoff
/// - Background data synchronization
/// - Performance monitoring
/// - Graceful error handling

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/cache/smart_cache_manager.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../../data/services/supabase_service.dart';

/// Enhanced error handling with retry logic
class EnhancedProviderError extends Error {
  final String message;
  final int retryCount;
  final Duration nextRetryDelay;
  final bool isRecoverable;
  
  EnhancedProviderError({
    required this.message,
    this.retryCount = 0,
    this.nextRetryDelay = const Duration(seconds: 2),
    this.isRecoverable = true,
  });
  
  @override
  String toString() => 'EnhancedProviderError: $message (retries: $retryCount)';
}

/// Retry configuration for providers
class RetryConfig {
  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  
  const RetryConfig({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
  });
  
  Duration delayForAttempt(int attempt) {
    final delay = baseDelay * (backoffMultiplier * attempt);
    return delay > maxDelay ? maxDelay : delay;
  }
}

/// Enhanced provider with retry logic
Future<T> withRetry<T>(
  Future<T> Function() operation, {
  RetryConfig config = const RetryConfig(),
  bool Function(dynamic error)? shouldRetry,
}) async {
  dynamic lastError;
  
  for (int attempt = 0; attempt < config.maxAttempts; attempt++) {
    try {
      return await operation();
    } catch (error) {
      lastError = error;
      
      // Check if we should retry this error
      final defaultShouldRetry = error is! EnhancedProviderError || 
          (error as EnhancedProviderError).isRecoverable;
      final retry = shouldRetry?.call(error) ?? defaultShouldRetry;
      
      if (!retry || attempt == config.maxAttempts - 1) {
        break;
      }
      
      // Wait before retrying
      final delay = config.delayForAttempt(attempt);
      await Future.delayed(delay);
    }
  }
  
  throw EnhancedProviderError(
    message: 'Operation failed after ${config.maxAttempts} attempts: $lastError',
    retryCount: config.maxAttempts,
    isRecoverable: false,
  );
}

/// Enhanced cash locations provider with caching and error recovery
final enhancedCashLocationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  
  if (companyId.isEmpty) return [];
  
  final cache = SmartCacheManager();
  final cacheKey = CacheKeys.cashLocations(companyId, storeId);
  
  // Try to get from cache first
  final cached = await cache.get<List<Map<String, dynamic>>>(
    cacheKey,
    maxAge: const Duration(minutes: 10),
    allowStale: true,
    refresher: () => _fetchCashLocations(companyId, storeId),
  );
  
  if (cached != null) return cached;
  
  // Fallback to direct fetch with retry
  return withRetry(() => _fetchCashLocations(companyId, storeId));
});

/// Enhanced counterparties provider
final enhancedCounterpartiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  
  if (companyId.isEmpty) return [];
  
  final cache = SmartCacheManager();
  final cacheKey = CacheKeys.counterparties(companyId);
  
  final cached = await cache.get<List<Map<String, dynamic>>>(
    cacheKey,
    maxAge: const Duration(minutes: 15),
    allowStale: true,
    refresher: () => _fetchCounterparties(companyId),
  );
  
  if (cached != null) return cached;
  
  return withRetry(() => _fetchCounterparties(companyId));
});

/// Enhanced transaction templates provider with intelligent caching
final enhancedTransactionTemplatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  final currentUser = ref.watch(authStateProvider);
  
  if (companyId.isEmpty || currentUser == null) return [];
  
  final cache = SmartCacheManager();
  final cacheKey = CacheKeys.templates(companyId, storeId);
  
  final cached = await cache.get<List<Map<String, dynamic>>>(
    cacheKey,
    maxAge: const Duration(minutes: 5), // Templates change more frequently
    allowStale: true,
    refresher: () => _fetchTemplates(companyId, storeId, currentUser.id),
  );
  
  if (cached != null) return cached;
  
  return withRetry(() => _fetchTemplates(companyId, storeId, currentUser.id));
});

/// Background data synchronization service
class BackgroundSyncService {
  static final BackgroundSyncService _instance = BackgroundSyncService._internal();
  factory BackgroundSyncService() => _instance;
  BackgroundSyncService._internal();
  
  final Map<String, Timer> _syncTimers = {};
  
  /// Start background sync for commonly used data
  void startBackgroundSync(WidgetRef ref) {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty) return;
    
    // Sync cash locations every 10 minutes
    _startSyncTimer(
      'cash_locations',
      const Duration(minutes: 10),
      () => _syncCashLocations(companyId, storeId),
    );
    
    // Sync counterparties every 15 minutes
    _startSyncTimer(
      'counterparties',
      const Duration(minutes: 15),
      () => _syncCounterparties(companyId),
    );
    
    // Sync templates every 5 minutes
    _startSyncTimer(
      'templates',
      const Duration(minutes: 5),
      () => _syncTemplates(ref),
    );
  }
  
  void _startSyncTimer(String key, Duration interval, VoidCallback syncFunction) {
    _syncTimers[key]?.cancel();
    _syncTimers[key] = Timer.periodic(interval, (_) {
      syncFunction();
    });
  }
  
  Future<void> _syncCashLocations(String companyId, String storeId) async {
    try {
      final cache = SmartCacheManager();
      final fresh = await _fetchCashLocations(companyId, storeId);
      await cache.set(
        CacheKeys.cashLocations(companyId, storeId),
        fresh,
        tags: [CacheTags.cashLocations, ...CacheTags.forCompany(companyId)],
      );
    } catch (e) {
      // Silent fail for background sync
    }
  }
  
  Future<void> _syncCounterparties(String companyId) async {
    try {
      final cache = SmartCacheManager();
      final fresh = await _fetchCounterparties(companyId);
      await cache.set(
        CacheKeys.counterparties(companyId),
        fresh,
        tags: [CacheTags.counterparties, ...CacheTags.forCompany(companyId)],
      );
    } catch (e) {
      // Silent fail for background sync
    }
  }
  
  Future<void> _syncTemplates(WidgetRef ref) async {
    try {
      final appState = ref.read(appStateProvider);
      final currentUser = ref.read(authStateProvider);
      if (currentUser == null) return;
      
      final cache = SmartCacheManager();
      final fresh = await _fetchTemplates(
        appState.companyChoosen, 
        appState.storeChoosen, 
        currentUser.id
      );
      await cache.set(
        CacheKeys.templates(appState.companyChoosen, appState.storeChoosen),
        fresh,
        tags: [CacheTags.templates, ...CacheTags.forCompany(appState.companyChoosen)],
      );
    } catch (e) {
      // Silent fail for background sync
    }
  }
  
  void stopAllSync() {
    for (final timer in _syncTimers.values) {
      timer.cancel();
    }
    _syncTimers.clear();
  }
}

/// Data fetching functions with optimized queries
Future<List<Map<String, dynamic>>> _fetchCashLocations(String companyId, String storeId) async {
  final supabase = Supabase.instance.client;
  
  var query = supabase
      .from('cash_locations')
      .select('cash_location_id, location_name, location_type')
      .eq('company_id', companyId);
  
  if (storeId.isNotEmpty) {
    query = query.eq('store_id', storeId);
  } else {
    query = query.isFilter('store_id', null);
  }
  
  final response = await query.order('location_name');
  return List<Map<String, dynamic>>.from(response);
}

Future<List<Map<String, dynamic>>> _fetchCounterparties(String companyId) async {
  final supabase = Supabase.instance.client;
  
  final response = await supabase
      .from('counterparties')
      .select('counterparty_id, name, is_internal, linked_company_id')
      .eq('company_id', companyId)
      .order('name');
  
  return List<Map<String, dynamic>>.from(response);
}

Future<List<Map<String, dynamic>>> _fetchTemplates(String companyId, String storeId, String userId) async {
  final supabase = Supabase.instance.client;
  
  // Optimized query with better indexing
  List<dynamic> response;
  if (storeId.isNotEmpty) {
    response = await supabase
        .from('transaction_templates')
        .select('''
          template_id, 
          name, 
          template_description,
          data, 
          permission, 
          tags, 
          visibility_level, 
          is_active, 
          updated_by, 
          company_id, 
          store_id, 
          counterparty_id, 
          counterparty_cash_location_id,
          created_at
        ''')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .or('store_id.eq.$storeId,store_id.is.null')
        .order('created_at', ascending: false)
        .limit(50); // Add reasonable limit for performance
  } else {
    response = await supabase
        .from('transaction_templates')
        .select('''
          template_id, 
          name, 
          template_description,
          data, 
          permission, 
          tags, 
          visibility_level, 
          is_active, 
          updated_by, 
          company_id, 
          store_id, 
          counterparty_id, 
          counterparty_cash_location_id,
          created_at
        ''')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .isFilter('store_id', null)
        .order('created_at', ascending: false)
        .limit(50);
  }
  
  // Apply visibility filtering
  final filteredTemplates = response.where((template) {
    final visibilityLevel = template['visibility_level']?.toString() ?? 'public';
    final updatedBy = template['updated_by']?.toString() ?? '';
    
    if (visibilityLevel == 'public') return true;
    if (visibilityLevel == 'private') return updatedBy == userId;
    return false;
  }).toList();
  
  return List<Map<String, dynamic>>.from(filteredTemplates);
}

/// Performance monitoring provider
final cachePerformanceProvider = Provider<Map<String, dynamic>>((ref) {
  final cache = SmartCacheManager();
  return cache.getStats();
});

/// Cache warming service
class CacheWarmingService {
  static Future<void> warmupCommonData(WidgetRef ref) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty) return;
    
    // Warm up critical data in background
    final futures = <Future>[];
    
    // Warm cash locations
    futures.add(_warmupData(
      () => _fetchCashLocations(companyId, storeId),
      CacheKeys.cashLocations(companyId, storeId),
      [CacheTags.cashLocations, ...CacheTags.forCompany(companyId)],
    ));
    
    // Warm counterparties
    futures.add(_warmupData(
      () => _fetchCounterparties(companyId),
      CacheKeys.counterparties(companyId),
      [CacheTags.counterparties, ...CacheTags.forCompany(companyId)],
    ));
    
    // Execute in parallel without blocking
    Future.wait(futures).catchError((e) {
      // Ignore warmup errors
    });
  }
  
  static Future<void> _warmupData<T>(
    Future<T> Function() fetcher,
    String cacheKey,
    List<String> tags,
  ) async {
    try {
      final data = await fetcher();
      await SmartCacheManager().set(cacheKey, data, tags: tags);
    } catch (e) {
      // Silent fail for warmup
    }
  }
}

/// Provider compatibility layer
/// These providers maintain backward compatibility while using enhanced caching

// Backward compatible providers that delegate to enhanced versions
final cashLocationsProvider = enhancedCashLocationsProvider;
final counterpartiesProvider = enhancedCounterpartiesProvider;

/// Enhanced provider that falls back to original if needed
final transactionTemplatesProviderWithFallback = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    return await ref.watch(enhancedTransactionTemplatesProvider.future);
  } catch (e) {
    // Fallback to original provider if enhanced version fails
    return await ref.watch(transactionTemplatesProvider.future);
  }
});

// Import the original provider to maintain compatibility
final transactionTemplatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabaseService = ref.read(supabaseServiceProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;
  final currentUser = ref.watch(authStateProvider);
  
  if (companyId.isEmpty || currentUser == null) return [];
  
  // This is a fallback - maintain original logic
  return await _fetchTemplates(companyId, storeId, currentUser.id);
});