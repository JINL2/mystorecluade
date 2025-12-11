import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// NavigationParams - Unified parameter passing system for navigation
/// Works alongside existing navigation patterns without breaking changes
/// 
/// Features:
/// - Memory-based parameter storage
/// - Support for complex objects
/// - Automatic cleanup after consumption
/// - Persistence option for critical params
/// - Compatible with all navigation methods
class NavigationParams {
  // Singleton pattern
  NavigationParams._privateConstructor();
  static final NavigationParams _instance = NavigationParams._privateConstructor();
  static NavigationParams get instance => _instance;
  
  // In-memory storage
  final Map<String, dynamic> _memory = {};
  final Map<String, DateTime> _timestamps = {};
  final Map<String, bool> _persistent = {};
  
  // Configuration
  static const Duration _defaultTTL = Duration(minutes: 5);
  static const String _persistencePrefix = 'nav_param_';
  
  /// Set a parameter value
  /// Optionally persist to SharedPreferences
  static Future<void> set(
    String key,
    dynamic value, {
    bool persist = false,
    Duration? ttl,
  }) async {
    final params = instance;
    
    // Store in memory
    params._memory[key] = value;
    params._timestamps[key] = DateTime.now();
    params._persistent[key] = persist;
    
    // Persist if requested
    if (persist) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final jsonValue = json.encode(value);
        await prefs.setString('$_persistencePrefix$key', jsonValue);
      } catch (e) {
        // If can't persist, continue with memory storage
      }
    }
    
    // Schedule cleanup if TTL provided
    if (ttl != null) {
      Future.delayed(ttl, () => remove(key));
    }
  }
  
  /// Get a parameter value
  /// Falls back to persisted value if not in memory
  static Future<T?> get<T>(
    String key, {
    T? fallback,
    bool removePersisted = false,
  }) async {
    final params = instance;
    
    // Check memory first
    if (params._memory.containsKey(key)) {
      // Check if expired
      final timestamp = params._timestamps[key];
      if (timestamp != null) {
        final age = DateTime.now().difference(timestamp);
        if (age > _defaultTTL) {
          params._memory.remove(key);
          params._timestamps.remove(key);
          params._persistent.remove(key);
        } else {
          return params._memory[key] as T?;
        }
      }
    }
    
    // Check persistence
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonValue = prefs.getString('$_persistencePrefix$key');
      
      if (jsonValue != null) {
        final value = json.decode(jsonValue);
        
        // Remove from persistence if requested
        if (removePersisted) {
          await prefs.remove('$_persistencePrefix$key');
        } else {
          // Load back into memory for faster access
          params._memory[key] = value;
          params._timestamps[key] = DateTime.now();
        }
        
        return value as T?;
      }
    } catch (e) {
      // If can't read from persistence, continue
    }
    
    return fallback;
  }
  
  /// Get a parameter value synchronously (memory only)
  static T? getSync<T>(String key, {T? fallback}) {
    final params = instance;
    
    if (params._memory.containsKey(key)) {
      final timestamp = params._timestamps[key];
      if (timestamp != null) {
        final age = DateTime.now().difference(timestamp);
        if (age <= _defaultTTL) {
          return params._memory[key] as T?;
        }
      }
    }
    
    return fallback;
  }
  
  /// Consume parameters with a specific prefix
  /// Removes them from storage after returning
  static Map<String, dynamic> consume(String prefix) {
    final params = instance;
    final result = <String, dynamic>{};
    final keysToRemove = <String>[];
    
    params._memory.forEach((key, value) {
      if (key.startsWith(prefix)) {
        result[key] = value;
        keysToRemove.add(key);
      }
    });
    
    // Remove consumed parameters
    for (final key in keysToRemove) {
      params._memory.remove(key);
      params._timestamps.remove(key);
      params._persistent.remove(key);
    }
    
    return result;
  }
  
  /// Remove a specific parameter
  static Future<void> remove(String key) async {
    final params = instance;
    
    params._memory.remove(key);
    params._timestamps.remove(key);
    
    // Remove from persistence if it was persisted
    if (params._persistent[key] == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('$_persistencePrefix$key');
      } catch (_) {}
    }
    
    params._persistent.remove(key);
  }
  
  /// Check if a parameter exists
  static bool has(String key) {
    final params = instance;
    
    if (params._memory.containsKey(key)) {
      final timestamp = params._timestamps[key];
      if (timestamp != null) {
        final age = DateTime.now().difference(timestamp);
        return age <= _defaultTTL;
      }
    }
    
    return false;
  }
  
  /// Clear all parameters
  static Future<void> clear({bool includePersisted = false}) async {
    final params = instance;
    
    params._memory.clear();
    params._timestamps.clear();
    params._persistent.clear();
    
    if (includePersisted) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys()
            .where((key) => key.startsWith(_persistencePrefix))
            .toList();
        
        for (final key in keys) {
          await prefs.remove(key);
        }
      } catch (_) {}
    }
  }
  
  /// Clean up expired parameters
  static void cleanup() {
    final params = instance;
    final now = DateTime.now();
    final keysToRemove = <String>[];
    
    params._timestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) > _defaultTTL) {
        keysToRemove.add(key);
      }
    });
    
    for (final key in keysToRemove) {
      params._memory.remove(key);
      params._timestamps.remove(key);
      params._persistent.remove(key);
    }
  }
  
  /// Get statistics about stored parameters
  static Map<String, dynamic> getStats() {
    final params = instance;
    final now = DateTime.now();
    int fresh = 0;
    int expired = 0;
    
    params._timestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) <= _defaultTTL) {
        fresh++;
      } else {
        expired++;
      }
    });
    
    return {
      'total': params._memory.length,
      'fresh': fresh,
      'expired': expired,
      'persistent': params._persistent.values.where((p) => p).length,
    };
  }
}

/// Extension for easy parameter passing
extension NavigationParamsExtension on Map<String, dynamic> {
  /// Convert map to navigation parameters
  Future<void> toNavigationParams({String prefix = ''}) async {
    for (final entry in entries) {
      await NavigationParams.set('$prefix${entry.key}', entry.value);
    }
  }
}