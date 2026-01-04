// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_audit_log_dto.freezed.dart';
part 'shift_audit_log_dto.g.dart';

/// Shift Audit Log DTO
///
/// Maps to shift_request_audit_log table
/// Shows who changed what, when, and how for a shift
@freezed
class ShiftAuditLogDto with _$ShiftAuditLogDto {
  const factory ShiftAuditLogDto({
    /// Unique identifier
    @JsonKey(name: 'audit_id') @Default('') String auditId,

    /// The shift request this log belongs to
    @JsonKey(name: 'shift_request_id') @Default('') String shiftRequestId,

    /// Operation type: INSERT, UPDATE, DELETE
    @JsonKey(name: 'operation') @Default('') String operation,

    /// Action type: CHECKIN, CHECKOUT, REPORT, MANAGER_EDIT, etc.
    @JsonKey(name: 'action_type') @Default('') String actionType,

    /// Event type: employee_checked_in, employee_late, shift_reported, etc.
    @JsonKey(name: 'event_type') String? eventType,

    /// Changed column names array
    @JsonKey(name: 'changed_columns') List<String>? changedColumns,

    /// Detailed change information (field -> {from, to})
    @JsonKey(name: 'change_details') Map<String, dynamic>? changeDetails,

    /// User ID who made the change
    @JsonKey(name: 'changed_by') String? changedBy,

    /// Display name of user who made the change (from RPC join)
    @JsonKey(name: 'changed_by_name') String? changedByName,

    /// Profile image URL of user who made the change (from RPC join)
    @JsonKey(name: 'changed_by_profile_image') String? changedByProfileImage,

    /// When the change was made (UTC timestamp string)
    @JsonKey(name: 'changed_at') String? changedAt,

    /// Reason for the change
    @JsonKey(name: 'reason') String? reason,

    /// New data after the change (full snapshot)
    @JsonKey(name: 'new_data') Map<String, dynamic>? newData,

    /// Old data before the change (full snapshot)
    @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,

    /// Profile information (joined from profiles table)
    /// Structure: {"display_name": "John"}
    @JsonKey(name: 'profiles') Map<String, dynamic>? profiles,

    /// Event-specific data (contains employee_name, store_name, etc.)
    /// Structure varies by event type
    @JsonKey(name: 'event_data') Map<String, dynamic>? eventData,
  }) = _ShiftAuditLogDto;

  factory ShiftAuditLogDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftAuditLogDtoFromJson(json);
}
