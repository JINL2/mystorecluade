import 'package:flutter/foundation.dart';

/// Simple logging abstraction for the application
///
/// In production, this can be replaced with a proper logging framework
/// like logger, firebase_crashlytics, or sentry
class AppLogger {
  final String tag;

  const AppLogger(this.tag);

  /// Debug log - only shown in debug mode
  void d(String message, [Map<String, dynamic>? params]) {
    if (kDebugMode) {
      final paramStr = params != null ? '\n   ${params.entries.map((e) => '${e.key}: ${e.value}').join('\n   ')}' : '';
      debugPrint('🔍 [$tag] $message$paramStr');
    }
  }

  /// Info log - shown in debug mode
  void i(String message, [Map<String, dynamic>? params]) {
    if (kDebugMode) {
      final paramStr = params != null ? '\n   ${params.entries.map((e) => '${e.key}: ${e.value}').join('\n   ')}' : '';
      debugPrint('ℹ️ [$tag] $message$paramStr');
    }
  }

  /// Warning log - shown in debug mode
  void w(String message, [Map<String, dynamic>? params]) {
    if (kDebugMode) {
      final paramStr = params != null ? '\n   ${params.entries.map((e) => '${e.key}: ${e.value}').join('\n   ')}' : '';
      debugPrint('⚠️ [$tag] $message$paramStr');
    }
  }

  /// Error log - always shown
  void e(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? params}) {
    final paramStr = params != null ? '\n   ${params.entries.map((e) => '${e.key}: ${e.value}').join('\n   ')}' : '';
    debugPrint('❌ [$tag] $message$paramStr');
    if (error != null) {
      debugPrint('   Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('   StackTrace: $stackTrace');
    }
  }
}
