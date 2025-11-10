import 'package:flutter/foundation.dart';

/// Logging service for Time Table feature
///
/// Centralized logging for better debugging and monitoring.
/// Easy to integrate with crashlytics/analytics later.
///
/// Usage:
/// ```dart
/// TimeTableLogger.logError('Failed to load shifts', error, stackTrace);
/// TimeTableLogger.logInfo('User approved shift', data: {'shiftId': '123'});
/// TimeTableLogger.logRpcCall('get_monthly_shift_status', params);
/// ```
class TimeTableLogger {
  static const String _prefix = '[TimeTable]';

  /// Log an error with context
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
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
  }

  /// Log info message
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

    // TODO: Send to analytics
    // FirebaseAnalytics.instance.logEvent(name: 'time_table_$message', parameters: data);
  }

  /// Log RPC call for debugging
  static void logRpcCall(
    String rpcName,
    Map<String, dynamic>? params, {
    Duration? duration,
  }) {
    if (kDebugMode) {
      final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
      debugPrint('🔄 $_prefix RPC: $rpcName$durationStr');
      if (params != null && params.isNotEmpty) {
        debugPrint('   Params: $params');
      }
    }
  }

  /// Threshold for slow RPC calls (in milliseconds)
  static const int _slowRpcThresholdMs = 1000; // 1 second

  /// Log RPC success
  static void logRpcSuccess(
    String rpcName,
    Duration duration, {
    int? itemCount,
  }) {
    if (kDebugMode) {
      final itemStr = itemCount != null ? ' ($itemCount items)' : '';
      final durationMs = duration.inMilliseconds;

      // Use warning emoji for slow RPC calls
      final emoji = durationMs > _slowRpcThresholdMs ? '⚠️' : '✅';
      debugPrint('$emoji $_prefix RPC Success: $rpcName in ${durationMs}ms$itemStr');

      // Log performance warning for slow RPCs
      if (durationMs > _slowRpcThresholdMs) {
        debugPrint('   ⚠️ WARNING: RPC took longer than ${_slowRpcThresholdMs}ms');
        debugPrint('   Consider optimizing this query or adding pagination');
      }
    }
  }

  /// Log RPC failure
  static void logRpcFailure(
    String rpcName,
    dynamic error,
    Duration duration,
  ) {
    debugPrint('❌ $_prefix RPC Failed: $rpcName after ${duration.inMilliseconds}ms');
    debugPrint('   Error: $error');

    // TODO: Send to error tracking
  }

  /// Log user action
  static void logUserAction(
    String action, {
    Map<String, dynamic>? details,
  }) {
    if (kDebugMode) {
      debugPrint('👤 $_prefix User Action: $action');
      if (details != null && details.isNotEmpty) {
        debugPrint('   Details: $details');
      }
    }

    // TODO: Send to analytics
    // FirebaseAnalytics.instance.logEvent(
    //   name: 'time_table_user_action',
    //   parameters: {'action': action, ...?details},
    // );
  }

  /// Log validation error
  static void logValidationError(
    String field,
    String error, {
    dynamic value,
  }) {
    debugPrint('⚠️ $_prefix Validation Error: $field - $error');
    if (value != null) {
      debugPrint('   Value: $value');
    }
  }

  /// Log performance metric
  static void logPerformance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metrics,
  }) {
    if (kDebugMode) {
      debugPrint('⏱️ $_prefix Performance: $operation took ${duration.inMilliseconds}ms');
      if (metrics != null && metrics.isNotEmpty) {
        debugPrint('   Metrics: $metrics');
      }
    }

    // TODO: Send to performance monitoring
    // FirebasePerformance.instance.newTrace(operation)..setMetric('duration', duration.inMilliseconds);
  }
}

/// Extension on Future for easy RPC logging
extension RpcLogging<T> on Future<T> {
  /// Wrap RPC call with automatic logging
  Future<T> logRpc(String rpcName, Map<String, dynamic>? params) async {
    final stopwatch = Stopwatch()..start();
    TimeTableLogger.logRpcCall(rpcName, params);

    try {
      final result = await this;
      stopwatch.stop();

      // Log item count if result is a list
      int? itemCount;
      if (result is List) {
        itemCount = result.length;
      }

      TimeTableLogger.logRpcSuccess(rpcName, stopwatch.elapsed, itemCount: itemCount);
      return result;
    } catch (e) {
      stopwatch.stop();
      TimeTableLogger.logRpcFailure(rpcName, e, stopwatch.elapsed);
      rethrow;
    }
  }
}
