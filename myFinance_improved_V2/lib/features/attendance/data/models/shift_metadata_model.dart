import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/shift_metadata.dart';

part 'shift_metadata_model.freezed.dart';
part 'shift_metadata_model.g.dart';

/// Shift Metadata Model (DTO)
///
/// Data Transfer Object for ShiftMetadata entity.
@freezed
class ShiftMetadataModel with _$ShiftMetadataModel {
  const ShiftMetadataModel._();

  const factory ShiftMetadataModel({
    @JsonKey(name: 'shift_id') required String shiftId,
    @JsonKey(name: 'shift_name') required String shiftName,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ShiftMetadataModel;

  factory ShiftMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftMetadataModelFromJson(json);

  /// Convert Model to Entity
  ShiftMetadata toEntity() {
    return ShiftMetadata(
      shiftId: shiftId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      description: description,
      isActive: isActive,
    );
  }
}
