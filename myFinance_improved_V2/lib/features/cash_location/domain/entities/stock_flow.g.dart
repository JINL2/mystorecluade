// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_flow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalFlowImpl _$$JournalFlowImplFromJson(Map<String, dynamic> json) =>
    _$JournalFlowImpl(
      flowId: json['flowId'] as String,
      createdAt: json['createdAt'] as String,
      systemTime: json['systemTime'] as String,
      balanceBefore: (json['balanceBefore'] as num).toDouble(),
      flowAmount: (json['flowAmount'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      journalId: json['journalId'] as String,
      journalDescription: json['journalDescription'] as String,
      journalType: json['journalType'] as String,
      accountId: json['accountId'] as String,
      accountName: json['accountName'] as String,
      createdBy: CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>),
      counterAccount: json['counterAccount'] == null
          ? null
          : CounterAccount.fromJson(
              json['counterAccount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$JournalFlowImplToJson(_$JournalFlowImpl instance) =>
    <String, dynamic>{
      'flowId': instance.flowId,
      'createdAt': instance.createdAt,
      'systemTime': instance.systemTime,
      'balanceBefore': instance.balanceBefore,
      'flowAmount': instance.flowAmount,
      'balanceAfter': instance.balanceAfter,
      'journalId': instance.journalId,
      'journalDescription': instance.journalDescription,
      'journalType': instance.journalType,
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'createdBy': instance.createdBy,
      'counterAccount': instance.counterAccount,
    };

_$ActualFlowImpl _$$ActualFlowImplFromJson(Map<String, dynamic> json) =>
    _$ActualFlowImpl(
      flowId: json['flowId'] as String,
      createdAt: json['createdAt'] as String,
      systemTime: json['systemTime'] as String,
      balanceBefore: (json['balanceBefore'] as num).toDouble(),
      flowAmount: (json['flowAmount'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      currency: CurrencyInfo.fromJson(json['currency'] as Map<String, dynamic>),
      createdBy: CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>),
      currentDenominations: (json['currentDenominations'] as List<dynamic>)
          .map((e) => DenominationDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ActualFlowImplToJson(_$ActualFlowImpl instance) =>
    <String, dynamic>{
      'flowId': instance.flowId,
      'createdAt': instance.createdAt,
      'systemTime': instance.systemTime,
      'balanceBefore': instance.balanceBefore,
      'flowAmount': instance.flowAmount,
      'balanceAfter': instance.balanceAfter,
      'currency': instance.currency,
      'createdBy': instance.createdBy,
      'currentDenominations': instance.currentDenominations,
    };

_$LocationSummaryImpl _$$LocationSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationSummaryImpl(
      cashLocationId: json['cashLocationId'] as String,
      locationName: json['locationName'] as String,
      locationType: json['locationType'] as String,
      bankName: json['bankName'] as String?,
      bankAccount: json['bankAccount'] as String?,
      currencyCode: json['currencyCode'] as String,
      currencyId: json['currencyId'] as String,
      baseCurrencySymbol: json['baseCurrencySymbol'] as String?,
    );

Map<String, dynamic> _$$LocationSummaryImplToJson(
        _$LocationSummaryImpl instance) =>
    <String, dynamic>{
      'cashLocationId': instance.cashLocationId,
      'locationName': instance.locationName,
      'locationType': instance.locationType,
      'bankName': instance.bankName,
      'bankAccount': instance.bankAccount,
      'currencyCode': instance.currencyCode,
      'currencyId': instance.currencyId,
      'baseCurrencySymbol': instance.baseCurrencySymbol,
    };

_$CounterAccountImpl _$$CounterAccountImplFromJson(Map<String, dynamic> json) =>
    _$CounterAccountImpl(
      accountId: json['accountId'] as String,
      accountName: json['accountName'] as String,
      accountType: json['accountType'] as String,
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$CounterAccountImplToJson(
        _$CounterAccountImpl instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'accountType': instance.accountType,
      'debit': instance.debit,
      'credit': instance.credit,
      'description': instance.description,
    };

_$CurrencyInfoImpl _$$CurrencyInfoImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyInfoImpl(
      currencyId: json['currencyId'] as String,
      currencyCode: json['currencyCode'] as String,
      currencyName: json['currencyName'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$$CurrencyInfoImplToJson(_$CurrencyInfoImpl instance) =>
    <String, dynamic>{
      'currencyId': instance.currencyId,
      'currencyCode': instance.currencyCode,
      'currencyName': instance.currencyName,
      'symbol': instance.symbol,
    };

_$CreatedByImpl _$$CreatedByImplFromJson(Map<String, dynamic> json) =>
    _$CreatedByImpl(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$$CreatedByImplToJson(_$CreatedByImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
    };

_$DenominationDetailImpl _$$DenominationDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$DenominationDetailImpl(
      denominationId: json['denominationId'] as String,
      denominationValue: (json['denominationValue'] as num).toDouble(),
      denominationType: json['denominationType'] as String,
      previousQuantity: (json['previousQuantity'] as num).toInt(),
      currentQuantity: (json['currentQuantity'] as num).toInt(),
      quantityChange: (json['quantityChange'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
      currencySymbol: json['currencySymbol'] as String?,
      currencyId: json['currencyId'] as String?,
      currencyCode: json['currencyCode'] as String?,
      currencyName: json['currencyName'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
      amountInBaseCurrency: (json['amountInBaseCurrency'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DenominationDetailImplToJson(
        _$DenominationDetailImpl instance) =>
    <String, dynamic>{
      'denominationId': instance.denominationId,
      'denominationValue': instance.denominationValue,
      'denominationType': instance.denominationType,
      'previousQuantity': instance.previousQuantity,
      'currentQuantity': instance.currentQuantity,
      'quantityChange': instance.quantityChange,
      'subtotal': instance.subtotal,
      'currencySymbol': instance.currencySymbol,
      'currencyId': instance.currencyId,
      'currencyCode': instance.currencyCode,
      'currencyName': instance.currencyName,
      'amount': instance.amount,
      'exchangeRate': instance.exchangeRate,
      'amountInBaseCurrency': instance.amountInBaseCurrency,
    };

_$StockFlowDataImpl _$$StockFlowDataImplFromJson(Map<String, dynamic> json) =>
    _$StockFlowDataImpl(
      locationSummary: json['locationSummary'] == null
          ? null
          : LocationSummary.fromJson(
              json['locationSummary'] as Map<String, dynamic>),
      journalFlows: (json['journalFlows'] as List<dynamic>)
          .map((e) => JournalFlow.fromJson(e as Map<String, dynamic>))
          .toList(),
      actualFlows: (json['actualFlows'] as List<dynamic>)
          .map((e) => ActualFlow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StockFlowDataImplToJson(_$StockFlowDataImpl instance) =>
    <String, dynamic>{
      'locationSummary': instance.locationSummary,
      'journalFlows': instance.journalFlows,
      'actualFlows': instance.actualFlows,
    };

_$PaginationInfoImpl _$$PaginationInfoImplFromJson(Map<String, dynamic> json) =>
    _$PaginationInfoImpl(
      offset: (json['offset'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalJournalFlows: (json['totalJournalFlows'] as num).toInt(),
      totalActualFlows: (json['totalActualFlows'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$$PaginationInfoImplToJson(
        _$PaginationInfoImpl instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'limit': instance.limit,
      'totalJournalFlows': instance.totalJournalFlows,
      'totalActualFlows': instance.totalActualFlows,
      'hasMore': instance.hasMore,
    };

_$StockFlowResponseImpl _$$StockFlowResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$StockFlowResponseImpl(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : StockFlowData.fromJson(json['data'] as Map<String, dynamic>),
      pagination: json['pagination'] == null
          ? null
          : PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StockFlowResponseImplToJson(
        _$StockFlowResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'pagination': instance.pagination,
    };
