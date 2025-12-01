// lib/core/monitoring/sentry_config.dart

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Sentry Configuration
///
/// Centralized configuration for error tracking and monitoring.
/// Uses Sentry for production error logging.
class SentryConfig {
  // ✅ Sentry DSN - Production & Development
  static const String _dsn = 'https://07462c1d1ae9f1a85a4480d7905b4bc4@o4510344916107264.ingest.us.sentry.io/4510344917024768';

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
        options.tracesSampleRate = 1.0;  // 100% of transactions

        // Release & Distribution
        options.release = 'myfinance@1.0.0+1';  // Match pubspec.yaml version
        options.dist = '1';

        // Debug
        options.debug = kDebugMode;

        // ✅ Filter sensitive data
        options.beforeSend = _beforeSend;
        options.beforeBreadcrumb = _beforeBreadcrumb;

        // ✅ Attach screenshots on errors (mobile only)
        options.attachScreenshot = true;
        options.screenshotQuality = SentryScreenshotQuality.low;

        // ✅ Max breadcrumbs
        options.maxBreadcrumbs = 100;
      },
      appRunner: appRunner,
    );
  }

  /// Filter sensitive data before sending to Sentry
  static SentryEvent? _beforeSend(SentryEvent event, Hint hint) {
    // ✅ Ignore widget inspector errors (nested error reporting)
    final exception = event.throwable;
    if (exception is AssertionError) {
      final message = exception.message?.toString() ?? '';
      if (message.contains('Looking up a deactivated widget\'s ancestor is unsafe') ||
          message.contains('_debugCheckStateIsActiveForAncestorLookup')) {
        // This is a widget lifecycle error during error reporting - ignore it
        return null;
      }
    }

    // ✅ Mask email addresses
    if (event.user?.email != null) {
      final email = event.user!.email!;
      final parts = email.split('@');
      if (parts.length == 2) {
        event = event.copyWith(
          user: event.user?.copyWith(
            email: '***@${parts[1]}',  // user@example.com → ***@example.com
          ),
        );
      }
    }

    // ✅ Remove sensitive tags
    final filteredTags = event.tags?.map((key, value) {
      if (key.toLowerCase().contains('password') ||
          key.toLowerCase().contains('token') ||
          key.toLowerCase().contains('secret')) {
        return MapEntry(key, '***REDACTED***');
      }
      return MapEntry(key, value);
    });

    if (filteredTags != null) {
      event = event.copyWith(tags: filteredTags);
    }

    return event;
  }

  /// Filter breadcrumbs before sending
  static Breadcrumb? _beforeBreadcrumb(Breadcrumb? breadcrumb, Hint? hint) {
    if (breadcrumb == null) return null;
    // ✅ Don't log navigation breadcrumbs with sensitive data
    if (breadcrumb.category == 'navigation' &&
        breadcrumb.data?.containsKey('from') == true) {
      final from = breadcrumb.data!['from'] as String?;
      if (from?.contains('password') == true ||
          from?.contains('token') == true) {
        return null;  // Skip this breadcrumb
      }
    }

    return breadcrumb;
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
    if (!kReleaseMode) {
      // In debug mode, just print
      debugPrint('🚨 [Sentry Debug] $exception');
      debugPrint('Hint: $hint');
      if (extra != null) debugPrint('Extra: $extra');
      return;
    }

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
    if (!kReleaseMode) {
      debugPrint('📝 [Sentry Debug] $message');
      if (extra != null) debugPrint('Extra: $extra');
      return;
    }

    await Sentry.captureMessage(
      message,
      level: level,
      hint: Hint.withMap(extra ?? {}),
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
    if (!kReleaseMode) {
      debugPrint('🍞 [Breadcrumb] $category: $message');
      return;
    }

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

  /// Set user context
  ///
  /// Call this after successful login.
  static void setUser({
    required String id,
    String? email,
    String? username,
    Map<String, dynamic>? extras,
  }) {
    if (!kReleaseMode) {
      debugPrint('👤 [Sentry User] $id - $email');
      return;
    }

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
    if (!kReleaseMode) {
      debugPrint('👤 [Sentry User] Cleared');
      return;
    }

    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Set custom context
  ///
  /// Add additional debug context.
  static void setContext(String key, Map<String, dynamic> context) {
    if (!kReleaseMode) {
      debugPrint('🔧 [Sentry Context] $key: $context');
      return;
    }

    Sentry.configureScope((scope) {
      scope.setContexts(key, context);
    });
  }
}
