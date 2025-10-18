// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_counterparty_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InternalCounterpartyDetailImpl _$$InternalCounterpartyDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$InternalCounterpartyDetailImpl(
      counterpartyId: json['counterpartyId'] as String,
      counterpartyName: json['counterpartyName'] as String,
      linkedCompanyId: json['linkedCompanyId'] as String,
      linkedCompanyName: json['linkedCompanyName'] as String,
      ourTotalReceivable: (json['ourTotalReceivable'] as num).toDouble(),
      ourTotalPayable: (json['ourTotalPayable'] as num).toDouble(),
      ourNetPosition: (json['ourNetPosition'] as num).toDouble(),
      theirTotalReceivable: (json['theirTotalReceivable'] as num).toDouble(),
      theirTotalPayable: (json['theirTotalPayable'] as num).toDouble(),
      theirNetPosition: (json['theirNetPosition'] as num).toDouble(),
      isReconciled: json['isReconciled'] as bool,
      variance: (json['variance'] as num?)?.toDouble(),
      lastReconciliationDate: json['lastReconciliationDate'] == null
          ? null
          : DateTime.parse(json['lastReconciliationDate'] as String),
      storeBreakdown: (json['storeBreakdown'] as List<dynamic>?)
              ?.map(
                  (e) => StoreDebtPosition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeStoreCount: (json['activeStoreCount'] as num).toInt(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      lastTransactionDate: json['lastTransactionDate'] == null
          ? null
          : DateTime.parse(json['lastTransactionDate'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$InternalCounterpartyDetailImplToJson(
        _$InternalCounterpartyDetailImpl instance) =>
    <String, dynamic>{
      'counterpartyId': instance.counterpartyId,
      'counterpartyName': instance.counterpartyName,
      'linkedCompanyId': instance.linkedCompanyId,
      'linkedCompanyName': instance.linkedCompanyName,
      'ourTotalReceivable': instance.ourTotalReceivable,
      'ourTotalPayable': instance.ourTotalPayable,
      'ourNetPosition': instance.ourNetPosition,
      'theirTotalReceivable': instance.theirTotalReceivable,
      'theirTotalPayable': instance.theirTotalPayable,
      'theirNetPosition': instance.theirNetPosition,
      'isReconciled': instance.isReconciled,
      'variance': instance.variance,
      'lastReconciliationDate':
          instance.lastReconciliationDate?.toIso8601String(),
      'storeBreakdown': instance.storeBreakdown,
      'activeStoreCount': instance.activeStoreCount,
      'transactionCount': instance.transactionCount,
      'lastTransactionDate': instance.lastTransactionDate?.toIso8601String(),
      'metadata': instance.metadata,
    };

_$StoreDebtPositionImpl _$$StoreDebtPositionImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreDebtPositionImpl(
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      storeCode: json['storeCode'] as String,
      receivable: (json['receivable'] as num).toDouble(),
      payable: (json['payable'] as num).toDouble(),
      netPosition: (json['netPosition'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      lastTransactionDate: json['lastTransactionDate'] == null
          ? null
          : DateTime.parse(json['lastTransactionDate'] as String),
      monthlyAverage: (json['monthlyAverage'] as num?)?.toDouble(),
      trend: (json['trend'] as num?)?.toDouble(),
      hasOverdue: json['hasOverdue'] as bool,
      hasDispute: json['hasDispute'] as bool,
      daysOutstanding: (json['daysOutstanding'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$StoreDebtPositionImplToJson(
        _$StoreDebtPositionImpl instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'storeCode': instance.storeCode,
      'receivable': instance.receivable,
      'payable': instance.payable,
      'netPosition': instance.netPosition,
      'transactionCount': instance.transactionCount,
      'lastTransactionDate': instance.lastTransactionDate?.toIso8601String(),
      'monthlyAverage': instance.monthlyAverage,
      'trend': instance.trend,
      'hasOverdue': instance.hasOverdue,
      'hasDispute': instance.hasDispute,
      'daysOutstanding': instance.daysOutstanding,
    };

_$PerspectiveDebtSummaryImpl _$$PerspectiveDebtSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$PerspectiveDebtSummaryImpl(
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
              ?.map((e) => StoreAggregate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      counterpartyCount: (json['counterpartyCount'] as num).toInt(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      collectionRate: (json['collectionRate'] as num).toDouble(),
      criticalCount: (json['criticalCount'] as num).toInt(),
    );

Map<String, dynamic> _$$PerspectiveDebtSummaryImplToJson(
        _$PerspectiveDebtSummaryImpl instance) =>
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

_$StoreAggregateImpl _$$StoreAggregateImplFromJson(Map<String, dynamic> json) =>
    _$StoreAggregateImpl(
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      receivable: (json['receivable'] as num).toDouble(),
      payable: (json['payable'] as num).toDouble(),
      netPosition: (json['netPosition'] as num).toDouble(),
      counterpartyCount: (json['counterpartyCount'] as num).toInt(),
      isHeadquarters: json['isHeadquarters'] as bool,
    );

Map<String, dynamic> _$$StoreAggregateImplToJson(
        _$StoreAggregateImpl instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'receivable': instance.receivable,
      'payable': instance.payable,
      'netPosition': instance.netPosition,
      'counterpartyCount': instance.counterpartyCount,
      'isHeadquarters': instance.isHeadquarters,
    };

_$ReconciliationStatusImpl _$$ReconciliationStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$ReconciliationStatusImpl(
      counterpartyId: json['counterpartyId'] as String,
      isReconciled: json['isReconciled'] as bool,
      ourView: (json['ourView'] as num).toDouble(),
      theirView: (json['theirView'] as num).toDouble(),
      variance: (json['variance'] as num).toDouble(),
      variancePercentage: (json['variancePercentage'] as num).toDouble(),
      lastChecked: json['lastChecked'] == null
          ? null
          : DateTime.parse(json['lastChecked'] as String),
      issues: (json['issues'] as List<dynamic>?)
              ?.map((e) =>
                  ReconciliationIssue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReconciliationStatusImplToJson(
        _$ReconciliationStatusImpl instance) =>
    <String, dynamic>{
      'counterpartyId': instance.counterpartyId,
      'isReconciled': instance.isReconciled,
      'ourView': instance.ourView,
      'theirView': instance.theirView,
      'variance': instance.variance,
      'variancePercentage': instance.variancePercentage,
      'lastChecked': instance.lastChecked?.toIso8601String(),
      'issues': instance.issues,
    };

_$ReconciliationIssueImpl _$$ReconciliationIssueImplFromJson(
        Map<String, dynamic> json) =>
    _$ReconciliationIssueImpl(
      issueType: json['issueType'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      transactionRef: json['transactionRef'] as String?,
      amountDifference: (json['amountDifference'] as num?)?.toDouble(),
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReconciliationIssueImplToJson(
        _$ReconciliationIssueImpl instance) =>
    <String, dynamic>{
      'issueType': instance.issueType,
      'description': instance.description,
      'severity': instance.severity,
      'transactionRef': instance.transactionRef,
      'amountDifference': instance.amountDifference,
      'details': instance.details,
    };
