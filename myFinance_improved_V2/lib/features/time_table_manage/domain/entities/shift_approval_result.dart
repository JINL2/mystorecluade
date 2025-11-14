import 'shift_request.dart';

/// Shift Approval Result Entity
///
/// Represents the result of toggling a shift request approval status.
/// Contains information about the approval action and the updated request.
class ShiftApprovalResult {
  /// The shift request ID that was processed
  final String shiftRequestId;

  /// New approval status (true = approved, false = not approved/pending)
  final bool isApproved;

  /// When the approval status was changed
  final DateTime approvedAt;

  /// User ID who performed the approval action
  final String? approvedBy;

  /// The updated shift request entity after approval
  final ShiftRequest updatedRequest;

  /// Optional message about the approval result
  final String? message;

  const ShiftApprovalResult({
    required this.shiftRequestId,
    required this.isApproved,
    required this.approvedAt,
    this.approvedBy,
    required this.updatedRequest,
    this.message,
  });

  /// Check if this was an approval action (vs. un-approval)
  bool get wasApproved => isApproved;

  /// Check if this was a rejection/un-approval action
  bool get wasRejected => !isApproved;

  /// Copy with method for immutability
  ShiftApprovalResult copyWith({
    String? shiftRequestId,
    bool? isApproved,
    DateTime? approvedAt,
    String? approvedBy,
    ShiftRequest? updatedRequest,
    String? message,
  }) {
    return ShiftApprovalResult(
      shiftRequestId: shiftRequestId ?? this.shiftRequestId,
      isApproved: isApproved ?? this.isApproved,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      updatedRequest: updatedRequest ?? this.updatedRequest,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShiftApprovalResult &&
        other.shiftRequestId == shiftRequestId &&
        other.isApproved == isApproved &&
        other.approvedAt == approvedAt &&
        other.approvedBy == approvedBy &&
        other.message == message;
  }

  @override
  int get hashCode {
    return shiftRequestId.hashCode ^
        isApproved.hashCode ^
        approvedAt.hashCode ^
        approvedBy.hashCode ^
        message.hashCode;
  }

  @override
  String toString() {
    return 'ShiftApprovalResult(id: $shiftRequestId, approved: $isApproved, at: $approvedAt)';
  }
}
