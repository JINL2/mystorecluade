import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/safe_navigation.dart';

/// Helper class for safe and reliable navigation operations
class NavigationHelper {
  /// Safely navigate back with fallback to home
  /// This prevents navigation issues when there's no route to pop to
  static void safeGoBack(BuildContext context, {String fallbackRoute = '/'}) {
    if (context.canPop()) {
      context.safePop();
    } else {
      context.safeGo(fallbackRoute);
    }
  }
  
  /// Navigate to a route using push (keeps navigation stack)
  static Future<T?> navigateTo<T>(BuildContext context, String route, {Object? extra}) {
    return context.push<T>(route, extra: extra);
  }
  
  /// Replace current route (clears navigation stack)
  static void replaceTo(BuildContext context, String route, {Object? extra}) {
    context.safeGo(route, extra: extra);
  }
  
  /// Push replacement route (replaces current route in stack)
  static void pushReplacement(BuildContext context, String route, {Object? extra}) {
    context.safePushReplacement(route, extra: extra);
  }
  
  /// Check if we can navigate back
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }
  
  /// Pop until a specific route or home
  static void popUntil(BuildContext context, String targetRoute) {
    while (context.canPop()) {
      final currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
      if (currentRoute == targetRoute) break;
      context.safePop();
    }
    
    // If we couldn't find the target route, go to it
    if (!context.canPop()) {
      context.safeGo(targetRoute);
    }
  }
}