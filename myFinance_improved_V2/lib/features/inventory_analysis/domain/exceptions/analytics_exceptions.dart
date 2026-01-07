// Domain Exceptions: Inventory Analysis
// Custom exceptions for analytics operations

/// Base exception for analytics domain
abstract class AnalyticsException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AnalyticsException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AnalyticsException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Connection exception
class AnalyticsConnectionException extends AnalyticsException {
  AnalyticsConnectionException({
    required super.message,
    super.details,
  }) : super(
          code: 'CONNECTION_ERROR',
        );
}

/// Repository exception
class AnalyticsRepositoryException extends AnalyticsException {
  AnalyticsRepositoryException({
    required super.message,
    super.code = 'REPOSITORY_ERROR',
    super.details,
  });
}
