import '../../domain/entities/category_summary.dart';

/// CategorySummary DTO
/// RPC 응답에서 변환
class CategorySummaryDto {
  final String categoryId;
  final String categoryName;
  final int totalProducts;
  final int reorderNeededCount;
  final int criticalCount;
  final int warningCount;
  final int stockoutCount;
  final int overstockCount;
  final int deadStockCount;
  final int abnormalCount;

  const CategorySummaryDto({
    required this.categoryId,
    required this.categoryName,
    required this.totalProducts,
    required this.reorderNeededCount,
    required this.criticalCount,
    required this.warningCount,
    required this.stockoutCount,
    required this.overstockCount,
    required this.deadStockCount,
    required this.abnormalCount,
  });

  factory CategorySummaryDto.fromJson(Map<String, dynamic> json) {
    return CategorySummaryDto(
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? 'Unknown',
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      reorderNeededCount: (json['reorder_needed_count'] as num?)?.toInt() ?? 0,
      criticalCount: (json['critical_count'] as num?)?.toInt() ?? 0,
      warningCount: (json['warning_count'] as num?)?.toInt() ?? 0,
      stockoutCount: (json['stockout_count'] as num?)?.toInt() ?? 0,
      overstockCount: (json['overstock_count'] as num?)?.toInt() ?? 0,
      deadStockCount: (json['dead_stock_count'] as num?)?.toInt() ?? 0,
      abnormalCount: (json['abnormal_count'] as num?)?.toInt() ?? 0,
    );
  }

  CategorySummary toEntity() {
    return CategorySummary(
      categoryId: categoryId,
      categoryName: categoryName,
      totalProducts: totalProducts,
      reorderNeededCount: reorderNeededCount,
      criticalCount: criticalCount,
      warningCount: warningCount,
      stockoutCount: stockoutCount,
      overstockCount: overstockCount,
      deadStockCount: deadStockCount,
      abnormalCount: abnormalCount,
    );
  }
}
