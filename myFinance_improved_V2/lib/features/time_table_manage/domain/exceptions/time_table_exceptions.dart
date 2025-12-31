/// Base exception for Time Table Management feature
class TimeTableException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const TimeTableException(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'TimeTableException: $message';
}

/// Exception for shift metadata operations
class ShiftMetadataException extends TimeTableException {
  const ShiftMetadataException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ShiftMetadataException: $message';
}

/// Exception for shift status operations
class ShiftStatusException extends TimeTableException {
  const ShiftStatusException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ShiftStatusException: $message';
}

/// Exception for shift approval operations
class ShiftApprovalException extends TimeTableException {
  const ShiftApprovalException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ShiftApprovalException: $message';
}

/// Exception for shift deletion operations
class ShiftDeletionException extends TimeTableException {
  const ShiftDeletionException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ShiftDeletionException: $message';
}
