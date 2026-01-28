import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_template_response_dto.freezed.dart';
part 'upsert_template_response_dto.g.dart';

/// Response DTO for transaction_template_upsert_template RPC
///
/// Maps the RPC response structure to Dart objects.
/// Replaces direct table queries: save(), update()
@freezed
class UpsertTemplateResponseDto with _$UpsertTemplateResponseDto {
  const factory UpsertTemplateResponseDto({
    /// Whether the RPC call was successful
    required bool success,

    /// Response data containing created/updated template
    UpsertTemplateDataDto? data,

    /// Error code if failed
    String? error,

    /// Human-readable message
    String? message,
  }) = _UpsertTemplateResponseDto;

  factory UpsertTemplateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UpsertTemplateResponseDtoFromJson(json);
}

/// Template data from upsert RPC response
@freezed
class UpsertTemplateDataDto with _$UpsertTemplateDataDto {
  const factory UpsertTemplateDataDto({
    /// Unique template identifier
    @JsonKey(name: 'template_id') required String templateId,

    /// Template display name
    required String name,

    /// Optional description
    @JsonKey(name: 'template_description') String? templateDescription,

    /// Template visibility level
    @JsonKey(name: 'visibility_level') required String visibilityLevel,

    /// Template permission level
    required String permission,

    /// Company identifier
    @JsonKey(name: 'company_id') required String companyId,

    /// Store identifier (nullable)
    @JsonKey(name: 'store_id') String? storeId,

    /// Active status flag
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// Whether attachment is required
    @JsonKey(name: 'required_attachment') @Default(false) bool requiredAttachment,

    /// Creation timestamp (local time)
    @JsonKey(name: 'created_at') required String createdAt,

    /// Last update timestamp (local time)
    @JsonKey(name: 'updated_at') required String updatedAt,

    /// Template creator
    @JsonKey(name: 'created_by') String? createdBy,

    /// Last updater
    @JsonKey(name: 'updated_by') String? updatedBy,
  }) = _UpsertTemplateDataDto;

  factory UpsertTemplateDataDto.fromJson(Map<String, dynamic> json) =>
      _$UpsertTemplateDataDtoFromJson(json);
}
