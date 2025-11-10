// lib/core/data/base_repository.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import '../errors/failures.dart';
import '../types/result.dart' as result_type;
import '../utils/app_logger.dart';

/// Base Repository providing common functionality for all repositories
///
/// Purpose:
/// - Eliminates boilerplate code across repositories
/// - Unifies error handling strategy
/// - Makes testing easier
/// - Enforces consistent patterns
///
/// Usage:
/// ```dart
/// class MyRepositoryImpl extends BaseRepository implements MyRepository {
///   @override
///   Future<MyEntity> save(MyEntity entity) {
///     return executeWithErrorHandling(
///       () async {
///         final params = entity.toRpcParams();
///         await dataSource.save(params);
///         return entity;
///       },
///       operationName: 'save entity',
///     );
///   }
/// }
/// ```
abstract class BaseRepository {
  /// Executes an operation with standardized error handling
  ///
  /// This method:
  /// - Catches all exceptions
  /// - Re-throws domain exceptions (preserving business logic errors)
  /// - Wraps infrastructure errors in SaveFailedException
  /// - Provides clear error messages for debugging
  ///
  /// Parameters:
  /// - [operation]: The async operation to execute
  /// - [operationName]: Description for error messages (e.g., 'save bank balance')
  ///
  /// Throws:
  /// - Original exception if it's a domain exception (e.g., ValidationException)
  /// - [SaveFailedException] for all other errors
  Future<T> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    required String operationName,
  }) async {
    try {
      AppLogger.logOperationStart(operationName);
      final stopwatch = Stopwatch()..start();

      final result = await operation();

      stopwatch.stop();
      AppLogger.logOperationSuccess(
        operationName,
        duration: stopwatch.elapsed,
      );

      return result;
    } catch (e, stackTrace) {
      // Log error with full context
      AppLogger.logError(
        'Repository operation failed: $operationName',
        e,
        stackTrace,
      );

      // Re-throw domain exceptions (they contain business logic info)
      if (_isDomainException(e)) {
        rethrow;
      }

      // Wrap infrastructure errors
      throw _SaveFailedException(
        'Failed to $operationName',
        originalError: e,
      );
    }
  }

  /// Executes a fetch operation with error handling
  ///
  /// Similar to [executeWithErrorHandling] but throws FetchFailedException
  /// for clearer distinction between save and fetch operations
  Future<T> executeFetch<T>(
    Future<T> Function() operation, {
    required String operationName,
  }) async {
    try {
      AppLogger.logOperationStart('fetch $operationName');
      final stopwatch = Stopwatch()..start();

      final result = await operation();

      stopwatch.stop();
      AppLogger.logOperationSuccess(
        'fetch $operationName',
        duration: stopwatch.elapsed,
      );

      return result;
    } catch (e, stackTrace) {
      // Log error with full context
      AppLogger.logError(
        'Repository fetch failed: $operationName',
        e,
        stackTrace,
      );

      if (_isDomainException(e)) {
        rethrow;
      }

      throw _FetchFailedException(
        'Failed to fetch $operationName',
        originalError: e,
      );
    }
  }

  /// Checks if an exception is a domain exception
  ///
  /// Domain exceptions include:
  /// - ArgumentError (validation)
  /// - Custom typed exceptions (not generic Exception)
  ///
  /// Generic Exception from throw Exception('message') will NOT be treated as domain exception
  bool _isDomainException(Object e) {
    // ArgumentError from entity validation
    if (e is ArgumentError) return true;

    // Generic Exception is NOT a domain exception
    final typeName = e.runtimeType.toString();
    if (typeName == '_Exception' || typeName == 'Exception') {
      return false;
    }

    // All other Exception subclasses are domain exceptions
    // (AuthException, ValidationException, CashEndingException, etc.)
    if (e is Exception && typeName.endsWith('Exception')) {
      return true;
    }

    return false;
  }

  // ============================================================================
  // Strong Typing Methods (Result-based)
  // ============================================================================

  /// Executes an operation with Result-based error handling (for save operations)
  ///
  /// This is the strongly-typed version that returns Result<T, Failure> instead
  /// of throwing exceptions.
  ///
  /// ✅ Benefits:
  /// - Compile-time safety
  /// - Forces explicit error handling
  /// - Clear distinction between success and failure
  /// - IDE support with pattern matching
  ///
  /// Usage:
  /// ```dart
  /// Future<Result<User, Failure>> saveUser(User user) {
  ///   return executeWithResult(
  ///     () async => await dataSource.save(user),
  ///     operationName: 'save user',
  ///   );
  /// }
  /// ```
  Future<result_type.Result<T, Failure>> executeWithResult<T>(
    Future<T> Function() operation, {
    required String operationName,
  }) async {
    try {
      AppLogger.logOperationStart(operationName);
      final stopwatch = Stopwatch()..start();

      final result = await operation();

      stopwatch.stop();
      AppLogger.logOperationSuccess(
        operationName,
        duration: stopwatch.elapsed,
      );

      return result_type.Success(result);
    } on SocketException catch (e, stackTrace) {
      AppLogger.logError(
        'Network error in $operationName',
        e,
        stackTrace,
        {'os_error': e.osError?.toString()},
      );

      return result_type.ResultFailure(
        NetworkFailure(
          message: 'No internet connection',
          code: 'NO_CONNECTION',
        ),
      );
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.logError(
        'Timeout in $operationName',
        e,
        stackTrace,
        {'duration': e.duration?.toString()},
      );

      return result_type.ResultFailure(
        NetworkFailure(
          message: 'Request timeout',
          code: 'TIMEOUT',
        ),
      );
    } on ArgumentError catch (e, stackTrace) {
      AppLogger.logError(
        'Validation error in $operationName',
        e,
        stackTrace,
      );

      // Domain validation error
      return result_type.ResultFailure(
        ValidationFailure(
          message: e.message?.toString() ?? 'Validation failed',
          code: 'VALIDATION_ERROR',
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.logError(
        'Operation failed: $operationName',
        e,
        stackTrace,
        {'error_type': e.runtimeType.toString()},
      );

      // Check if it's a domain exception
      if (_isDomainException(e)) {
        return result_type.ResultFailure(
          ValidationFailure(
            message: e.toString(),
            code: 'DOMAIN_ERROR',
          ),
        );
      }

      // Infrastructure error
      return result_type.ResultFailure(
        ServerFailure(
          message: 'Failed to $operationName: ${e.toString()}',
          code: 'SERVER_ERROR',
        ),
      );
    }
  }

  /// Executes a fetch operation with Result-based error handling
  ///
  /// Similar to [executeWithResult] but more semantically clear for fetch operations
  Future<result_type.Result<T, Failure>> executeFetchWithResult<T>(
    Future<T> Function() operation, {
    required String operationName,
  }) async {
    return executeWithResult(operation, operationName: 'fetch $operationName');
  }
}

/// Exception thrown when a save operation fails
///
/// This wraps infrastructure errors (network, database, etc.)
/// to provide clear error messages to the UI layer
class _SaveFailedException implements Exception {
  final String message;
  final Object? originalError;

  _SaveFailedException(this.message, {this.originalError});

  @override
  String toString() {
    if (originalError != null) {
      return '$message\nCaused by: $originalError';
    }
    return message;
  }
}

/// Exception thrown when a fetch operation fails
class _FetchFailedException implements Exception {
  final String message;
  final Object? originalError;

  _FetchFailedException(this.message, {this.originalError});

  @override
  String toString() {
    if (originalError != null) {
      return '$message\nCaused by: $originalError';
    }
    return message;
  }
}
