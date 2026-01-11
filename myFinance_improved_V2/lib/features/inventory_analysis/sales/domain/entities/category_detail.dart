import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_detail.freezed.dart';

/// Top 브랜드 정보
@freezed
class TopBrand with _$TopBrand {
  const factory TopBrand({
    required String brandId,
    required String brandName,
    required num revenue,
    required num marginRatePct,
    required int quantity,
  }) = _TopBrand;
}

/// 문제 제품 정보 (재고 부족 등)
@freezed
class ProblemProduct with _$ProblemProduct {
  const ProblemProduct._();

  const factory ProblemProduct({
    required String productId,
    required String productName,
    required int currentStock,
    required num reorderPoint,
    required num? marginChange, // 전월 대비 마진 변화
    required String issueType, // 'low_stock', 'margin_drop'
  }) = _ProblemProduct;

  String get issueLabel {
    return switch (issueType) {
      'low_stock' => 'Low Stock',
      'margin_drop' => 'Margin Drop',
      _ => 'Needs Attention',
    };
  }
}

/// 카테고리 상세 데이터
/// RPC: get_category_detail 응답
@freezed
class CategoryDetail with _$CategoryDetail {
  const CategoryDetail._();

  const factory CategoryDetail({
    required String categoryId,
    required String categoryName,
    required num totalRevenue,
    required num totalMargin,
    required num marginRatePct,
    required int totalQuantity,
    required num? growthPct, // 전월 대비 성장률
    required List<TopBrand> topBrands,
    required List<ProblemProduct> problemProducts,
  }) = _CategoryDetail;

  /// 문제 있는지 여부
  bool get hasProblems => problemProducts.isNotEmpty;

  /// 재고 부족 제품 수
  int get lowStockCount =>
      problemProducts.where((p) => p.issueType == 'low_stock').length;

  /// 마진 하락 제품 수
  int get marginDropCount =>
      problemProducts.where((p) => p.issueType == 'margin_drop').length;
}
