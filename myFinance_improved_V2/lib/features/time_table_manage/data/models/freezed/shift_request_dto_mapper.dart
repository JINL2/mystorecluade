import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/shift_request.dart';
import 'employee_info_dto_mapper.dart';
import 'shift_request_dto.dart';

/// Extension to map ShiftRequestDto → Domain Entity
extension ShiftRequestDtoMapper on ShiftRequestDto {
  ShiftRequest toEntity() {
    return ShiftRequest(
      shiftRequestId: shiftRequestId,
      shiftId: shiftId,
      employee: employee.toEntity(),
      isApproved: isApproved,
      createdAt: createdAt.isNotEmpty
          ? DateTimeUtils.toLocal(createdAt)
          : DateTime.now(),
      approvedAt: DateTimeUtils.toLocalSafe(approvedAt),
    );
  }
}
