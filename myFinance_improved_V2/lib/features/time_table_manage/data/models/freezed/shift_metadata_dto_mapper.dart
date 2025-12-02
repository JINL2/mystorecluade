import '../../../domain/entities/shift_metadata.dart';
import '../../../domain/entities/shift_metadata_item.dart';
import 'shift_metadata_dto.dart';

/// Shift Metadata DTO Mapper
///
/// Converts between ShiftMetadataDto and domain entities
class ShiftMetadataDtoMapper {
  /// Convert DTO to ShiftMetadataItem entity
  static ShiftMetadataItem toShiftMetadataItem(ShiftMetadataDto dto) {
    return ShiftMetadataItem(
      shiftId: dto.shiftId,
      shiftName: dto.shiftName,
      startTime: dto.startTime,
      endTime: dto.endTime,
      targetCount: dto.numberShift,
      isActive: dto.isActive,
      isCanOvertime: dto.isCanOvertime,
    );
  }

  /// Convert list of DTOs to ShiftMetadata entity
  static ShiftMetadata toEntity(List<ShiftMetadataDto> dtos) {
    final shifts = dtos.map(toShiftMetadataItem).toList();

    return ShiftMetadata(
      shifts: shifts,
      lastUpdated: DateTime.now(),
    );
  }

  /// Convert ShiftMetadataItem back to DTO (if needed)
  static ShiftMetadataDto fromShiftMetadataItem(
    ShiftMetadataItem item, {
    String storeId = '',
  }) {
    return ShiftMetadataDto(
      shiftId: item.shiftId,
      storeId: storeId,
      shiftName: item.shiftName,
      startTime: item.startTime,
      endTime: item.endTime,
      numberShift: item.targetCount,
      isActive: item.isActive,
      isCanOvertime: item.isCanOvertime,
    );
  }
}
