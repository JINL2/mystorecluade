import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/sales_dashboard.dart';

part 'sales_dashboard_model.g.dart';

/// 월별 매출 데이터 Model
@JsonSerializable(fieldRename: FieldRename.snake)
class MonthlyMetricsModel {
  final num revenue;
  final num margin;
  @JsonKey(name: 'margin_rate')
  final num marginRate;
  final int quantity;

  MonthlyMetricsModel({
    required this.revenue,
    required this.margin,
    required this.marginRate,
    required this.quantity,
  });

  factory MonthlyMetricsModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyMetricsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyMetricsModelToJson(this);

  MonthlyMetrics toEntity() => MonthlyMetrics(
        revenue: revenue,
        margin: margin,
        marginRate: marginRate,
        quantity: quantity,
      );
}

/// 성장률 데이터 Model
@JsonSerializable(fieldRename: FieldRename.snake)
class GrowthMetricsModel {
  @JsonKey(name: 'revenue_pct')
  final num revenuePct;
  @JsonKey(name: 'margin_pct')
  final num marginPct;
  @JsonKey(name: 'quantity_pct')
  final num quantityPct;

  GrowthMetricsModel({
    required this.revenuePct,
    required this.marginPct,
    required this.quantityPct,
  });

  factory GrowthMetricsModel.fromJson(Map<String, dynamic> json) =>
      _$GrowthMetricsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GrowthMetricsModelToJson(this);

  GrowthMetrics toEntity() => GrowthMetrics(
        revenuePct: revenuePct,
        marginPct: marginPct,
        quantityPct: quantityPct,
      );
}

/// 수익률 대시보드 Model
/// RPC: inventory_analysis_get_sales_dashboard 응답 파싱
@JsonSerializable(fieldRename: FieldRename.snake)
class SalesDashboardModel {
  @JsonKey(name: 'this_month')
  final MonthlyMetricsModel thisMonth;
  @JsonKey(name: 'last_month')
  final MonthlyMetricsModel lastMonth;
  final GrowthMetricsModel growth;

  SalesDashboardModel({
    required this.thisMonth,
    required this.lastMonth,
    required this.growth,
  });

  factory SalesDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$SalesDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesDashboardModelToJson(this);

  SalesDashboard toEntity() => SalesDashboard(
        thisMonth: thisMonth.toEntity(),
        lastMonth: lastMonth.toEntity(),
        growth: growth.toEntity(),
      );
}
