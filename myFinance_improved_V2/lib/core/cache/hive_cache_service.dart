import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// HiveCacheService - Persistent local cache using Hive
///
/// Provides fast local storage for homepage data with TTL support.
/// Used for SWR (Stale-While-Revalidate) pattern to enable instant app launch.
///
/// Boxes:
/// - user_companies: User + companies + subscriptions (12h TTL)
/// - categories: Feature categories (infinite TTL - static data)
/// - quick_access: User's quick access features per company (24h TTL)
class HiveCacheService {
  HiveCacheService._();
  static final HiveCacheService _instance = HiveCacheService._();
  static HiveCacheService get instance => _instance;

  // Box names
  static const String _userCompaniesBox = 'user_companies_cache';
  static const String _categoriesBox = 'categories_cache';
  static const String _quickAccessBox = 'quick_access_cache';

  // TTL durations
  // All data refreshed via pull-to-refresh, so 7 days is safe
  static const Duration userCompaniesTTL = Duration(days: 7);
  static const Duration categoriesTTL = Duration(days: 365); // Essentially infinite
  static const Duration quickAccessTTL = Duration(days: 7);

  bool _isInitialized = false;

  /// Initialize Hive - must be called before using any cache methods
  /// Call this in main.dart before runApp()
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      // Open all boxes
      await Hive.openBox<String>(_userCompaniesBox);
      await Hive.openBox<String>(_categoriesBox);
      await Hive.openBox<String>(_quickAccessBox);

      _isInitialized = true;
      debugPrint('HiveCacheService initialized successfully');
    } catch (e) {
      debugPrint('HiveCacheService initialization failed: $e');
      // Don't rethrow - app should work without cache
    }
  }

  /// Check if cache entry is valid (not expired)
  bool _isValid(DateTime? cachedAt, Duration ttl) {
    if (cachedAt == null) return false;
    return DateTime.now().difference(cachedAt) < ttl;
  }

  // ============================================================================
  // User Companies Cache
  // ============================================================================

  /// Get cached user companies data
  /// Returns null if cache is empty or expired
  Future<Map<String, dynamic>?> getUserCompanies(String userId) async {
    if (!_isInitialized) return null;

    try {
      final box = Hive.box<String>(_userCompaniesBox);
      final key = 'user_$userId';
      final cachedJson = box.get(key);

      if (cachedJson == null) return null;

      final cached = jsonDecode(cachedJson) as Map<String, dynamic>;
      final cachedAt = DateTime.tryParse(cached['cached_at'] as String? ?? '');

      if (!_isValid(cachedAt, userCompaniesTTL)) {
        // Cache expired, remove it
        await box.delete(key);
        return null;
      }

      return cached['data'] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Failed to get user companies cache: $e');
      return null;
    }
  }

  /// Save user companies data to cache
  Future<void> saveUserCompanies(String userId, Map<String, dynamic> data) async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_userCompaniesBox);
      final key = 'user_$userId';

      final cacheEntry = {
        'data': data,
        'cached_at': DateTime.now().toIso8601String(),
        'version': 1,
      };

      await box.put(key, jsonEncode(cacheEntry));
      debugPrint('User companies cached for user: $userId');
    } catch (e) {
      debugPrint('Failed to save user companies cache: $e');
    }
  }

  /// Invalidate user companies cache
  Future<void> invalidateUserCompanies(String userId) async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_userCompaniesBox);
      await box.delete('user_$userId');
      debugPrint('User companies cache invalidated for user: $userId');
    } catch (e) {
      debugPrint('Failed to invalidate user companies cache: $e');
    }
  }

  // ============================================================================
  // Categories Cache
  // ============================================================================

  /// Get cached categories data
  /// Returns null if cache is empty (no TTL check - static data)
  Future<List<dynamic>?> getCategories() async {
    if (!_isInitialized) return null;

    try {
      final box = Hive.box<String>(_categoriesBox);
      final cachedJson = box.get('categories');

      if (cachedJson == null) return null;

      final cached = jsonDecode(cachedJson) as Map<String, dynamic>;
      return cached['data'] as List<dynamic>?;
    } catch (e) {
      debugPrint('Failed to get categories cache: $e');
      return null;
    }
  }

  /// Save categories data to cache
  Future<void> saveCategories(List<dynamic> data) async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_categoriesBox);

      final cacheEntry = {
        'data': data,
        'cached_at': DateTime.now().toIso8601String(),
        'version': 1,
      };

      await box.put('categories', jsonEncode(cacheEntry));
      debugPrint('Categories cached');
    } catch (e) {
      debugPrint('Failed to save categories cache: $e');
    }
  }

  /// Invalidate categories cache
  Future<void> invalidateCategories() async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_categoriesBox);
      await box.delete('categories');
      debugPrint('Categories cache invalidated');
    } catch (e) {
      debugPrint('Failed to invalidate categories cache: $e');
    }
  }

  // ============================================================================
  // Quick Access Features Cache
  // ============================================================================

  /// Get cached quick access features
  /// Returns null if cache is empty or expired
  Future<List<dynamic>?> getQuickAccess(String userId, String companyId) async {
    if (!_isInitialized) return null;

    try {
      final box = Hive.box<String>(_quickAccessBox);
      final key = 'quick_${userId}_$companyId';
      final cachedJson = box.get(key);

      if (cachedJson == null) return null;

      final cached = jsonDecode(cachedJson) as Map<String, dynamic>;
      final cachedAt = DateTime.tryParse(cached['cached_at'] as String? ?? '');

      if (!_isValid(cachedAt, quickAccessTTL)) {
        // Cache expired, remove it
        await box.delete(key);
        return null;
      }

      return cached['data'] as List<dynamic>?;
    } catch (e) {
      debugPrint('Failed to get quick access cache: $e');
      return null;
    }
  }

  /// Save quick access features to cache
  Future<void> saveQuickAccess(
    String userId,
    String companyId,
    List<dynamic> data,
  ) async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_quickAccessBox);
      final key = 'quick_${userId}_$companyId';

      final cacheEntry = {
        'data': data,
        'cached_at': DateTime.now().toIso8601String(),
        'version': 1,
      };

      await box.put(key, jsonEncode(cacheEntry));
      debugPrint('Quick access cached for user: $userId, company: $companyId');
    } catch (e) {
      debugPrint('Failed to save quick access cache: $e');
    }
  }

  /// Invalidate quick access cache for a specific company
  Future<void> invalidateQuickAccess(String userId, String companyId) async {
    if (!_isInitialized) return;

    try {
      final box = Hive.box<String>(_quickAccessBox);
      await box.delete('quick_${userId}_$companyId');
      debugPrint('Quick access cache invalidated for user: $userId, company: $companyId');
    } catch (e) {
      debugPrint('Failed to invalidate quick access cache: $e');
    }
  }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  /// Clear all caches (e.g., on logout)
  Future<void> clearAll() async {
    if (!_isInitialized) return;

    try {
      if (kDebugMode) {
        debugPrint('🗑️ [SWR] Clearing all Hive caches...');
      }
      await Hive.box<String>(_userCompaniesBox).clear();
      await Hive.box<String>(_categoriesBox).clear();
      await Hive.box<String>(_quickAccessBox).clear();
      if (kDebugMode) {
        debugPrint('✅ [SWR] All Hive caches cleared (logout)');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SWR] Failed to clear Hive caches: $e');
      }
    }
  }

  /// Clear all caches for a specific user (e.g., on logout)
  Future<void> clearUserData(String userId) async {
    if (!_isInitialized) return;

    try {
      // Clear user companies
      final userBox = Hive.box<String>(_userCompaniesBox);
      await userBox.delete('user_$userId');

      // Clear all quick access entries for this user
      final quickBox = Hive.box<String>(_quickAccessBox);
      final keysToDelete = quickBox.keys
          .where((key) => key.toString().startsWith('quick_$userId'))
          .toList();
      for (final key in keysToDelete) {
        await quickBox.delete(key);
      }

      debugPrint('User data cleared from Hive for user: $userId');
    } catch (e) {
      debugPrint('Failed to clear user data from Hive: $e');
    }
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getStats() {
    if (!_isInitialized) {
      return {'initialized': false};
    }

    try {
      return {
        'initialized': true,
        'user_companies_count': Hive.box<String>(_userCompaniesBox).length,
        'categories_cached': Hive.box<String>(_categoriesBox).isNotEmpty,
        'quick_access_count': Hive.box<String>(_quickAccessBox).length,
      };
    } catch (e) {
      return {'initialized': true, 'error': e.toString()};
    }
  }
}
