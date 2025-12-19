// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_usage_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateUsageResponseDtoImpl _$$TemplateUsageResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateUsageResponseDtoImpl(
      success: json['success'] as bool,
      error: json['error'] as String?,
      message: json['message'] as String?,
      template: json['template'] == null
          ? null
          : TemplateDataDto.fromJson(json['template'] as Map<String, dynamic>),
      analysis: json['analysis'] == null
          ? null
          : TemplateAnalysisDto.fromJson(
              json['analysis'] as Map<String, dynamic>),
      uiConfig: json['ui_config'] == null
          ? null
          : TemplateUiConfigDto.fromJson(
              json['ui_config'] as Map<String, dynamic>),
      defaults: json['defaults'] == null
          ? null
          : TemplateDefaultsDto.fromJson(
              json['defaults'] as Map<String, dynamic>),
      displayInfo: json['display_info'] == null
          ? null
          : TemplateDisplayInfoDto.fromJson(
              json['display_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TemplateUsageResponseDtoImplToJson(
        _$TemplateUsageResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'template': instance.template,
      'analysis': instance.analysis,
      'ui_config': instance.uiConfig,
      'defaults': instance.defaults,
      'display_info': instance.displayInfo,
    };

_$TemplateDataDtoImpl _$$TemplateDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateDataDtoImpl(
      templateId: json['template_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      requiredAttachment: json['required_attachment'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      tags: json['tags'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$TemplateDataDtoImplToJson(
        _$TemplateDataDtoImpl instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'name': instance.name,
      'description': instance.description,
      'required_attachment': instance.requiredAttachment,
      'data': instance.data,
      'tags': instance.tags,
    };

_$TemplateAnalysisDtoImpl _$$TemplateAnalysisDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateAnalysisDtoImpl(
      complexity: json['complexity'] as String,
      missingItems: (json['missing_items'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isReady: json['is_ready'] as bool? ?? false,
      completenessScore: (json['completeness_score'] as num?)?.toInt() ?? 100,
    );

Map<String, dynamic> _$$TemplateAnalysisDtoImplToJson(
        _$TemplateAnalysisDtoImpl instance) =>
    <String, dynamic>{
      'complexity': instance.complexity,
      'missing_items': instance.missingItems,
      'is_ready': instance.isReady,
      'completeness_score': instance.completenessScore,
    };

_$TemplateUiConfigDtoImpl _$$TemplateUiConfigDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateUiConfigDtoImpl(
      showCashLocationSelector:
          json['show_cash_location_selector'] as bool? ?? false,
      showCounterpartySelector:
          json['show_counterparty_selector'] as bool? ?? false,
      showCounterpartyStoreSelector:
          json['show_counterparty_store_selector'] as bool? ?? false,
      showCounterpartyCashLocationSelector:
          json['show_counterparty_cash_location_selector'] as bool? ?? false,
      counterpartyIsLocked: json['counterparty_is_locked'] as bool? ?? false,
      lockedCounterpartyName: json['locked_counterparty_name'] as String?,
      linkedCompanyId: json['linked_company_id'] as String?,
    );

Map<String, dynamic> _$$TemplateUiConfigDtoImplToJson(
        _$TemplateUiConfigDtoImpl instance) =>
    <String, dynamic>{
      'show_cash_location_selector': instance.showCashLocationSelector,
      'show_counterparty_selector': instance.showCounterpartySelector,
      'show_counterparty_store_selector':
          instance.showCounterpartyStoreSelector,
      'show_counterparty_cash_location_selector':
          instance.showCounterpartyCashLocationSelector,
      'counterparty_is_locked': instance.counterpartyIsLocked,
      'locked_counterparty_name': instance.lockedCounterpartyName,
      'linked_company_id': instance.linkedCompanyId,
    };

_$TemplateDefaultsDtoImpl _$$TemplateDefaultsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateDefaultsDtoImpl(
      cashLocationId: json['cash_location_id'] as String?,
      cashLocationName: json['cash_location_name'] as String?,
      counterpartyId: json['counterparty_id'] as String?,
      counterpartyName: json['counterparty_name'] as String?,
      counterpartyStoreId: json['counterparty_store_id'] as String?,
      counterpartyStoreName: json['counterparty_store_name'] as String?,
      counterpartyCashLocationId:
          json['counterparty_cash_location_id'] as String?,
      isInternalCounterparty:
          json['is_internal_counterparty'] as bool? ?? false,
    );

Map<String, dynamic> _$$TemplateDefaultsDtoImplToJson(
        _$TemplateDefaultsDtoImpl instance) =>
    <String, dynamic>{
      'cash_location_id': instance.cashLocationId,
      'cash_location_name': instance.cashLocationName,
      'counterparty_id': instance.counterpartyId,
      'counterparty_name': instance.counterpartyName,
      'counterparty_store_id': instance.counterpartyStoreId,
      'counterparty_store_name': instance.counterpartyStoreName,
      'counterparty_cash_location_id': instance.counterpartyCashLocationId,
      'is_internal_counterparty': instance.isInternalCounterparty,
    };

_$TemplateDisplayInfoDtoImpl _$$TemplateDisplayInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateDisplayInfoDtoImpl(
      debitCategory: json['debit_category'] as String? ?? 'Other',
      creditCategory: json['credit_category'] as String? ?? 'Other',
      transactionType: json['transaction_type'] as String? ?? '',
    );

Map<String, dynamic> _$$TemplateDisplayInfoDtoImplToJson(
        _$TemplateDisplayInfoDtoImpl instance) =>
    <String, dynamic>{
      'debit_category': instance.debitCategory,
      'credit_category': instance.creditCategory,
      'transaction_type': instance.transactionType,
    };

_$CreateTransactionResponseDtoImpl _$$CreateTransactionResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateTransactionResponseDtoImpl(
      success: json['success'] as bool,
      journalId: json['journal_id'] as String?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      field: json['field'] as String?,
    );

Map<String, dynamic> _$$CreateTransactionResponseDtoImplToJson(
        _$CreateTransactionResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'journal_id': instance.journalId,
      'message': instance.message,
      'error': instance.error,
      'field': instance.field,
    };
