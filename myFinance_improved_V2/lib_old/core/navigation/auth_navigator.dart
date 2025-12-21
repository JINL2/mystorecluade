import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'safe_navigation.dart';
import 'navigation_params.dart';

/// AuthNavigator - Unified navigation system for auth flows
/// Harmonizes different navigation patterns without breaking changes
/// 
/// Features:
/// - Intelligent navigation method selection
/// - Stack management and cleanup
/// - Parameter passing consistency
/// - Navigation history tracking
/// - Error recovery
class AuthNavigator {
  // Singleton pattern
  AuthNavigator._privateConstructor();
  static final AuthNavigator _instance = AuthNavigator._privateConstructor();
  static AuthNavigator get instance => _instance;
  
  // Navigation tracking
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final List<String> _routeStack = [];
  static final Map<String, DateTime> _navigationTimestamps = {};
  static final Map<String, int> _navigationCounts = {};
  
  // Configuration
  static const Duration _navigationTimeout = Duration(seconds: 5);
  static const int _maxStackSize = 10;
  
  /// Get navigator key for MaterialApp
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  
  /// Get current route
  static String? get currentRoute => _routeStack.isNotEmpty ? _routeStack.last : null;
  
  /// Get route history
  static List<String> get routeHistory => List.from(_routeStack);
  
  /// Navigate to signup page with intelligent method selection
  static Future<void> toSignup(BuildContext context, {Map<String, dynamic>? params}) async {
    // Store parameters if provided
    if (params != null) {
      await params.toNavigationParams(prefix: 'signup_');
    }
    
    // Track navigation
    _trackNavigation('/auth/signup');
    
    // Use safePush for auth page navigation to avoid redirect loops
    // safePush adds to the navigation stack without triggering redirects
    context.safePush('/auth/signup');
  }
  
  /// Navigate to login page
  static Future<void> toLogin(BuildContext context, {Map<String, dynamic>? params}) async {
    if (params != null) {
      await params.toNavigationParams(prefix: 'login_');
    }
    
    _trackNavigation('/auth/login');
    
    // Clear any existing stack and go to login
    context.safeGo('/auth/login');
  }
  
  /// Navigate to choose role page
  static Future<void> toChooseRole(BuildContext context, {Map<String, dynamic>? params}) async {
    if (params != null) {
      await params.toNavigationParams(prefix: 'choose_role_');
    }
    
    _trackNavigation('/onboarding/choose-role');
    context.safeGo('/onboarding/choose-role');
  }
  
  /// Navigate to create business page
  static Future<void> toCreateBusiness(BuildContext context, {Map<String, dynamic>? params}) async {
    if (params != null) {
      await params.toNavigationParams(prefix: 'create_business_');
    }
    
    _trackNavigation('/onboarding/create-business');
    context.safePush('/onboarding/create-business');
  }
  
  /// Navigate to create store page
  static Future<void> toCreateStore(
    BuildContext context, {
    required String companyId,
    required String companyName,
    Map<String, dynamic>? additionalParams,
  }) async {
    // Store required parameters
    await NavigationParams.set('create_store_company_id', companyId);
    await NavigationParams.set('create_store_company_name', companyName);
    
    if (additionalParams != null) {
      await additionalParams.toNavigationParams(prefix: 'create_store_');
    }
    
    _trackNavigation('/onboarding/create-store');
    
    // Use safeGo with extra parameters for compatibility
    context.safeGo('/onboarding/create-store', extra: {
      'companyId': companyId,
      'companyName': companyName,
      ...?additionalParams,
    });
  }
  
  /// Navigate to join business page
  static Future<void> toJoinBusiness(BuildContext context, {Map<String, dynamic>? params}) async {
    if (params != null) {
      await params.toNavigationParams(prefix: 'join_business_');
    }
    
    _trackNavigation('/onboarding/join-business');
    context.safePush('/onboarding/join-business');
  }
  
  /// Navigate to forgot password page
  static Future<void> toForgotPassword(BuildContext context, {Map<String, dynamic>? params}) async {
    if (params != null) {
      await params.toNavigationParams(prefix: 'forgot_password_');
    }
    
    _trackNavigation('/auth/forgot-password');
    // Use safePush to maintain navigation stack for auth pages
    context.safePush('/auth/forgot-password');
  }
  
  /// Navigate to dashboard/homepage
  static Future<void> toDashboard(BuildContext context, {Map<String, dynamic>? params}) async {
    if (params != null) {
      await params.toNavigationParams(prefix: 'dashboard_');
    }
    
    _trackNavigation('/');
    
    // Clear navigation stack and go to dashboard
    _clearStack();
    context.safeGo('/');
  }
  
  /// Navigate back with intelligent handling
  static void back(BuildContext context) {
    // Try to pop first if possible (for pushed routes)
    if (context.canPop()) {
      context.safePop();
      // Clean up route stack
      if (_routeStack.isNotEmpty) {
        _routeStack.removeLast();
      }
    } else {
      // If can't pop, use GoRouter navigation to go to previous route
      final previousRoute = _getPreviousRoute();
      if (previousRoute != null) {
        context.safeGo(previousRoute);
      } else {
        // Default to login if no previous route
        context.safeGo('/auth/login');
      }
      
      // Clean up route stack
      if (_routeStack.isNotEmpty) {
        _routeStack.removeLast();
      }
    }
  }
  
  /// Replace current route
  static Future<void> replace(BuildContext context, String route, {Map<String, dynamic>? params}) async {
    if (params != null) {
      final prefix = route.replaceAll('/', '_').replaceAll('-', '_');
      await params.toNavigationParams(prefix: '${prefix}_');
    }
    
    // Remove current route from stack
    if (_routeStack.isNotEmpty) {
      _routeStack.removeLast();
    }
    
    _trackNavigation(route);
    context.safeGo(route);
  }
  
  /// Check if coming from login page (kept for future use if needed)
  static bool _isComingFromLogin() {
    if (_routeStack.isNotEmpty) {
      final lastRoute = _routeStack.last;
      return lastRoute == '/auth/login' || lastRoute.contains('login');
    }
    return false;
  }
  
  /// Get previous route from stack
  static String? _getPreviousRoute() {
    if (_routeStack.length > 1) {
      return _routeStack[_routeStack.length - 2];
    }
    return null;
  }
  
  /// Track navigation for analytics and debugging
  static void _trackNavigation(String route) {
    // Add to stack
    _routeStack.add(route);
    
    // Limit stack size
    if (_routeStack.length > _maxStackSize) {
      _routeStack.removeAt(0);
    }
    
    // Track timestamp
    _navigationTimestamps[route] = DateTime.now();
    
    // Track count
    _navigationCounts[route] = (_navigationCounts[route] ?? 0) + 1;
  }
  
  /// Clear navigation stack
  static void _clearStack() {
    _routeStack.clear();
  }
  
  /// Get navigation statistics
  static Map<String, dynamic> getStats() {
    return {
      'current_route': currentRoute,
      'stack_size': _routeStack.length,
      'unique_routes': _navigationCounts.length,
      'total_navigations': _navigationCounts.values.fold(0, (a, b) => a + b),
      'most_visited': _getMostVisitedRoute(),
    };
  }
  
  /// Get most visited route
  static String? _getMostVisitedRoute() {
    if (_navigationCounts.isEmpty) return null;
    
    String? mostVisited;
    int maxCount = 0;
    
    _navigationCounts.forEach((route, count) {
      if (count > maxCount) {
        maxCount = count;
        mostVisited = route;
      }
    });
    
    return mostVisited;
  }
  
  /// Reset navigation state
  static void reset() {
    _routeStack.clear();
    _navigationTimestamps.clear();
    _navigationCounts.clear();
    NavigationParams.clear();
  }
}

/// Extension for easy access from BuildContext
extension AuthNavigatorExtension on BuildContext {
  AuthNavigator get authNavigator => AuthNavigator.instance;
  
  /// Quick navigation methods
  Future<void> navigateToSignup({Map<String, dynamic>? params}) => 
      AuthNavigator.toSignup(this, params: params);
  
  Future<void> navigateToLogin({Map<String, dynamic>? params}) => 
      AuthNavigator.toLogin(this, params: params);
  
  Future<void> navigateToDashboard({Map<String, dynamic>? params}) => 
      AuthNavigator.toDashboard(this, params: params);
  
  void navigateBack() => AuthNavigator.back(this);
}