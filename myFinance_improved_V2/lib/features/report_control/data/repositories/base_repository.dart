// lib/features/report_control/data/repositories/base_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/exceptions/report_exception.dart';

/// Base Repository for common error handling in Report Control feature
///
/// Provides DRY error handling for all repositories.
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
  ///     final data = await _datasource.getUserReports(userId);
  ///     return data.map((dto) => dto.toDomain()).toList();
  ///   },
  ///   operationName: 'getUserReports',
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
      throw RpcException(
        'RPC error in $operationName: ${e.details}',
        originalError: e,
      );
    } on AuthException catch (e) {
      // Supabase auth error (e.g., expired session)
      throw DataSourceException(
        'Auth error in $operationName: ${e.message}',
        originalError: e,
      );
    } on ReportException {
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
