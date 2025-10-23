import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_dto.freezed.dart';
part 'template_dto.g.dart';

/// Template DTO - Database-to-Domain mapping for transaction templates
/// 
/// Maps between snake_case database columns and camelCase domain fields
/// Provides type-safe conversion with proper null handling
@freezed
class TemplateDto with _$TemplateDto {
  const factory TemplateDto({
    /// Unique template identifier (DB: template_id)
    @JsonKey(name: 'template_id') required String templateId,
    
    /// Template display name (DB: name)
    required String name,
    
    /// Optional description (DB: template_description)  
    @JsonKey(name: 'template_description') String? templateDescription,
    
    /// 🚨 CRITICAL: JSONB transaction data array (DB: data)
    /// Each line: {account_id, debit, credit, description, cash?, debt?, fix_asset?}
    @Default([]) List<Map<String, dynamic>> data,
    
    /// Template categorization tags (DB: tags)
    @Default({}) Map<String, dynamic> tags,
    
    /// Template visibility level (DB: visibility_level)
    @JsonKey(name: 'visibility_level') required String visibilityLevel,
    
    /// Template permission level (DB: permission)
    required String permission,
    
    /// Company identifier (DB: company_id)
    @JsonKey(name: 'company_id') required String companyId,
    
    /// Store identifier - can be null in DB (DB: store_id)
    @JsonKey(name: 'store_id') String? storeId,
    
    /// Single counterparty ID for template (DB: counterparty_id)
    @JsonKey(name: 'counterparty_id') String? counterpartyId,
    
    /// Counterparty cash location for internal transactions (DB: counterparty_cash_location_id)
    @JsonKey(name: 'counterparty_cash_location_id') String? counterpartyCashLocationId,
    
    /// Template creator (DB: created_by) - nullable because DB may not have this field
    @JsonKey(name: 'created_by') String? createdBy,
    
    /// Creation timestamp as ISO string (DB: created_at)
    @JsonKey(name: 'created_at') required String createdAt,
    
    /// Last update timestamp as ISO string (DB: updated_at)
    @JsonKey(name: 'updated_at') required String updatedAt,
    
    /// Last updater (DB: updated_by)
    @JsonKey(name: 'updated_by') String? updatedBy,
    
    /// Active status flag (DB: is_active)
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _TemplateDto;

  factory TemplateDto.fromJson(Map<String, dynamic> json) => _$TemplateDtoFromJson(json);
}