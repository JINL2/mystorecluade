import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/category_detail.dart';

part 'category_detail_model.g.dart';

/// Top 브랜드 Model
@JsonSerializable(fieldRename: FieldRename.snake)
class TopBrandModel {
  @JsonKey(name: 'brand_id')
  final String brandId;
  @JsonKey(name: 'brand_name')
  final String brandName;
  final num revenue;
  @JsonKey(name: 'avg_margin_rate')
  final num marginRatePct;
  final int quantity;

  TopBrandModel({
    required this.brandId,
    required this.brandName,
    required this.revenue,
    required this.marginRatePct,
    required this.quantity,
  });

  factory TopBrandModel.fromJson(Map<String, dynamic> json) =>
      _$TopBrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopBrandModelToJson(this);

  TopBrand toEntity() => TopBrand(
        brandId: brandId,
        brandName: brandName,
        revenue: revenue,
        marginRatePct: marginRatePct,
        quantity: quantity,
      );
}

/// 문제 제품 Model
@JsonSerializable(fieldRename: FieldRename.snake)
class ProblemProductModel {
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'current_stock')
  final int currentStock;
  @JsonKey(name: 'reorder_point')
  final num reorderPoint;
  @JsonKey(name: 'margin_change')
  final num? marginChange;
  @JsonKey(name: 'issue_type')
  final String issueType;

  ProblemProductModel({
    required this.productId,
    required this.productName,
    required this.currentStock,
    required this.reorderPoint,
    this.marginChange,
    required this.issueType,
  });

  factory ProblemProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProblemProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemProductModelToJson(this);

  ProblemProduct toEntity() => ProblemProduct(
        productId: productId,
        productName: productName,
        currentStock: currentStock,
        reorderPoint: reorderPoint,
        marginChange: marginChange,
        issueType: issueType,
      );
}

/// 카테고리 상세 Model
/// RPC: get_category_detail 응답 파싱
@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryDetailModel {
  final CategorySummaryModel summary;
  @JsonKey(name: 'top_brands')
  final List<TopBrandModel> topBrands;
  @JsonKey(name: 'problem_products')
  final List<ProblemProductModel> problemProducts;

  CategoryDetailModel({
    required this.summary,
    required this.topBrands,
    required this.problemProducts,
  });

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDetailModelToJson(this);

  CategoryDetail toEntity() => CategoryDetail(
        categoryId: summary.categoryId,
        categoryName: summary.categoryName,
        totalRevenue: summary.totalRevenue,
        totalMargin: summary.totalMargin,
        marginRatePct: summary.marginRatePct,
        totalQuantity: summary.totalQuantity,
        growthPct: summary.growthPct,
        topBrands: topBrands.map((b) => b.toEntity()).toList(),
        problemProducts: problemProducts.map((p) => p.toEntity()).toList(),
      );
}

/// 카테고리 요약 Model
@JsonSerializable(fieldRename: FieldRename.snake)
class CategorySummaryModel {
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(name: 'total_revenue')
  final num totalRevenue;
  @JsonKey(name: 'total_margin')
  final num totalMargin;
  @JsonKey(name: 'margin_rate_pct')
  final num marginRatePct;
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  @JsonKey(name: 'growth_pct')
  final num? growthPct;

  CategorySummaryModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalRevenue,
    required this.totalMargin,
    required this.marginRatePct,
    required this.totalQuantity,
    this.growthPct,
  });

  factory CategorySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySummaryModelToJson(this);
}
