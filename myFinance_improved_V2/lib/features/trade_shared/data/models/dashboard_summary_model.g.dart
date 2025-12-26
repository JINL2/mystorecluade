// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryModelImpl _$$DashboardSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardSummaryModelImpl(
      overview: DashboardOverviewModel.fromJson(
          json['overview'] as Map<String, dynamic>),
      byStatus: (json['by_status'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
          ) ??
          const {},
      alerts: DashboardAlertSummaryModel.fromJson(
          json['alerts'] as Map<String, dynamic>),
      recentActivities: (json['recent_activities'] as List<dynamic>?)
              ?.map((e) =>
                  RecentActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashboardSummaryModelImplToJson(
        _$DashboardSummaryModelImpl instance) =>
    <String, dynamic>{
      'overview': instance.overview,
      'by_status': instance.byStatus,
      'alerts': instance.alerts,
      'recent_activities': instance.recentActivities,
    };

_$DashboardOverviewModelImpl _$$DashboardOverviewModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardOverviewModelImpl(
      totalPICount: (json['total_pi_count'] as num?)?.toInt() ?? 0,
      totalPOCount: (json['total_po_count'] as num?)?.toInt() ?? 0,
      totalLCCount: (json['total_lc_count'] as num?)?.toInt() ?? 0,
      totalShipmentCount: (json['total_shipment_count'] as num?)?.toInt() ?? 0,
      totalCICount: (json['total_ci_count'] as num?)?.toInt() ?? 0,
      activePOs: (json['active_pos'] as num?)?.toInt() ?? 0,
      activeLCs: (json['active_lcs'] as num?)?.toInt() ?? 0,
      pendingShipments: (json['pending_shipments'] as num?)?.toInt() ?? 0,
      inTransitCount: (json['in_transit_count'] as num?)?.toInt() ?? 0,
      pendingPayments: (json['pending_payments'] as num?)?.toInt() ?? 0,
      totalTradeVolume: (json['total_trade_volume'] as num?)?.toDouble() ?? 0,
      totalLCValue: (json['total_lc_value'] as num?)?.toDouble() ?? 0,
      totalReceived: (json['total_received'] as num?)?.toDouble() ?? 0,
      pendingPaymentAmount:
          (json['pending_payment_amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
    );

Map<String, dynamic> _$$DashboardOverviewModelImplToJson(
        _$DashboardOverviewModelImpl instance) =>
    <String, dynamic>{
      'total_pi_count': instance.totalPICount,
      'total_po_count': instance.totalPOCount,
      'total_lc_count': instance.totalLCCount,
      'total_shipment_count': instance.totalShipmentCount,
      'total_ci_count': instance.totalCICount,
      'active_pos': instance.activePOs,
      'active_lcs': instance.activeLCs,
      'pending_shipments': instance.pendingShipments,
      'in_transit_count': instance.inTransitCount,
      'pending_payments': instance.pendingPayments,
      'total_trade_volume': instance.totalTradeVolume,
      'total_lc_value': instance.totalLCValue,
      'total_received': instance.totalReceived,
      'pending_payment_amount': instance.pendingPaymentAmount,
      'currency': instance.currency,
    };

_$DashboardAlertSummaryModelImpl _$$DashboardAlertSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardAlertSummaryModelImpl(
      expiringLCs: (json['expiring_lcs'] as num?)?.toInt() ?? 0,
      overdueShipments: (json['overdue_shipments'] as num?)?.toInt() ?? 0,
      pendingDocuments: (json['pending_documents'] as num?)?.toInt() ?? 0,
      discrepancies: (json['discrepancies'] as num?)?.toInt() ?? 0,
      paymentsDue: (json['payments_due'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DashboardAlertSummaryModelImplToJson(
        _$DashboardAlertSummaryModelImpl instance) =>
    <String, dynamic>{
      'expiring_lcs': instance.expiringLCs,
      'overdue_shipments': instance.overdueShipments,
      'pending_documents': instance.pendingDocuments,
      'discrepancies': instance.discrepancies,
      'payments_due': instance.paymentsDue,
    };

_$RecentActivityModelImpl _$$RecentActivityModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentActivityModelImpl(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      entityNumber: json['entity_number'] as String?,
      action: json['action'] as String,
      actionDetail: json['action_detail'] as String?,
      previousStatus: json['previous_status'] as String?,
      newStatus: json['new_status'] as String?,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$RecentActivityModelImplToJson(
        _$RecentActivityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'entity_number': instance.entityNumber,
      'action': instance.action,
      'action_detail': instance.actionDetail,
      'previous_status': instance.previousStatus,
      'new_status': instance.newStatus,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'created_at': instance.createdAt.toIso8601String(),
    };
