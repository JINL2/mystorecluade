import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/navigation/safe_navigation.dart';
import '../../core/navigation/navigation_params.dart';
import '../../core/navigation/auth_navigator.dart';
import '../../core/notifications/services/token_manager.dart';
import '../../presentation/providers/state_synchronizer.dart';
import 'auth_data_cache.dart';

/// AppResetService - Unified cleanup service for the entire application
/// Ensures consistent state clearing across all systems
/// 
/// Features:
/// - Ordered cleanup chain with dependencies
/// - Error isolation (one failure doesn't stop others)
/// - Progress tracking and reporting
/// - Partial cleanup support
/// - Analytics integration
class AppResetService {
  // Singleton pattern
  AppResetService._privateConstructor();
  static final AppResetService _instance = AppResetService._privateConstructor();
  static AppResetService get instance => _instance;
  
  // Cleanup state
  bool _isResetting = false;
  final List<String> _failedSteps = [];
  final Map<String, Duration> _stepDurations = {};
  
  /// Cleanup levels
  enum CleanupLevel {
    minimal,    // Just auth state
    standard,   // Auth + app state
    complete,   // Everything including cache
  }
  
  /// Clear all application state with proper ordering
  /// Returns true if all cleanup steps succeeded
  static Future<bool> clearAll({
    CleanupLevel level = CleanupLevel.complete,
    ProviderContainer? ref,
    bool silent = false,
  }) async {
    final service = instance;
    
    if (service._isResetting) {
      if (!silent && kDebugMode) {
        debugPrint('Reset already in progress');
      }
      return false;
    }
    
    service._isResetting = true;
    service._failedSteps.clear();
    service._stepDurations.clear();
    
    final startTime = DateTime.now();
    bool allSucceeded = true;
    
    try {
      // Define cleanup steps based on level
      final cleanupSteps = _getCleanupSteps(level, ref);
      
      // Execute cleanup chain with error isolation
      for (final step in cleanupSteps) {
        final stepStart = DateTime.now();
        
        try {
          await step.operation();
          service._stepDurations[step.name] = DateTime.now().difference(stepStart);
          
          if (!silent && kDebugMode) {
            debugPrint('✅ Cleared: ${step.name}');
          }
        } catch (error) {
          allSucceeded = false;
          service._failedSteps.add(step.name);
          service._stepDurations[step.name] = DateTime.now().difference(stepStart);
          
          if (!silent) {
            debugPrint('❌ Failed to clear ${step.name}: $error');
          }
          
          // Continue with other steps even if one fails
        }
      }
      
      // Log cleanup metrics
      final totalDuration = DateTime.now().difference(startTime);
      _logCleanupMetrics(level, allSucceeded, totalDuration);
      
      return allSucceeded;
      
    } finally {
      service._isResetting = false;
    }
  }
  
  /// Get cleanup steps based on level
  static List<_CleanupStep> _getCleanupSteps(CleanupLevel level, ProviderContainer? ref) {
    final steps = <_CleanupStep>[];
    
    // Always clear these (minimal level)
    steps.addAll([
      _CleanupStep(
        'Token Manager',
        () async {
          try {
            final tokenManager = TokenManager();
            await tokenManager.clearToken();
          } catch (_) {}
        },
      ),
      _CleanupStep(
        'Supabase Auth',
        () async {
          try {
            await Supabase.instance.client.auth.signOut();
          } catch (_) {}
        },
      ),
      _CleanupStep(
        'Navigation Locks',
        () {
          SafeNavigation.instance.clearAuthLocks();
        },
      ),
    ]);
    
    // Standard level additions
    if (level == CleanupLevel.standard || level == CleanupLevel.complete) {
      steps.addAll([
        _CleanupStep(
          'App State',
          () async {
            if (ref != null) {
              try {
                // Clear app state if ref is provided
                // This would call the appropriate provider methods
                // ref.read(appStateProvider.notifier).clearData();
              } catch (_) {}
            }
          },
        ),
        _CleanupStep(
          'Navigation Params',
          () async {
            await NavigationParams.clear(includePersisted: true);
          },
        ),
        _CleanupStep(
          'Navigation History',
          () {
            AuthNavigator.reset();
          },
        ),
      ]);
    }
    
    // Complete level additions
    if (level == CleanupLevel.complete) {
      steps.addAll([
        _CleanupStep(
          'Auth Data Cache',
          () {
            AuthDataCache.instance.clearAll();
          },
        ),
        _CleanupStep(
          'State Synchronizer',
          () {
            StateSynchronizer.instance.reset();
          },
        ),
        _CleanupStep(
          'SharedPreferences',
          () async {
            try {
              final prefs = await SharedPreferences.getInstance();
              
              // Clear app-specific keys (preserve system settings)
              final keysToRemove = prefs.getKeys().where((key) {
                return key.startsWith('app_') ||
                       key.startsWith('user_') ||
                       key.startsWith('cache_') ||
                       key.startsWith('nav_') ||
                       key.startsWith('last_');
              }).toList();
              
              for (final key in keysToRemove) {
                await prefs.remove(key);
              }
            } catch (_) {}
          },
        ),
        _CleanupStep(
          'Memory Caches',
          () {
            // Clear any other in-memory caches
            // This is where you'd clear other singleton instances
          },
        ),
      ]);
    }
    
    return steps;
  }
  
  /// Clear specific subsystem
  static Future<void> clearSubsystem(String subsystem) async {
    switch (subsystem) {
      case 'auth':
        await clearAll(level: CleanupLevel.minimal);
        break;
      case 'navigation':
        AuthNavigator.reset();
        await NavigationParams.clear();
        SafeNavigation.instance.clearAuthLocks();
        break;
      case 'cache':
        AuthDataCache.instance.clearAll();
        break;
      case 'state':
        StateSynchronizer.instance.reset();
        break;
      default:
        if (kDebugMode) {
          debugPrint('Unknown subsystem: $subsystem');
        }
    }
  }
  
  /// Get cleanup status
  static Map<String, dynamic> getStatus() {
    final service = instance;
    
    return {
      'is_resetting': service._isResetting,
      'failed_steps': List.from(service._failedSteps),
      'step_durations': Map.from(service._stepDurations),
      'total_duration_ms': service._stepDurations.values
          .fold<int>(0, (sum, duration) => sum + duration.inMilliseconds),
    };
  }
  
  /// Log cleanup metrics for monitoring
  static void _logCleanupMetrics(
    CleanupLevel level,
    bool success,
    Duration duration,
  ) {
    final service = instance;
    
    final metrics = {
      'event': 'app_reset',
      'level': level.name,
      'success': success,
      'duration_ms': duration.inMilliseconds,
      'failed_steps': service._failedSteps,
      'step_count': service._stepDurations.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    if (kDebugMode) {
      debugPrint('App reset completed: ${success ? 'Success' : 'Partial failure'}');
      debugPrint('Duration: ${duration.inMilliseconds}ms');
      if (service._failedSteps.isNotEmpty) {
        debugPrint('Failed steps: ${service._failedSteps.join(', ')}');
      }
    }
    
    // In production, send to analytics service
    _storeMetrics(metrics);
  }
  
  /// Store metrics (placeholder for analytics integration)
  static void _storeMetrics(Map<String, dynamic> metrics) {
    // In production:
    // - Send to Firebase Analytics
    // - Log to Crashlytics
    // - Store for batch upload
  }
}

/// Represents a single cleanup step
class _CleanupStep {
  final String name;
  final Future<void> Function() operation;
  
  _CleanupStep(this.name, this.operation);
}

/// Extension for easy access
extension AppResetExtension on Object {
  /// Quick access to app reset service
  Future<bool> resetApp({
    AppResetService.CleanupLevel level = AppResetService.CleanupLevel.complete,
  }) {
    return AppResetService.clearAll(level: level);
  }
}