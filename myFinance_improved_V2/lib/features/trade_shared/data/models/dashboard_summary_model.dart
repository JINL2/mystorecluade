import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_summary.dart';

part 'dashboard_summary_model.freezed.dart';
part 'dashboard_summary_model.g.dart';

/// Dashboard summary response from RPC
@freezed
class DashboardSummaryModel with _$DashboardSummaryModel {
  const DashboardSummaryModel._();

  const factory DashboardSummaryModel({
    required DashboardOverviewModel overview,
    @JsonKey(name: 'by_status') @Default({}) Map<String, Map<String, int>> byStatus,
    required DashboardAlertSummaryModel alerts,
    @JsonKey(name: 'recent_activities') @Default([]) List<RecentActivityModel> recentActivities,
  }) = _DashboardSummaryModel;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  /// Convert to domain entity
  DashboardSummary toEntity() => DashboardSummary(
        overview: overview.toEntity(),
        byStatus: byStatus,
        alerts: alerts.toEntity(),
        recentActivities: recentActivities.map((e) => e.toEntity()).toList(),
      );
}

/// Overview model
@freezed
class DashboardOverviewModel with _$DashboardOverviewModel {
  const DashboardOverviewModel._();

  const factory DashboardOverviewModel({
    // Document counts
    @JsonKey(name: 'total_pi_count') @Default(0) int totalPICount,
    @JsonKey(name: 'total_po_count') @Default(0) int totalPOCount,
    @JsonKey(name: 'total_lc_count') @Default(0) int totalLCCount,
    @JsonKey(name: 'total_shipment_count') @Default(0) int totalShipmentCount,
    @JsonKey(name: 'total_ci_count') @Default(0) int totalCICount,
    // Active counts
    @JsonKey(name: 'active_pos') @Default(0) int activePOs,
    @JsonKey(name: 'active_lcs') @Default(0) int activeLCs,
    @JsonKey(name: 'pending_shipments') @Default(0) int pendingShipments,
    @JsonKey(name: 'in_transit_count') @Default(0) int inTransitCount,
    @JsonKey(name: 'pending_payments') @Default(0) int pendingPayments,
    // Amount totals
    @JsonKey(name: 'total_trade_volume') @Default(0) double totalTradeVolume,
    @JsonKey(name: 'total_lc_value') @Default(0) double totalLCValue,
    @JsonKey(name: 'total_received') @Default(0) double totalReceived,
    @JsonKey(name: 'pending_payment_amount') @Default(0) double pendingPaymentAmount,
    @Default('USD') String currency,
  }) = _DashboardOverviewModel;

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewModelFromJson(json);

  DashboardOverview toEntity() => DashboardOverview(
        totalPICount: totalPICount,
        totalPOCount: totalPOCount,
        totalLCCount: totalLCCount,
        totalShipmentCount: totalShipmentCount,
        totalCICount: totalCICount,
        activePOs: activePOs,
        activeLCs: activeLCs,
        activeLCCount: activeLCs,
        pendingShipments: pendingShipments,
        inTransitCount: inTransitCount > 0 ? inTransitCount : pendingShipments,
        pendingPayments: pendingPayments,
        totalTradeVolume: totalTradeVolume > 0 ? totalTradeVolume : totalLCValue,
        totalLCValue: totalLCValue,
        totalReceived: totalReceived,
        pendingPaymentAmount: pendingPaymentAmount,
        currency: currency,
      );
}

/// Alert summary model
@freezed
class DashboardAlertSummaryModel with _$DashboardAlertSummaryModel {
  const DashboardAlertSummaryModel._();

  const factory DashboardAlertSummaryModel({
    @JsonKey(name: 'expiring_lcs') @Default(0) int expiringLCs,
    @JsonKey(name: 'overdue_shipments') @Default(0) int overdueShipments,
    @JsonKey(name: 'pending_documents') @Default(0) int pendingDocuments,
    @Default(0) int discrepancies,
    @JsonKey(name: 'payments_due') @Default(0) int paymentsDue,
  }) = _DashboardAlertSummaryModel;

  factory DashboardAlertSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardAlertSummaryModelFromJson(json);

  DashboardAlertSummary toEntity() => DashboardAlertSummary(
        expiringLCs: expiringLCs,
        overdueShipments: overdueShipments,
        pendingDocuments: pendingDocuments,
        discrepancies: discrepancies,
        paymentsDue: paymentsDue,
      );
}

/// Recent activity model
/// Supports multiple field name variations from RPC responses
@freezed
class RecentActivityModel with _$RecentActivityModel {
  const RecentActivityModel._();

  const factory RecentActivityModel({
    @Default('') String id,
    @JsonKey(name: 'entity_type') @Default('') String entityType,
    @JsonKey(name: 'entity_id') @Default('') String entityId,
    @JsonKey(name: 'entity_number') String? entityNumber,
    @Default('') String action,
    @JsonKey(name: 'action_detail') String? actionDetail,
    @JsonKey(name: 'previous_status') String? previousStatus,
    @JsonKey(name: 'new_status') String? newStatus,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _RecentActivityModel;

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) =>
      _$RecentActivityModelFromJson(json);

  /// Create from RPC response with different field names
  factory RecentActivityModel.fromRpcJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['id']?.toString() ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      entityNumber: json['entity_number']?.toString(),
      action: json['action']?.toString() ?? json['action_type']?.toString() ?? '',
      actionDetail: json['action_detail']?.toString() ?? json['action_description']?.toString(),
      previousStatus: json['previous_status']?.toString(),
      newStatus: json['new_status']?.toString(),
      userId: json['user_id']?.toString() ?? json['performed_by']?.toString(),
      userName: json['user_name']?.toString(),
      createdAt: _parseDateTime(json['created_at'] ?? json['performed_at']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  RecentActivity toEntity() => RecentActivity(
        id: id,
        entityType: entityType,
        entityId: entityId,
        entityNumber: entityNumber,
        action: action,
        actionDetail: actionDetail,
        previousStatus: previousStatus,
        newStatus: newStatus,
        userId: userId,
        userName: userName,
        createdAt: createdAt ?? DateTime.now(),
      );
}
