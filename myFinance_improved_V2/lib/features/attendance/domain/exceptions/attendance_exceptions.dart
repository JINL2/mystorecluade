/// Base exception for attendance feature
abstract class AttendanceException implements Exception {
  final String message;
  final String? details;

  const AttendanceException(this.message, [this.details]);

  @override
  String toString() => details != null ? '$message: $details' : message;
}

/// Location permission denied exception
class LocationPermissionDeniedException extends AttendanceException {
  const LocationPermissionDeniedException([String? details])
      : super('Location permission denied', details);
}

/// Location services disabled exception
class LocationServicesDisabledException extends AttendanceException {
  const LocationServicesDisabledException([String? details])
      : super('Location services are disabled', details);
}

/// Invalid QR code exception
class InvalidQRCodeException extends AttendanceException {
  const InvalidQRCodeException([String? details])
      : super('Invalid QR code format', details);
}

/// Invalid store ID exception
class InvalidStoreIdException extends AttendanceException {
  const InvalidStoreIdException([String? details])
      : super('Invalid store ID', details);
}

/// Shift request not found exception
class ShiftRequestNotFoundException extends AttendanceException {
  const ShiftRequestNotFoundException([String? details])
      : super('Shift request not found', details);
}

/// Already checked in exception
class AlreadyCheckedInException extends AttendanceException {
  const AlreadyCheckedInException([String? details])
      : super('Already checked in for this shift', details);
}

/// Already checked out exception
class AlreadyCheckedOutException extends AttendanceException {
  const AlreadyCheckedOutException([String? details])
      : super('Already checked out for this shift', details);
}

/// Network exception
class AttendanceNetworkException extends AttendanceException {
  const AttendanceNetworkException([String? details])
      : super('Network error occurred', details);
}

/// Server exception
class AttendanceServerException extends AttendanceException {
  const AttendanceServerException([String? details])
      : super('Server error occurred', details);
}
