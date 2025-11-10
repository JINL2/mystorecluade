import 'package:flutter/foundation.dart';

/// Core Application Logger
///
/// Centralized logging utility for the entire application.
/// Used by BaseRepository and other core components.
///
/// Features:
/// - Structured logging with emoji indicators
/// - Debug-mode only logging (production safe)
/// - Stack trace support
/// - Context/metadata support
/// - Easy Firebase Crashlytics integration
///
/// Usage:
/// ```dart
/// AppLogger.logError('Failed to save data', error, stackTrace);
/// AppLogger.logInfo('Operation completed successfully');
/// AppLogger.logWarning('Deprecated API used');
/// ```
class AppLogger {
  static const String _prefix = '[APP]';

  /// Log an error with optional stack trace and context
  ///
  /// This should be used for all error scenarios that need tracking.
  /// Errors are always logged (even in release mode for crash reporting).
  static void logError(
    String message,
    dynamic error, [
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  ]) {
    debugPrint('❌ $_prefix ERROR: $message');
    debugPrint('   Error: $error');

    if (stackTrace != null) {
      debugPrint('   StackTrace: $stackTrace');
    }

    if (context != null && context.isNotEmpty) {
      debugPrint('   Context: $context');
    }

    // TODO: Send to Firebase Crashlytics
    // FirebaseCrashlytics.instance.recordError(
    //   error,
    //   stackTrace,
    //   reason: '[$_prefix] $message',
    //   information: context?.entries.map((e) => '${e.key}: ${e.value}').toList() ?? [],
    //   fatal: false,
    // );
  }

  /// Log informational message (debug mode only)
  ///
  /// Use this for successful operations, state changes, etc.
  static void logInfo(
    String message, {
    Map<String, dynamic>? data,
  }) {
    if (kDebugMode) {
      debugPrint('ℹ️ $_prefix INFO: $message');
      if (data != null && data.isNotEmpty) {
        debugPrint('   Data: $data');
      }
    }

    // TODO: Send to analytics if needed
    // FirebaseAnalytics.instance.logEvent(
    //   name: 'app_info',
    //   parameters: {'message': message, ...?data},
    // );
  }

  /// Log warning message (debug mode only)
  ///
  /// Use this for non-critical issues that should be investigated.
  static void logWarning(
    String message, {
    Map<String, dynamic>? data,
  }) {
    if (kDebugMode) {
      debugPrint('⚠️ $_prefix WARNING: $message');
      if (data != null && data.isNotEmpty) {
        debugPrint('   Data: $data');
      }
    }
  }

  /// Log debug message (debug mode only)
  ///
  /// Use this for verbose debugging information.
  static void logDebug(
    String message, {
    Map<String, dynamic>? data,
  }) {
    if (kDebugMode) {
      debugPrint('🔍 $_prefix DEBUG: $message');
      if (data != null && data.isNotEmpty) {
        debugPrint('   Data: $data');
      }
    }
  }

  /// Log operation start (debug mode only)
  ///
  /// Use this to track the beginning of important operations.
  static void logOperationStart(
    String operation, {
    Map<String, dynamic>? params,
  }) {
    if (kDebugMode) {
      debugPrint('▶️ $_prefix START: $operation');
      if (params != null && params.isNotEmpty) {
        debugPrint('   Params: $params');
      }
    }
  }

  /// Log operation success (debug mode only)
  ///
  /// Use this to track successful completion of operations.
  static void logOperationSuccess(
    String operation, {
    Duration? duration,
    Map<String, dynamic>? result,
  }) {
    if (kDebugMode) {
      final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
      debugPrint('✅ $_prefix SUCCESS: $operation$durationStr');
      if (result != null && result.isNotEmpty) {
        debugPrint('   Result: $result');
      }
    }
  }

  /// Log operation failure (debug mode only, but also sends to error tracking)
  ///
  /// Use this for operations that failed but are already handled.
  static void logOperationFailure(
    String operation,
    dynamic error, {
    Duration? duration,
    StackTrace? stackTrace,
  }) {
    final durationStr = duration != null ? ' (after ${duration.inMilliseconds}ms)' : '';
    debugPrint('❌ $_prefix FAILED: $operation$durationStr');
    debugPrint('   Error: $error');

    if (stackTrace != null) {
      debugPrint('   StackTrace: $stackTrace');
    }

    // TODO: Send to error tracking
    // FirebaseCrashlytics.instance.recordError(
    //   error,
    //   stackTrace,
    //   reason: 'Operation failed: $operation',
    //   fatal: false,
    // );
  }

  /// Log performance metric (debug mode only)
  ///
  /// Use this to track performance of critical operations.
  static void logPerformance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metrics,
  }) {
    if (kDebugMode) {
      final emoji = duration.inMilliseconds > 1000 ? '⚠️' : '⏱️';
      debugPrint('$emoji $_prefix PERFORMANCE: $operation took ${duration.inMilliseconds}ms');

      if (duration.inMilliseconds > 1000) {
        debugPrint('   ⚠️ WARNING: Operation took longer than 1000ms');
      }

      if (metrics != null && metrics.isNotEmpty) {
        debugPrint('   Metrics: $metrics');
      }
    }

    // TODO: Send to Firebase Performance Monitoring
    // final trace = FirebasePerformance.instance.newTrace('app_$operation');
    // trace.setMetric('duration_ms', duration.inMilliseconds);
    // metrics?.forEach((key, value) {
    //   if (value is int) trace.setMetric(key, value);
    // });
    // await trace.stop();
  }
}
