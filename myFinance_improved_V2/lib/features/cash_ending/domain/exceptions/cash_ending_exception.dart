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

/// Exception thrown when required data is missing
class MissingDataException extends CashEndingException {
  const MissingDataException(super.message, {super.code});
}

/// Exception thrown when save operation fails
class SaveFailedException extends CashEndingException {
  const SaveFailedException(super.message, {super.code, super.originalError});
}

/// Exception thrown when fetch operation fails
class FetchFailedException extends CashEndingException {
  const FetchFailedException(super.message, {super.code, super.originalError});
}

/// Exception thrown when no denominations are entered
class NoDenominationsException extends CashEndingException {
  const NoDenominationsException()
      : super('Please enter at least one denomination quantity');
}

/// Exception thrown when location is not selected
class LocationNotSelectedException extends CashEndingException {
  const LocationNotSelectedException()
      : super('Please select a location');
}

/// Exception thrown when data source operation fails (Supabase, network, etc.)
class DataSourceException extends CashEndingException {
  const DataSourceException(super.message, {super.code, super.originalError});
}
