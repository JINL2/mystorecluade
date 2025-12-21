// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_control_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CriticalAlertImpl _$$CriticalAlertImplFromJson(Map<String, dynamic> json) =>
    _$CriticalAlertImpl(
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

Map<String, dynamic> _$$CriticalAlertImplToJson(_$CriticalAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'message': instance.message,
      'count': instance.count,
      'severity': instance.severity,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$KPIMetricsImpl _$$KPIMetricsImplFromJson(Map<String, dynamic> json) =>
    _$KPIMetricsImpl(
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

Map<String, dynamic> _$$KPIMetricsImplToJson(_$KPIMetricsImpl instance) =>
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

_$AgingAnalysisImpl _$$AgingAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$AgingAnalysisImpl(
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
      overdue30: (json['overdue30'] as num?)?.toDouble() ?? 0.0,
      overdue60: (json['overdue60'] as num?)?.toDouble() ?? 0.0,
      overdue90: (json['overdue90'] as num?)?.toDouble() ?? 0.0,
      trend: (json['trend'] as List<dynamic>?)
              ?.map((e) => AgingTrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AgingAnalysisImplToJson(_$AgingAnalysisImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'overdue30': instance.overdue30,
      'overdue60': instance.overdue60,
      'overdue90': instance.overdue90,
      'trend': instance.trend,
    };

_$AgingTrendPointImpl _$$AgingTrendPointImplFromJson(
        Map<String, dynamic> json) =>
    _$AgingTrendPointImpl(
      date: DateTime.parse(json['date'] as String),
      current: (json['current'] as num).toDouble(),
      overdue30: (json['overdue30'] as num).toDouble(),
      overdue60: (json['overdue60'] as num).toDouble(),
      overdue90: (json['overdue90'] as num).toDouble(),
    );

Map<String, dynamic> _$$AgingTrendPointImplToJson(
        _$AgingTrendPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'current': instance.current,
      'overdue30': instance.overdue30,
      'overdue60': instance.overdue60,
      'overdue90': instance.overdue90,
    };

_$PrioritizedDebtImpl _$$PrioritizedDebtImplFromJson(
        Map<String, dynamic> json) =>
    _$PrioritizedDebtImpl(
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
              ?.map((e) => SuggestedAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => DebtTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasPaymentPlan: json['hasPaymentPlan'] as bool? ?? false,
      isDisputed: json['isDisputed'] as bool? ?? false,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      linkedCompanyName: json['linkedCompanyName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PrioritizedDebtImplToJson(
        _$PrioritizedDebtImpl instance) =>
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
      'recentTransactions': instance.recentTransactions,
      'hasPaymentPlan': instance.hasPaymentPlan,
      'isDisputed': instance.isDisputed,
      'transactionCount': instance.transactionCount,
      'linkedCompanyName': instance.linkedCompanyName,
      'metadata': instance.metadata,
    };

_$SuggestedActionImpl _$$SuggestedActionImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestedActionImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      isPrimary: json['isPrimary'] as bool,
      color: json['color'] as String,
      description: json['description'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SuggestedActionImplToJson(
        _$SuggestedActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'label': instance.label,
      'icon': instance.icon,
      'isPrimary': instance.isPrimary,
      'color': instance.color,
      'description': instance.description,
      'parameters': instance.parameters,
    };

_$DebtTransactionImpl _$$DebtTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$DebtTransactionImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      status: json['status'] as String,
      description: json['description'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DebtTransactionImplToJson(
        _$DebtTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'status': instance.status,
      'description': instance.description,
      'referenceNumber': instance.referenceNumber,
      'metadata': instance.metadata,
    };

_$SmartDebtOverviewImpl _$$SmartDebtOverviewImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartDebtOverviewImpl(
      kpiMetrics:
          KPIMetrics.fromJson(json['kpiMetrics'] as Map<String, dynamic>),
      agingAnalysis:
          AgingAnalysis.fromJson(json['agingAnalysis'] as Map<String, dynamic>),
      criticalAlerts: (json['criticalAlerts'] as List<dynamic>?)
              ?.map((e) => CriticalAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topRisks: (json['topRisks'] as List<dynamic>?)
              ?.map((e) => PrioritizedDebt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      viewpointDescription: json['viewpointDescription'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$SmartDebtOverviewImplToJson(
        _$SmartDebtOverviewImpl instance) =>
    <String, dynamic>{
      'kpiMetrics': instance.kpiMetrics,
      'agingAnalysis': instance.agingAnalysis,
      'criticalAlerts': instance.criticalAlerts,
      'topRisks': instance.topRisks,
      'viewpointDescription': instance.viewpointDescription,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_$QuickActionImpl _$$QuickActionImplFromJson(Map<String, dynamic> json) =>
    _$QuickActionImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      isEnabled: json['isEnabled'] as bool,
      description: json['description'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$QuickActionImplToJson(_$QuickActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'label': instance.label,
      'icon': instance.icon,
      'color': instance.color,
      'isEnabled': instance.isEnabled,
      'description': instance.description,
      'parameters': instance.parameters,
    };

_$DebtCommunicationImpl _$$DebtCommunicationImplFromJson(
        Map<String, dynamic> json) =>
    _$DebtCommunicationImpl(
      id: json['id'] as String,
      debtId: json['debtId'] as String,
      type: json['type'] as String,
      communicationDate: DateTime.parse(json['communicationDate'] as String),
      createdBy: json['createdBy'] as String,
      notes: json['notes'] as String?,
      followUpDate: json['followUpDate'] == null
          ? null
          : DateTime.parse(json['followUpDate'] as String),
      isFollowUpCompleted: json['isFollowUpCompleted'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DebtCommunicationImplToJson(
        _$DebtCommunicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debtId': instance.debtId,
      'type': instance.type,
      'communicationDate': instance.communicationDate.toIso8601String(),
      'createdBy': instance.createdBy,
      'notes': instance.notes,
      'followUpDate': instance.followUpDate?.toIso8601String(),
      'isFollowUpCompleted': instance.isFollowUpCompleted,
      'metadata': instance.metadata,
    };

_$PaymentPlanImpl _$$PaymentPlanImplFromJson(Map<String, dynamic> json) =>
    _$PaymentPlanImpl(
      id: json['id'] as String,
      debtId: json['debtId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      installmentAmount: (json['installmentAmount'] as num).toDouble(),
      frequency: json['frequency'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: json['status'] as String,
      installments: (json['installments'] as List<dynamic>?)
              ?.map((e) =>
                  PaymentPlanInstallment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$PaymentPlanImplToJson(_$PaymentPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debtId': instance.debtId,
      'totalAmount': instance.totalAmount,
      'installmentAmount': instance.installmentAmount,
      'frequency': instance.frequency,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': instance.status,
      'installments': instance.installments,
      'createdAt': instance.createdAt?.toIso8601String(),
      'notes': instance.notes,
    };

_$PaymentPlanInstallmentImpl _$$PaymentPlanInstallmentImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentPlanInstallmentImpl(
      id: json['id'] as String,
      paymentPlanId: json['paymentPlanId'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      paidDate: json['paidDate'] == null
          ? null
          : DateTime.parse(json['paidDate'] as String),
      paymentReference: json['paymentReference'] as String?,
    );

Map<String, dynamic> _$$PaymentPlanInstallmentImplToJson(
        _$PaymentPlanInstallmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentPlanId': instance.paymentPlanId,
      'amount': instance.amount,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': instance.status,
      'paidAmount': instance.paidAmount,
      'paidDate': instance.paidDate?.toIso8601String(),
      'paymentReference': instance.paymentReference,
    };

_$DebtFilterImpl _$$DebtFilterImplFromJson(Map<String, dynamic> json) =>
    _$DebtFilterImpl(
      counterpartyType: json['counterpartyType'] as String? ?? 'all',
      riskCategory: json['riskCategory'] as String? ?? 'all',
      paymentStatus: json['paymentStatus'] as String? ?? 'all',
      minDaysOverdue: (json['minDaysOverdue'] as num?)?.toInt() ?? 0,
      minAmount: (json['minAmount'] as num?)?.toDouble() ?? 0.0,
      hasPaymentPlan: json['hasPaymentPlan'] as bool? ?? false,
      isDisputed: json['isDisputed'] as bool? ?? false,
      fromDate: json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String),
      toDate: json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate'] as String),
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$DebtFilterImplToJson(_$DebtFilterImpl instance) =>
    <String, dynamic>{
      'counterpartyType': instance.counterpartyType,
      'riskCategory': instance.riskCategory,
      'paymentStatus': instance.paymentStatus,
      'minDaysOverdue': instance.minDaysOverdue,
      'minAmount': instance.minAmount,
      'hasPaymentPlan': instance.hasPaymentPlan,
      'isDisputed': instance.isDisputed,
      'fromDate': instance.fromDate?.toIso8601String(),
      'toDate': instance.toDate?.toIso8601String(),
      'searchQuery': instance.searchQuery,
    };

_$DebtAnalyticsImpl _$$DebtAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$DebtAnalyticsImpl(
      currentAging:
          AgingAnalysis.fromJson(json['currentAging'] as Map<String, dynamic>),
      agingTrend: (json['agingTrend'] as List<dynamic>?)
              ?.map((e) => AgingTrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      collectionEfficiency: (json['collectionEfficiency'] as num).toDouble(),
      collectionTrend: (json['collectionTrend'] as List<dynamic>?)
              ?.map((e) =>
                  CollectionTrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      riskDistribution: (json['riskDistribution'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      topRisks: (json['topRisks'] as List<dynamic>?)
              ?.map((e) =>
                  CounterpartyRiskScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reportDate: json['reportDate'] == null
          ? null
          : DateTime.parse(json['reportDate'] as String),
    );

Map<String, dynamic> _$$DebtAnalyticsImplToJson(_$DebtAnalyticsImpl instance) =>
    <String, dynamic>{
      'currentAging': instance.currentAging,
      'agingTrend': instance.agingTrend,
      'collectionEfficiency': instance.collectionEfficiency,
      'collectionTrend': instance.collectionTrend,
      'riskDistribution': instance.riskDistribution,
      'topRisks': instance.topRisks,
      'reportDate': instance.reportDate?.toIso8601String(),
    };

_$CollectionTrendPointImpl _$$CollectionTrendPointImplFromJson(
        Map<String, dynamic> json) =>
    _$CollectionTrendPointImpl(
      date: DateTime.parse(json['date'] as String),
      collectionRate: (json['collectionRate'] as num).toDouble(),
      totalCollected: (json['totalCollected'] as num).toDouble(),
      totalOutstanding: (json['totalOutstanding'] as num).toDouble(),
    );

Map<String, dynamic> _$$CollectionTrendPointImplToJson(
        _$CollectionTrendPointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'collectionRate': instance.collectionRate,
      'totalCollected': instance.totalCollected,
      'totalOutstanding': instance.totalOutstanding,
    };

_$CounterpartyRiskScoreImpl _$$CounterpartyRiskScoreImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterpartyRiskScoreImpl(
      counterpartyId: json['counterpartyId'] as String,
      counterpartyName: json['counterpartyName'] as String,
      riskScore: (json['riskScore'] as num).toDouble(),
      totalExposure: (json['totalExposure'] as num).toDouble(),
      daysOutstanding: (json['daysOutstanding'] as num).toInt(),
      riskFactors: json['riskFactors'] as String,
    );

Map<String, dynamic> _$$CounterpartyRiskScoreImplToJson(
        _$CounterpartyRiskScoreImpl instance) =>
    <String, dynamic>{
      'counterpartyId': instance.counterpartyId,
      'counterpartyName': instance.counterpartyName,
      'riskScore': instance.riskScore,
      'totalExposure': instance.totalExposure,
      'daysOutstanding': instance.daysOutstanding,
      'riskFactors': instance.riskFactors,
    };
