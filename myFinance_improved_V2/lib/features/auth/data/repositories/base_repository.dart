// lib/features/auth/data/repositories/base_repository.dart

/// Base repository with common error handling wrapper
///
/// All repositories should extend this class to get consistent
/// exception handling patterns.
///
/// Note: Since DataSource layer already handles Supabase-specific exceptions,
/// this base class simply provides convenience wrapper methods.
/// DataSource converts Supabase exceptions to regular Exceptions with meaningful messages.
abstract class BaseRepository {
  /// Execute database operation
  ///
  /// Wraps the operation call to provide consistent error handling pattern.
  /// DataSource layer is responsible for converting Supabase exceptions.
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
    } catch (e) {
      // Re-throw the exception from DataSource
      // DataSource already provides meaningful error messages
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
    } catch (e) {
      // Re-throw the exception from DataSource
      rethrow;
    }
  }
}
