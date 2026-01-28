/// Delete Template Response DTO - RPC Response for template deletion
///
/// Maps the response from transaction_template_delete_template RPC
///
/// Clean Architecture: DATA LAYER - DTO
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_template_response_dto.freezed.dart';
part 'delete_template_response_dto.g.dart';

@freezed
class DeleteTemplateResponseDto with _$DeleteTemplateResponseDto {
  const factory DeleteTemplateResponseDto({
    required bool success,
    String? error,
    String? message,
    DeleteTemplateDataDto? data,
  }) = _DeleteTemplateResponseDto;

  factory DeleteTemplateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteTemplateResponseDtoFromJson(json);
}

@freezed
class DeleteTemplateDataDto with _$DeleteTemplateDataDto {
  const factory DeleteTemplateDataDto({
    @JsonKey(name: 'template_id') required String templateId,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  }) = _DeleteTemplateDataDto;

  factory DeleteTemplateDataDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteTemplateDataDtoFromJson(json);
}
