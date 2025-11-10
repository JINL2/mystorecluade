/// Monthly Shift Status Entity
///
/// Represents the monthly shift status for a user view.
/// Matches get_monthly_shift_status RPC response structure.
///
/// Each instance represents one shift on one date for the current user.
class MonthlyShiftStatus {
  final String storeId;
  final String shiftId;
  final String requestDate;
  final int totalRegistered;
  final bool isRegisteredByMe;
  final String? shiftRequestId;
  final bool isApproved;
  final int totalOtherStaffs;
  final List<Map<String, dynamic>> otherStaffs;

  const MonthlyShiftStatus({
    required this.storeId,
    required this.shiftId,
    required this.requestDate,
    required this.totalRegistered,
    required this.isRegisteredByMe,
    this.shiftRequestId,
    required this.isApproved,
    required this.totalOtherStaffs,
    required this.otherStaffs,
  });

  /// Check if user is registered for this shift
  bool get isRegistered => isRegisteredByMe;

  /// Get approval status text
  String get approvalStatus {
    if (!isRegisteredByMe) return 'not_registered';
    if (isApproved) return 'approved';
    return 'pending';
  }

  @override
  String toString() =>
      'MonthlyShiftStatus($requestDate, shift: $shiftId, registered: $isRegisteredByMe, approved: $isApproved)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyShiftStatus &&
          runtimeType == other.runtimeType &&
          requestDate == other.requestDate &&
          shiftId == other.shiftId &&
          storeId == other.storeId;

  @override
  int get hashCode => requestDate.hashCode ^ shiftId.hashCode ^ storeId.hashCode;
}
