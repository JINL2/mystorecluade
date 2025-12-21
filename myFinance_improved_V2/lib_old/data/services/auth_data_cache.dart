import 'dart:async';

/// AuthDataCache - Transparent caching layer for auth-related API calls
/// Prevents redundant API calls during auth flows without changing existing code
/// 
/// Features:
/// - 30-second cache timeout for fresh data
/// - Automatic cache invalidation on timeout
/// - Zero changes required to existing API calls
/// - Thread-safe implementation
class AuthDataCache {
  // Singleton pattern for global cache access
  AuthDataCache._privateConstructor();
  static final AuthDataCache _instance = AuthDataCache._privateConstructor();
  static AuthDataCache get instance => _instance;
  
  // Cache storage with timestamps
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _timestamps = {};
  final Map<String, Completer<dynamic>> _pendingRequests = {};
  
  // Configuration
  static const Duration _cacheTimeout = Duration(seconds: 30);
  static const Duration _pendingTimeout = Duration(seconds: 10);
  
  /// Deduplicate API calls with intelligent caching
  /// Returns cached data if fresh, otherwise makes the API call
  /// Prevents concurrent duplicate requests
  Future<T> deduplicate<T>(
    String key,
    Future<T> Function() apiCall, {
    Duration? customTimeout,
  }) async {
    // Check if there's a pending request for the same key
    if (_pendingRequests.containsKey(key)) {
      try {
        // Wait for the pending request to complete
        final result = await _pendingRequests[key]!.future
            .timeout(_pendingTimeout);
        return result as T;
      } catch (e) {
        // If pending request fails or times out, proceed with new request
        _pendingRequests.remove(key);
      }
    }
    
    // Check cache validity
    if (_cache.containsKey(key) && _timestamps.containsKey(key)) {
      final age = DateTime.now().difference(_timestamps[key]!);
      final timeout = customTimeout ?? _cacheTimeout;
      
      if (age < timeout) {
        // Return cached data if still fresh
        return _cache[key] as T;
      }
    }
    
    // Create a new pending request
    final completer = Completer<T>();
    _pendingRequests[key] = completer;
    
    try {
      // Make the actual API call
      final result = await apiCall();
      
      // Cache the result
      _cache[key] = result;
      _timestamps[key] = DateTime.now();
      
      // Complete the pending request
      completer.complete(result);
      
      return result;
    } catch (error) {
      // Complete with error
      completer.completeError(error);
      
      // Remove failed cache entry
      _cache.remove(key);
      _timestamps.remove(key);
      
      rethrow;
    } finally {
      // Clean up pending request
      _pendingRequests.remove(key);
    }
  }
  
  /// Get cached value without making API call
  T? getCached<T>(String key) {
    if (_cache.containsKey(key) && _timestamps.containsKey(key)) {
      final age = DateTime.now().difference(_timestamps[key]!);
      if (age < _cacheTimeout) {
        return _cache[key] as T?;
      }
    }
    return null;
  }
  
  /// Invalidate specific cache entry
  void invalidate(String key) {
    _cache.remove(key);
    _timestamps.remove(key);
  }
  
  /// Invalidate all cache entries matching a pattern
  void invalidatePattern(String pattern) {
    final keysToRemove = _cache.keys
        .where((key) => key.contains(pattern))
        .toList();
    
    for (final key in keysToRemove) {
      invalidate(key);
    }
  }
  
  /// Clear all cached data
  void clearAll() {
    _cache.clear();
    _timestamps.clear();
    _pendingRequests.clear();
  }
  
  /// Get cache statistics for monitoring
  Map<String, dynamic> getStats() {
    final now = DateTime.now();
    int freshEntries = 0;
    int staleEntries = 0;
    
    for (final timestamp in _timestamps.values) {
      if (now.difference(timestamp) < _cacheTimeout) {
        freshEntries++;
      } else {
        staleEntries++;
      }
    }
    
    return {
      'total_entries': _cache.length,
      'fresh_entries': freshEntries,
      'stale_entries': staleEntries,
      'pending_requests': _pendingRequests.length,
    };
  }
  
  /// Clean up stale entries (call periodically if needed)
  void cleanup() {
    final now = DateTime.now();
    final keysToRemove = <String>[];
    
    _timestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) > _cacheTimeout) {
        keysToRemove.add(key);
      }
    });
    
    for (final key in keysToRemove) {
      invalidate(key);
    }
  }
}