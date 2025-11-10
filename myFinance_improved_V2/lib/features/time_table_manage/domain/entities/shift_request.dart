import 'package:freezed_annotation/freezed_annotation.dart';

import 'employee_info.dart';

part 'shift_request.freezed.dart';
part 'shift_request.g.dart';

/// Shift Request Entity
///
/// Represents an employee's request to work a specific shift.
@freezed
class ShiftRequest with _$ShiftRequest {
  const ShiftRequest._();

  const factory ShiftRequest({
    @JsonKey(name: 'shift_request_id')
    required String shiftRequestId,
    @JsonKey(name: 'shift_id')
    required String shiftId,
    required EmployeeInfo employee,
    @JsonKey(name: 'is_approved')
    required bool isApproved,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
    @JsonKey(name: 'approved_at')
    DateTime? approvedAt,
  }) = _ShiftRequest;

  /// Create from JSON
  factory ShiftRequest.fromJson(Map<String, dynamic> json) =>
      _$ShiftRequestFromJson(json);

  /// Check if request is pending approval
  bool get isPending => !isApproved;

  /// Get request status text
  String get statusText => isApproved ? 'Approved' : 'Pending';
}
