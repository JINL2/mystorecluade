import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/core/homepage_logger.dart';

/// Base repository class with common error handling and logging
///
/// All repository implementations should extend this class to get:
/// - Centralized error mapping (PostgrestException → Failure)
/// - Automatic logging for errors
/// - Consistent error handling patterns
///
/// Usage:
/// ```dart
/// class MyRepositoryImpl extends BaseRepository implements MyRepository {
///   @override
///   Future<Either<Failure, MyEntity>> getData() async {
///     return executeWithErrorHandling(
///       operation: () async {
///         final model = await dataSource.getData();
///         return model.toEntity();
///       },
///       errorContext: 'getData',
///     );
///   }
/// }
/// ```
abstract class BaseRepository {
  /// Execute a repository operation with automatic error handling
  ///
  /// [operation]: The async operation to execute
  /// [errorContext]: Context string for logging (e.g., 'createCompany', 'getData')
  /// [fallbackErrorMessage]: Custom error message for generic exceptions
  Future<Either<Failure, T>> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String errorContext,
    String? fallbackErrorMessage,
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } on Failure catch (failure) {
      // Handle thrown Failures (for validation errors that should be returned early)
      homepageLogger.w('Validation failure in $errorContext: ${failure.message}');
      return Left(failure);
    } on PostgrestException catch (e) {
      homepageLogger.e('PostgrestException in $errorContext: ${e.code} - ${e.message}');
      return Left(mapPostgrestError(e));
    } on Exception catch (e) {
      homepageLogger.e('Exception in $errorContext: $e');
      if (e.toString().contains('not authenticated')) {
        return const Left(AuthFailure(
          message: 'Please log in to continue',
          code: 'AUTH_REQUIRED',
        ));
      }
      return Left(UnknownFailure(
        message: fallbackErrorMessage ?? e.toString(),
        code: 'UNKNOWN_ERROR',
      ));
    } catch (e) {
      homepageLogger.e('Unexpected error in $errorContext: $e');
      return Left(UnknownFailure(
        message: fallbackErrorMessage ?? 'An unexpected error occurred. Please try again.',
        code: 'UNKNOWN_ERROR',
      ));
    }
  }

  /// Map Supabase PostgrestException to domain Failures
  ///
  /// Handles common database error codes:
  /// - 23505: Unique constraint violation
  /// - 23503: Foreign key constraint violation
  /// - 23514: Check constraint violation
  /// - PGRST116: No rows returned
  Failure mapPostgrestError(PostgrestException e) {
    switch (e.code) {
      case '23505': // Unique constraint violation
        if (e.message.contains('company_name')) {
          return const ServerFailure(
            message: 'A business with this name already exists',
            code: 'DUPLICATE_NAME',
          );
        }
        if (e.message.contains('store_name')) {
          return const ServerFailure(
            message: 'A store with this name already exists',
            code: 'DUPLICATE_NAME',
          );
        }
        if (e.message.contains('company_code') || e.message.contains('store_code')) {
          return const ServerFailure(
            message: 'This code is already in use',
            code: 'DUPLICATE_CODE',
          );
        }
        return const ServerFailure(
          message: 'This information is already in use',
          code: 'DUPLICATE_ERROR',
        );

      case '23503': // Foreign key constraint violation
        return const ServerFailure(
          message: 'Invalid reference data. Please refresh and try again',
          code: 'FOREIGN_KEY_ERROR',
        );

      case '23514': // Check constraint violation
        return const ServerFailure(
          message: 'Invalid data format. Please check your input',
          code: 'CHECK_CONSTRAINT_ERROR',
        );

      case 'PGRST116': // No rows returned
        return const NotFoundFailure(
          message: 'Required information not found',
          code: 'NOT_FOUND',
        );

      case 'PGRST301': // Timeout
        return const ServerFailure(
          message: 'Request timed out. Please try again',
          code: 'TIMEOUT_ERROR',
        );

      default:
        return ServerFailure(
          message: 'A database error occurred. Please try again',
          code: e.code ?? 'DATABASE_ERROR',
        );
    }
  }
}
