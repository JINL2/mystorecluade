// lib/features/cash_ending/data/repositories/base_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/exceptions/cash_ending_exception.dart';

/// Base Repository for common error handling
///
/// Provides DRY error handling for all repositories in cash_ending feature.
/// Converts infrastructure errors (Supabase, network) to domain exceptions.
abstract class BaseRepository {
  /// Execute operation with unified error handling
  ///
  /// Wraps repository operations and converts errors to domain exceptions.
  /// Use this for all datasource calls to ensure consistent error handling.
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
    } on PostgrestException catch (e) {
      // Supabase database error
      throw DataSourceException(
        'Database error in $operationName: ${e.message}',
        originalError: e,
      );
    } on FunctionException catch (e) {
      // Supabase RPC function error
      throw DataSourceException(
        'RPC error in $operationName: ${e.details}',
        originalError: e,
      );
    } on AuthException catch (e) {
      // Supabase auth error (e.g., expired session)
      throw DataSourceException(
        'Auth error in $operationName: ${e.message}',
        originalError: e,
      );
    } on CashEndingException {
      // Already a domain exception, just rethrow
      rethrow;
    } catch (e) {
      // Unknown error
      throw DataSourceException(
        'Unexpected error in $operationName: $e',
        originalError: e,
      );
    }
  }
}
