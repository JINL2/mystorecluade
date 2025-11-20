import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/shift_approval_result.dart';
import 'shift_approval_result_dto.dart';
import 'shift_request_dto_mapper.dart';

/// Extension to map ShiftApprovalResultDto → Domain Entity
extension ShiftApprovalResultDtoMapper on ShiftApprovalResultDto {
  ShiftApprovalResult toEntity() {
    return ShiftApprovalResult(
      shiftRequestId: shiftRequestId,
      isApproved: isApproved,
      approvedAt: DateTimeUtils.toLocal(approvedAt),
      approvedBy: approvedBy,
      updatedRequest: updatedRequest.toEntity(),
      message: message,
    );
  }
}
