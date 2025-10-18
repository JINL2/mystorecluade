// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionFilterImpl _$$TransactionFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionFilterImpl(
      scope: $enumDecodeNullable(_$TransactionScopeEnumMap, json['scope']) ??
          TransactionScope.store,
      dateFrom: json['dateFrom'] == null
          ? null
          : DateTime.parse(json['dateFrom'] as String),
      dateTo: json['dateTo'] == null
          ? null
          : DateTime.parse(json['dateTo'] as String),
      accountId: json['accountId'] as String?,
      accountIds: (json['accountIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cashLocationId: json['cashLocationId'] as String?,
      counterpartyId: json['counterpartyId'] as String?,
      journalType: json['journalType'] as String?,
      createdBy: json['createdBy'] as String?,
      searchQuery: json['searchQuery'] as String?,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TransactionFilterImplToJson(
        _$TransactionFilterImpl instance) =>
    <String, dynamic>{
      'scope': _$TransactionScopeEnumMap[instance.scope]!,
      'dateFrom': instance.dateFrom?.toIso8601String(),
      'dateTo': instance.dateTo?.toIso8601String(),
      'accountId': instance.accountId,
      'accountIds': instance.accountIds,
      'cashLocationId': instance.cashLocationId,
      'counterpartyId': instance.counterpartyId,
      'journalType': instance.journalType,
      'createdBy': instance.createdBy,
      'searchQuery': instance.searchQuery,
      'limit': instance.limit,
      'offset': instance.offset,
    };

const _$TransactionScopeEnumMap = {
  TransactionScope.store: 'store',
  TransactionScope.company: 'company',
};

_$TransactionSummaryImpl _$$TransactionSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionSummaryImpl(
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      todayTotal: (json['todayTotal'] as num?)?.toDouble() ?? 0.0,
      todayCount: (json['todayCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TransactionSummaryImplToJson(
        _$TransactionSummaryImpl instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpenses': instance.totalExpenses,
      'netAmount': instance.netAmount,
      'transactionCount': instance.transactionCount,
      'todayTotal': instance.todayTotal,
      'todayCount': instance.todayCount,
    };
