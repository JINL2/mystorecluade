import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_mapping_models.freezed.dart';
part 'account_mapping_models.g.dart';

/// Account Mapping Model for internal company transaction mirroring
/// When Company A sends money as "Notes Receivable", Company B receives as "Notes Payable"
@freezed
class AccountMapping with _$AccountMapping {
  const AccountMapping._();

  const factory AccountMapping({
    @JsonKey(name: 'mapping_id') required String mappingId,
    @JsonKey(name: 'my_company_id') required String myCompanyId,
    @JsonKey(name: 'my_account_id') required String myAccountId,
    @JsonKey(name: 'counterparty_id') required String counterpartyId,
    @JsonKey(name: 'linked_company_id') required String linkedCompanyId,
    @JsonKey(name: 'linked_account_id') required String linkedAccountId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    
    // Additional fields for display purposes (joined data)
    @JsonKey(name: 'my_company_name', includeIfNull: false) String? myCompanyName,
    @JsonKey(name: 'my_account_name', includeIfNull: false) String? myAccountName,
    @JsonKey(name: 'counterparty_name', includeIfNull: false) String? counterpartyName,
    @JsonKey(name: 'linked_company_name', includeIfNull: false) String? linkedCompanyName,
    @JsonKey(name: 'linked_account_name', includeIfNull: false) String? linkedAccountName,
  }) = _AccountMapping;

  factory AccountMapping.fromJson(Map<String, dynamic> json) =>
      _$AccountMappingFromJson(json);
      
  /// User-friendly description of the mapping
  String get mappingDescription {
    final myAccount = myAccountName ?? 'Unknown Account';
    final linkedAccount = linkedAccountName ?? 'Unknown Account';
    final counterparty = counterpartyName ?? 'Unknown Company';
    
    return 'When I record "$myAccount", $counterparty records "$linkedAccount"';
  }
}

/// Form data for creating/editing account mappings
@freezed
class AccountMappingFormData with _$AccountMappingFormData {
  const factory AccountMappingFormData({
    String? mappingId,
    required String myCompanyId,
    String? myAccountId,
    String? counterpartyId,
    String? linkedCompanyId,
    String? linkedAccountId,
    @Default(true) bool isActive,
  }) = _AccountMappingFormData;

  factory AccountMappingFormData.fromJson(Map<String, dynamic> json) =>
      _$AccountMappingFormDataFromJson(json);

  factory AccountMappingFormData.fromAccountMapping(AccountMapping mapping) {
    return AccountMappingFormData(
      mappingId: mapping.mappingId,
      myCompanyId: mapping.myCompanyId,
      myAccountId: mapping.myAccountId,
      counterpartyId: mapping.counterpartyId,
      linkedCompanyId: mapping.linkedCompanyId,
      linkedAccountId: mapping.linkedAccountId,
      isActive: mapping.isActive,
    );
  }
}

/// Account information for dropdowns
@freezed
class AccountInfo with _$AccountInfo {
  const factory AccountInfo({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'account_name') required String accountName,
    @JsonKey(name: 'account_type') String? accountType,
    @JsonKey(name: 'expense_nature') String? expenseNature,
    @JsonKey(name: 'category_tag') String? categoryTag,
    @JsonKey(name: 'description', includeIfNull: false) String? description,
  }) = _AccountInfo;

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);
}

/// Company information for dropdowns
@freezed
class CompanyInfo with _$CompanyInfo {
  const factory CompanyInfo({
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'company_code') String? companyCode,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _CompanyInfo;

  factory CompanyInfo.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoFromJson(json);
}

/// Response wrapper for API operations
@freezed
class AccountMappingResponse with _$AccountMappingResponse {
  const factory AccountMappingResponse.success({
    required AccountMapping data,
    String? message,
  }) = AccountMappingResponseSuccess;

  const factory AccountMappingResponse.error({
    required String message,
    String? code,
  }) = AccountMappingResponseError;

  factory AccountMappingResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountMappingResponseFromJson(json);
}

/// Validation result for form validation
@freezed
class MappingValidationResult with _$MappingValidationResult {
  const factory MappingValidationResult({
    required bool isValid,
    Map<String, String>? errors,
  }) = _MappingValidationResult;

  factory MappingValidationResult.valid() => const MappingValidationResult(
    isValid: true,
    errors: null,
  );

  factory MappingValidationResult.invalid(Map<String, String> errors) => 
    MappingValidationResult(
      isValid: false,
      errors: errors,
    );
}