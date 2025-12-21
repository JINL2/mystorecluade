import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/index.dart';

// Supply Chain Analytics Data Models

// Core Supply Chain Problem Model
class SupplyChainProblem {
  final String id;
  final int rank;
  final double priorityScore;
  final ProductInfo product;
  final BottleneckStage stage;
  final ProblemMetrics metrics;
  final FinancialImpact financialImpact;
  final List<SmartAction> actions;
  final CollaborationInfo collaboration;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const SupplyChainProblem({
    required this.id,
    required this.rank,
    required this.priorityScore,
    required this.product,
    required this.stage,
    required this.metrics,
    required this.financialImpact,
    required this.actions,
    required this.collaboration,
    required this.createdAt,
    required this.lastUpdated,
  });

  SupplyChainProblem copyWith({
    String? id,
    int? rank,
    double? priorityScore,
    ProductInfo? product,
    BottleneckStage? stage,
    ProblemMetrics? metrics,
    FinancialImpact? financialImpact,
    List<SmartAction>? actions,
    CollaborationInfo? collaboration,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return SupplyChainProblem(
      id: id ?? this.id,
      rank: rank ?? this.rank,
      priorityScore: priorityScore ?? this.priorityScore,
      product: product ?? this.product,
      stage: stage ?? this.stage,
      metrics: metrics ?? this.metrics,
      financialImpact: financialImpact ?? this.financialImpact,
      actions: actions ?? this.actions,
      collaboration: collaboration ?? this.collaboration,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Product Information
class ProductInfo {
  final String sku;
  final String name;
  final String brand;
  final String category;
  final String? imageUrl;
  final double unitCost;
  final double salePrice;

  const ProductInfo({
    required this.sku,
    required this.name,
    required this.brand,
    required this.category,
    this.imageUrl,
    required this.unitCost,
    required this.salePrice,
  });

  ProductInfo copyWith({
    String? sku,
    String? name,
    String? brand,
    String? category,
    String? imageUrl,
    double? unitCost,
    double? salePrice,
  }) {
    return ProductInfo(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      unitCost: unitCost ?? this.unitCost,
      salePrice: salePrice ?? this.salePrice,
    );
  }
}

// Bottleneck Stage Information
class BottleneckStage {
  final SupplyChainStage stage;
  final String koreanLabel;
  final String description;
  final String rootCause;
  final int daysAccumulated;
  final Color indicatorColor;

  const BottleneckStage({
    required this.stage,
    required this.koreanLabel,
    required this.description,
    required this.rootCause,
    required this.daysAccumulated,
    required this.indicatorColor,
  });

  BottleneckStage copyWith({
    SupplyChainStage? stage,
    String? koreanLabel,
    String? description,
    String? rootCause,
    int? daysAccumulated,
    Color? indicatorColor,
  }) {
    return BottleneckStage(
      stage: stage ?? this.stage,
      koreanLabel: koreanLabel ?? this.koreanLabel,
      description: description ?? this.description,
      rootCause: rootCause ?? this.rootCause,
      daysAccumulated: daysAccumulated ?? this.daysAccumulated,
      indicatorColor: indicatorColor ?? this.indicatorColor,
    );
  }
}

// Supply Chain Stages
enum SupplyChainStage {
  order('주문'),
  send('배송'),
  receive('입고'),
  sell('판매');

  const SupplyChainStage(this.koreanLabel);
  final String koreanLabel;
  
  String get englishLabel {
    switch (this) {
      case SupplyChainStage.order:
        return 'Order';
      case SupplyChainStage.send:
        return 'Send';
      case SupplyChainStage.receive:
        return 'Receive';
      case SupplyChainStage.sell:
        return 'Sell';
    }
  }
}

// Problem Metrics
class ProblemMetrics {
  final double integralValue;
  final int currentGap;
  final int daysAccumulated;
  final double velocityTrend;
  final double confidenceScore;

  const ProblemMetrics({
    required this.integralValue,
    required this.currentGap,
    required this.daysAccumulated,
    required this.velocityTrend,
    required this.confidenceScore,
  });

  ProblemMetrics copyWith({
    double? integralValue,
    int? currentGap,
    int? daysAccumulated,
    double? velocityTrend,
    double? confidenceScore,
  }) {
    return ProblemMetrics(
      integralValue: integralValue ?? this.integralValue,
      currentGap: currentGap ?? this.currentGap,
      daysAccumulated: daysAccumulated ?? this.daysAccumulated,
      velocityTrend: velocityTrend ?? this.velocityTrend,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }
}

// Financial Impact Analysis
class FinancialImpact {
  final double currentLoss;
  final double projectedLoss;
  final double opportunityCost;
  final double carryingCost;
  final double preventionValue;

  const FinancialImpact({
    required this.currentLoss,
    required this.projectedLoss,
    required this.opportunityCost,
    required this.carryingCost,
    required this.preventionValue,
  });

  double get totalImpact => currentLoss + projectedLoss + opportunityCost;

  FinancialImpact copyWith({
    double? currentLoss,
    double? projectedLoss,
    double? opportunityCost,
    double? carryingCost,
    double? preventionValue,
  }) {
    return FinancialImpact(
      currentLoss: currentLoss ?? this.currentLoss,
      projectedLoss: projectedLoss ?? this.projectedLoss,
      opportunityCost: opportunityCost ?? this.opportunityCost,
      carryingCost: carryingCost ?? this.carryingCost,
      preventionValue: preventionValue ?? this.preventionValue,
    );
  }
}

// Smart Action Definition
class SmartAction {
  final String id;
  final String koreanLabel;
  final String description;
  final ActionType type;
  final UserRole requiredRole;
  final double successProbability;
  final int estimatedTimeHours;
  final double cost;
  final ActionPriority priority;
  final IconData icon;
  final Color color;

  const SmartAction({
    required this.id,
    required this.koreanLabel,
    required this.description,
    required this.type,
    required this.requiredRole,
    required this.successProbability,
    required this.estimatedTimeHours,
    required this.cost,
    required this.priority,
    required this.icon,
    required this.color,
  });

  String get englishLabel {
    switch (type) {
      case ActionType.contactSupplier:
        return 'Contact Supplier';
      case ActionType.expediteOrder:
        return 'Expedite Order';
      case ActionType.findAlternative:
        return 'Find Alternative';
      case ActionType.createPromotion:
        return 'Create Promotion';
      case ActionType.requestTransfer:
        return 'Request Transfer';
      case ActionType.updateForecast:
        return 'Update Forecast';
      case ActionType.escalateIssue:
        return 'Escalate Issue';
      case ActionType.trackShipment:
        return 'Track Shipment';
      case ActionType.qualityCheck:
        return 'Quality Check';
      case ActionType.negotiateTerms:
        return 'Negotiate Terms';
    }
  }

  SmartAction copyWith({
    String? id,
    String? koreanLabel,
    String? description,
    ActionType? type,
    UserRole? requiredRole,
    double? successProbability,
    int? estimatedTimeHours,
    double? cost,
    ActionPriority? priority,
    IconData? icon,
    Color? color,
  }) {
    return SmartAction(
      id: id ?? this.id,
      koreanLabel: koreanLabel ?? this.koreanLabel,
      description: description ?? this.description,
      type: type ?? this.type,
      requiredRole: requiredRole ?? this.requiredRole,
      successProbability: successProbability ?? this.successProbability,
      estimatedTimeHours: estimatedTimeHours ?? this.estimatedTimeHours,
      cost: cost ?? this.cost,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}

// Action Types
enum ActionType {
  contactSupplier('공급업체 연락'),
  expediteOrder('긴급 주문'),
  findAlternative('대체 공급처'),
  createPromotion('프로모션 생성'),
  requestTransfer('매장간 이동'),
  updateForecast('수요 예측 갱신'),
  escalateIssue('문제 에스컬레이션'),
  trackShipment('배송 추적'),
  qualityCheck('품질 검사'),
  negotiateTerms('조건 재협상');

  const ActionType(this.koreanLabel);
  final String koreanLabel;
}

// User Roles
enum UserRole {
  ceo('CEO'),
  purchasingManager('구매 담당자'),
  storeManager('매장 관리자'),
  analyst('분석가');

  const UserRole(this.koreanLabel);
  final String koreanLabel;
}

// Action Priority
enum ActionPriority {
  immediate('즉시'),
  urgent('긴급'),
  scheduled('예정'),
  monitor('모니터링');

  const ActionPriority(this.koreanLabel);
  final String koreanLabel;
}

// Collaboration Information
class CollaborationInfo {
  final String? assignedUserId;
  final String? assignedUserName;
  final List<String> watcherIds;
  final int commentCount;
  final DateTime? lastActionDate;
  final String? status;

  const CollaborationInfo({
    this.assignedUserId,
    this.assignedUserName,
    required this.watcherIds,
    required this.commentCount,
    this.lastActionDate,
    this.status,
  });

  CollaborationInfo copyWith({
    String? assignedUserId,
    String? assignedUserName,
    List<String>? watcherIds,
    int? commentCount,
    DateTime? lastActionDate,
    String? status,
  }) {
    return CollaborationInfo(
      assignedUserId: assignedUserId ?? this.assignedUserId,
      assignedUserName: assignedUserName ?? this.assignedUserName,
      watcherIds: watcherIds ?? this.watcherIds,
      commentCount: commentCount ?? this.commentCount,
      lastActionDate: lastActionDate ?? this.lastActionDate,
      status: status ?? this.status,
    );
  }
}

// Health Score Model
class SupplyChainHealth {
  final double currentScore;
  final HealthTrend trend;
  final double changePercent;
  final double benchmarkScore;
  final List<HealthMetric> metrics;
  final DateTime lastUpdated;

  const SupplyChainHealth({
    required this.currentScore,
    required this.trend,
    required this.changePercent,
    required this.benchmarkScore,
    required this.metrics,
    required this.lastUpdated,
  });

  Color get scoreColor {
    if (currentScore >= 85) return TossColors.success;
    if (currentScore >= 70) return TossColors.warning;
    if (currentScore >= 50) return TossColors.warning;
    return TossColors.error;
  }

  String get scoreLabel {
    if (currentScore >= 85) return 'Excellent';
    if (currentScore >= 70) return 'Good';
    if (currentScore >= 50) return 'Caution';
    return 'Critical';
  }

  SupplyChainHealth copyWith({
    double? currentScore,
    HealthTrend? trend,
    double? changePercent,
    double? benchmarkScore,
    List<HealthMetric>? metrics,
    DateTime? lastUpdated,
  }) {
    return SupplyChainHealth(
      currentScore: currentScore ?? this.currentScore,
      trend: trend ?? this.trend,
      changePercent: changePercent ?? this.changePercent,
      benchmarkScore: benchmarkScore ?? this.benchmarkScore,
      metrics: metrics ?? this.metrics,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Health Trend
enum HealthTrend {
  improving('개선'),
  stable('안정'),
  declining('악화');

  const HealthTrend(this.koreanLabel);
  final String koreanLabel;

  IconData get icon {
    switch (this) {
      case HealthTrend.improving:
        return Icons.trending_up;
      case HealthTrend.stable:
        return Icons.trending_flat;
      case HealthTrend.declining:
        return Icons.trending_down;
    }
  }

  Color get color {
    switch (this) {
      case HealthTrend.improving:
        return TossColors.success;
      case HealthTrend.stable:
        return TossColors.primary;
      case HealthTrend.declining:
        return TossColors.error;
    }
  }
}

// Health Metrics
class HealthMetric {
  final String name;
  final String koreanLabel;
  final double value;
  final double target;
  final HealthTrend trend;
  final String unit;

  const HealthMetric({
    required this.name,
    required this.koreanLabel,
    required this.value,
    required this.target,
    required this.trend,
    required this.unit,
  });

  double get performanceRatio => value / target;
  bool get isOnTarget => performanceRatio >= 0.95;

  HealthMetric copyWith({
    String? name,
    String? koreanLabel,
    double? value,
    double? target,
    HealthTrend? trend,
    String? unit,
  }) {
    return HealthMetric(
      name: name ?? this.name,
      koreanLabel: koreanLabel ?? this.koreanLabel,
      value: value ?? this.value,
      target: target ?? this.target,
      trend: trend ?? this.trend,
      unit: unit ?? this.unit,
    );
  }
}

// KPI Summary Model
class SupplyChainKPI {
  final KPIType type;
  final String koreanLabel;
  final String value;
  final String? previousValue;
  final KPITrend trend;
  final Color color;
  final IconData icon;
  final String? description;

  const SupplyChainKPI({
    required this.type,
    required this.koreanLabel,
    required this.value,
    this.previousValue,
    required this.trend,
    required this.color,
    required this.icon,
    this.description,
  });

  String get englishLabel {
    switch (type) {
      case KPIType.critical:
        return 'Critical Issues';
      case KPIType.warning:
        return 'Warning Items';
      case KPIType.normal:
        return 'Normal Operations';
      case KPIType.valueAtRisk:
        return 'Value at Risk';
    }
  }

  SupplyChainKPI copyWith({
    KPIType? type,
    String? koreanLabel,
    String? value,
    String? previousValue,
    KPITrend? trend,
    Color? color,
    IconData? icon,
    String? description,
  }) {
    return SupplyChainKPI(
      type: type ?? this.type,
      koreanLabel: koreanLabel ?? this.koreanLabel,
      value: value ?? this.value,
      previousValue: previousValue ?? this.previousValue,
      trend: trend ?? this.trend,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      description: description ?? this.description,
    );
  }
}

// KPI Types
enum KPIType {
  critical('긴급'),
  warning('주의'),
  normal('정상'),
  valueAtRisk('위험금액');

  const KPIType(this.koreanLabel);
  final String koreanLabel;
}

// KPI Trend
enum KPITrend {
  up('증가'),
  down('감소'),
  stable('안정');

  const KPITrend(this.koreanLabel);
  final String koreanLabel;
}

// Integral Value Data Point
class IntegralDataPoint {
  final DateTime date;
  final double orderValue;
  final double shipValue;
  final double receiveValue;
  final double saleValue;
  final double totalIntegral;
  final double financialImpact;

  const IntegralDataPoint({
    required this.date,
    required this.orderValue,
    required this.shipValue,
    required this.receiveValue,
    required this.saleValue,
    required this.totalIntegral,
    required this.financialImpact,
  });

  IntegralDataPoint copyWith({
    DateTime? date,
    double? orderValue,
    double? shipValue,
    double? receiveValue,
    double? saleValue,
    double? totalIntegral,
    double? financialImpact,
  }) {
    return IntegralDataPoint(
      date: date ?? this.date,
      orderValue: orderValue ?? this.orderValue,
      shipValue: shipValue ?? this.shipValue,
      receiveValue: receiveValue ?? this.receiveValue,
      saleValue: saleValue ?? this.saleValue,
      totalIntegral: totalIntegral ?? this.totalIntegral,
      financialImpact: financialImpact ?? this.financialImpact,
    );
  }
}

// Stage Performance Data
class StagePerformance {
  final SupplyChainStage stage;
  final String koreanLabel;
  final int totalProblems;
  final double avgResolutionTime;
  final double financialImpact;
  final HealthTrend trend;
  final List<SupplyChainProblem> topProblems;

  const StagePerformance({
    required this.stage,
    required this.koreanLabel,
    required this.totalProblems,
    required this.avgResolutionTime,
    required this.financialImpact,
    required this.trend,
    required this.topProblems,
  });

  StagePerformance copyWith({
    SupplyChainStage? stage,
    String? koreanLabel,
    int? totalProblems,
    double? avgResolutionTime,
    double? financialImpact,
    HealthTrend? trend,
    List<SupplyChainProblem>? topProblems,
  }) {
    return StagePerformance(
      stage: stage ?? this.stage,
      koreanLabel: koreanLabel ?? this.koreanLabel,
      totalProblems: totalProblems ?? this.totalProblems,
      avgResolutionTime: avgResolutionTime ?? this.avgResolutionTime,
      financialImpact: financialImpact ?? this.financialImpact,
      trend: trend ?? this.trend,
      topProblems: topProblems ?? this.topProblems,
    );
  }
}

// Filter Configuration
class SupplyChainFilters {
  final DateRange timeRange;
  final List<String> storeIds;
  final List<String> productCategories;
  final List<String> supplierIds;
  final List<ProblemSeverity> severityLevels;
  final List<SupplyChainStage> stages;

  const SupplyChainFilters({
    required this.timeRange,
    required this.storeIds,
    required this.productCategories,
    required this.supplierIds,
    required this.severityLevels,
    required this.stages,
  });

  bool get hasActiveFilters =>
      storeIds.isNotEmpty ||
      productCategories.isNotEmpty ||
      supplierIds.isNotEmpty ||
      severityLevels.length < ProblemSeverity.values.length ||
      stages.length < SupplyChainStage.values.length;

  SupplyChainFilters copyWith({
    DateRange? timeRange,
    List<String>? storeIds,
    List<String>? productCategories,
    List<String>? supplierIds,
    List<ProblemSeverity>? severityLevels,
    List<SupplyChainStage>? stages,
  }) {
    return SupplyChainFilters(
      timeRange: timeRange ?? this.timeRange,
      storeIds: storeIds ?? this.storeIds,
      productCategories: productCategories ?? this.productCategories,
      supplierIds: supplierIds ?? this.supplierIds,
      severityLevels: severityLevels ?? this.severityLevels,
      stages: stages ?? this.stages,
    );
  }
}

// Date Range
class DateRange {
  final DateTime start;
  final DateTime end;
  final String koreanLabel;

  const DateRange({
    required this.start,
    required this.end,
    required this.koreanLabel,
  });

  int get daysDifference => end.difference(start).inDays;
  
  String get englishLabel => koreanLabel; // For now, assume koreanLabel contains English text

  DateRange copyWith({
    DateTime? start,
    DateTime? end,
    String? koreanLabel,
  }) {
    return DateRange(
      start: start ?? this.start,
      end: end ?? this.end,
      koreanLabel: koreanLabel ?? this.koreanLabel,
    );
  }
}

// Problem Severity
enum ProblemSeverity {
  critical('긴급'),
  warning('주의'), 
  normal('정상');

  const ProblemSeverity(this.koreanLabel);
  final String koreanLabel;

  Color get color {
    switch (this) {
      case ProblemSeverity.critical:
        return TossColors.error;
      case ProblemSeverity.warning:
        return TossColors.warning;
      case ProblemSeverity.normal:
        return TossColors.success;
    }
  }

  IconData get icon {
    switch (this) {
      case ProblemSeverity.critical:
        return Icons.error;
      case ProblemSeverity.warning:
        return Icons.warning;
      case ProblemSeverity.normal:
        return Icons.check_circle;
    }
  }
}

// User Persona Configuration
class UserPersona {
  final UserRole role;
  final String koreanLabel;
  final List<KPIType> priorityKPIs;
  final List<ActionType> primaryActions;
  final Color themeColor;
  final int updateFrequencyMinutes;

  const UserPersona({
    required this.role,
    required this.koreanLabel,
    required this.priorityKPIs,
    required this.primaryActions,
    required this.themeColor,
    required this.updateFrequencyMinutes,
  });

  UserPersona copyWith({
    UserRole? role,
    String? koreanLabel,
    List<KPIType>? priorityKPIs,
    List<ActionType>? primaryActions,
    Color? themeColor,
    int? updateFrequencyMinutes,
  }) {
    return UserPersona(
      role: role ?? this.role,
      koreanLabel: koreanLabel ?? this.koreanLabel,
      priorityKPIs: priorityKPIs ?? this.priorityKPIs,
      primaryActions: primaryActions ?? this.primaryActions,
      themeColor: themeColor ?? this.themeColor,
      updateFrequencyMinutes: updateFrequencyMinutes ?? this.updateFrequencyMinutes,
    );
  }
}

// Supply Chain Analytics Dashboard State
class SupplyChainDashboardState {
  final SupplyChainHealth health;
  final List<SupplyChainKPI> kpis;
  final List<SupplyChainProblem> priorityProblems;
  final List<IntegralDataPoint> integralData;
  final List<StagePerformance> stagePerformance;
  final SupplyChainFilters filters;
  final UserPersona userPersona;
  final bool isLoading;
  final String? error;
  final DateTime lastRefresh;

  const SupplyChainDashboardState({
    required this.health,
    required this.kpis,
    required this.priorityProblems,
    required this.integralData,
    required this.stagePerformance,
    required this.filters,
    required this.userPersona,
    required this.isLoading,
    this.error,
    required this.lastRefresh,
  });

  SupplyChainDashboardState copyWith({
    SupplyChainHealth? health,
    List<SupplyChainKPI>? kpis,
    List<SupplyChainProblem>? priorityProblems,
    List<IntegralDataPoint>? integralData,
    List<StagePerformance>? stagePerformance,
    SupplyChainFilters? filters,
    UserPersona? userPersona,
    bool? isLoading,
    String? error,
    DateTime? lastRefresh,
  }) {
    return SupplyChainDashboardState(
      health: health ?? this.health,
      kpis: kpis ?? this.kpis,
      priorityProblems: priorityProblems ?? this.priorityProblems,
      integralData: integralData ?? this.integralData,
      stagePerformance: stagePerformance ?? this.stagePerformance,
      filters: filters ?? this.filters,
      userPersona: userPersona ?? this.userPersona,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastRefresh: lastRefresh ?? this.lastRefresh,
    );
  }
}