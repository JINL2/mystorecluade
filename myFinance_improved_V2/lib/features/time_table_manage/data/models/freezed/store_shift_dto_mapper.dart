import '../../../domain/entities/shift.dart';
import 'store_shift_dto.dart';

/// Extension to map StoreShiftDto → Domain Entity
extension StoreShiftDtoMapper on StoreShiftDto {
  Shift toEntity({required String storeId, required String shiftDate}) {
    // Convert "HH:MM" string to DateTime
    // Use a dummy date (today) since RPC only provides time
    final now = DateTime.now();
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');

    final planStart = DateTime(
      now.year,
      now.month,
      now.day,
      int.tryParse(startParts.isNotEmpty ? startParts[0] : '0') ?? 0,
      int.tryParse(startParts.length > 1 ? startParts[1] : '0') ?? 0,
    );

    final planEnd = DateTime(
      now.year,
      now.month,
      now.day,
      int.tryParse(endParts.isNotEmpty ? endParts[0] : '0') ?? 0,
      int.tryParse(endParts.length > 1 ? endParts[1] : '0') ?? 0,
    );

    return Shift(
      shiftId: shiftId,
      storeId: storeId,
      shiftDate: shiftDate,
      planStartTime: planStart,
      planEndTime: planEnd,
      targetCount: 0, // Not provided in RPC response
      currentCount: 0, // Not provided in RPC response
      tags: [], // Not provided in RPC response
      shiftName: shiftName,
    );
  }
}
