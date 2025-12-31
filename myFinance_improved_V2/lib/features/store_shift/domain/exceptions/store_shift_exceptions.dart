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
  const ShiftNotFoundException([super.message = 'Shift not found', super.stackTrace]);

  @override
  String toString() => 'ShiftNotFoundException: $message';
}

/// Exception thrown when store data is not found
class StoreNotFoundException extends StoreShiftException {
  const StoreNotFoundException([super.message = 'Store not found', super.stackTrace]);

  @override
  String toString() => 'StoreNotFoundException: $message';
}

/// Exception thrown when shift creation fails
class ShiftCreationException extends StoreShiftException {
  const ShiftCreationException([super.message = 'Failed to create shift', super.stackTrace]);

  @override
  String toString() => 'ShiftCreationException: $message';
}

/// Exception thrown when shift update fails
class ShiftUpdateException extends StoreShiftException {
  const ShiftUpdateException([super.message = 'Failed to update shift', super.stackTrace]);

  @override
  String toString() => 'ShiftUpdateException: $message';
}

/// Exception thrown when shift deletion fails
class ShiftDeletionException extends StoreShiftException {
  const ShiftDeletionException([super.message = 'Failed to delete shift', super.stackTrace]);

  @override
  String toString() => 'ShiftDeletionException: $message';
}

/// Exception thrown when store location update fails
class StoreLocationUpdateException extends StoreShiftException {
  const StoreLocationUpdateException([super.message = 'Failed to update store location', super.stackTrace]);

  @override
  String toString() => 'StoreLocationUpdateException: $message';
}
