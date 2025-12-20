// lib/core/monitoring/sentry_config.dart

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Sentry Configuration
///
/// Centralized configuration for error tracking and monitoring.
/// Uses Sentry for production error logging.
///
/// Production: Errors sent to Sentry with user context
/// Development: Errors logged locally via dart:developer
class SentryConfig {
  // Sentry DSN
  static const String _dsn =
      'https://07462c1d1ae9f1a85a4480d7905b4bc4@o4510344916107264.ingest.us.sentry.io/4510344917024768';

  // Logging tag for development
  static const String _logName = 'Sentry';

  /// Initialize Sentry
  ///
  /// Call this in main.dart before runApp()
  static Future<void> init(Future<void> Function() appRunner) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = _dsn;

        // Environment
        options.environment = kReleaseMode ? 'production' : 'development';

        // Performance Monitoring
        // Production: 20% sampling to reduce costs
        // Development: 100% for full visibility
        options.tracesSampleRate = kReleaseMode ? 0.2 : 1.0;

        // Release & Distribution
        options.release = 'myfinance@1.0.0+1'; // Match pubspec.yaml version
        options.dist = '1';

        // Debug mode only in development
        options.debug = kDebugMode;

        // Filter sensitive data
        options.beforeSend = _beforeSend;
        options.beforeBreadcrumb = _beforeBreadcrumb;

        // Attach screenshots on errors (mobile only)
        options.attachScreenshot = true;
        options.screenshotQuality = SentryScreenshotQuality.low;

        // Max breadcrumbs
        options.maxBreadcrumbs = 100;

        // Reduce noise from known issues
        options.enableAutoSessionTracking = true;
        options.attachThreads = true;
      },
      appRunner: appRunner,
    );

    _log('Sentry initialized (${kReleaseMode ? "production" : "development"})');
  }

  /// Filter sensitive data before sending to Sentry
  static SentryEvent? _beforeSend(SentryEvent event, Hint hint) {
    // Ignore widget inspector errors (nested error reporting)
    final exception = event.throwable;
    if (exception is AssertionError) {
      final message = exception.message?.toString() ?? '';
      if (message.contains('Looking up a deactivated widget') ||
          message.contains('_debugCheckStateIsActiveForAncestorLookup')) {
        return null;
      }
    }

    // Mask email addresses
    if (event.user?.email != null) {
      final email = event.user!.email!;
      final atIndex = email.indexOf('@');
      if (atIndex > 0) {
        event = event.copyWith(
          user: event.user?.copyWith(
            email: '***${email.substring(atIndex)}',
          ),
        );
      }
    }

    // Remove sensitive tags
    final tags = event.tags;
    if (tags != null && tags.isNotEmpty) {
      final filteredTags = <String, String>{};
      for (final entry in tags.entries) {
        final keyLower = entry.key.toLowerCase();
        if (keyLower.contains('password') ||
            keyLower.contains('token') ||
            keyLower.contains('secret') ||
            keyLower.contains('api_key')) {
          filteredTags[entry.key] = '***REDACTED***';
        } else {
          filteredTags[entry.key] = entry.value;
        }
      }
      event = event.copyWith(tags: filteredTags);
    }

    return event;
  }

  /// Filter breadcrumbs before sending
  static Breadcrumb? _beforeBreadcrumb(Breadcrumb? breadcrumb, Hint? hint) {
    if (breadcrumb == null) return null;

    // Skip navigation breadcrumbs with sensitive routes
    if (breadcrumb.category == 'navigation') {
      final from = breadcrumb.data?['from'] as String?;
      final to = breadcrumb.data?['to'] as String?;
      if (_containsSensitiveRoute(from) || _containsSensitiveRoute(to)) {
        return null;
      }
    }

    return breadcrumb;
  }

  /// Check if route contains sensitive keywords
  static bool _containsSensitiveRoute(String? route) {
    if (route == null) return false;
    final lower = route.toLowerCase();
    return lower.contains('password') ||
        lower.contains('token') ||
        lower.contains('secret') ||
        lower.contains('otp');
  }

  /// Capture exception manually
  ///
  /// Use this for critical errors that need immediate attention.
  static Future<void> captureException(
    dynamic exception,
    dynamic stackTrace, {
    String? hint,
    Map<String, dynamic>? extra,
    SentryLevel level = SentryLevel.error,
  }) async {
    // Always log locally for debugging
    _log(
      'Exception: $exception',
      error: exception,
      stackTrace: stackTrace is StackTrace ? stackTrace : null,
    );

    if (!kReleaseMode) return;

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: Hint.withMap({
        if (hint != null) 'hint': hint,
        if (extra != null) ...extra,
      }),
    );
  }

  /// Capture message manually
  ///
  /// Use this for important info/warning messages.
  static Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extra,
  }) async {
    _log('Message [$level]: $message');

    if (!kReleaseMode) return;

    await Sentry.captureMessage(
      message,
      level: level,
      hint: extra != null ? Hint.withMap(extra) : null,
    );
  }

  /// Add breadcrumb
  ///
  /// Track user actions for debugging context.
  static void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    // In development, only log important breadcrumbs
    if (!kReleaseMode && level.ordinal >= SentryLevel.warning.ordinal) {
      _log('Breadcrumb: $message', category: category);
    }

    if (kReleaseMode) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: message,
          category: category,
          data: data,
          level: level,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  /// Set user context
  ///
  /// Call this after successful login.
  static void setUser({
    required String id,
    String? email,
    String? username,
    Map<String, dynamic>? extras,
  }) {
    _log('User set: $id');

    if (!kReleaseMode) return;

    Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(
          id: id,
          email: email,
          username: username,
          data: extras,
        ),
      );
    });
  }

  /// Clear user context
  ///
  /// Call this after logout.
  static void clearUser() {
    _log('User cleared');

    if (!kReleaseMode) return;

    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Set custom context
  ///
  /// Add additional debug context.
  static void setContext(String key, Map<String, dynamic> context) {
    if (!kReleaseMode) return;

    Sentry.configureScope((scope) {
      scope.setContexts(key, context);
    });
  }

  /// Internal logging using dart:developer
  ///
  /// Uses structured logging instead of debugPrint for better performance.
  /// Only logs in debug mode, completely compiled out in release.
  static void _log(
    String message, {
    String? category,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: category != null ? '$_logName:$category' : _logName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
