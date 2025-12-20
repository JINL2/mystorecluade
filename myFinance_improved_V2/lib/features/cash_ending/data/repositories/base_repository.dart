// lib/features/cash_ending/data/repositories/base_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../domain/exceptions/cash_ending_exception.dart';

/// Base Repository for common error handling
///
/// Provides DRY error handling for all repositories in cash_ending feature.
/// Converts infrastructure errors (Supabase, network) to domain exceptions.
/// Includes Sentry logging for production error monitoring.
abstract class BaseRepository {
  /// Execute operation with unified error handling
  ///
  /// Wraps repository operations and converts errors to domain exceptions.
  /// Use this for all datasource calls to ensure consistent error handling.
  /// Logs errors to Sentry for production monitoring.
  ///
  /// Example:
  /// ```dart
  /// return executeWithErrorHandling(
  ///   () async {
  ///     final data = await _datasource.getData();
  ///     return data.map((json) => Model.fromJson(json).toEntity()).toList();
  ///   },
  ///   operationName: 'getData',
  /// );
  /// ```
  Future<T> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    required String operationName,
  }) async {
    try {
      return await operation();
    } on PostgrestException catch (e, stackTrace) {
      // Supabase database error
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEnding: Database error in $operationName',
        extra: {'operation': operationName, 'message': e.message, 'code': e.code},
      );
      throw DataSourceException(
        'Database error in $operationName: ${e.message}',
        originalError: e,
      );
    } on FunctionException catch (e, stackTrace) {
      // Supabase RPC function error
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEnding: RPC error in $operationName',
        extra: {'operation': operationName, 'details': e.details},
      );
      throw DataSourceException(
        'RPC error in $operationName: ${e.details}',
        originalError: e,
      );
    } on AuthException catch (e, stackTrace) {
      // Supabase auth error (e.g., expired session)
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEnding: Auth error in $operationName',
        extra: {'operation': operationName},
      );
      throw DataSourceException(
        'Auth error in $operationName: ${e.message}',
        originalError: e,
      );
    } on CashEndingException {
      // Already a domain exception, just rethrow (no need to log twice)
      rethrow;
    } catch (e, stackTrace) {
      // Unknown error - log to Sentry
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEnding: Unexpected error in $operationName',
        extra: {'operation': operationName},
      );
      throw DataSourceException(
        'Unexpected error in $operationName: $e',
        originalError: e,
      );
    }
  }
}
