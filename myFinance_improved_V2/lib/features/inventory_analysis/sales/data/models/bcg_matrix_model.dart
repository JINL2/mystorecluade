import '../../domain/entities/bcg_category.dart';

/// BCG Matrix category Model
/// RPC response fields: category_id, category_name, total_revenue, margin_rate_pct,
/// total_quantity, revenue_pct, quadrant
class BcgCategoryModel {
  final String categoryId;
  final String categoryName;
  final num totalRevenue;
  final num marginRatePct;
  final int totalQuantity;
  final num revenuePct;
  final String quadrant;

  BcgCategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalRevenue,
    required this.marginRatePct,
    required this.totalQuantity,
    required this.revenuePct,
    required this.quadrant,
  });

  factory BcgCategoryModel.fromJson(Map<String, dynamic> json) {
    return BcgCategoryModel(
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      totalRevenue: json['total_revenue'] as num? ?? 0,
      marginRatePct: json['margin_rate_pct'] as num? ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      revenuePct: json['revenue_pct'] as num? ?? 0,
      quadrant: json['quadrant'] as String? ?? 'dog',
    );
  }

  BcgCategory toEntity() {
    return BcgCategory(
      categoryId: categoryId,
      categoryName: categoryName,
      totalRevenue: totalRevenue,
      marginRatePct: marginRatePct,
      totalQuantity: totalQuantity,
      revenuePct: revenuePct,
      // Use revenuePct for percentile (approximate, RPC doesn't return raw percentiles)
      salesVolumePercentile: revenuePct,
      marginPercentile: marginRatePct,
      // Keep quadrant as lowercase (matches RPC response: 'star', 'cash_cow', etc.)
      quadrant: quadrant.toLowerCase(),
    );
  }
}

/// BCG Matrix full response parsing
/// RPC response structure: { "star": [...], "cash_cow": [...], "problem_child": [...], "dog": [...] }
class BcgMatrixModel {
  final List<BcgCategoryModel> categories;

  BcgMatrixModel({required this.categories});

  /// Parse JSON from RPC response
  /// Handles: { "star": [...], "cash_cow": [...], "problem_child": [...], "dog": [...] }
  factory BcgMatrixModel.fromJson(Map<String, dynamic> json) {
    final List<BcgCategoryModel> allCategories = [];

    // Parse each quadrant
    final quadrants = ['star', 'cash_cow', 'problem_child', 'dog'];
    for (final quadrant in quadrants) {
      final quadrantData = json[quadrant] as List<dynamic>?;
      if (quadrantData != null) {
        for (final item in quadrantData) {
          if (item is Map<String, dynamic>) {
            allCategories.add(BcgCategoryModel.fromJson(item));
          }
        }
      }
    }

    return BcgMatrixModel(categories: allCategories);
  }

  BcgMatrix toEntity() => BcgMatrix(
        categories: categories.map((c) => c.toEntity()).toList(),
      );
}
