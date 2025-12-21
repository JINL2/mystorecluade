import 'package:freezed_annotation/freezed_annotation.dart';

part 'internal_counterparty_models.freezed.dart';
part 'internal_counterparty_models.g.dart';

/// Enhanced model for internal counterparty with store breakdown
@freezed
class InternalCounterpartyDetail with _$InternalCounterpartyDetail {
  const factory InternalCounterpartyDetail({
    required String counterpartyId,
    required String counterpartyName,
    required String linkedCompanyId,
    required String linkedCompanyName,
    
    // Our perspective
    required double ourTotalReceivable,
    required double ourTotalPayable,
    required double ourNetPosition,
    
    // Their perspective (reciprocal)
    required double theirTotalReceivable,
    required double theirTotalPayable,
    required double theirNetPosition,
    
    // Reconciliation status
    required bool isReconciled,
    double? variance,
    DateTime? lastReconciliationDate,
    
    // Store-level breakdown
    @Default([]) List<StoreDebtPosition> storeBreakdown,
    
    // Metadata
    required int activeStoreCount,
    required int transactionCount,
    DateTime? lastTransactionDate,
    Map<String, dynamic>? metadata,
  }) = _InternalCounterpartyDetail;

  factory InternalCounterpartyDetail.fromJson(Map<String, dynamic> json) =>
      _$InternalCounterpartyDetailFromJson(json);
}

/// Store-level debt position for internal counterparties
@freezed
class StoreDebtPosition with _$StoreDebtPosition {
  const factory StoreDebtPosition({
    required String storeId,
    required String storeName,
    required String storeCode,
    
    // Position from our perspective
    required double receivable,
    required double payable,
    required double netPosition,
    
    // Transaction details
    required int transactionCount,
    DateTime? lastTransactionDate,
    
    // Trends
    double? monthlyAverage,
    double? trend, // percentage change
    
    // Status
    required bool hasOverdue,
    required bool hasDispute,
    int? daysOutstanding,
  }) = _StoreDebtPosition;

  factory StoreDebtPosition.fromJson(Map<String, dynamic> json) =>
      _$StoreDebtPositionFromJson(json);
}

/// Perspective-aware debt summary
@freezed
class PerspectiveDebtSummary with _$PerspectiveDebtSummary {
  const factory PerspectiveDebtSummary({
    required String perspectiveType, // 'company', 'store', 'group'
    required String entityId,
    required String entityName,
    
    // Aggregated positions
    required double totalReceivable,
    required double totalPayable,
    required double netPosition,
    
    // Internal vs External breakdown
    required double internalReceivable,
    required double internalPayable,
    required double internalNetPosition,
    
    required double externalReceivable,
    required double externalPayable,
    required double externalNetPosition,
    
    // Store aggregation (for company perspective)
    @Default([]) List<StoreAggregate> storeAggregates,
    
    // Metrics
    required int counterpartyCount,
    required int transactionCount,
    required double collectionRate,
    required int criticalCount,
  }) = _PerspectiveDebtSummary;

  factory PerspectiveDebtSummary.fromJson(Map<String, dynamic> json) =>
      _$PerspectiveDebtSummaryFromJson(json);
}

/// Store aggregate for company-level view
@freezed
class StoreAggregate with _$StoreAggregate {
  const factory StoreAggregate({
    required String storeId,
    required String storeName,
    required double receivable,
    required double payable,
    required double netPosition,
    required int counterpartyCount,
    required bool isHeadquarters,
  }) = _StoreAggregate;

  factory StoreAggregate.fromJson(Map<String, dynamic> json) =>
      _$StoreAggregateFromJson(json);
}

/// Reconciliation status between internal companies
@freezed
class ReconciliationStatus with _$ReconciliationStatus {
  const factory ReconciliationStatus({
    required String counterpartyId,
    required bool isReconciled,
    required double ourView,
    required double theirView,
    required double variance,
    required double variancePercentage,
    DateTime? lastChecked,
    @Default([]) List<ReconciliationIssue> issues,
  }) = _ReconciliationStatus;

  factory ReconciliationStatus.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationStatusFromJson(json);
}

/// Individual reconciliation issue
@freezed
class ReconciliationIssue with _$ReconciliationIssue {
  const factory ReconciliationIssue({
    required String issueType, // 'missing_transaction', 'amount_mismatch', 'date_mismatch'
    required String description,
    required String severity, // 'critical', 'warning', 'info'
    String? transactionRef,
    double? amountDifference,
    Map<String, dynamic>? details,
  }) = _ReconciliationIssue;

  factory ReconciliationIssue.fromJson(Map<String, dynamic> json) =>
      _$ReconciliationIssueFromJson(json);
}