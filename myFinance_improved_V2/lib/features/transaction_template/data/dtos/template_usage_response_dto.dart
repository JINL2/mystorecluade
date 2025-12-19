import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_usage_response_dto.freezed.dart';
part 'template_usage_response_dto.g.dart';

/// Response DTO for get_template_for_usage RPC
///
/// Maps the RPC response structure to Dart objects.
/// Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md Section 3.1
@freezed
class TemplateUsageResponseDto with _$TemplateUsageResponseDto {
  const factory TemplateUsageResponseDto({
    /// Whether the RPC call was successful
    required bool success,

    /// Error type if failed (e.g., 'not_found', 'database_error')
    String? error,

    /// Error message if failed
    String? message,

    /// Template data section
    TemplateDataDto? template,

    /// Analysis results section
    TemplateAnalysisDto? analysis,

    /// UI configuration section
    @JsonKey(name: 'ui_config') TemplateUiConfigDto? uiConfig,

    /// Default values section
    TemplateDefaultsDto? defaults,

    /// Display info section
    @JsonKey(name: 'display_info') TemplateDisplayInfoDto? displayInfo,
  }) = _TemplateUsageResponseDto;

  factory TemplateUsageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateUsageResponseDtoFromJson(json);
}

/// Template data from RPC response
@freezed
class TemplateDataDto with _$TemplateDataDto {
  const factory TemplateDataDto({
    @JsonKey(name: 'template_id') required String templateId,
    required String name,
    String? description,
    @JsonKey(name: 'required_attachment') @Default(false) bool requiredAttachment,
    @Default([]) List<Map<String, dynamic>> data,
    @Default({}) Map<String, dynamic> tags,
  }) = _TemplateDataDto;

  factory TemplateDataDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateDataDtoFromJson(json);
}

/// Analysis results from RPC response
@freezed
class TemplateAnalysisDto with _$TemplateAnalysisDto {
  const factory TemplateAnalysisDto({
    /// Template complexity: 'simple' | 'withCash' | 'withCounterparty' | 'complex'
    required String complexity,

    /// List of missing items that need user input
    @JsonKey(name: 'missing_items') @Default([]) List<String> missingItems,

    /// Whether template is ready to use (no missing items)
    @JsonKey(name: 'is_ready') @Default(false) bool isReady,

    /// Completeness score (0-100)
    @JsonKey(name: 'completeness_score') @Default(100) int completenessScore,
  }) = _TemplateAnalysisDto;

  factory TemplateAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateAnalysisDtoFromJson(json);
}

/// UI configuration from RPC response
@freezed
class TemplateUiConfigDto with _$TemplateUiConfigDto {
  const factory TemplateUiConfigDto({
    /// Whether to show cash location selector
    @JsonKey(name: 'show_cash_location_selector') @Default(false) bool showCashLocationSelector,

    /// Whether to show counterparty selector
    @JsonKey(name: 'show_counterparty_selector') @Default(false) bool showCounterpartySelector,

    /// Whether to show counterparty store selector (internal counterparty)
    @JsonKey(name: 'show_counterparty_store_selector') @Default(false) bool showCounterpartyStoreSelector,

    /// Whether to show counterparty cash location selector (internal counterparty)
    @JsonKey(name: 'show_counterparty_cash_location_selector') @Default(false) bool showCounterpartyCashLocationSelector,

    /// Whether counterparty is locked (internal counterparty)
    @JsonKey(name: 'counterparty_is_locked') @Default(false) bool counterpartyIsLocked,

    /// Locked counterparty name for display
    @JsonKey(name: 'locked_counterparty_name') String? lockedCounterpartyName,

    /// Linked company ID for internal counterparty
    @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
  }) = _TemplateUiConfigDto;

  factory TemplateUiConfigDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateUiConfigDtoFromJson(json);
}

/// Default values from RPC response
@freezed
class TemplateDefaultsDto with _$TemplateDefaultsDto {
  const factory TemplateDefaultsDto({
    /// Default cash location ID
    @JsonKey(name: 'cash_location_id') String? cashLocationId,

    /// Default cash location name
    @JsonKey(name: 'cash_location_name') String? cashLocationName,

    /// Default counterparty ID
    @JsonKey(name: 'counterparty_id') String? counterpartyId,

    /// Default counterparty name
    @JsonKey(name: 'counterparty_name') String? counterpartyName,

    /// Default counterparty store ID (internal)
    @JsonKey(name: 'counterparty_store_id') String? counterpartyStoreId,

    /// Default counterparty store name (internal)
    @JsonKey(name: 'counterparty_store_name') String? counterpartyStoreName,

    /// Default counterparty cash location ID
    @JsonKey(name: 'counterparty_cash_location_id') String? counterpartyCashLocationId,

    /// Whether counterparty is internal
    @JsonKey(name: 'is_internal_counterparty') @Default(false) bool isInternalCounterparty,
  }) = _TemplateDefaultsDto;

  factory TemplateDefaultsDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateDefaultsDtoFromJson(json);
}

/// Display info from RPC response
@freezed
class TemplateDisplayInfoDto with _$TemplateDisplayInfoDto {
  const factory TemplateDisplayInfoDto({
    /// Debit category display name (e.g., 'Receivable')
    @JsonKey(name: 'debit_category') @Default('Other') String debitCategory,

    /// Credit category display name (e.g., 'Cash')
    @JsonKey(name: 'credit_category') @Default('Other') String creditCategory,

    /// Transaction type display (e.g., 'Receivable → Cash')
    @JsonKey(name: 'transaction_type') @Default('') String transactionType,
  }) = _TemplateDisplayInfoDto;

  factory TemplateDisplayInfoDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateDisplayInfoDtoFromJson(json);
}

/// Response DTO for create_transaction_from_template RPC
@freezed
class CreateTransactionResponseDto with _$CreateTransactionResponseDto {
  const factory CreateTransactionResponseDto({
    /// Whether the transaction was created successfully
    required bool success,

    /// Created journal ID (UUID)
    @JsonKey(name: 'journal_id') String? journalId,

    /// Success or error message
    String? message,

    /// Error type if failed (e.g., 'validation_error', 'account_mapping_required')
    String? error,

    /// Field that caused the error (for validation errors)
    String? field,
  }) = _CreateTransactionResponseDto;

  factory CreateTransactionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionResponseDtoFromJson(json);
}
