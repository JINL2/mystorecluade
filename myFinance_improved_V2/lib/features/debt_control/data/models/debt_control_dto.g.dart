// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_control_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KpiMetricsDtoImpl _$$KpiMetricsDtoImplFromJson(Map<String, dynamic> json) =>
    _$KpiMetricsDtoImpl(
      netPosition: (json['netPosition'] as num?)?.toDouble() ?? 0.0,
      netPositionTrend: (json['netPositionTrend'] as num?)?.toDouble() ?? 0.0,
      avgDaysOutstanding: (json['avgDaysOutstanding'] as num?)?.toInt() ?? 0,
      agingTrend: (json['agingTrend'] as num?)?.toDouble() ?? 0.0,
      collectionRate: (json['collectionRate'] as num?)?.toDouble() ?? 0.0,
      collectionTrend: (json['collectionTrend'] as num?)?.toDouble() ?? 0.0,
      criticalCount: (json['criticalCount'] as num?)?.toInt() ?? 0,
      criticalTrend: (json['criticalTrend'] as num?)?.toDouble() ?? 0.0,
      totalReceivable: (json['totalReceivable'] as num?)?.toDouble() ?? 0.0,
      totalPayable: (json['totalPayable'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$KpiMetricsDtoImplToJson(_$KpiMetricsDtoImpl instance) =>
    <String, dynamic>{
      'netPosition': instance.netPosition,
      'netPositionTrend': instance.netPositionTrend,
      'avgDaysOutstanding': instance.avgDaysOutstanding,
      'agingTrend': instance.agingTrend,
      'collectionRate': instance.collectionRate,
      'collectionTrend': instance.collectionTrend,
      'criticalCount': instance.criticalCount,
      'criticalTrend': instance.criticalTrend,
      'totalReceivable': instance.totalReceivable,
      'totalPayable': instance.totalPayable,
      'transactionCount': instance.transactionCount,
    };

_$AgingAnalysisDtoImpl _$$AgingAnalysisDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AgingAnalysisDtoImpl(
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
      overdue30: (json['overdue30'] as num?)?.toDouble() ?? 0.0,
      overdue60: (json['overdue60'] as num?)?.toDouble() ?? 0.0,
      overdue90: (json['overdue90'] as num?)?.toDouble() ?? 0.0,
      trend: (json['trend'] as List<dynamic>?)
              ?.map(
                  (e) => AgingTrendPointDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AgingAnalysisDtoImplToJson(
        _$AgingAnalysisDtoImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'overdue30': instance.overdue30,
      'overdue60': instance.overdue60,
      'overdue90': instance.overdue90,
      'trend': instance.trend,
    };

_$AgingTrendPointDtoImpl _$$AgingTrendPointDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AgingTrendPointDtoImpl(
      date: DateTime.parse(json['date'] as String),
      current: (json['current'] as num).toDouble(),
      overdue30: (json['overdue30'] as num).toDouble(),
      overdue60: (json['overdue60'] as num).toDouble(),
      overdue90: (json['overdue90'] as num).toDouble(),
    );

Map<String, dynamic> _$$AgingTrendPointDtoImplToJson(
        _$AgingTrendPointDtoImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'current': instance.current,
      'overdue30': instance.overdue30,
      'overdue60': instance.overdue60,
      'overdue90': instance.overdue90,
    };

_$CriticalAlertDtoImpl _$$CriticalAlertDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CriticalAlertDtoImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
      count: (json['count'] as num).toInt(),
      severity: json['severity'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CriticalAlertDtoImplToJson(
        _$CriticalAlertDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'message': instance.message,
      'count': instance.count,
      'severity': instance.severity,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$PrioritizedDebtDtoImpl _$$PrioritizedDebtDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PrioritizedDebtDtoImpl(
      id: json['id'] as String,
      counterpartyId: json['counterpartyId'] as String,
      counterpartyName: json['counterpartyName'] as String,
      counterpartyType: json['counterpartyType'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      daysOverdue: (json['daysOverdue'] as num).toInt(),
      riskCategory: json['riskCategory'] as String,
      priorityScore: (json['priorityScore'] as num).toDouble(),
      lastContactDate: json['lastContactDate'] == null
          ? null
          : DateTime.parse(json['lastContactDate'] as String),
      lastContactType: json['lastContactType'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      suggestedActions: (json['suggestedActions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hasPaymentPlan: json['hasPaymentPlan'] as bool? ?? false,
      isDisputed: json['isDisputed'] as bool? ?? false,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      linkedCompanyName: json['linkedCompanyName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PrioritizedDebtDtoImplToJson(
        _$PrioritizedDebtDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'counterpartyId': instance.counterpartyId,
      'counterpartyName': instance.counterpartyName,
      'counterpartyType': instance.counterpartyType,
      'amount': instance.amount,
      'currency': instance.currency,
      'dueDate': instance.dueDate.toIso8601String(),
      'daysOverdue': instance.daysOverdue,
      'riskCategory': instance.riskCategory,
      'priorityScore': instance.priorityScore,
      'lastContactDate': instance.lastContactDate?.toIso8601String(),
      'lastContactType': instance.lastContactType,
      'paymentStatus': instance.paymentStatus,
      'suggestedActions': instance.suggestedActions,
      'hasPaymentPlan': instance.hasPaymentPlan,
      'isDisputed': instance.isDisputed,
      'transactionCount': instance.transactionCount,
      'linkedCompanyName': instance.linkedCompanyName,
      'metadata': instance.metadata,
    };

_$PerspectiveSummaryDtoImpl _$$PerspectiveSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PerspectiveSummaryDtoImpl(
      perspectiveType: json['perspectiveType'] as String,
      entityId: json['entityId'] as String,
      entityName: json['entityName'] as String,
      totalReceivable: (json['totalReceivable'] as num).toDouble(),
      totalPayable: (json['totalPayable'] as num).toDouble(),
      netPosition: (json['netPosition'] as num).toDouble(),
      internalReceivable: (json['internalReceivable'] as num).toDouble(),
      internalPayable: (json['internalPayable'] as num).toDouble(),
      internalNetPosition: (json['internalNetPosition'] as num).toDouble(),
      externalReceivable: (json['externalReceivable'] as num).toDouble(),
      externalPayable: (json['externalPayable'] as num).toDouble(),
      externalNetPosition: (json['externalNetPosition'] as num).toDouble(),
      storeAggregates: (json['storeAggregates'] as List<dynamic>?)
              ?.map(
                  (e) => StoreAggregateDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      counterpartyCount: (json['counterpartyCount'] as num).toInt(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      collectionRate: (json['collectionRate'] as num).toDouble(),
      criticalCount: (json['criticalCount'] as num).toInt(),
    );

Map<String, dynamic> _$$PerspectiveSummaryDtoImplToJson(
        _$PerspectiveSummaryDtoImpl instance) =>
    <String, dynamic>{
      'perspectiveType': instance.perspectiveType,
      'entityId': instance.entityId,
      'entityName': instance.entityName,
      'totalReceivable': instance.totalReceivable,
      'totalPayable': instance.totalPayable,
      'netPosition': instance.netPosition,
      'internalReceivable': instance.internalReceivable,
      'internalPayable': instance.internalPayable,
      'internalNetPosition': instance.internalNetPosition,
      'externalReceivable': instance.externalReceivable,
      'externalPayable': instance.externalPayable,
      'externalNetPosition': instance.externalNetPosition,
      'storeAggregates': instance.storeAggregates,
      'counterpartyCount': instance.counterpartyCount,
      'transactionCount': instance.transactionCount,
      'collectionRate': instance.collectionRate,
      'criticalCount': instance.criticalCount,
    };

_$StoreAggregateDtoImpl _$$StoreAggregateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreAggregateDtoImpl(
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      receivable: (json['receivable'] as num).toDouble(),
      payable: (json['payable'] as num).toDouble(),
      netPosition: (json['netPosition'] as num).toDouble(),
      counterpartyCount: (json['counterpartyCount'] as num).toInt(),
      isHeadquarters: json['isHeadquarters'] as bool,
    );

Map<String, dynamic> _$$StoreAggregateDtoImplToJson(
        _$StoreAggregateDtoImpl instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'receivable': instance.receivable,
      'payable': instance.payable,
      'netPosition': instance.netPosition,
      'counterpartyCount': instance.counterpartyCount,
      'isHeadquarters': instance.isHeadquarters,
    };
