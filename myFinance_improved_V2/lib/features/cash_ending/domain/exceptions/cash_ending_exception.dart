// lib/features/cash_ending/domain/exceptions/cash_ending_exception.dart

/// Base exception for cash ending domain errors
class CashEndingException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const CashEndingException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    if (code != null) {
      return 'CashEndingException [$code]: $message';
    }
    return 'CashEndingException: $message';
  }
}

/// Exception thrown when data source operation fails (Supabase, network, etc.)
class DataSourceException extends CashEndingException {
  const DataSourceException(super.message, {super.code, super.originalError});
}
