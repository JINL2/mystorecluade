/// Template Cache Repository - In-memory caching for transaction templates
///
/// Purpose: Provides high-performance caching for template data:
/// - In-memory caching with TTL (Time To Live) management
/// - Cache invalidation strategies for data consistency
/// - Smart cache key generation and lookup
/// - Memory-efficient cache size management
/// - Cache hit/miss statistics and monitoring
///
/// Usage: TemplateCacheRepository.getCachedTemplates(companyId, storeId)
import 'package:flutter_riverpod/flutter_riverpod.dart';

final templateCacheRepositoryProvider = Provider<TemplateCacheRepository>((ref) {
  return TemplateCacheRepository();
});

class TemplateCacheRepository {
  // Cache storage
  final Map<String, CacheEntry<List<Map<String, dynamic>>>> _templatesCache = {};
  final Map<String, CacheEntry<Map<String, dynamic>>> _templateCache = {};
  
  // Cache configuration
  static const Duration _defaultTtl = Duration(minutes: 15);
  static const int _maxCacheSize = 100;
  
  // Cache statistics
  int _cacheHits = 0;
  int _cacheMisses = 0;

  /// Cache templates list for specific company and store
  Future<void> cacheTemplates({
    required String companyId,
    required String storeId,
    required List<Map<String, dynamic>> templates,
    bool? isActive,
    String? visibilityLevel,
  }) async {
    final cacheKey = _generateTemplatesCacheKey(
      companyId: companyId,
      storeId: storeId,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    // Ensure cache size limit
    _ensureCacheSize();

    _templatesCache[cacheKey] = CacheEntry(
      data: List<Map<String, dynamic>>.from(templates),
      timestamp: DateTime.now(),
      ttl: _defaultTtl,
    );

    // Also cache individual templates
    for (final template in templates) {
      final templateId = template['template_id'] as String?;
      if (templateId != null) {
        await cacheTemplate(template);
      }
    }
  }

  /// Get cached templates list
  Future<List<Map<String, dynamic>>?> getCachedTemplates({
    required String companyId,
    required String storeId,
    bool? isActive,
    String? visibilityLevel,
  }) async {
    final cacheKey = _generateTemplatesCacheKey(
      companyId: companyId,
      storeId: storeId,
      isActive: isActive,
      visibilityLevel: visibilityLevel,
    );

    final cacheEntry = _templatesCache[cacheKey];
    
    if (cacheEntry == null || cacheEntry.isExpired) {
      _cacheMisses++;
      if (cacheEntry != null) {
        _templatesCache.remove(cacheKey);
      }
      return null;
    }

    _cacheHits++;
    return cacheEntry.data;
  }

  /// Cache individual template
  Future<void> cacheTemplate(Map<String, dynamic> template) async {
    final templateId = template['template_id'] as String?;
    if (templateId == null) return;

    // Ensure cache size limit
    _ensureCacheSize();

    _templateCache[templateId] = CacheEntry(
      data: Map<String, dynamic>.from(template),
      timestamp: DateTime.now(),
      ttl: _defaultTtl,
    );
  }

  /// Get cached individual template
  Future<Map<String, dynamic>?> getCachedTemplateById(String templateId) async {
    final cacheEntry = _templateCache[templateId];
    
    if (cacheEntry == null || cacheEntry.isExpired) {
      _cacheMisses++;
      if (cacheEntry != null) {
        _templateCache.remove(templateId);
      }
      return null;
    }

    _cacheHits++;
    return cacheEntry.data;
  }

  /// Invalidate templates cache for specific company/store
  Future<void> invalidateTemplatesCache(String companyId, String storeId) async {
    final keysToRemove = <String>[];
    
    for (final key in _templatesCache.keys) {
      if (key.startsWith('${companyId}_${storeId}_')) {
        keysToRemove.add(key);
      }
    }

    for (final key in keysToRemove) {
      _templatesCache.remove(key);
    }
  }

  /// Invalidate specific template cache
  Future<void> invalidateTemplateCache(String templateId) async {
    _templateCache.remove(templateId);
  }

  /// Invalidate all cache
  Future<void> invalidateAllCache() async {
    _templatesCache.clear();
    _templateCache.clear();
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    final totalRequests = _cacheHits + _cacheMisses;
    final hitRate = totalRequests > 0 ? (_cacheHits / totalRequests * 100) : 0.0;

    return {
      'cache_hits': _cacheHits,
      'cache_misses': _cacheMisses,
      'hit_rate_percentage': hitRate.toStringAsFixed(2),
      'templates_cache_size': _templatesCache.length,
      'template_cache_size': _templateCache.length,
      'total_cache_entries': _templatesCache.length + _templateCache.length,
    };
  }

  /// Reset cache statistics
  void resetStats() {
    _cacheHits = 0;
    _cacheMisses = 0;
  }

  /// Clean expired cache entries
  Future<void> cleanExpiredEntries() async {
    // Clean templates cache
    final expiredTemplatesKeys = <String>[];
    for (final entry in _templatesCache.entries) {
      if (entry.value.isExpired) {
        expiredTemplatesKeys.add(entry.key);
      }
    }
    for (final key in expiredTemplatesKeys) {
      _templatesCache.remove(key);
    }

    // Clean template cache
    final expiredTemplateKeys = <String>[];
    for (final entry in _templateCache.entries) {
      if (entry.value.isExpired) {
        expiredTemplateKeys.add(entry.key);
      }
    }
    for (final key in expiredTemplateKeys) {
      _templateCache.remove(key);
    }
  }

  /// Generate cache key for templates list
  String _generateTemplatesCacheKey({
    required String companyId,
    required String storeId,
    bool? isActive,
    String? visibilityLevel,
  }) {
    final parts = [companyId, storeId];
    
    if (isActive != null) {
      parts.add('active_${isActive.toString()}');
    }
    
    if (visibilityLevel != null) {
      parts.add('visibility_$visibilityLevel');
    }
    
    return parts.join('_');
  }

  /// Ensure cache doesn't exceed size limits
  void _ensureCacheSize() {
    // Clean expired entries first
    cleanExpiredEntries();

    // If still over limit, remove oldest entries
    if (_templatesCache.length > _maxCacheSize ~/ 2) {
      final sortedEntries = _templatesCache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
      
      final removeCount = _templatesCache.length - (_maxCacheSize ~/ 2);
      for (int i = 0; i < removeCount; i++) {
        _templatesCache.remove(sortedEntries[i].key);
      }
    }

    if (_templateCache.length > _maxCacheSize ~/ 2) {
      final sortedEntries = _templateCache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
      
      final removeCount = _templateCache.length - (_maxCacheSize ~/ 2);
      for (int i = 0; i < removeCount; i++) {
        _templateCache.remove(sortedEntries[i].key);
      }
    }
  }

  /// Preload templates into cache
  Future<void> preloadTemplates({
    required String companyId,
    required String storeId,
    required List<Map<String, dynamic>> templates,
  }) async {
    await cacheTemplates(
      companyId: companyId,
      storeId: storeId,
      templates: templates,
    );

    // Also cache common filter variations
    final activeTemplates = templates.where((t) => t['is_active'] == true).toList();
    await cacheTemplates(
      companyId: companyId,
      storeId: storeId,
      templates: activeTemplates,
      isActive: true,
    );

    final publicTemplates = templates.where((t) => t['visibility_level'] == 'public').toList();
    await cacheTemplates(
      companyId: companyId,
      storeId: storeId,
      templates: publicTemplates,
      visibilityLevel: 'public',
    );
  }
}

/// Cache entry with TTL support
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration ttl;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.ttl,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}