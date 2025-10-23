import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_control_dto.freezed.dart';
part 'debt_control_dto.g.dart';

/// DTO for KPI metrics from API/Database
@freezed
class KpiMetricsDto with _$KpiMetricsDto {
  const factory KpiMetricsDto({
    @Default(0.0) double netPosition,
    @Default(0.0) double netPositionTrend,
    @Default(0) int avgDaysOutstanding,
    @Default(0.0) double agingTrend,
    @Default(0.0) double collectionRate,
    @Default(0.0) double collectionTrend,
    @Default(0) int criticalCount,
    @Default(0.0) double criticalTrend,
    @Default(0.0) double totalReceivable,
    @Default(0.0) double totalPayable,
    @Default(0) int transactionCount,
  }) = _KpiMetricsDto;

  factory KpiMetricsDto.fromJson(Map<String, dynamic> json) =>
      _$KpiMetricsDtoFromJson(json);
}

/// DTO for Aging Analysis
@freezed
class AgingAnalysisDto with _$AgingAnalysisDto {
  const factory AgingAnalysisDto({
    @Default(0.0) double current,
    @Default(0.0) double overdue30,
    @Default(0.0) double overdue60,
    @Default(0.0) double overdue90,
    @Default([]) List<AgingTrendPointDto> trend,
  }) = _AgingAnalysisDto;

  factory AgingAnalysisDto.fromJson(Map<String, dynamic> json) =>
      _$AgingAnalysisDtoFromJson(json);
}

/// DTO for Aging Trend Point
@freezed
class AgingTrendPointDto with _$AgingTrendPointDto {
  const factory AgingTrendPointDto({
    required DateTime date,
    required double current,
    required double overdue30,
    required double overdue60,
    required double overdue90,
  }) = _AgingTrendPointDto;

  factory AgingTrendPointDto.fromJson(Map<String, dynamic> json) =>
      _$AgingTrendPointDtoFromJson(json);
}

/// DTO for Critical Alert
@freezed
class CriticalAlertDto with _$CriticalAlertDto {
  const factory CriticalAlertDto({
    required String id,
    required String type,
    required String message,
    required int count,
    required String severity,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _CriticalAlertDto;

  factory CriticalAlertDto.fromJson(Map<String, dynamic> json) =>
      _$CriticalAlertDtoFromJson(json);
}

/// DTO for Prioritized Debt
@freezed
class PrioritizedDebtDto with _$PrioritizedDebtDto {
  const factory PrioritizedDebtDto({
    required String id,
    required String counterpartyId,
    required String counterpartyName,
    required String counterpartyType,
    required double amount,
    required String currency,
    required DateTime dueDate,
    required int daysOverdue,
    required String riskCategory,
    required double priorityScore,
    DateTime? lastContactDate,
    String? lastContactType,
    String? paymentStatus,
    @Default([]) List<String> suggestedActions,
    @Default(false) bool hasPaymentPlan,
    @Default(false) bool isDisputed,
    @Default(0) int transactionCount,
    String? linkedCompanyName,
    Map<String, dynamic>? metadata,
  }) = _PrioritizedDebtDto;

  factory PrioritizedDebtDto.fromJson(Map<String, dynamic> json) =>
      _$PrioritizedDebtDtoFromJson(json);
}

/// DTO for Perspective Summary
@freezed
class PerspectiveSummaryDto with _$PerspectiveSummaryDto {
  const factory PerspectiveSummaryDto({
    required String perspectiveType,
    required String entityId,
    required String entityName,
    required double totalReceivable,
    required double totalPayable,
    required double netPosition,
    required double internalReceivable,
    required double internalPayable,
    required double internalNetPosition,
    required double externalReceivable,
    required double externalPayable,
    required double externalNetPosition,
    @Default([]) List<StoreAggregateDto> storeAggregates,
    required int counterpartyCount,
    required int transactionCount,
    required double collectionRate,
    required int criticalCount,
  }) = _PerspectiveSummaryDto;

  factory PerspectiveSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PerspectiveSummaryDtoFromJson(json);
}

/// DTO for Store Aggregate
@freezed
class StoreAggregateDto with _$StoreAggregateDto {
  const factory StoreAggregateDto({
    required String storeId,
    required String storeName,
    required double receivable,
    required double payable,
    required double netPosition,
    required int counterpartyCount,
    required bool isHeadquarters,
  }) = _StoreAggregateDto;

  factory StoreAggregateDto.fromJson(Map<String, dynamic> json) =>
      _$StoreAggregateDtoFromJson(json);
}
