/// GoRouter Extensions with Duplicate Click Prevention
///
/// Provides debounced navigation methods to prevent rapid duplicate clicks
/// while maintaining standard GoRouter API compatibility.
///
/// Usage:
/// ```dart
/// import 'package:go_router/go_router.dart';
/// import 'package:myfinance_improved/core/navigation/go_router_extensions.dart';
///
/// // Use normally - debouncing is automatic
/// context.pop();
/// context.push('/page');
/// context.go('/page');
/// ```

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Debouncer to prevent rapid duplicate navigation calls
class _NavigationDebouncer {
  static final _NavigationDebouncer _instance = _NavigationDebouncer._();
  static _NavigationDebouncer get instance => _instance;

  _NavigationDebouncer._();

  /// Active debounce timers for each action type
  final Map<String, Timer> _timers = {};

  /// Default debounce duration (300ms)
  static const Duration debounceDuration = Duration(milliseconds: 300);

  /// Check if action is currently debounced
  bool isDebounced(String actionKey) {
    return _timers[actionKey]?.isActive ?? false;
  }

  /// Execute action with debouncing
  void debounce(String actionKey, VoidCallback action, {Duration? duration}) {
    // If already debounced, ignore
    if (isDebounced(actionKey)) {
      debugPrint('[Navigation] Debounced: $actionKey');
      return;
    }

    // Execute action immediately
    action();

    // Set debounce timer
    _timers[actionKey] = Timer(duration ?? debounceDuration, () {
      _timers.remove(actionKey);
    });
  }

  /// Clear specific debounce
  void clear(String actionKey) {
    _timers[actionKey]?.cancel();
    _timers.remove(actionKey);
  }

  /// Clear all debounces
  void clearAll() {
    _timers.forEach((key, timer) => timer.cancel());
    _timers.clear();
  }
}

/// Extension on BuildContext for debounced GoRouter navigation
extension DebouncedGoRouterExtension on BuildContext {
  /// Debounced pop with duplicate click prevention
  ///
  /// Prevents rapid successive pop() calls within 300ms
  void debouncedPop<T extends Object?>([T? result]) {
    _NavigationDebouncer.instance.debounce(
      'pop_${hashCode}',
      () {
        if (mounted && canPop()) {
          pop(result);
        }
      },
    );
  }

  /// Debounced push with duplicate click prevention
  ///
  /// Prevents rapid successive push() calls to same route within 300ms
  Future<T?> debouncedPush<T extends Object?>(
    String location, {
    Object? extra,
  }) async {
    final actionKey = 'push_${location}_${hashCode}';

    if (_NavigationDebouncer.instance.isDebounced(actionKey)) {
      debugPrint('[Navigation] Push debounced: $location');
      return null;
    }

    // Mark as debounced
    _NavigationDebouncer.instance.debounce(
      actionKey,
      () {}, // No-op, just mark as debounced
    );

    // Execute push
    if (mounted) {
      return await push<T>(location, extra: extra);
    }
    return null;
  }

  /// Debounced go with duplicate click prevention
  ///
  /// Prevents rapid successive go() calls to same route within 300ms
  void debouncedGo(
    String location, {
    Object? extra,
  }) {
    final actionKey = 'go_${location}_${hashCode}';

    _NavigationDebouncer.instance.debounce(
      actionKey,
      () {
        if (mounted) {
          go(location, extra: extra);
        }
      },
    );
  }

  /// Debounced pushReplacement with duplicate click prevention
  Future<T?> debouncedPushReplacement<T extends Object?>(
    String location, {
    Object? extra,
  }) async {
    final actionKey = 'pushReplacement_${location}_${hashCode}';

    if (_NavigationDebouncer.instance.isDebounced(actionKey)) {
      debugPrint('[Navigation] PushReplacement debounced: $location');
      return null;
    }

    // Mark as debounced
    _NavigationDebouncer.instance.debounce(
      actionKey,
      () {}, // No-op, just mark as debounced
    );

    // Execute pushReplacement
    if (mounted) {
      return await pushReplacement<T>(location, extra: extra);
    }
    return null;
  }
}

/// Helper to clear all navigation debounces (useful for testing)
void clearAllNavigationDebounces() {
  _NavigationDebouncer.instance.clearAll();
}
