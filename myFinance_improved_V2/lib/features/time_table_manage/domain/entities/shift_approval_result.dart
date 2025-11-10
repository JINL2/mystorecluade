import 'package:freezed_annotation/freezed_annotation.dart';

import 'shift_request.dart';

part 'shift_approval_result.freezed.dart';
part 'shift_approval_result.g.dart';

/// Shift Approval Result Entity
///
/// Represents the result of toggling a shift request approval status.
/// Contains information about the approval action and the updated request.
@freezed
class ShiftApprovalResult with _$ShiftApprovalResult {
  const ShiftApprovalResult._();

  const factory ShiftApprovalResult({
    /// The shift request ID that was processed
    @JsonKey(name: 'shift_request_id')
    required String shiftRequestId,

    /// New approval status (true = approved, false = not approved/pending)
    @JsonKey(name: 'is_approved')
    required bool isApproved,

    /// When the approval status was changed
    @JsonKey(name: 'approved_at')
    required DateTime approvedAt,

    /// User ID who performed the approval action
    @JsonKey(name: 'approved_by')
    String? approvedBy,

    /// The updated shift request entity after approval
    @JsonKey(name: 'updated_request')
    required ShiftRequest updatedRequest,

    /// Optional message about the approval result
    String? message,
  }) = _ShiftApprovalResult;

  /// Create from JSON
  factory ShiftApprovalResult.fromJson(Map<String, dynamic> json) =>
      _$ShiftApprovalResultFromJson(json);

  /// Check if this was an approval action (vs. un-approval)
  bool get wasApproved => isApproved;

  /// Check if this was a rejection/un-approval action
  bool get wasRejected => !isApproved;
}
