import 'employee_info.dart';

/// Shift Request Entity
///
/// Represents an employee's request to work a specific shift.
class ShiftRequest {
  final String shiftRequestId;
  final String shiftId;
  final EmployeeInfo employee;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime? approvedAt;

  const ShiftRequest({
    required this.shiftRequestId,
    required this.shiftId,
    required this.employee,
    required this.isApproved,
    required this.createdAt,
    this.approvedAt,
  });

  /// Check if request is pending approval
  bool get isPending => !isApproved;

  /// Get request status text
  String get statusText => isApproved ? 'Approved' : 'Pending';

  /// Copy with method for immutability
  ShiftRequest copyWith({
    String? shiftRequestId,
    String? shiftId,
    EmployeeInfo? employee,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? approvedAt,
  }) {
    return ShiftRequest(
      shiftRequestId: shiftRequestId ?? this.shiftRequestId,
      shiftId: shiftId ?? this.shiftId,
      employee: employee ?? this.employee,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }

  @override
  String toString() => 'ShiftRequest(id: $shiftRequestId, employee: ${employee.userName}, approved: $isApproved)';
}
