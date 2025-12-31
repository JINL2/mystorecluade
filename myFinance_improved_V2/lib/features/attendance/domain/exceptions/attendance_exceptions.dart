/// Base exception for attendance feature
abstract class AttendanceException implements Exception {
  final String message;
  final String? details;

  const AttendanceException(this.message, [this.details]);

  @override
  String toString() => details != null ? '$message: $details' : message;
}

/// Server exception
class AttendanceServerException extends AttendanceException {
  const AttendanceServerException([String? details])
      : super('Server error occurred', details);
}
