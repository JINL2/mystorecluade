import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// SafeNavigation provides thread-safe and debounced navigation methods
/// to prevent navigation issues and race conditions
class SafeNavigation {
  // Singleton instance
  static final SafeNavigation _instance = SafeNavigation._internal();
  factory SafeNavigation() => _instance;
  SafeNavigation._internal();

  // Track navigation state
  bool _isNavigating = false;
  DateTime? _lastNavigationTime;
  
  // Debounce duration (prevents rapid navigation)
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  /// Safe push navigation with debouncing and mounted check
  Future<T?> safePush<T>(
    BuildContext context,
    String location, {
    Object? extra,
    bool requireMounted = true,
  }) async {
    if (!_canNavigate(context, requireMounted)) {
      return null;
    }

    try {
      _isNavigating = true;
      _lastNavigationTime = DateTime.now();
      
      // Perform the navigation
      final result = await context.push<T>(location, extra: extra);
      
      // Small delay to ensure navigation stability
      await Future.delayed(const Duration(milliseconds: 50));
      
      return result;
    } catch (e) {
      debugPrint('Navigation error to $location: $e');
      return null;
    } finally {
      _isNavigating = false;
    }
  }

  /// Safe go navigation (replaces entire stack)
  void safeGo(
    BuildContext context,
    String location, {
    Object? extra,
    bool requireMounted = true,
  }) {
    if (!_canNavigate(context, requireMounted)) {
      return;
    }

    try {
      _isNavigating = true;
      _lastNavigationTime = DateTime.now();
      
      // Perform the navigation
      context.go(location, extra: extra);
      
      // Reset flag after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _isNavigating = false;
      });
    } catch (e) {
      debugPrint('Navigation error to $location: $e');
      _isNavigating = false;
    }
  }

  /// Safe pop navigation with fallback
  void safePop<T>(
    BuildContext context, {
    T? result,
    String fallbackRoute = '/',
    bool requireMounted = true,
  }) {
    if (requireMounted && !context.mounted) {
      return;
    }

    try {
      if (context.canPop()) {
        context.pop(result);
      } else {
        // No route to pop to, go to fallback
        context.go(fallbackRoute);
      }
    } catch (e) {
      debugPrint('Pop navigation error: $e');
      // Fallback to home on error
      try {
        context.go(fallbackRoute);
      } catch (_) {
        // Ignore secondary error
      }
    }
  }

  /// Safe push replacement navigation
  Future<T?> safePushReplacement<T>(
    BuildContext context,
    String location, {
    Object? extra,
    bool requireMounted = true,
  }) async {
    if (!_canNavigate(context, requireMounted)) {
      return null;
    }

    try {
      _isNavigating = true;
      _lastNavigationTime = DateTime.now();
      
      // Perform the navigation
      final result = await context.pushReplacement<T>(location, extra: extra);
      
      // Small delay to ensure navigation stability
      await Future.delayed(const Duration(milliseconds: 50));
      
      return result;
    } catch (e) {
      debugPrint('Navigation replacement error to $location: $e');
      return null;
    } finally {
      _isNavigating = false;
    }
  }

  /// Check if navigation is safe to perform
  bool _canNavigate(BuildContext context, bool requireMounted) {
    // Check if context is mounted
    if (requireMounted && !context.mounted) {
      debugPrint('Navigation blocked: Context not mounted');
      return false;
    }

    // Check if already navigating
    if (_isNavigating) {
      debugPrint('Navigation blocked: Already navigating');
      return false;
    }

    // Check debounce timing
    if (_lastNavigationTime != null) {
      final timeSinceLastNavigation = DateTime.now().difference(_lastNavigationTime!);
      if (timeSinceLastNavigation < _debounceDuration) {
        debugPrint('Navigation blocked: Debounce active (${timeSinceLastNavigation.inMilliseconds}ms)');
        return false;
      }
    }

    return true;
  }

  /// Reset navigation state (useful for error recovery)
  void reset() {
    _isNavigating = false;
    _lastNavigationTime = null;
  }

  /// Check if currently navigating
  bool get isNavigating => _isNavigating;
}

/// Extension methods for convenient safe navigation
extension SafeNavigationExtension on BuildContext {
  /// Safe push navigation
  Future<T?> safePush<T>(String location, {Object? extra}) {
    return SafeNavigation().safePush<T>(this, location, extra: extra);
  }

  /// Safe go navigation
  void safeGo(String location, {Object? extra}) {
    SafeNavigation().safeGo(this, location, extra: extra);
  }

  /// Safe pop navigation
  void safePop<T>({T? result, String fallbackRoute = '/'}) {
    SafeNavigation().safePop<T>(this, result: result, fallbackRoute: fallbackRoute);
  }

  /// Safe push replacement
  Future<T?> safePushReplacement<T>(String location, {Object? extra}) {
    return SafeNavigation().safePushReplacement<T>(this, location, extra: extra);
  }
}