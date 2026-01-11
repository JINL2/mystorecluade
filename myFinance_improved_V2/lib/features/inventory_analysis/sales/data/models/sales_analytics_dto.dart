import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/sales_analytics.dart';

part 'sales_analytics_dto.g.dart';

/// Analytics data point DTO
@JsonSerializable()
class AnalyticsDataPointDto {
  final String period;
  @JsonKey(name: 'dimension_id')
  final String? dimensionId;
  @JsonKey(name: 'dimension_name')
  final String? dimensionName;
  @JsonKey(name: 'total_quantity')
  final num? totalQuantity;
  @JsonKey(name: 'total_revenue')
  final num? totalRevenue;
  @JsonKey(name: 'total_margin')
  final num? totalMargin;
  @JsonKey(name: 'margin_rate')
  final num? marginRate;
  @JsonKey(name: 'invoice_count')
  final num? invoiceCount;
  @JsonKey(name: 'revenue_growth')
  final num? revenueGrowth;
  @JsonKey(name: 'quantity_growth')
  final num? quantityGrowth;
  @JsonKey(name: 'margin_growth')
  final num? marginGrowth;

  AnalyticsDataPointDto({
    required this.period,
    this.dimensionId,
    this.dimensionName,
    this.totalQuantity,
    this.totalRevenue,
    this.totalMargin,
    this.marginRate,
    this.invoiceCount,
    this.revenueGrowth,
    this.quantityGrowth,
    this.marginGrowth,
  });

  factory AnalyticsDataPointDto.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataPointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsDataPointDtoToJson(this);

  AnalyticsDataPoint toEntity() => AnalyticsDataPoint(
        period: DateTime.parse(period),
        dimensionId: dimensionId ?? '',
        dimensionName: dimensionName ?? '',
        totalQuantity: totalQuantity?.toDouble() ?? 0,
        totalRevenue: totalRevenue?.toDouble() ?? 0,
        totalMargin: totalMargin?.toDouble() ?? 0,
        marginRate: marginRate?.toDouble() ?? 0,
        invoiceCount: invoiceCount?.toInt() ?? 0,
        revenueGrowth: revenueGrowth?.toDouble(),
        quantityGrowth: quantityGrowth?.toDouble(),
        marginGrowth: marginGrowth?.toDouble(),
      );
}

/// Analytics summary DTO
@JsonSerializable()
class AnalyticsSummaryDto {
  @JsonKey(name: 'total_revenue')
  final num? totalRevenue;
  @JsonKey(name: 'total_quantity')
  final num? totalQuantity;
  @JsonKey(name: 'total_margin')
  final num? totalMargin;
  @JsonKey(name: 'avg_margin_rate')
  final num? avgMarginRate;
  @JsonKey(name: 'record_count')
  final num? recordCount;

  AnalyticsSummaryDto({
    this.totalRevenue,
    this.totalQuantity,
    this.totalMargin,
    this.avgMarginRate,
    this.recordCount,
  });

  factory AnalyticsSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsSummaryDtoToJson(this);

  AnalyticsSummary toEntity() => AnalyticsSummary(
        totalRevenue: totalRevenue?.toDouble() ?? 0,
        totalQuantity: totalQuantity?.toDouble() ?? 0,
        totalMargin: totalMargin?.toDouble() ?? 0,
        avgMarginRate: avgMarginRate?.toDouble() ?? 0,
        recordCount: recordCount?.toInt() ?? 0,
      );
}

/// Complete analytics response DTO
@JsonSerializable()
class SalesAnalyticsResponseDto {
  final bool? success;
  final Map<String, dynamic>? summary;
  final List<dynamic>? data;
  final String? error;

  SalesAnalyticsResponseDto({
    this.success,
    this.summary,
    this.data,
    this.error,
  });

  factory SalesAnalyticsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SalesAnalyticsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SalesAnalyticsResponseDtoToJson(this);

  SalesAnalyticsResponse toEntity() {
    if (success != true) {
      return SalesAnalyticsResponse(
        success: false,
        summary: const AnalyticsSummary(
          totalRevenue: 0,
          totalQuantity: 0,
          totalMargin: 0,
          avgMarginRate: 0,
          recordCount: 0,
        ),
        data: [],
        error: error,
      );
    }

    // Parse data and sort by period ascending for proper time series display
    final dataList = data
            ?.map((e) =>
                AnalyticsDataPointDto.fromJson(e as Map<String, dynamic>)
                    .toEntity())
            .toList() ??
        [];
    // Sort by period ascending (chronological order for time series charts)
    dataList.sort((a, b) => a.period.compareTo(b.period));

    return SalesAnalyticsResponse(
      success: true,
      summary: summary != null
          ? AnalyticsSummaryDto.fromJson(summary!).toEntity()
          : const AnalyticsSummary(
              totalRevenue: 0,
              totalQuantity: 0,
              totalMargin: 0,
              avgMarginRate: 0,
              recordCount: 0,
            ),
      data: dataList,
    );
  }
}

/// Drill-down item DTO
@JsonSerializable()
class DrillDownItemDto {
  final String? id;
  final String? name;
  @JsonKey(name: 'total_quantity')
  final num? totalQuantity;
  @JsonKey(name: 'total_revenue')
  final num? totalRevenue;
  @JsonKey(name: 'total_margin')
  final num? totalMargin;
  @JsonKey(name: 'margin_rate')
  final num? marginRate;
  @JsonKey(name: 'product_count')
  final num? productCount;
  @JsonKey(name: 'brand_count')
  final num? brandCount;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @JsonKey(name: 'category_name')
  final String? categoryName;
  @JsonKey(name: 'brand_id')
  final String? brandId;
  @JsonKey(name: 'brand_name')
  final String? brandName;

  DrillDownItemDto({
    this.id,
    this.name,
    this.totalQuantity,
    this.totalRevenue,
    this.totalMargin,
    this.marginRate,
    this.productCount,
    this.brandCount,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
  });

  factory DrillDownItemDto.fromJson(Map<String, dynamic> json) =>
      _$DrillDownItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DrillDownItemDtoToJson(this);

  DrillDownItem toEntity() => DrillDownItem(
        id: id ?? '',
        name: name ?? '',
        totalQuantity: totalQuantity?.toDouble() ?? 0,
        totalRevenue: totalRevenue?.toDouble() ?? 0,
        totalMargin: totalMargin?.toDouble() ?? 0,
        marginRate: marginRate?.toDouble() ?? 0,
        productCount: productCount?.toInt(),
        brandCount: brandCount?.toInt(),
        categoryId: categoryId,
        categoryName: categoryName,
        brandId: brandId,
        brandName: brandName,
      );
}

/// Drill-down response DTO
@JsonSerializable()
class DrillDownResponseDto {
  final bool? success;
  final String? level;
  @JsonKey(name: 'parent_id')
  final String? parentId;
  final List<dynamic>? data;
  final String? error;

  DrillDownResponseDto({
    this.success,
    this.level,
    this.parentId,
    this.data,
    this.error,
  });

  factory DrillDownResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DrillDownResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DrillDownResponseDtoToJson(this);

  DrillDownResponse toEntity() {
    if (success != true) {
      return DrillDownResponse(
        success: false,
        level: level ?? 'category',
        data: [],
        error: error,
      );
    }

    return DrillDownResponse(
      success: true,
      level: level ?? 'category',
      parentId: parentId,
      data: data
              ?.map((e) =>
                  DrillDownItemDto.fromJson(e as Map<String, dynamic>)
                      .toEntity())
              .toList() ??
          [],
    );
  }
}
