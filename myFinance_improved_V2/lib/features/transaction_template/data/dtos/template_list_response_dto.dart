import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_list_response_dto.freezed.dart';
part 'template_list_response_dto.g.dart';

/// Response DTO for transaction_template_get_list RPC
///
/// Maps the RPC response structure to Dart objects.
/// Replaces direct table queries: findByCompanyAndStore, searchTemplates
@freezed
class TemplateListResponseDto with _$TemplateListResponseDto {
  const factory TemplateListResponseDto({
    /// Whether the RPC call was successful
    required bool success,

    /// Response data containing templates and pagination
    TemplateListDataDto? data,

    /// Error message if failed
    String? error,
  }) = _TemplateListResponseDto;

  factory TemplateListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateListResponseDtoFromJson(json);
}

/// Template list data from RPC response
@freezed
class TemplateListDataDto with _$TemplateListDataDto {
  const factory TemplateListDataDto({
    /// List of templates
    @Default([]) List<TemplateListItemDto> templates,

    /// Total count of matching templates (for pagination)
    @JsonKey(name: 'total_count') @Default(0) int totalCount,

    /// Whether there are more templates to load
    @JsonKey(name: 'has_more') @Default(false) bool hasMore,
  }) = _TemplateListDataDto;

  factory TemplateListDataDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateListDataDtoFromJson(json);
}

/// Individual template item in list response
@freezed
class TemplateListItemDto with _$TemplateListItemDto {
  const factory TemplateListItemDto({
    /// Unique template identifier
    @JsonKey(name: 'template_id') required String templateId,

    /// Template display name
    required String name,

    /// Optional description
    @JsonKey(name: 'template_description') String? templateDescription,

    /// JSONB transaction data array
    @Default([]) List<Map<String, dynamic>> data,

    /// Template categorization tags
    @Default({}) Map<String, dynamic> tags,

    /// Template visibility level
    @JsonKey(name: 'visibility_level') required String visibilityLevel,

    /// Template permission level
    required String permission,

    /// Company identifier
    @JsonKey(name: 'company_id') required String companyId,

    /// Store identifier (nullable)
    @JsonKey(name: 'store_id') String? storeId,

    /// Counterparty ID
    @JsonKey(name: 'counterparty_id') String? counterpartyId,

    /// Counterparty cash location ID
    @JsonKey(name: 'counterparty_cash_location_id') String? counterpartyCashLocationId,

    /// Template creator
    @JsonKey(name: 'created_by') String? createdBy,

    /// Creation timestamp (local time converted from UTC)
    @JsonKey(name: 'created_at') required String createdAt,

    /// Last update timestamp (local time converted from UTC)
    @JsonKey(name: 'updated_at') required String updatedAt,

    /// Last updater
    @JsonKey(name: 'updated_by') String? updatedBy,

    /// Active status flag
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// Whether attachment is required
    @JsonKey(name: 'required_attachment') @Default(false) bool requiredAttachment,
  }) = _TemplateListItemDto;

  factory TemplateListItemDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateListItemDtoFromJson(json);
}
