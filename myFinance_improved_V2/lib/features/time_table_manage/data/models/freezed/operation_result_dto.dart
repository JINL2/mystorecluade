import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation_result_dto.freezed.dart';
part 'operation_result_dto.g.dart';

/// Operation Result DTO
///
/// Generic result object returned by various RPCs:
/// - insert_shift_schedule
/// - manager_shift_delete_tag
/// - manager_shift_insert_schedule
/// - insert_shift_schedule_bulk
/// - manager_shift_add_bonus
/// - delete_shift (via direct table operation)
///
/// Represents success/failure status with optional message and metadata
@freezed
class OperationResultDto with _$OperationResultDto {
  const factory OperationResultDto({
    /// Whether the operation succeeded
    @JsonKey(name: 'success') @Default(false) bool success,

    /// Optional message describing the result
    @JsonKey(name: 'message') String? message,

    /// Optional error code for failures
    @JsonKey(name: 'error_code') String? errorCode,

    /// Additional metadata from the operation
    @JsonKey(name: 'metadata') @Default({}) Map<String, dynamic> metadata,
  }) = _OperationResultDto;

  factory OperationResultDto.fromJson(Map<String, dynamic> json) =>
      _$OperationResultDtoFromJson(json);
}
