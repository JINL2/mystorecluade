import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// SubscriptionCacheService - Short-lived cache for subscription data
///
/// Separate from HiveCacheService for:
/// 1. Shorter TTL (1 hour vs 7 days) - subscription changes need faster reflection
/// 2. Independent invalidation - RevenueCat/Realtime can invalidate without affecting other caches
/// 3. Clear separation of concerns - subscription is payment-critical data
///
/// Cache Strategy:
/// - TTL: 1 hour (subscription changes should reflect within 1 hour max)
/// - Invalidation: On RevenueCat listener event or Supabase Realtime update
/// - Fallback: If stale, still return data but mark as stale for UI indicator
class SubscriptionCacheService {
  SubscriptionCacheService._();
  static final SubscriptionCacheService _instance = SubscriptionCacheService._();
  static SubscriptionCacheService get instance => _instance;

  // Box name
  static const String _subscriptionBox = 'subscription_cache';

  // TTL: 1 hour (vs 7 days for user_companies)
  // Subscription changes from other devices/platforms should reflect within 1 hour
  static const Duration subscriptionTTL = Duration(hours: 1);

  // Stale threshold: 5 minutes after TTL
  // After this, we strongly recommend refresh
  static const Duration staleTolerance = Duration(minutes: 5);

  bool _isInitialized = false;

  /// Initialize the subscription cache box
  /// Called from HiveCacheService.initialize() or separately
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.openBox<String>(_subscriptionBox);
      _isInitialized = true;
      debugPrint('[SubscriptionCache] Initialized successfully');
    } catch (e) {
      debugPrint('[SubscriptionCache] Initialization failed: $e');
    }
  }

  /// Check if cache entry is valid (not expired)
  bool _isValid(DateTime? cachedAt) {
    if (cachedAt == null) return false;
    return DateTime.now().difference(cachedAt) < subscriptionTTL;
  }

  /// Check if cache entry is stale but still usable
  bool _isStale(DateTime? cachedAt) {
    if (cachedAt == null) return true;
    final age = DateTime.now().difference(cachedAt);
    return age >= subscriptionTTL && age < (subscriptionTTL + staleTolerance);
  }

  // ============================================================================
  // Subscription Cache Operations
  // ============================================================================

  /// Get cached subscription data for a user
  ///
  /// Returns a record with:
  /// - data: The subscription data (null if no cache)
  /// - isStale: True if data is past TTL but still within tolerance
  /// - cachedAt: When the data was cached
  Future<({Map<String, dynamic>? data, bool isStale, DateTime? cachedAt})>
      getSubscription(String userId) async {
    if (!_isInitialized) {
      return (data: null, isStale: true, cachedAt: null);
    }

    try {
      final box = Hive.box<String>(_subscriptionBox);
      final key = 'sub_$userId';
      final cachedJson = box.get(key);

      if (cachedJson == null) {
        return (data: null, isStale: true, cachedAt: null);
      }

      final cached = jsonDecode(cachedJson) as Map<String, dynamic>;
      final cachedAt = DateTime.tryParse(cached['cached_at'] as String? ?? '');
      final data = cached['data'] as Map<String, dynamic>?;

      // Check validity
      if (_isValid(cachedAt)) {
        // Fresh data
        return (data: data, isStale: false, cachedAt: cachedAt);
      } else if (_isStale(cachedAt)) {
        // Stale but usable
        debugPrint('[SubscriptionCache] Returning stale data for user: $userId');
        return (data: data, isStale: true, cachedAt: cachedAt);
      } else {
        // Too old, delete and return null
        await box.delete(key);
        debugPrint('[SubscriptionCache] Cache expired, deleted for user: $userId');
        return (data: null, isStale: true, cachedAt: null);
      }
    } catch (e) {
      debugPrint('[SubscriptionCache] Failed to get cache: $e');
      return (data: null, isStale: true, cachedAt: null);
    }
  }

  /// Save subscription data to cache
  ///
  /// Data should include:
  /// - plan_id, plan_name, plan_type
  /// - max_companies, max_stores, max_employees (null = unlimited)
  /// - ai_daily_limit
  /// - status (active, canceled, expired, etc.)
  /// - features list
  Future<void> saveSubscription(String userId, Map<String, dynamic> data) async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_subscriptionBox);
      final key = 'sub_$userId';

      final cacheEntry = {
        'data': data,
        'cached_at': DateTime.now().toIso8601String(),
        'version': 1,
      };

      await box.put(key, jsonEncode(cacheEntry));
      debugPrint('[SubscriptionCache] Saved for user: $userId');
    } catch (e) {
      debugPrint('[SubscriptionCache] Failed to save: $e');
    }
  }

  /// Invalidate subscription cache for a user
  ///
  /// Called when:
  /// - RevenueCat listener detects subscription change
  /// - Supabase Realtime receives subscription_user update
  /// - User manually refreshes subscription
  Future<void> invalidate(String userId) async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_subscriptionBox);
      await box.delete('sub_$userId');
      debugPrint('[SubscriptionCache] Invalidated for user: $userId');
    } catch (e) {
      debugPrint('[SubscriptionCache] Failed to invalidate: $e');
    }
  }

  /// Clear all subscription caches (e.g., on logout)
  Future<void> clearAll() async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_subscriptionBox);
      await box.clear();
      debugPrint('[SubscriptionCache] All caches cleared');
    } catch (e) {
      debugPrint('[SubscriptionCache] Failed to clear: $e');
    }
  }

  /// Get cache age for debugging/UI
  Future<Duration?> getCacheAge(String userId) async {
    if (!_isInitialized) return null;

    try {
      final box = Hive.box<String>(_subscriptionBox);
      final cachedJson = box.get('sub_$userId');

      if (cachedJson == null) return null;

      final cached = jsonDecode(cachedJson) as Map<String, dynamic>;
      final cachedAt = DateTime.tryParse(cached['cached_at'] as String? ?? '');

      if (cachedAt == null) return null;
      return DateTime.now().difference(cachedAt);
    } catch (e) {
      return null;
    }
  }

  /// Check if we have any cached subscription (regardless of validity)
  Future<bool> hasCache(String userId) async {
    if (!_isInitialized) return false;

    try {
      final box = Hive.box<String>(_subscriptionBox);
      return box.containsKey('sub_$userId');
    } catch (e) {
      return false;
    }
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getStats() {
    if (!_isInitialized) {
      return {'initialized': false};
    }

    try {
      final box = Hive.box<String>(_subscriptionBox);
      return {
        'initialized': true,
        'subscription_count': box.length,
        'ttl_hours': subscriptionTTL.inHours,
      };
    } catch (e) {
      return {'initialized': true, 'error': e.toString()};
    }
  }
}
