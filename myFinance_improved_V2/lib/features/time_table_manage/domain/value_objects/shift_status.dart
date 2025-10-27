/// Shift Status Enum
///
/// Represents the various states a shift can be in.
enum ShiftStatus {
  /// Shift is scheduled but not yet started
  scheduled,

  /// Shift is currently in progress
  inProgress,

  /// Shift has been completed
  completed,

  /// Shift has been cancelled
  cancelled;

  /// Get display name in Korean
  String get displayName {
    switch (this) {
      case ShiftStatus.scheduled:
        return '예정됨';
      case ShiftStatus.inProgress:
        return '진행중';
      case ShiftStatus.completed:
        return '완료됨';
      case ShiftStatus.cancelled:
        return '취소됨';
    }
  }

  /// Get color for status display
  String get colorHex {
    switch (this) {
      case ShiftStatus.scheduled:
        return '#3182F6'; // Blue
      case ShiftStatus.inProgress:
        return '#00C73C'; // Green
      case ShiftStatus.completed:
        return '#6B7684'; // Gray
      case ShiftStatus.cancelled:
        return '#F04452'; // Red
    }
  }
}

/// Shift Request Status Enum
///
/// Represents the approval status of a shift request.
enum ShiftRequestStatus {
  /// Request is waiting for approval
  pending,

  /// Request has been approved
  approved,

  /// Request has been rejected
  rejected;

  /// Get display name in Korean
  String get displayName {
    switch (this) {
      case ShiftRequestStatus.pending:
        return '대기중';
      case ShiftRequestStatus.approved:
        return '승인됨';
      case ShiftRequestStatus.rejected:
        return '거부됨';
    }
  }

  /// Get color for status display
  String get colorHex {
    switch (this) {
      case ShiftRequestStatus.pending:
        return '#FF9500'; // Orange
      case ShiftRequestStatus.approved:
        return '#00C73C'; // Green
      case ShiftRequestStatus.rejected:
        return '#F04452'; // Red
    }
  }
}
