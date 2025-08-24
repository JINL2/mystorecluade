/// Advanced Cache Management System
/// Provides intelligent caching with TTL, invalidation, and performance monitoring
/// 
/// Design Philosophy: 
/// - Memory efficient with automatic cleanup
/// - Stale-while-revalidate for better UX
/// - Performance monitoring and metrics
/// - Graceful degradation on cache failures

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Cache entry with metadata
class CacheEntry<T> {
  final T data;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String key;
  final int accessCount;
  final DateTime lastAccessed;

  CacheEntry({
    required this.data,
    required this.createdAt,
    required this.expiresAt,
    required this.key,
    this.accessCount = 1,
    DateTime? lastAccessed,
  }) : lastAccessed = lastAccessed ?? DateTime.now();

  CacheEntry<T> withAccess() {
    return CacheEntry<T>(
      data: data,
      createdAt: createdAt,
      expiresAt: expiresAt,
      key: key,
      accessCount: accessCount + 1,
      lastAccessed: DateTime.now(),
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isStale => DateTime.now().isAfter(expiresAt.subtract(Duration(minutes: 2)));
  Duration get age => DateTime.now().difference(createdAt);
}

/// Cache performance metrics
class CacheMetrics {
  int hits = 0;
  int misses = 0;
  int evictions = 0;
  int refreshes = 0;
  Duration totalLoadTime = Duration.zero;
  
  double get hitRate => (hits + misses) > 0 ? hits / (hits + misses) : 0.0;
  double get averageLoadTime => totalLoadTime.inMilliseconds / (hits + misses).clamp(1, double.infinity);
  
  void recordHit() => hits++;
  void recordMiss() => misses++;
  void recordEviction() => evictions++;
  void recordRefresh() => refreshes++;
  void recordLoadTime(Duration duration) => totalLoadTime += duration;
  
  @override
  String toString() {
    return 'CacheMetrics(hits: $hits, misses: $misses, hitRate: ${(hitRate * 100).toStringAsFixed(1)}%, avgLoad: ${averageLoadTime.toStringAsFixed(1)}ms)';
  }
}

/// Advanced cache invalidation strategies
enum InvalidationStrategy {
  /// Invalidate when any related data changes
  aggressive,
  /// Invalidate only when direct data changes
  conservative,
  /// Invalidate based on time patterns
  timeBasedAndSignificant, // 30-mins base with user preference learning
  /// Custom invalidation logic
  custom,
}

/// Smart Cache Manager with advanced features
class SmartCacheManager {
  static final SmartCacheManager _instance = SmartCacheManager._internal();
  factory SmartCacheManager() => _instance;
  SmartCacheManager._internal();

  final Map<String, CacheEntry<dynamic>> _cache = {};
  final Map<String, CacheMetrics> _metrics = {};
  final Map<String, Timer> _refreshTimers = {};
  final Map<String, Completer<dynamic>?> _refreshCompleters = {};
  
  // Configuration
  static const int maxCacheSize = 200; // Maximum number of cache entries
  static const Duration defaultTTL = Duration(minutes: 15); // Default cache TTL
  static const Duration staleGracePeriod = Duration(minutes: 5); // Grace period for stale data
  
  /// Get cached data with advanced features
  Future<T?> get<T>(
    String key, {
    Duration? maxAge,
    bool allowStale = true,
    Future<T> Function()? refresher,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final entry = _cache[key] as CacheEntry<T>?;
      final metrics = _getMetrics(key);
      
      if (entry != null) {
        // Update access statistics
        _cache[key] = entry.withAccess();
        
        // Check if data is still valid
        if (!entry.isExpired) {
          metrics.recordHit();
          metrics.recordLoadTime(stopwatch.elapsed);
          
          // Background refresh if stale
          if (entry.isStale && refresher != null) {
            _backgroundRefresh(key, refresher);
          }
          
          return entry.data;
        }
        
        // Data is expired but we allow stale data
        if (allowStale && refresher != null) {
          metrics.recordHit(); // Still a cache hit, just stale
          
          // Start refresh and return stale data immediately
          _backgroundRefresh(key, refresher);
          return entry.data;
        }
      }
      
      // Cache miss
      metrics.recordMiss();
      
      // Try to load fresh data if refresher provided
      if (refresher != null) {
        final freshData = await refresher();
        await set(key, freshData);
        metrics.recordLoadTime(stopwatch.elapsed);
        return freshData;
      }
      
      return null;
    } finally {
      stopwatch.stop();
    }
  }
  
  /// Store data in cache with TTL
  Future<void> set<T>(
    String key, 
    T data, {
    Duration? ttl,
    List<String>? tags,
  }) async {
    final now = DateTime.now();
    final expiry = now.add(ttl ?? defaultTTL);
    
    // Cleanup if cache is getting too large
    if (_cache.length >= maxCacheSize) {
      await _evictLeastUsed();
    }
    
    _cache[key] = CacheEntry<T>(
      data: data,
      createdAt: now,
      expiresAt: expiry,
      key: key,
    );
    
    // Store tags for invalidation if provided
    if (tags != null) {
      _storeTags(key, tags);
    }
  }
  
  /// Background refresh without blocking current request
  void _backgroundRefresh<T>(String key, Future<T> Function() refresher) async {
    // Prevent multiple concurrent refreshes
    if (_refreshCompleters[key] != null) return;
    
    final completer = Completer<T>();
    _refreshCompleters[key] = completer;
    
    try {
      final freshData = await refresher();
      await set(key, freshData);
      _getMetrics(key).recordRefresh();
      completer.complete(freshData);
    } catch (e) {
      completer.completeError(e);
      // Keep stale data on refresh failure
      if (kDebugMode) {
        print('Cache refresh failed for $key: $e');
      }
    } finally {
      _refreshCompleters[key] = null;
    }
  }
  
  /// Evict least recently used entries
  Future<void> _evictLeastUsed() async {
    if (_cache.isEmpty) return;
    
    // Sort by last accessed time and access count
    final entries = _cache.entries.toList();
    entries.sort((a, b) {
      final aEntry = a.value;
      final bEntry = b.value;
      
      // Prefer evicting older, less accessed items
      final accessDiff = aEntry.accessCount.compareTo(bEntry.accessCount);
      if (accessDiff != 0) return accessDiff;
      
      return aEntry.lastAccessed.compareTo(bEntry.lastAccessed);
    });
    
    // Remove least used 20% of entries
    final evictionCount = (maxCacheSize * 0.2).ceil();
    for (int i = 0; i < evictionCount && i < entries.length; i++) {
      final key = entries[i].key;
      _cache.remove(key);
      _getMetrics(key).recordEviction();
      
      // Cancel any pending refresh timers
      _refreshTimers[key]?.cancel();
      _refreshTimers.remove(key);
    }
  }
  
  /// Get or create metrics for a cache key
  CacheMetrics _getMetrics(String key) {
    return _metrics.putIfAbsent(key, () => CacheMetrics());
  }
  
  /// Store tags for invalidation purposes
  final Map<String, Set<String>> _keyTags = {};
  final Map<String, Set<String>> _tagKeys = {};
  
  void _storeTags(String key, List<String> tags) {
    _keyTags[key] = tags.toSet();
    for (final tag in tags) {
      _tagKeys.putIfAbsent(tag, () => <String>{}).add(key);
    }
  }
  
  /// Invalidate cache entries by tags
  Future<void> invalidateByTags(List<String> tags) async {
    final keysToInvalidate = <String>{};
    
    for (final tag in tags) {
      final keys = _tagKeys[tag];
      if (keys != null) {
        keysToInvalidate.addAll(keys);
      }
    }
    
    for (final key in keysToInvalidate) {
      _cache.remove(key);
      _refreshTimers[key]?.cancel();
      _refreshTimers.remove(key);
    }
  }
  
  /// Clear specific cache entry
  Future<void> invalidate(String key) async {
    _cache.remove(key);
    _refreshTimers[key]?.cancel();
    _refreshTimers.remove(key);
    
    // Clean up tags
    final tags = _keyTags[key];
    if (tags != null) {
      for (final tag in tags) {
        _tagKeys[tag]?.remove(key);
        if (_tagKeys[tag]?.isEmpty == true) {
          _tagKeys.remove(tag);
        }
      }
      _keyTags.remove(key);
    }
  }
  
  /// Clear all cache entries
  Future<void> clear() async {
    _cache.clear();
    _metrics.clear();
    
    // Cancel all timers
    for (final timer in _refreshTimers.values) {
      timer.cancel();
    }
    _refreshTimers.clear();
    _refreshCompleters.clear();
    
    // Clear tags
    _keyTags.clear();
    _tagKeys.clear();
  }
  
  /// Get cache statistics for monitoring
  Map<String, dynamic> getStats() {
    final totalEntries = _cache.length;
    final expiredEntries = _cache.values.where((e) => e.isExpired).length;
    final staleEntries = _cache.values.where((e) => e.isStale).length;
    
    return {
      'totalEntries': totalEntries,
      'expiredEntries': expiredEntries,
      'staleEntries': staleEntries,
      'maxSize': maxCacheSize,
      'utilizationPercent': (totalEntries / maxCacheSize * 100).toStringAsFixed(1),
      'metrics': _metrics,
    };
  }
  
  /// Cleanup expired entries (called periodically)
  Future<void> cleanup() async {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredKeys) {
      await invalidate(key);
    }
  }
}

/// Cache key generator for consistent naming
class CacheKeys {
  // Template-related cache keys
  static String templates(String companyId, String storeId) => 
      'templates:$companyId:$storeId';
      
  static String cashLocations(String companyId, String storeId) => 
      'cash_locations:$companyId:$storeId';
      
  static String counterparties(String companyId) => 
      'counterparties:$companyId';
      
  static String counterpartyCashLocations(String linkedCompanyId) => 
      'counterparty_cash_locations:$linkedCompanyId';
      
  static String accounts() => 'accounts:global';
  
  // User and app state
  static String userProfile(String userId) => 'user_profile:$userId';
  static String companyPermissions(String companyId, String userId) => 
      'permissions:$companyId:$userId';
}

/// Cache tags for intelligent invalidation
class CacheTags {
  static const String templates = 'templates';
  static const String accounts = 'accounts';
  static const String cashLocations = 'cash_locations';
  static const String counterparties = 'counterparties';
  static const String userProfile = 'user_profile';
  static const String permissions = 'permissions';
  
  // Composite tags for related data
  static List<String> forCompany(String companyId) => ['company:$companyId'];
  static List<String> forStore(String storeId) => ['store:$storeId'];
  static List<String> forUser(String userId) => ['user:$userId'];
}