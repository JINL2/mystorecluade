import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Navigation state for tracking navigation status and locked routes
class NavigationState {
  final bool isNavigating;
  final List<String> lockedRoutes;
  final String? currentRoute;
  final String? previousRoute;
  final List<String> navigationStack;
  final Map<String, DateTime> routeTimestamps;
  final int navigationCount;
  final Object? lastNavigationError;

  const NavigationState({
    this.isNavigating = false,
    this.lockedRoutes = const [],
    this.currentRoute,
    this.previousRoute,
    this.navigationStack = const [],
    this.routeTimestamps = const {},
    this.navigationCount = 0,
    this.lastNavigationError,
  });
  
  /// Check if a specific route is locked
  bool isRouteLocked(String route) {
    return lockedRoutes.contains(route);
  }
  
  /// Check if navigation is allowed
  bool canNavigate(String route) {
    return !isNavigating && !isRouteLocked(route);
  }
  
  /// Get the time since last navigation to a specific route
  Duration? getTimeSinceLastNavigation(String route) {
    final timestamp = routeTimestamps[route];
    if (timestamp == null) return null;
    return DateTime.now().difference(timestamp);
  }
  
  /// Check if rapid navigation is occurring (multiple navigations in short time)
  bool isRapidNavigation(String route, {Duration threshold = const Duration(milliseconds: 500)}) {
    final timeSince = getTimeSinceLastNavigation(route);
    if (timeSince == null) return false;
    return timeSince < threshold;
  }
  
  /// Create a copy with updated values
  NavigationState copyWith({
    bool? isNavigating,
    List<String>? lockedRoutes,
    String? currentRoute,
    String? previousRoute,
    List<String>? navigationStack,
    Map<String, DateTime>? routeTimestamps,
    int? navigationCount,
    Object? lastNavigationError,
  }) {
    return NavigationState(
      isNavigating: isNavigating ?? this.isNavigating,
      lockedRoutes: lockedRoutes ?? this.lockedRoutes,
      currentRoute: currentRoute ?? this.currentRoute,
      previousRoute: previousRoute ?? this.previousRoute,
      navigationStack: navigationStack ?? this.navigationStack,
      routeTimestamps: routeTimestamps ?? this.routeTimestamps,
      navigationCount: navigationCount ?? this.navigationCount,
      lastNavigationError: lastNavigationError ?? this.lastNavigationError,
    );
  }
}

/// Navigation state notifier for managing navigation state
class NavigationStateNotifier extends StateNotifier<NavigationState> {
  NavigationStateNotifier() : super(const NavigationState());
  
  /// Set navigating status
  void setNavigating(bool isNavigating) {
    state = state.copyWith(isNavigating: isNavigating);
  }
  
  /// Lock a specific route
  void lockRoute(String route) {
    if (!state.lockedRoutes.contains(route)) {
      state = state.copyWith(
        lockedRoutes: [...state.lockedRoutes, route],
      );
    }
  }
  
  /// Unlock a specific route
  void unlockRoute(String route) {
    state = state.copyWith(
      lockedRoutes: state.lockedRoutes.where((r) => r != route).toList(),
    );
  }
  
  /// Clear all locked routes
  void clearAllLocks() {
    state = state.copyWith(lockedRoutes: []);
  }
  
  /// Update current route
  void updateCurrentRoute(String route) {
    state = state.copyWith(
      previousRoute: state.currentRoute,
      currentRoute: route,
      navigationStack: [
        ...state.navigationStack.take(49), // Keep last 50 routes
        route,
      ],
      routeTimestamps: {
        ...state.routeTimestamps,
        route: DateTime.now(),
      },
      navigationCount: state.navigationCount + 1,
    );
  }
  
  /// Set navigation error
  void setNavigationError(Object error) {
    state = state.copyWith(lastNavigationError: error);
  }
  
  /// Clear navigation error
  void clearNavigationError() {
    state = state.copyWith(lastNavigationError: null);
  }
  
  /// Check if can navigate to route
  bool canNavigate(String route) {
    // Check rapid navigation
    if (state.isRapidNavigation(route)) {
      return false;
    }
    
    // Check if route is locked or currently navigating
    return state.canNavigate(route);
  }
  
  /// Start navigation with automatic locking
  bool startNavigation(String route) {
    if (!canNavigate(route)) {
      return false;
    }
    
    setNavigating(true);
    lockRoute(route);
    updateCurrentRoute(route);
    return true;
  }
  
  /// Complete navigation with automatic unlocking
  void completeNavigation(String route, {bool success = true}) {
    setNavigating(false);
    unlockRoute(route);
    
    if (!success) {
      setNavigationError('Navigation to $route failed');
    }
  }
  
  /// Get navigation history
  List<String> getNavigationHistory({int limit = 10}) {
    final stack = state.navigationStack;
    if (stack.length <= limit) return stack;
    return stack.skip(stack.length - limit).toList();
  }
  
  /// Clear navigation history
  void clearHistory() {
    state = state.copyWith(
      navigationStack: [],
      routeTimestamps: {},
    );
  }
  
  /// Reset entire navigation state
  void reset() {
    state = const NavigationState();
  }
  
  /// Get navigation statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalNavigations': state.navigationCount,
      'currentRoute': state.currentRoute,
      'previousRoute': state.previousRoute,
      'lockedRoutesCount': state.lockedRoutes.length,
      'historySize': state.navigationStack.length,
      'hasError': state.lastNavigationError != null,
    };
  }
}

/// Provider for navigation state
final navigationStateProvider = StateNotifierProvider<NavigationStateNotifier, NavigationState>((ref) {
  return NavigationStateNotifier();
});

/// Provider for checking if currently navigating
final isNavigatingProvider = Provider<bool>((ref) {
  return ref.watch(navigationStateProvider.select((state) => state.isNavigating));
});

/// Provider for current route
final currentRouteProvider = Provider<String?>((ref) {
  return ref.watch(navigationStateProvider.select((state) => state.currentRoute));
});

/// Provider for navigation history
final navigationHistoryProvider = Provider<List<String>>((ref) {
  final notifier = ref.watch(navigationStateProvider.notifier);
  return notifier.getNavigationHistory();
});

/// Provider for checking if a specific route is locked
final isRouteLocked = Provider.family<bool, String>((ref, route) {
  return ref.watch(navigationStateProvider.select((state) => state.isRouteLocked(route)));
});

/// Provider for navigation statistics
final navigationStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(navigationStateProvider.notifier);
  return notifier.getStatistics();
});