import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Shared utility for mapping Supabase errors to domain failures
/// Reduces code duplication across repository implementations
class SupabaseErrorMapper {
  /// Map PostgrestException to appropriate Failure type
  static Failure mapPostgrestError(PostgrestException e) {
    switch (e.code) {
      case '23505': // Unique constraint violation
        return _handleUniqueConstraintViolation(e);
      case '23503': // Foreign key constraint violation
        return _handleForeignKeyViolation(e);
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
      default:
        return ServerFailure(
          message: 'A database error occurred. Please try again',
          code: e.code ?? 'DATABASE_ERROR',
        );
    }
  }

  /// Handle unique constraint violations
  static Failure _handleUniqueConstraintViolation(PostgrestException e) {
    if (e.message.contains('company_name')) {
      return const ServerFailure(
        message: 'A business with this name already exists',
        code: 'DUPLICATE_NAME',
      );
    }
    if (e.message.contains('store_name')) {
      return const ServerFailure(
        message: 'A store with this name already exists in your company',
        code: 'DUPLICATE_STORE_NAME',
      );
    }
    return const ServerFailure(
      message: 'This information is already in use',
      code: 'DUPLICATE_ERROR',
    );
  }

  /// Handle foreign key constraint violations
  static Failure _handleForeignKeyViolation(PostgrestException e) {
    if (e.message.contains('company_id')) {
      return const NotFoundFailure(
        message: 'Selected company no longer exists',
        code: 'COMPANY_NOT_FOUND',
      );
    }
    return const ServerFailure(
      message: 'Invalid reference data. Please refresh and try again',
      code: 'FOREIGN_KEY_ERROR',
    );
  }

  /// Map general exceptions to failures
  static Failure mapException(Exception e) {
    if (e.toString().contains('not authenticated')) {
      return const AuthFailure(
        message: 'Please log in to continue',
        code: 'AUTH_REQUIRED',
      );
    }
    if (e.toString().contains('Company not found')) {
      return const NotFoundFailure(
        message: 'Selected company no longer exists',
        code: 'COMPANY_NOT_FOUND',
      );
    }
    return UnknownFailure(
      message: e.toString(),
      code: 'UNKNOWN_ERROR',
    );
  }
}
