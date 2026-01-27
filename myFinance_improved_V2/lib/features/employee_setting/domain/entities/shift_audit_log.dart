/// Domain Entity: Shift Audit Log
///
/// Pure business object representing a shift request audit log entry.
/// Used to track employee check-in/check-out and other shift-related activities.
class ShiftAuditLog {
  final String auditId;
  final String shiftRequestId;
  final String userId;
  final String? storeId;
  final String? storeName;
  final DateTime? requestDate;
  final String operation;
  final String actionType;
  final List<String>? changedColumns;
  final String? changedBy;
  final String? changedByName;
  final DateTime changedAt;
  final String? reason;

  const ShiftAuditLog({
    required this.auditId,
    required this.shiftRequestId,
    required this.userId,
    this.storeId,
    this.storeName,
    this.requestDate,
    required this.operation,
    required this.actionType,
    this.changedColumns,
    this.changedBy,
    this.changedByName,
    required this.changedAt,
    this.reason,
  });

  /// Get human-readable action type text
  String get actionTypeText {
    switch (actionType.toUpperCase()) {
      case 'CHECKIN':
        return 'Check In';
      case 'CHECKOUT':
        return 'Check Out';
      case 'MANAGER_EDIT':
        return 'Manager Edit';
      case 'REPORT_SOLVED':
        return 'Report Solved';
      case 'REQUEST':
        return 'Shift Request';
      default:
        return actionType;
    }
  }

  /// Get icon name based on action type
  String get actionIconName {
    switch (actionType.toUpperCase()) {
      case 'CHECKIN':
        return 'login';
      case 'CHECKOUT':
        return 'logout';
      case 'MANAGER_EDIT':
        return 'edit';
      case 'REPORT_SOLVED':
        return 'check_circle';
      case 'REQUEST':
        return 'schedule';
      default:
        return 'history';
    }
  }

  /// Check if this is a check-in action
  bool get isCheckIn => actionType.toUpperCase() == 'CHECKIN';

  /// Check if this is a check-out action
  bool get isCheckOut => actionType.toUpperCase() == 'CHECKOUT';

  /// Check if this is a manager edit
  bool get isManagerEdit => actionType.toUpperCase() == 'MANAGER_EDIT';

  /// Get relative time text (e.g., "2 hours ago")
  String get relativeTimeText {
    final now = DateTime.now();
    final difference = now.difference(changedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '${weeks}w ago';
    } else {
      final months = difference.inDays ~/ 30;
      return '${months}mo ago';
    }
  }
}

/// Result wrapper for shift audit logs with pagination
class ShiftAuditLogsResult {
  final List<ShiftAuditLog> logs;
  final ShiftAuditLogsPagination pagination;

  const ShiftAuditLogsResult({
    required this.logs,
    required this.pagination,
  });

  /// Create empty result
  factory ShiftAuditLogsResult.empty() {
    return const ShiftAuditLogsResult(
      logs: [],
      pagination: ShiftAuditLogsPagination(
        totalCount: 0,
        limit: 20,
        offset: 0,
        hasMore: false,
      ),
    );
  }
}

/// Pagination info for shift audit logs
class ShiftAuditLogsPagination {
  final int totalCount;
  final int limit;
  final int offset;
  final bool hasMore;

  const ShiftAuditLogsPagination({
    required this.totalCount,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });
}
