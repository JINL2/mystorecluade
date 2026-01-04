import '../../../domain/entities/shift_audit_log.dart';
import 'shift_audit_log_dto.dart';

/// Extension to map ShiftAuditLogDto → Domain Entity
///
/// Separates DTO (data layer) from Entity (domain layer)
extension ShiftAuditLogDtoMapper on ShiftAuditLogDto {
  /// Convert DTO to Domain Entity
  ShiftAuditLog toEntity() {
    return ShiftAuditLog(
      auditId: auditId,
      shiftRequestId: shiftRequestId,
      operation: operation,
      actionType: actionType,
      eventType: eventType ?? 'unknown',
      changedColumns: changedColumns,
      changeDetails: changeDetails,
      changedBy: changedBy,
      changedByName: changedByName ?? _extractDisplayName(),
      changedByProfileImage: changedByProfileImage,
      changedAt: _parseDateTime(changedAt) ?? DateTime.now(),
      reason: reason,
      newData: newData,
      oldData: oldData,
    );
  }

  /// Extract display name from:
  /// 1. event_data.employee_name (most reliable - set by triggers)
  /// 2. Joined profiles table: {"display_name": "John Doe"}
  /// 3. new_data.employee_name for employee actions
  String? _extractDisplayName() {
    // Try event_data first (most reliable source)
    if (eventData != null) {
      final employeeName = eventData!['employee_name'] as String?;
      if (employeeName != null && employeeName.isNotEmpty) {
        return employeeName;
      }
    }

    // Try profiles (if FK join worked)
    if (profiles != null && profiles!['display_name'] != null) {
      return profiles!['display_name'] as String?;
    }

    // Try new_data as fallback
    if (newData != null) {
      final employeeName = newData!['employee_name'] as String?;
      if (employeeName != null && employeeName.isNotEmpty) {
        return employeeName;
      }
    }

    return null;
  }

  /// Parse timestamp string to DateTime
  /// Handles both ISO8601 and Postgres timestamp formats
  DateTime? _parseDateTime(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return null;

    try {
      // Handle ISO8601 format with timezone
      return DateTime.parse(timestamp).toLocal();
    } catch (e) {
      return null;
    }
  }
}
