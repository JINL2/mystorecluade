import 'dart:async';
import 'package:flutter/foundation.dart';
import 'token_manager.dart';

/// Enhanced TokenManager with intelligent retry mechanism
/// Adds transparent retry logic without modifying core TokenManager
/// 
/// Features:
/// - Exponential backoff retry strategy
/// - Background retry scheduling
/// - Error analytics integration
/// - Silent failure recovery
extension TokenManagerEnhanced on TokenManager {
  /// Ensure token is registered with intelligent retry
  /// Attempts registration with exponential backoff
  /// Schedules background retry if all attempts fail
  Future<bool> ensureTokenRegisteredSafely({
    int maxAttempts = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
    bool scheduleBackgroundRetry = true,
  }) async {
    // Track attempt results for analytics
    final attemptResults = <Map<String, dynamic>>[];
    
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final attemptStart = DateTime.now();
      
      try {
        // Try to register token
        final result = await ensureTokenRegistered();
        
        if (result) {
          // Success - log and return
          attemptResults.add({
            'attempt': attempt + 1,
            'success': true,
            'duration_ms': DateTime.now().difference(attemptStart).inMilliseconds,
          });
          
          _logTokenSuccess(attemptResults);
          return true;
        }
        
        // Registration returned false - log and retry
        attemptResults.add({
          'attempt': attempt + 1,
          'success': false,
          'error': 'Registration returned false',
          'duration_ms': DateTime.now().difference(attemptStart).inMilliseconds,
        });
        
      } catch (error) {
        // Error occurred - log and prepare for retry
        attemptResults.add({
          'attempt': attempt + 1,
          'success': false,
          'error': error.toString(),
          'duration_ms': DateTime.now().difference(attemptStart).inMilliseconds,
        });
        
        // Log error for debugging (but not to console in production)
        if (kDebugMode) {
          debugPrint('Token registration attempt ${attempt + 1} failed: $error');
        }
      }
      
      // If not the last attempt, wait with exponential backoff
      if (attempt < maxAttempts - 1) {
        final delay = initialDelay * (attempt + 1);
        await Future.delayed(delay);
      }
    }
    
    // All attempts failed - schedule background retry if requested
    if (scheduleBackgroundRetry) {
      _scheduleBackgroundRetry(attemptResults);
    }
    
    // Log failure for analytics
    _logTokenFailure(attemptResults);
    
    return false;
  }
  
  /// Schedule a background retry for token registration
  static void _scheduleBackgroundRetry(List<Map<String, dynamic>> previousAttempts) {
    // Use a longer delay for background retry
    final delay = _calculateBackgroundDelay(previousAttempts.length);
    
    Timer(delay, () async {
      try {
        final tokenManager = TokenManager();
        final success = await tokenManager.ensureTokenRegisteredSafely(
          maxAttempts: 2, // Fewer attempts in background
          scheduleBackgroundRetry: false, // Don't recursively schedule
        );
        
        if (success && kDebugMode) {
          debugPrint('Background token registration succeeded');
        }
      } catch (e) {
        // Silent failure in background
        if (kDebugMode) {
          debugPrint('Background token registration failed: $e');
        }
      }
    });
  }
  
  /// Calculate delay for background retry based on previous attempts
  static Duration _calculateBackgroundDelay(int previousAttempts) {
    // Start with 5 minutes, double for each previous attempt set
    final minutes = 5 * (previousAttempts <= 3 ? 1 : previousAttempts - 2);
    
    // Cap at 30 minutes
    return Duration(minutes: minutes.clamp(5, 30));
  }
  
  /// Log successful token registration for analytics
  static void _logTokenSuccess(List<Map<String, dynamic>> attempts) {
    try {
      // In production, this would send to analytics service
      // For now, just track locally
      final totalDuration = attempts
          .map((a) => a['duration_ms'] as int? ?? 0)
          .reduce((a, b) => a + b);
      
      final successData = {
        'event': 'fcm_token_registered',
        'attempts': attempts.length,
        'total_duration_ms': totalDuration,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      if (kDebugMode) {
        debugPrint('Token registration succeeded after ${attempts.length} attempts');
      }
      
      // Store success metrics for monitoring
      _storeMetrics('token_success', successData);
      
    } catch (_) {
      // Don't fail if analytics fails
    }
  }
  
  /// Log failed token registration for analytics
  static void _logTokenFailure(List<Map<String, dynamic>> attempts) {
    try {
      // Extract error messages
      final errors = attempts
          .where((a) => a['error'] != null)
          .map((a) => a['error'])
          .toSet()
          .toList();
      
      final failureData = {
        'event': 'fcm_token_failed',
        'attempts': attempts.length,
        'errors': errors,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      if (kDebugMode) {
        debugPrint('Token registration failed after ${attempts.length} attempts');
      }
      
      // Store failure metrics for monitoring
      _storeMetrics('token_failure', failureData);
      
    } catch (_) {
      // Don't fail if analytics fails
    }
  }
  
  /// Store metrics for monitoring (simplified version)
  static void _storeMetrics(String key, Map<String, dynamic> data) {
    // In production, this would:
    // 1. Send to analytics service (Firebase, Mixpanel, etc.)
    // 2. Store locally for batch upload
    // 3. Monitor failure patterns
    
    // For now, just store in memory for debugging
    _TokenMetrics.instance.store(key, data);
  }
}

/// Simple in-memory metrics storage for token registration
/// In production, replace with proper analytics service
class _TokenMetrics {
  static final _TokenMetrics instance = _TokenMetrics._();
  _TokenMetrics._();
  
  final Map<String, List<Map<String, dynamic>>> _metrics = {};
  static const int _maxMetricsPerKey = 100;
  
  void store(String key, Map<String, dynamic> data) {
    _metrics.putIfAbsent(key, () => []);
    _metrics[key]!.add(data);
    
    // Limit memory usage
    if (_metrics[key]!.length > _maxMetricsPerKey) {
      _metrics[key]!.removeAt(0);
    }
  }
  
  List<Map<String, dynamic>> get(String key) {
    return List.from(_metrics[key] ?? []);
  }
  
  Map<String, dynamic> getStats() {
    final stats = <String, dynamic>{};
    
    _metrics.forEach((key, values) {
      stats[key] = {
        'count': values.length,
        'latest': values.isNotEmpty ? values.last : null,
      };
    });
    
    return stats;
  }
  
  void clear() {
    _metrics.clear();
  }
}

/// Convenience method for easy access
extension TokenManagerConvenience on TokenManager {
  /// Register token with best practices
  /// Use this instead of ensureTokenRegistered for better reliability
  Future<bool> registerTokenSafely() async {
    return ensureTokenRegisteredSafely();
  }
}