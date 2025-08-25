import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_control_models.freezed.dart';
part 'debt_control_models.g.dart';

/// Critical alert data model for proactive debt management notifications
@freezed
class CriticalAlert with _$CriticalAlert {
  const factory CriticalAlert({
    required String id,
    required String type, // 'overdue_critical', 'payment_received', 'dispute_pending'
    required String message,
    required int count,
    required String severity, // 'critical', 'warning', 'info'
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _CriticalAlert;

  factory CriticalAlert.fromJson(Map<String, dynamic> json) =>
      _$CriticalAlertFromJson(json);
}

/// Key Performance Indicators for debt management dashboard
@freezed
class KPIMetrics with _$KPIMetrics {
  const factory KPIMetrics({
    @Default(0.0) double netPosition,
    @Default(0.0) double netPositionTrend, // percentage change
    @Default(0) int avgDaysOutstanding,
    @Default(0.0) double agingTrend,
    @Default(0.0) double collectionRate,
    @Default(0.0) double collectionTrend,
    @Default(0) int criticalCount,
    @Default(0.0) double criticalTrend,
    @Default(0.0) double totalReceivable,
    @Default(0.0) double totalPayable,
    @Default(0) int transactionCount,
  }) = _KPIMetrics;

  factory KPIMetrics.fromJson(Map<String, dynamic> json) =>
      _$KPIMetricsFromJson(json);
}

/// Aging analysis data for debt portfolio insights
@freezed
class AgingAnalysis with _$AgingAnalysis {
  const factory AgingAnalysis({
    @Default(0.0) double current, // 0-30 days
    @Default(0.0) double overdue30, // 31-60 days
    @Default(0.0) double overdue60, // 61-90 days
    @Default(0.0) double overdue90, // 90+ days
    @Default([]) List<AgingTrendPoint> trend,
  }) = _AgingAnalysis;

  factory AgingAnalysis.fromJson(Map<String, dynamic> json) =>
      _$AgingAnalysisFromJson(json);
}

/// Trend data point for aging analysis charts
@freezed
class AgingTrendPoint with _$AgingTrendPoint {
  const factory AgingTrendPoint({
    required DateTime date,
    required double current,
    required double overdue30,
    required double overdue60,
    required double overdue90,
  }) = _AgingTrendPoint;

  factory AgingTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$AgingTrendPointFromJson(json);
}

/// Risk-prioritized debt item with intelligent scoring
@freezed
class PrioritizedDebt with _$PrioritizedDebt {
  const factory PrioritizedDebt({
    required String id,
    required String counterpartyId,
    required String counterpartyName,
    required String counterpartyType, // 'customer', 'vendor', 'employee', 'internal'
    required double amount,
    required String currency,
    required DateTime dueDate,
    required int daysOverdue,
    required String riskCategory, // 'critical', 'attention', 'watch', 'current'
    required double priorityScore, // 0-100 risk score
    DateTime? lastContactDate,
    String? lastContactType, // 'call', 'email', 'meeting'
    String? paymentStatus, // 'overdue', 'partial', 'current', 'disputed'
    @Default([]) List<SuggestedAction> suggestedActions,
    @Default([]) List<DebtTransaction> recentTransactions,
    @Default(false) bool hasPaymentPlan,
    @Default(false) bool isDisputed,
    Map<String, dynamic>? metadata,
  }) = _PrioritizedDebt;

  factory PrioritizedDebt.fromJson(Map<String, dynamic> json) =>
      _$PrioritizedDebtFromJson(json);
}

/// Contextual action suggestion for debt management
@freezed
class SuggestedAction with _$SuggestedAction {
  const factory SuggestedAction({
    required String id,
    required String type, // 'call', 'email', 'payment_plan', 'legal', etc.
    required String label,
    required String icon,
    required bool isPrimary,
    required String color, // hex color code
    String? description,
    Map<String, dynamic>? parameters,
  }) = _SuggestedAction;

  factory SuggestedAction.fromJson(Map<String, dynamic> json) =>
      _$SuggestedActionFromJson(json);
}

/// Individual debt transaction for history tracking
@freezed
class DebtTransaction with _$DebtTransaction {
  const factory DebtTransaction({
    required String id,
    required String type, // 'invoice', 'payment', 'credit_note', 'adjustment'
    required double amount,
    required String currency,
    required DateTime transactionDate,
    required String status, // 'posted', 'pending', 'cancelled'
    String? description,
    String? referenceNumber,
    Map<String, dynamic>? metadata,
  }) = _DebtTransaction;

  factory DebtTransaction.fromJson(Map<String, dynamic> json) =>
      _$DebtTransactionFromJson(json);
}

/// Smart debt overview containing all intelligence data
@freezed
class SmartDebtOverview with _$SmartDebtOverview {
  const factory SmartDebtOverview({
    required KPIMetrics kpiMetrics,
    required AgingAnalysis agingAnalysis,
    @Default([]) List<CriticalAlert> criticalAlerts,
    @Default([]) List<PrioritizedDebt> topRisks,
    String? viewpointDescription,
    DateTime? lastUpdated,
  }) = _SmartDebtOverview;

  factory SmartDebtOverview.fromJson(Map<String, dynamic> json) =>
      _$SmartDebtOverviewFromJson(json);
}

/// Quick action configuration for actions hub
@freezed
class QuickAction with _$QuickAction {
  const factory QuickAction({
    required String id,
    required String type,
    required String label,
    required String icon,
    required String color,
    required bool isEnabled,
    String? description,
    Map<String, dynamic>? parameters,
  }) = _QuickAction;

  factory QuickAction.fromJson(Map<String, dynamic> json) =>
      _$QuickActionFromJson(json);
}

/// Communication record for debt follow-up tracking
@freezed
class DebtCommunication with _$DebtCommunication {
  const factory DebtCommunication({
    required String id,
    required String debtId,
    required String type, // 'call', 'email', 'letter', 'meeting'
    required DateTime communicationDate,
    required String createdBy,
    String? notes,
    DateTime? followUpDate,
    @Default(false) bool isFollowUpCompleted,
    Map<String, dynamic>? metadata,
  }) = _DebtCommunication;

  factory DebtCommunication.fromJson(Map<String, dynamic> json) =>
      _$DebtCommunicationFromJson(json);
}

/// Payment plan configuration for structured debt collection
@freezed
class PaymentPlan with _$PaymentPlan {
  const factory PaymentPlan({
    required String id,
    required String debtId,
    required double totalAmount,
    required double installmentAmount,
    required String frequency, // 'weekly', 'monthly', 'quarterly'
    required DateTime startDate,
    required DateTime endDate,
    required String status, // 'active', 'completed', 'defaulted', 'cancelled'
    @Default([]) List<PaymentPlanInstallment> installments,
    DateTime? createdAt,
    String? notes,
  }) = _PaymentPlan;

  factory PaymentPlan.fromJson(Map<String, dynamic> json) =>
      _$PaymentPlanFromJson(json);
}

/// Individual installment in a payment plan
@freezed
class PaymentPlanInstallment with _$PaymentPlanInstallment {
  const factory PaymentPlanInstallment({
    required String id,
    required String paymentPlanId,
    required double amount,
    required DateTime dueDate,
    required String status, // 'pending', 'paid', 'overdue', 'partial'
    @Default(0.0) double paidAmount,
    DateTime? paidDate,
    String? paymentReference,
  }) = _PaymentPlanInstallment;

  factory PaymentPlanInstallment.fromJson(Map<String, dynamic> json) =>
      _$PaymentPlanInstallmentFromJson(json);
}

/// Filter criteria for debt list filtering
@freezed
class DebtFilter with _$DebtFilter {
  const factory DebtFilter({
    @Default('all') String counterpartyType, // 'all', 'group', 'external', 'customer', 'vendor'
    @Default('all') String riskCategory, // 'all', 'critical', 'attention', 'watch', 'current'
    @Default('all') String paymentStatus, // 'all', 'overdue', 'current', 'disputed'
    @Default(0) int minDaysOverdue,
    @Default(0.0) double minAmount,
    @Default(false) bool hasPaymentPlan,
    @Default(false) bool isDisputed,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
  }) = _DebtFilter;

  factory DebtFilter.fromJson(Map<String, dynamic> json) =>
      _$DebtFilterFromJson(json);
}

/// Debt analytics data for reporting and insights
@freezed
class DebtAnalytics with _$DebtAnalytics {
  const factory DebtAnalytics({
    required AgingAnalysis currentAging,
    @Default([]) List<AgingTrendPoint> agingTrend,
    required double collectionEfficiency,
    @Default([]) List<CollectionTrendPoint> collectionTrend,
    required Map<String, double> riskDistribution,
    @Default([]) List<CounterpartyRiskScore> topRisks,
    DateTime? reportDate,
  }) = _DebtAnalytics;

  factory DebtAnalytics.fromJson(Map<String, dynamic> json) =>
      _$DebtAnalyticsFromJson(json);
}

/// Collection trend data point
@freezed
class CollectionTrendPoint with _$CollectionTrendPoint {
  const factory CollectionTrendPoint({
    required DateTime date,
    required double collectionRate,
    required double totalCollected,
    required double totalOutstanding,
  }) = _CollectionTrendPoint;

  factory CollectionTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$CollectionTrendPointFromJson(json);
}

/// Counterparty risk scoring data
@freezed
class CounterpartyRiskScore with _$CounterpartyRiskScore {
  const factory CounterpartyRiskScore({
    required String counterpartyId,
    required String counterpartyName,
    required double riskScore, // 0-100
    required double totalExposure,
    required int daysOutstanding,
    required String riskFactors, // comma-separated list
  }) = _CounterpartyRiskScore;

  factory CounterpartyRiskScore.fromJson(Map<String, dynamic> json) =>
      _$CounterpartyRiskScoreFromJson(json);
}