import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_summary.freezed.dart';

/// 카테고리 요약 Entity
/// 카테고리별 재고 현황
@freezed
class CategorySummary with _$CategorySummary {
  const CategorySummary._();

  const factory CategorySummary({
    /// 카테고리 ID
    required String categoryId,

    /// 카테고리 이름
    required String categoryName,

    /// 전체 상품 수
    required int totalProducts,

    /// 재주문 필요 수
    required int reorderNeededCount,

    /// 긴급 수
    required int criticalCount,

    /// 주의 수
    required int warningCount,

    /// 품절 수
    required int stockoutCount,

    /// 과잉 수
    required int overstockCount,

    /// Dead Stock 수
    required int deadStockCount,

    /// 비정상 수
    required int abnormalCount,
  }) = _CategorySummary;

  /// 재주문 비율 (%)
  double get reorderRate =>
      totalProducts > 0 ? (reorderNeededCount / totalProducts) * 100 : 0;

  /// 액션 필요 총 수
  int get actionNeededCount =>
      abnormalCount + stockoutCount + criticalCount + warningCount;

  /// 카테고리 상태 (긴급 여부)
  bool get hasUrgentItems => abnormalCount > 0 || criticalCount > 0;

  /// Mock 데이터 (스켈레톤용)
  static CategorySummary mock() => const CategorySummary(
        categoryId: 'mock-id',
        categoryName: 'Category',
        totalProducts: 0,
        reorderNeededCount: 0,
        criticalCount: 0,
        warningCount: 0,
        stockoutCount: 0,
        overstockCount: 0,
        deadStockCount: 0,
        abnormalCount: 0,
      );

  static List<CategorySummary> mockList([int count = 5]) =>
      List.generate(count, (_) => mock());
}
