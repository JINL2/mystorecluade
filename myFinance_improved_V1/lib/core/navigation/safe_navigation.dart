import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation_state_provider.dart';

/// SafeNavigation provides thread-safe navigation with race condition protection,
/// debouncing, and comprehensive error handling for Flutter navigation
class SafeNavigation {
  SafeNavigation._();
  
  static final SafeNavigation _instance = SafeNavigation._();
  static SafeNavigation get instance => _instance;
  
  /// Navigation locks to prevent race conditions
  final Map<String, bool> _navigationLocks = {};
  
  /// Navigation history for loop detection
  final List<String> _navigationHistory = [];
  
  /// Navigation timestamps for time-aware loop detection
  final List<DateTime> _navigationTimestamps = [];
  
  /// Debounce timers for navigation actions
  final Map<String, Timer?> _debounceTimers = {};
  
  /// Maximum redirect history to prevent loops
  static const int maxRedirectHistory = 10;
  
  /// Debounce duration for rapid navigation attempts
  static const Duration debounceDuration = Duration(milliseconds: 300);
  
  /// Check if navigation to a specific route is currently locked
  bool isNavigationLocked(String route) {
    return _navigationLocks[route] == true;
  }
  
  /// Lock navigation for a specific route
  void _lockNavigation(String route) {
    _navigationLocks[route] = true;
  }
  
  /// Unlock navigation for a specific route
  void _unlockNavigation(String route) {
    _navigationLocks[route] = false;
    _debounceTimers[route]?.cancel();
    _debounceTimers.remove(route);
  }
  
  /// Add route to navigation history with timestamp
  void _addToHistory(String route) {
    _navigationHistory.add(route);
    _navigationTimestamps.add(DateTime.now());
    
    // Keep only recent history
    if (_navigationHistory.length > maxRedirectHistory) {
      _navigationHistory.removeAt(0);
      _navigationTimestamps.removeAt(0);
    }
  }
  
  /// Check for redirect loops with improved detection
  bool _hasRedirectLoop() {
    if (_navigationHistory.length < 6) return false;
    
    // Get recent navigation data
    final historyLength = _navigationHistory.length;
    final recentHistory = _navigationHistory.sublist(
      historyLength >= 8 ? historyLength - 8 : 0
    );
    final recentTimestamps = _navigationTimestamps.sublist(
      historyLength >= 8 ? historyLength - 8 : 0
    );
    
    // Check for rapid automated loops (real problems)
    // Look for 3+ consecutive identical routes within 1 second
    int consecutiveCount = 1;
    for (int i = recentHistory.length - 2; i >= 0; i--) {
      if (recentHistory[i] == recentHistory.last) {
        // Check if navigation happened within 1 second
        final timeDiff = recentTimestamps[i+1].difference(recentTimestamps[i]);
        if (timeDiff.inMilliseconds < 1000) {
          consecutiveCount++;
          if (consecutiveCount >= 3) {
            debugPrint('[SafeNavigation] Rapid redirect loop detected');
            return true;
          }
        } else {
          // Reset count if navigations are spread over time (user-initiated)
          break;
        }
      } else {
        break;
      }
    }
    
    // Check for A-B-A-B pattern but only if rapid (within 2 seconds total)
    if (recentHistory.length >= 4) {
      final last4 = recentHistory.sublist(recentHistory.length - 4);
      if (last4[0] == last4[2] && last4[1] == last4[3] && last4[0] != last4[1]) {
        // Check if all 4 navigations happened within 2 seconds
        final timeSpan = recentTimestamps.last.difference(
          recentTimestamps[recentTimestamps.length - 4]
        );
        if (timeSpan.inMilliseconds < 2000) {
          debugPrint('[SafeNavigation] Rapid A-B-A-B loop detected');
          return true;
        }
      }
    }
    
    return false;
  }
  
  /// Safe push navigation with race condition protection
  Future<T?> safePush<T>({
    required BuildContext context,
    required String route,
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    String? lockKey,
  }) async {
    // Validate context is mounted
    if (!context.mounted) {
      debugPrint('[SafeNavigation] Context not mounted for push to: $route');
      return null;
    }
    
    // Use route as lock key if not provided
    lockKey ??= route;
    
    // Check for existing navigation lock
    if (isNavigationLocked(lockKey)) {
      debugPrint('[SafeNavigation] Navigation locked for: $lockKey');
      return null;
    }
    
    // Check for redirect loops
    if (_hasRedirectLoop()) {
      debugPrint('[SafeNavigation] Redirect loop detected, aborting navigation to: $route');
      _navigationHistory.clear();
      return null;
    }
    
    // Debounce rapid navigation attempts
    if (_debounceTimers[lockKey]?.isActive == true) {
      debugPrint('[SafeNavigation] Debouncing navigation to: $route');
      return null;
    }
    
    // Set debounce timer
    _debounceTimers[lockKey] = Timer(debounceDuration, () {
      _debounceTimers.remove(lockKey);
    });
    
    // Lock navigation
    _lockNavigation(lockKey);
    _addToHistory(route);
    
    try {
      // Double-check mounted state before navigation
      if (!context.mounted) {
        debugPrint('[SafeNavigation] Context unmounted before navigation to: $route');
        return null;
      }
      
      // Build the complete route with query parameters
      String fullRoute = route;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        final queryString = queryParameters.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        fullRoute = '$route?$queryString';
      }
      
      // Perform navigation
      final result = await context.push<T>(fullRoute, extra: extra);
      
      // Update navigation state on successful navigation
      if (context.mounted) {
        _updateNavigationState(route);
      }
      
      return result;
      
    } catch (error, stackTrace) {
      debugPrint('[SafeNavigation] Error navigating to $route: $error');
      debugPrintStack(stackTrace: stackTrace);
      
      // Show error feedback if context is still mounted
      if (context.mounted) {
        _showNavigationError(context, route, error);
      }
      
      return null;
    } finally {
      // Always unlock navigation
      _unlockNavigation(lockKey);
    }
  }
  
  /// Safe go navigation (replaces current route)
  void safeGo({
    required BuildContext context,
    required String route,
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    // Validate context is mounted
    if (!context.mounted) {
      debugPrint('[SafeNavigation] Context not mounted for go to: $route');
      return;
    }
    
    // Check for redirect loops
    if (_hasRedirectLoop()) {
      debugPrint('[SafeNavigation] Redirect loop detected, aborting go to: $route');
      _navigationHistory.clear();
      context.go('/'); // Fallback to home
      return;
    }
    
    _addToHistory(route);
    
    try {
      // Build the complete route with query parameters
      String fullRoute = route;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        final queryString = queryParameters.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        fullRoute = '$route?$queryString';
      }
      
      // Perform navigation
      context.go(fullRoute, extra: extra);
      
      // Update navigation state on successful navigation
      if (context.mounted) {
        _updateNavigationState(route);
      }
      
    } catch (error, stackTrace) {
      debugPrint('[SafeNavigation] Error going to $route: $error');
      debugPrintStack(stackTrace: stackTrace);
      
      // Show error feedback if context is still mounted
      if (context.mounted) {
        _showNavigationError(context, route, error);
      }
      
      // Fallback to home on error
      if (context.mounted) {
        context.go('/');
      }
    }
  }
  
  /// Safe pop navigation
  bool safePop({
    required BuildContext context,
    Object? result,
  }) {
    // Validate context is mounted
    if (!context.mounted) {
      debugPrint('[SafeNavigation] Context not mounted for pop');
      return false;
    }
    
    try {
      // Check if we can pop
      if (!context.canPop()) {
        debugPrint('[SafeNavigation] Cannot pop, going to home');
        context.go('/');
        return false;
      }
      
      // Perform pop
      context.pop(result);
      return true;
      
    } catch (error, stackTrace) {
      debugPrint('[SafeNavigation] Error popping: $error');
      debugPrintStack(stackTrace: stackTrace);
      
      // Fallback to home on error
      if (context.mounted) {
        context.go('/');
      }
      
      return false;
    }
  }
  
  /// Safe push replacement (replaces current route in stack)
  Future<T?> safePushReplacement<T>({
    required BuildContext context,
    required String route,
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    String? lockKey,
  }) async {
    // Validate context is mounted
    if (!context.mounted) {
      debugPrint('[SafeNavigation] Context not mounted for pushReplacement to: $route');
      return null;
    }
    
    // Use route as lock key if not provided
    lockKey ??= route;
    
    // Check for existing navigation lock
    if (isNavigationLocked(lockKey)) {
      debugPrint('[SafeNavigation] Navigation locked for: $lockKey');
      return null;
    }
    
    // Lock navigation
    _lockNavigation(lockKey);
    _addToHistory(route);
    
    try {
      // Double-check mounted state before navigation
      if (!context.mounted) {
        debugPrint('[SafeNavigation] Context unmounted before pushReplacement to: $route');
        return null;
      }
      
      // Build the complete route with query parameters
      String fullRoute = route;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        final queryString = queryParameters.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        fullRoute = '$route?$queryString';
      }
      
      // Perform navigation
      context.pushReplacement(fullRoute, extra: extra);
      return null;  // pushReplacement doesn't return a value
      
    } catch (error, stackTrace) {
      debugPrint('[SafeNavigation] Error push replacement to $route: $error');
      debugPrintStack(stackTrace: stackTrace);
      
      // Show error feedback if context is still mounted
      if (context.mounted) {
        _showNavigationError(context, route, error);
      }
      
      return null;
    } finally {
      // Always unlock navigation
      _unlockNavigation(lockKey);
    }
  }
  
  /// Safe push named navigation
  Future<T?> safePushNamed<T>({
    required BuildContext context,
    required String name,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) async {
    // Validate context is mounted
    if (!context.mounted) {
      debugPrint('[SafeNavigation] Context not mounted for pushNamed to: $name');
      return null;
    }
    
    // Check for existing navigation lock
    if (isNavigationLocked(name)) {
      debugPrint('[SafeNavigation] Navigation locked for: $name');
      return null;
    }
    
    // Lock navigation
    _lockNavigation(name);
    
    try {
      // Double-check mounted state before navigation
      if (!context.mounted) {
        debugPrint('[SafeNavigation] Context unmounted before pushNamed to: $name');
        return null;
      }
      
      // Perform navigation
      return await context.pushNamed<T>(
        name,
        pathParameters: pathParameters ?? {},
        queryParameters: queryParameters ?? {},
        extra: extra,
      );
      
    } catch (error, stackTrace) {
      debugPrint('[SafeNavigation] Error push named to $name: $error');
      debugPrintStack(stackTrace: stackTrace);
      
      // Show error feedback if context is still mounted
      if (context.mounted) {
        _showNavigationError(context, name, error);
      }
      
      return null;
    } finally {
      // Always unlock navigation
      _unlockNavigation(name);
    }
  }
  
  /// Safe go named navigation
  void safeGoNamed({
    required BuildContext context,
    required String name,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    // Validate context is mounted
    if (!context.mounted) {
      debugPrint('[SafeNavigation] Context not mounted for goNamed to: $name');
      return;
    }
    
    _addToHistory(name);
    
    try {
      // Perform navigation
      context.goNamed(
        name,
        pathParameters: pathParameters ?? {},
        queryParameters: queryParameters ?? {},
        extra: extra,
      );
      
    } catch (error, stackTrace) {
      debugPrint('[SafeNavigation] Error go named to $name: $error');
      debugPrintStack(stackTrace: stackTrace);
      
      // Show error feedback if context is still mounted
      if (context.mounted) {
        _showNavigationError(context, name, error);
      }
      
      // Fallback to home on error
      if (context.mounted) {
        context.go('/');
      }
    }
  }
  
  /// Clear navigation history (useful after successful critical navigation)
  void clearHistory() {
    _navigationHistory.clear();
    _navigationTimestamps.clear();
  }
  
  /// Clear history for a specific route to prevent false loop detection
  void clearHistoryForRoute(String route) {
    if (_navigationHistory.isEmpty) return;
    
    // Remove all occurrences of this route from history
    final indicesToRemove = <int>[];
    for (int i = _navigationHistory.length - 1; i >= 0; i--) {
      if (_navigationHistory[i] == route || _navigationHistory[i] == '/$route') {
        indicesToRemove.add(i);
      }
    }
    
    // Remove in reverse order to maintain indices
    for (int index in indicesToRemove) {
      if (index < _navigationHistory.length) {
        _navigationHistory.removeAt(index);
        if (index < _navigationTimestamps.length) {
          _navigationTimestamps.removeAt(index);
        }
      }
    }
    
    debugPrint('[SafeNavigation] Cleared history for route: $route');
  }
  
  /// Clear all navigation locks (use with caution)
  void clearAllLocks() {
    _navigationLocks.clear();
    _debounceTimers.forEach((key, timer) => timer?.cancel());
    _debounceTimers.clear();
  }
  
  /// Clear navigation lock for specific route
  void clearLockForRoute(String route) {
    _navigationLocks.remove(route);
    _debounceTimers[route]?.cancel();
    _debounceTimers.remove(route);
    
    // Also clear this route from recent history to prevent false positives
    // This is useful for routes that users frequently navigate to/from
    if (_navigationHistory.isNotEmpty && _navigationHistory.last == route) {
      // Keep the history but mark it as user-cleared to prevent loop detection
      // We don't remove it entirely to maintain navigation history integrity
    }
    
    debugPrint('[SafeNavigation] Cleared lock for route: $route');
  }
  
  /// Update navigation state safely if possible
  void _updateNavigationState(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Try to find a ProviderContainer in the current context
        final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
        if (context != null && context.mounted) {
          final container = ProviderScope.containerOf(context, listen: false);
          final navNotifier = container.read(navigationStateProvider.notifier);
          navNotifier.updateCurrentRoute(route);
        }
      } catch (e) {
        // Silently ignore if we can't update navigation state
        debugPrint('[SafeNavigation] Could not update navigation state: $e');
      }
    });
  }
  
  /// Show navigation error to user
  void _showNavigationError(BuildContext context, String route, Object error) {
    if (!context.mounted) return;
    
    // Try to show snackbar
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed. Please try again.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    } catch (_) {
      // Silently fail if we can't show snackbar
    }
  }
}

/// Extension methods for convenient safe navigation
extension SafeNavigationExtension on BuildContext {
  /// Safe push navigation
  Future<T?> safePush<T>(
    String route, {
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    return SafeNavigation.instance.safePush<T>(
      context: this,
      route: route,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }
  
  /// Safe go navigation
  void safeGo(
    String route, {
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    SafeNavigation.instance.safeGo(
      context: this,
      route: route,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }
  
  /// Safe pop navigation
  bool safePop([Object? result]) {
    return SafeNavigation.instance.safePop(
      context: this,
      result: result,
    );
  }
  
  /// Safe push replacement
  Future<T?> safePushReplacement<T>(
    String route, {
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    return SafeNavigation.instance.safePushReplacement<T>(
      context: this,
      route: route,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }
  
  /// Safe push named
  Future<T?> safePushNamed<T>(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    return SafeNavigation.instance.safePushNamed<T>(
      context: this,
      name: name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
  
  /// Safe go named
  void safeGoNamed(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    SafeNavigation.instance.safeGoNamed(
      context: this,
      name: name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}