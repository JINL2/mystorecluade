// lib/features/auth/data/repositories/base_repository.dart

import 'package:flutter/foundation.dart';
import '../../../../core/monitoring/sentry_config.dart';

/// Base repository with common error handling wrapper
///
/// All repositories should extend this class to get consistent
/// exception handling patterns.
///
/// Features:
/// - Automatic error logging to Sentry (production only)
/// - Consistent exception handling
/// - Repository context tracking
abstract class BaseRepository {
  /// Execute database operation
  ///
  /// Wraps the operation call to provide consistent error handling pattern.
  /// Automatically logs errors to Sentry in production.
  ///
  /// Example:
  /// ```dart
  /// Future<User> createUser(User user) {
  ///   return execute(() async {
  ///     final model = await _dataSource.createUser(...);
  ///     return model.toEntity();
  ///   });
  /// }
  /// ```
  Future<T> execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      // ✅ Log error to Sentry in production
      if (kReleaseMode) {
        await SentryConfig.captureException(
          e,
          stackTrace,
          hint: 'Repository operation failed',
          extra: {
            'repository': runtimeType.toString(),
            'operation': 'execute',
          },
        );
      }

      // Re-throw the exception
      rethrow;
    }
  }

  /// Execute and return nullable result
  ///
  /// Similar to execute(), but returns null for operations that might not find data.
  /// Useful for queries that use maybeSingle() or optional lookups.
  ///
  /// Example:
  /// ```dart
  /// Future<User?> findUserById(String id) {
  ///   return executeNullable(() async {
  ///     final model = await _dataSource.getUserById(id);
  ///     return model?.toEntity();
  ///   });
  /// }
  /// ```
  Future<T?> executeNullable<T>(Future<T?> Function() operation) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      // ✅ Log error to Sentry in production
      if (kReleaseMode) {
        await SentryConfig.captureException(
          e,
          stackTrace,
          hint: 'Repository nullable operation failed',
          extra: {
            'repository': runtimeType.toString(),
            'operation': 'executeNullable',
          },
        );
      }

      // Re-throw the exception
      rethrow;
    }
  }
}
