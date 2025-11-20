import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/shift.dart';
import 'shift_dto.dart';

/// Extension to map ShiftDto → Domain Entity
extension ShiftDtoMapper on ShiftDto {
  Shift toEntity() {
    return Shift(
      shiftId: shiftId,
      storeId: storeId,
      shiftDate: shiftDate,
      planStartTime: planStartTime.isNotEmpty
          ? DateTimeUtils.toLocal(planStartTime)
          : DateTime.now(),
      planEndTime: planEndTime.isNotEmpty
          ? DateTimeUtils.toLocal(planEndTime)
          : DateTime.now(),
      targetCount: targetCount,
      currentCount: currentCount,
      shiftName: shiftName,
    );
  }
}
