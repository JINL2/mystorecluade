import 'package:freezed_annotation/freezed_annotation.dart';
import 'shift_request_dto.dart';

part 'shift_approval_result_dto.freezed.dart';
part 'shift_approval_result_dto.g.dart';

/// Shift Approval Result DTO
///
/// Maps to RPC: toggle_shift_approval
@freezed
class ShiftApprovalResultDto with _$ShiftApprovalResultDto {
  const factory ShiftApprovalResultDto({
    @JsonKey(name: 'shift_request_id') @Default('') String shiftRequestId,
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    @JsonKey(name: 'approved_at') @Default('') String approvedAt,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'updated_request') required ShiftRequestDto updatedRequest,
    @JsonKey(name: 'message') String? message,
  }) = _ShiftApprovalResultDto;

  factory ShiftApprovalResultDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftApprovalResultDtoFromJson(json);
}
