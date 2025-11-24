// lib/features/report_control/domain/exceptions/report_exception.dart

/// Base exception for Report Control feature
///
/// All exceptions in this feature should extend this class
sealed class ReportException implements Exception {
  final String message;
  final Object? originalError;

  const ReportException(this.message, {this.originalError});

  @override
  String toString() => 'ReportException: $message';
}

/// Exception thrown when data source operation fails
class DataSourceException extends ReportException {
  const DataSourceException(super.message, {super.originalError});

  @override
  String toString() => 'DataSourceException: $message';
}

/// Exception thrown when RPC function call fails
class RpcException extends ReportException {
  const RpcException(super.message, {super.originalError});

  @override
  String toString() => 'RpcException: $message';
}

/// Exception thrown when subscription operation fails
class SubscriptionException extends ReportException {
  const SubscriptionException(super.message, {super.originalError});

  @override
  String toString() => 'SubscriptionException: $message';
}
