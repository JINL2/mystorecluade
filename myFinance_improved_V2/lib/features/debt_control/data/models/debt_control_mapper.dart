import '../../domain/entities/aging_analysis.dart';
import '../../domain/entities/critical_alert.dart';
import '../../domain/entities/debt_overview.dart';
import '../../domain/entities/kpi_metrics.dart';
import '../../domain/entities/perspective_summary.dart';
import '../../domain/entities/prioritized_debt.dart';
import 'debt_control_dto.dart';

/// Mapper class for converting between DTOs and Domain entities
class DebtControlMapper {
  /// Map KpiMetricsDto to KpiMetrics entity
  static KpiMetrics kpiMetricsDtoToEntity(KpiMetricsDto dto) {
    return KpiMetrics(
      netPosition: dto.netPosition,
      netPositionTrend: dto.netPositionTrend,
      avgDaysOutstanding: dto.avgDaysOutstanding,
      agingTrend: dto.agingTrend,
      collectionRate: dto.collectionRate,
      collectionTrend: dto.collectionTrend,
      criticalCount: dto.criticalCount,
      criticalTrend: dto.criticalTrend,
      totalReceivable: dto.totalReceivable,
      totalPayable: dto.totalPayable,
      transactionCount: dto.transactionCount,
    );
  }

  /// Map AgingAnalysisDto to AgingAnalysis entity
  static AgingAnalysis agingAnalysisDtoToEntity(AgingAnalysisDto dto) {
    return AgingAnalysis(
      current: dto.current,
      overdue30: dto.overdue30,
      overdue60: dto.overdue60,
      overdue90: dto.overdue90,
      trend: dto.trend.map(agingTrendPointDtoToEntity).toList(),
    );
  }

  /// Map AgingTrendPointDto to AgingTrendPoint entity
  static AgingTrendPoint agingTrendPointDtoToEntity(AgingTrendPointDto dto) {
    return AgingTrendPoint(
      date: dto.date,
      current: dto.current,
      overdue30: dto.overdue30,
      overdue60: dto.overdue60,
      overdue90: dto.overdue90,
    );
  }

  /// Map CriticalAlertDto to CriticalAlert entity
  static CriticalAlert criticalAlertDtoToEntity(CriticalAlertDto dto) {
    return CriticalAlert(
      id: dto.id,
      type: dto.type,
      message: dto.message,
      count: dto.count,
      severity: dto.severity,
      isRead: dto.isRead,
      createdAt: dto.createdAt,
    );
  }

  /// Map PrioritizedDebtDto to PrioritizedDebt entity
  static PrioritizedDebt prioritizedDebtDtoToEntity(PrioritizedDebtDto dto) {
    return PrioritizedDebt(
      id: dto.id,
      counterpartyId: dto.counterpartyId,
      counterpartyName: dto.counterpartyName,
      counterpartyType: dto.counterpartyType,
      amount: dto.amount,
      currency: dto.currency,
      dueDate: dto.dueDate,
      daysOverdue: dto.daysOverdue,
      riskCategory: dto.riskCategory,
      priorityScore: dto.priorityScore,
      lastContactDate: dto.lastContactDate,
      lastContactType: dto.lastContactType,
      paymentStatus: dto.paymentStatus,
      suggestedActions: dto.suggestedActions,
      hasPaymentPlan: dto.hasPaymentPlan,
      isDisputed: dto.isDisputed,
      transactionCount: dto.transactionCount,
      linkedCompanyName: dto.linkedCompanyName,
      metadata: dto.metadata,
    );
  }

  /// Map PerspectiveSummaryDto to PerspectiveSummary entity
  static PerspectiveSummary perspectiveSummaryDtoToEntity(
      PerspectiveSummaryDto dto,) {
    return PerspectiveSummary(
      perspectiveType: dto.perspectiveType,
      entityId: dto.entityId,
      entityName: dto.entityName,
      totalReceivable: dto.totalReceivable,
      totalPayable: dto.totalPayable,
      netPosition: dto.netPosition,
      internalReceivable: dto.internalReceivable,
      internalPayable: dto.internalPayable,
      internalNetPosition: dto.internalNetPosition,
      externalReceivable: dto.externalReceivable,
      externalPayable: dto.externalPayable,
      externalNetPosition: dto.externalNetPosition,
      storeAggregates: dto.storeAggregates.map(storeAggregateDtoToEntity).toList(),
      counterpartyCount: dto.counterpartyCount,
      transactionCount: dto.transactionCount,
      collectionRate: dto.collectionRate,
      criticalCount: dto.criticalCount,
    );
  }

  /// Map StoreAggregateDto to StoreAggregate entity
  static StoreAggregate storeAggregateDtoToEntity(StoreAggregateDto dto) {
    return StoreAggregate(
      storeId: dto.storeId,
      storeName: dto.storeName,
      receivable: dto.receivable,
      payable: dto.payable,
      netPosition: dto.netPosition,
      counterpartyCount: dto.counterpartyCount,
      isHeadquarters: dto.isHeadquarters,
    );
  }

  /// Create DebtOverview from multiple DTOs
  static DebtOverview createDebtOverview({
    required KpiMetricsDto kpiMetrics,
    required AgingAnalysisDto agingAnalysis,
    required List<CriticalAlertDto> criticalAlerts,
    required List<PrioritizedDebtDto> topRisks,
    String? viewpointDescription,
    DateTime? lastUpdated,
  }) {
    return DebtOverview(
      kpiMetrics: kpiMetricsDtoToEntity(kpiMetrics),
      agingAnalysis: agingAnalysisDtoToEntity(agingAnalysis),
      criticalAlerts: criticalAlerts.map(criticalAlertDtoToEntity).toList(),
      topRisks: topRisks.map(prioritizedDebtDtoToEntity).toList(),
      viewpointDescription: viewpointDescription,
      lastUpdated: lastUpdated,
    );
  }
}
