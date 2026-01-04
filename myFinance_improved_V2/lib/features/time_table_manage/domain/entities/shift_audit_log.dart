/// Shift Audit Log Entity
///
/// Contains audit log information for shift changes.
/// Shows who changed what, when, and how.
class ShiftAuditLog {
  /// Unique identifier for this audit log entry
  final String auditId;

  /// The shift request this log belongs to
  final String shiftRequestId;

  /// Operation type: INSERT, UPDATE, DELETE
  final String operation;

  /// Action type: CHECKIN, CHECKOUT, REPORT, MANAGER_EDIT, etc.
  final String actionType;

  /// Event type: employee_checked_in, employee_late, shift_reported, etc.
  final String eventType;

  /// Changed column names (e.g., ['confirm_start_time_utc', 'bonus_amount_v2'])
  final List<String>? changedColumns;

  /// Detailed change information (field -> {from, to})
  final Map<String, dynamic>? changeDetails;

  /// User ID who made the change
  final String? changedBy;

  /// Display name of user who made the change
  final String? changedByName;

  /// Profile image URL of user who made the change
  final String? changedByProfileImage;

  /// When the change was made
  final DateTime changedAt;

  /// Reason for the change (if provided)
  final String? reason;

  /// New data after the change (full snapshot)
  final Map<String, dynamic>? newData;

  /// Old data before the change (full snapshot)
  final Map<String, dynamic>? oldData;

  const ShiftAuditLog({
    required this.auditId,
    required this.shiftRequestId,
    required this.operation,
    required this.actionType,
    required this.eventType,
    this.changedColumns,
    this.changeDetails,
    this.changedBy,
    this.changedByName,
    this.changedByProfileImage,
    required this.changedAt,
    this.reason,
    this.newData,
    this.oldData,
  });

  /// Get human-readable event description
  String get eventDescription {
    switch (eventType) {
      case 'shift_requested':
        return 'Shift requested';
      case 'shift_approved':
        return 'Shift approved';
      case 'employee_checked_in':
        return 'Employee checked in';
      case 'employee_late':
        return 'Employee checked in late';
      case 'employee_checked_out':
        return 'Employee checked out';
      case 'employee_overtime':
        return 'Overtime recorded';
      case 'employee_early_leave':
        return 'Early leave recorded';
      case 'shift_reported':
        return 'Issue reported';
      case 'shift_report_solved':
        return 'Report resolved';
      case 'shift_manager_edited':
        return 'Manager edited';
      case 'shift_problem_solved':
        return 'Problem resolved';
      case 'shift_updated':
        return 'Shift updated';
      case 'shift_cancelled':
        return 'Shift cancelled';
      case 'shift_deleted':
        return 'Shift deleted';
      default:
        return eventType.replaceAll('_', ' ').capitalize();
    }
  }

  /// Get manager memo from change details if this was a memo update
  String? get managerMemo {
    if (changeDetails == null) return null;

    final memoChange = changeDetails!['manager_memo_v2'];
    if (memoChange == null) return null;

    final toValue = memoChange['to'];
    if (toValue is List && toValue.isNotEmpty) {
      // Get the last memo entry
      final lastMemo = toValue.last;
      if (lastMemo is Map && lastMemo['content'] != null) {
        return lastMemo['content'] as String?;
      }
    }

    return null;
  }

  /// Get report reason from new_data if this is a report event
  String? get reportReason {
    if (eventType != 'shift_reported') return null;
    if (newData == null) return null;

    return newData!['report_reason_v2'] as String?;
  }

  /// Get bonus amount change if any
  BonusChange? get bonusChange {
    if (changeDetails == null) return null;

    final bonusDetail = changeDetails!['bonus_amount_v2'];
    if (bonusDetail == null) return null;

    final from = bonusDetail['from'];
    final to = bonusDetail['to'];

    if (from == null && to == null) return null;

    return BonusChange(
      from: (from is num) ? from.toInt() : 0,
      to: (to is num) ? to.toInt() : 0,
    );
  }

  /// Get confirmed time changes if any
  TimeChange? get confirmStartTimeChange {
    return _getTimeChange('confirm_start_time_utc');
  }

  TimeChange? get confirmEndTimeChange {
    return _getTimeChange('confirm_end_time_utc');
  }

  TimeChange? _getTimeChange(String field) {
    if (changeDetails == null) return null;

    final timeDetail = changeDetails![field];
    if (timeDetail == null) return null;

    final from = timeDetail['from'] as String?;
    final to = timeDetail['to'] as String?;

    if (from == null && to == null) return null;

    return TimeChange(from: from, to: to);
  }

  /// Check if this log has meaningful changes to display
  bool get hasDetailedChanges {
    return managerMemo != null ||
        reportReason != null ||
        bonusChange != null ||
        confirmStartTimeChange != null ||
        confirmEndTimeChange != null;
  }
}

/// Represents a bonus amount change
class BonusChange {
  final int from;
  final int to;

  const BonusChange({required this.from, required this.to});

  int get difference => to - from;
  bool get isIncrease => difference > 0;
  bool get isDecrease => difference < 0;
}

/// Represents a time field change
class TimeChange {
  final String? from;
  final String? to;

  const TimeChange({this.from, this.to});

  bool get hasChange => from != to;
}

/// String extension for capitalize
extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
