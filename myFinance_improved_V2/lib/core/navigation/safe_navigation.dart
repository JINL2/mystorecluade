import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
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
    
    // Auto-unlock after 5 seconds to prevent persistent locks
    Timer(const Duration(seconds: 5), () {
      if (_navigationLocks[route] == true) {
        _unlockNavigation(route);
        if (kDebugMode) {
          debugPrint('[SafeNavigation] Auto-unlocked stale lock: $route');
        }
      }
    });
  }
  
  /// Unlock navigation for a specific route
  void _unlockNavigation(String route) {
    _navigationLocks[route] = false;
    _debounceTimers[route]?.cancel();
    _debounceTimers.remove(route);
  }
  
  /// Add route to navigation history
  void _addToHistory(String route) {
    _navigationHistory.add(route);
    
    // Keep only recent history
    if (_navigationHistory.length > maxRedirectHistory) {
      _navigationHistory.removeAt(0);
    }
  }
  
  /// Check for redirect loops
  bool _hasRedirectLoop() {
    if (_navigationHistory.length < 4) return false;
    
    // Check if the last 4 navigations contain a loop pattern
    final startIndex = _navigationHistory.length - 4;
    final recent = _navigationHistory.sublist(startIndex).toList();
    if (recent.length == 4 && 
        recent[0] == recent[2] && 
        recent[1] == recent[3]) {
      return true;
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
      if (kDebugMode) {
        debugPrint('[SafeNavigation] Context not mounted for push to: $route');
      }
      return null;
    }
    
    // Use route as lock key if not provided
    lockKey ??= route;
    
    // Check for existing navigation lock
    if (isNavigationLocked(lockKey)) {
      if (kDebugMode) {
        debugPrint('[SafeNavigation] Navigation locked: $lockKey');
      }
      return null;
    }
    
    // Check for redirect loops
    if (_hasRedirectLoop()) {
      if (kDebugMode) {
        debugPrint('[SafeNavigation] Redirect loop detected: $route');
      }
      _navigationHistory.clear();
      return null;
    }
    
    // Debounce rapid navigation attempts (reduced time for auth pages)
    final isAuthPage = route.startsWith('/auth/');
    final debounceTime = isAuthPage ? const Duration(milliseconds: 150) : debounceDuration;
    
    if (_debounceTimers[lockKey]?.isActive == true) {
      if (kDebugMode) {
        debugPrint('[SafeNavigation] Debounce active: $route');
      }
      return null;
    }
    
    // Set debounce timer
    _debounceTimers[lockKey] = Timer(debounceTime, () {
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
      // Reduced logging - only in debug mode
      if (kDebugMode) {
        debugPrint('[SafeNavigation] Locked: $lockKey');
      }
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
      if (kDebugMode) {
        debugPrint('[SafeNavigation] Locked: $name');
      }
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
    if (kDebugMode) {
      debugPrint('[SafeNavigation] Cleared lock for route: $route');
    }
  }
  
  /// Clear all auth navigation locks (useful for auth page issues)
  void clearAuthLocks() {
    final authRoutes = _navigationLocks.keys.where((route) => route.startsWith('/auth')).toList();
    for (final route in authRoutes) {
      clearLockForRoute(route);
    }
    if (kDebugMode) {
      debugPrint('[SafeNavigation] Cleared ${authRoutes.length} auth locks: $authRoutes');
    }
    
    // Also clear any debounce timers for auth routes
    final authTimers = _debounceTimers.keys.where((route) => route.startsWith('/auth')).toList();
    for (final route in authTimers) {
      _debounceTimers[route]?.cancel();
      _debounceTimers.remove(route);
    }
    if (kDebugMode && authTimers.isNotEmpty) {
      debugPrint('[SafeNavigation] Cleared ${authTimers.length} auth timers: $authTimers');
    }
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
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'OK',
            textColor: TossColors.white,
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