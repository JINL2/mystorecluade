/// Enum representing the current shift status of a user
enum ShiftStatus {
  /// No shift scheduled for today
  offDuty,

  /// Shift scheduled but not started yet
  scheduled,

  /// Currently working on a shift
  working,

  /// All shifts for today are completed
  finished;

  /// Get display string for the status
  String get displayName {
    switch (this) {
      case ShiftStatus.offDuty:
        return 'Off Duty';
      case ShiftStatus.scheduled:
        return 'Scheduled';
      case ShiftStatus.working:
        return 'Working';
      case ShiftStatus.finished:
        return 'Finished';
    }
  }

  /// Get status value for storage/comparison
  String get value {
    switch (this) {
      case ShiftStatus.offDuty:
        return 'off_duty';
      case ShiftStatus.scheduled:
        return 'scheduled';
      case ShiftStatus.working:
        return 'working';
      case ShiftStatus.finished:
        return 'finished';
    }
  }

  /// Create ShiftStatus from string value
  static ShiftStatus fromValue(String value) {
    switch (value) {
      case 'off_duty':
        return ShiftStatus.offDuty;
      case 'scheduled':
        return ShiftStatus.scheduled;
      case 'working':
        return ShiftStatus.working;
      case 'finished':
        return ShiftStatus.finished;
      default:
        return ShiftStatus.offDuty;
    }
  }
}
