import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/bcg_category.dart';

part 'bcg_matrix_model.g.dart';

/// BCG Matrix 카테고리 Model
@JsonSerializable(fieldRename: FieldRename.snake)
class BcgCategoryModel {
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(name: 'total_revenue')
  final num totalRevenue;
  @JsonKey(name: 'margin_rate_pct')
  final num marginRatePct;
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  @JsonKey(name: 'sales_volume_percentile')
  final num salesVolumePercentile;
  @JsonKey(name: 'margin_percentile')
  final num marginPercentile;
  @JsonKey(name: 'strategy_quadrant')
  final String quadrant;

  BcgCategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalRevenue,
    required this.marginRatePct,
    required this.totalQuantity,
    required this.salesVolumePercentile,
    required this.marginPercentile,
    required this.quadrant,
  });

  factory BcgCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$BcgCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BcgCategoryModelToJson(this);

  BcgCategory toEntity() => BcgCategory(
        categoryId: categoryId,
        categoryName: categoryName,
        totalRevenue: totalRevenue,
        marginRatePct: marginRatePct,
        totalQuantity: totalQuantity,
        salesVolumePercentile: salesVolumePercentile,
        marginPercentile: marginPercentile,
        quadrant: quadrant,
      );
}

/// BCG Matrix 전체 응답 파싱
class BcgMatrixModel {
  final List<BcgCategoryModel> categories;

  BcgMatrixModel({required this.categories});

  /// Map<String, dynamic> 형태의 JSON 파싱
  /// RPC 응답 구조: { "categories": [...] } 또는 직접 배열
  factory BcgMatrixModel.fromJson(Map<String, dynamic> json) {
    final categoriesData = json['categories'] as List<dynamic>?;
    if (categoriesData != null) {
      return BcgMatrixModel(
        categories: categoriesData
            .map((item) =>
                BcgCategoryModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    }
    // 직접 배열로 오는 경우 빈 리스트 반환
    return BcgMatrixModel(categories: []);
  }

  /// List<dynamic> 형태의 JSON 파싱 (배열 직접 응답용)
  factory BcgMatrixModel.fromJsonList(List<dynamic> jsonList) {
    return BcgMatrixModel(
      categories: jsonList
          .map((json) => BcgCategoryModel.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  BcgMatrix toEntity() => BcgMatrix(
        categories: categories.map((c) => c.toEntity()).toList(),
      );
}
