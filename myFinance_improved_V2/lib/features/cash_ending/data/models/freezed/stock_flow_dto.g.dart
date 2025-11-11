// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_flow_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationSummaryDtoImpl _$$LocationSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationSummaryDtoImpl(
      cashLocationId: json['cash_location_id'] as String,
      locationName: json['location_name'] as String,
      locationType: json['location_type'] as String,
      bankName: json['bank_name'] as String?,
      bankAccount: json['bank_account'] as String?,
      currencyCode: json['currency_code'] as String,
      currencyId: json['currency_id'] as String,
      baseCurrencySymbol: json['base_currency_symbol'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
    );

Map<String, dynamic> _$$LocationSummaryDtoImplToJson(
        _$LocationSummaryDtoImpl instance) =>
    <String, dynamic>{
      'cash_location_id': instance.cashLocationId,
      'location_name': instance.locationName,
      'location_type': instance.locationType,
      'bank_name': instance.bankName,
      'bank_account': instance.bankAccount,
      'currency_code': instance.currencyCode,
      'currency_id': instance.currencyId,
      'base_currency_symbol': instance.baseCurrencySymbol,
      'currency_symbol': instance.currencySymbol,
    };

_$CurrencyInfoDtoImpl _$$CurrencyInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrencyInfoDtoImpl(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String,
      currencyName: json['currency_name'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$$CurrencyInfoDtoImplToJson(
        _$CurrencyInfoDtoImpl instance) =>
    <String, dynamic>{
      'currency_id': instance.currencyId,
      'currency_code': instance.currencyCode,
      'currency_name': instance.currencyName,
      'symbol': instance.symbol,
    };

_$CreatedByDtoImpl _$$CreatedByDtoImplFromJson(Map<String, dynamic> json) =>
    _$CreatedByDtoImpl(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
    );

Map<String, dynamic> _$$CreatedByDtoImplToJson(_$CreatedByDtoImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'full_name': instance.fullName,
    };

_$DenominationDetailDtoImpl _$$DenominationDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DenominationDetailDtoImpl(
      denominationId: json['denomination_id'] as String?,
      denominationValue: (json['denomination_value'] as num?)?.toDouble(),
      denominationType: json['denomination_type'] as String?,
      previousQuantity: (json['previous_quantity'] as num?)?.toInt(),
      currentQuantity: (json['current_quantity'] as num?)?.toInt(),
      quantityChange: (json['quantity_change'] as num?)?.toInt(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      currencySymbol: json['currency_symbol'] as String?,
    );

Map<String, dynamic> _$$DenominationDetailDtoImplToJson(
        _$DenominationDetailDtoImpl instance) =>
    <String, dynamic>{
      'denomination_id': instance.denominationId,
      'denomination_value': instance.denominationValue,
      'denomination_type': instance.denominationType,
      'previous_quantity': instance.previousQuantity,
      'current_quantity': instance.currentQuantity,
      'quantity_change': instance.quantityChange,
      'subtotal': instance.subtotal,
      'currency_symbol': instance.currencySymbol,
    };

_$ActualFlowDtoImpl _$$ActualFlowDtoImplFromJson(Map<String, dynamic> json) =>
    _$ActualFlowDtoImpl(
      flowId: json['flow_id'] as String,
      createdAt: json['created_at'] as String,
      systemTime: json['system_time'] as String,
      balanceBefore: (json['balance_before'] as num).toDouble(),
      flowAmount: (json['flow_amount'] as num).toDouble(),
      balanceAfter: (json['balance_after'] as num).toDouble(),
      currency:
          CurrencyInfoDto.fromJson(json['currency'] as Map<String, dynamic>),
      createdBy:
          CreatedByDto.fromJson(json['created_by'] as Map<String, dynamic>),
      currentDenominations: (json['current_denominations'] as List<dynamic>?)
              ?.map((e) =>
                  DenominationDetailDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ActualFlowDtoImplToJson(_$ActualFlowDtoImpl instance) =>
    <String, dynamic>{
      'flow_id': instance.flowId,
      'created_at': instance.createdAt,
      'system_time': instance.systemTime,
      'balance_before': instance.balanceBefore,
      'flow_amount': instance.flowAmount,
      'balance_after': instance.balanceAfter,
      'currency': instance.currency,
      'created_by': instance.createdBy,
      'current_denominations': instance.currentDenominations,
    };

_$PaginationInfoDtoImpl _$$PaginationInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationInfoDtoImpl(
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalJournalFlows: (json['total_journal_flows'] as num?)?.toInt() ?? 0,
      totalActualFlows: (json['total_actual_flows'] as num?)?.toInt() ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );

Map<String, dynamic> _$$PaginationInfoDtoImplToJson(
        _$PaginationInfoDtoImpl instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'limit': instance.limit,
      'total_journal_flows': instance.totalJournalFlows,
      'total_actual_flows': instance.totalActualFlows,
      'has_more': instance.hasMore,
    };

_$StockFlowDataDtoImpl _$$StockFlowDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$StockFlowDataDtoImpl(
      locationSummary: json['location_summary'] == null
          ? null
          : LocationSummaryDto.fromJson(
              json['location_summary'] as Map<String, dynamic>),
      actualFlows: (json['actual_flows'] as List<dynamic>?)
              ?.map((e) => ActualFlowDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$StockFlowDataDtoImplToJson(
        _$StockFlowDataDtoImpl instance) =>
    <String, dynamic>{
      'location_summary': instance.locationSummary,
      'actual_flows': instance.actualFlows,
    };

_$StockFlowResponseDtoImpl _$$StockFlowResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$StockFlowResponseDtoImpl(
      success: json['success'] as bool? ?? false,
      data: json['data'] == null
          ? null
          : StockFlowDataDto.fromJson(json['data'] as Map<String, dynamic>),
      pagination: json['pagination'] == null
          ? null
          : PaginationInfoDto.fromJson(
              json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StockFlowResponseDtoImplToJson(
        _$StockFlowResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'pagination': instance.pagination,
    };
