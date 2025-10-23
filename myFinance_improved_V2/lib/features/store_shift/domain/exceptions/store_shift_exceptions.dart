/// Base exception for Store Shift feature
abstract class StoreShiftException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const StoreShiftException(this.message, [this.stackTrace]);

  @override
  String toString() => 'StoreShiftException: $message';
}

/// Exception thrown when shift data is not found
class ShiftNotFoundException extends StoreShiftException {
  const ShiftNotFoundException([String message = 'Shift not found', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'ShiftNotFoundException: $message';
}

/// Exception thrown when store data is not found
class StoreNotFoundException extends StoreShiftException {
  const StoreNotFoundException([String message = 'Store not found', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'StoreNotFoundException: $message';
}

/// Exception thrown when shift data validation fails
class InvalidShiftDataException extends StoreShiftException {
  const InvalidShiftDataException([String message = 'Invalid shift data', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'InvalidShiftDataException: $message';
}

/// Exception thrown when shift creation fails
class ShiftCreationException extends StoreShiftException {
  const ShiftCreationException([String message = 'Failed to create shift', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'ShiftCreationException: $message';
}

/// Exception thrown when shift update fails
class ShiftUpdateException extends StoreShiftException {
  const ShiftUpdateException([String message = 'Failed to update shift', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'ShiftUpdateException: $message';
}

/// Exception thrown when shift deletion fails
class ShiftDeletionException extends StoreShiftException {
  const ShiftDeletionException([String message = 'Failed to delete shift', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'ShiftDeletionException: $message';
}

/// Exception thrown when store location update fails
class StoreLocationUpdateException extends StoreShiftException {
  const StoreLocationUpdateException([String message = 'Failed to update store location', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'StoreLocationUpdateException: $message';
}

/// Exception thrown when user is unauthorized to perform operation
class UnauthorizedException extends StoreShiftException {
  const UnauthorizedException([String message = 'User is not authenticated', StackTrace? stackTrace])
      : super(message, stackTrace);

  @override
  String toString() => 'UnauthorizedException: $message';
}
