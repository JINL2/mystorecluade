import '../../domain/entities/inventory_health_dashboard.dart';

/// Inventory Health Dashboard DTO
/// inventory_analysis_get_inventory_health_dashboard RPC 응답에서 변환
class InventoryHealthDashboardDto {
  final HealthSummaryDto summary;
  final List<HealthCategoryDto> categories;
  final List<HealthProductDto> urgentProducts;
  final List<HealthProductDto> normalProducts;
  final List<OverstockProductDto> overstockProducts;
  final List<RecountProductDto> recountProducts;

  const InventoryHealthDashboardDto({
    required this.summary,
    required this.categories,
    required this.urgentProducts,
    required this.normalProducts,
    required this.overstockProducts,
    required this.recountProducts,
  });

  factory InventoryHealthDashboardDto.fromJson(Map<String, dynamic> json) {
    // success check
    if (json['success'] != true) {
      return InventoryHealthDashboardDto.empty();
    }

    // summary 파싱
    final summaryJson = json['summary'];
    final summary = summaryJson is Map<String, dynamic>
        ? HealthSummaryDto.fromJson(summaryJson)
        : HealthSummaryDto.empty();

    // categories 파싱
    List<HealthCategoryDto> categories = [];
    final categoriesJson = json['categories'];
    if (categoriesJson is List) {
      categories = categoriesJson
          .whereType<Map<String, dynamic>>()
          .map((e) => HealthCategoryDto.fromJson(e))
          .toList();
    }

    // urgent_products 파싱
    List<HealthProductDto> urgentProducts = [];
    final urgentJson = json['urgent_products'];
    if (urgentJson is List) {
      urgentProducts = urgentJson
          .whereType<Map<String, dynamic>>()
          .map((e) => HealthProductDto.fromJson(e))
          .toList();
    }

    // normal_products 파싱
    List<HealthProductDto> normalProducts = [];
    final normalJson = json['normal_products'];
    if (normalJson is List) {
      normalProducts = normalJson
          .whereType<Map<String, dynamic>>()
          .map((e) => HealthProductDto.fromJson(e))
          .toList();
    }

    // overstock_products 파싱
    List<OverstockProductDto> overstockProducts = [];
    final overstockJson = json['overstock_products'];
    if (overstockJson is List) {
      overstockProducts = overstockJson
          .whereType<Map<String, dynamic>>()
          .map((e) => OverstockProductDto.fromJson(e))
          .toList();
    }

    // recount_products 파싱
    List<RecountProductDto> recountProducts = [];
    final recountJson = json['recount_products'];
    if (recountJson is List) {
      recountProducts = recountJson
          .whereType<Map<String, dynamic>>()
          .map((e) => RecountProductDto.fromJson(e))
          .toList();
    }

    return InventoryHealthDashboardDto(
      summary: summary,
      categories: categories,
      urgentProducts: urgentProducts,
      normalProducts: normalProducts,
      overstockProducts: overstockProducts,
      recountProducts: recountProducts,
    );
  }

  factory InventoryHealthDashboardDto.empty() => InventoryHealthDashboardDto(
        summary: HealthSummaryDto.empty(),
        categories: [],
        urgentProducts: [],
        normalProducts: [],
        overstockProducts: [],
        recountProducts: [],
      );

  InventoryHealthDashboard toEntity() {
    return InventoryHealthDashboard(
      summary: summary.toEntity(),
      categories: categories.map((e) => e.toEntity()).toList(),
      urgentProducts: urgentProducts.map((e) => e.toEntity()).toList(),
      normalProducts: normalProducts.map((e) => e.toEntity()).toList(),
      overstockProducts: overstockProducts.map((e) => e.toEntity()).toList(),
      recountProducts: recountProducts.map((e) => e.toEntity()).toList(),
    );
  }
}

/// Summary DTO
class HealthSummaryDto {
  final int totalProducts;
  final int urgentCount;
  final double urgentPct;
  final int normalCount;
  final double normalPct;
  final int sufficientCount;
  final double sufficientPct;
  final int overstockCount;
  final double overstockPct;
  final int recountCount;
  final double recountPct;
  final int totalReorderNeeded;

  const HealthSummaryDto({
    required this.totalProducts,
    required this.urgentCount,
    required this.urgentPct,
    required this.normalCount,
    required this.normalPct,
    required this.sufficientCount,
    required this.sufficientPct,
    required this.overstockCount,
    required this.overstockPct,
    required this.recountCount,
    required this.recountPct,
    required this.totalReorderNeeded,
  });

  factory HealthSummaryDto.fromJson(Map<String, dynamic> json) {
    return HealthSummaryDto(
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      urgentCount: (json['urgent_count'] as num?)?.toInt() ?? 0,
      urgentPct: (json['urgent_pct'] as num?)?.toDouble() ?? 0.0,
      normalCount: (json['normal_count'] as num?)?.toInt() ?? 0,
      normalPct: (json['normal_pct'] as num?)?.toDouble() ?? 0.0,
      sufficientCount: (json['sufficient_count'] as num?)?.toInt() ?? 0,
      sufficientPct: (json['sufficient_pct'] as num?)?.toDouble() ?? 0.0,
      overstockCount: (json['overstock_count'] as num?)?.toInt() ?? 0,
      overstockPct: (json['overstock_pct'] as num?)?.toDouble() ?? 0.0,
      recountCount: (json['recount_count'] as num?)?.toInt() ?? 0,
      recountPct: (json['recount_pct'] as num?)?.toDouble() ?? 0.0,
      totalReorderNeeded: (json['total_reorder_needed'] as num?)?.toInt() ?? 0,
    );
  }

  factory HealthSummaryDto.empty() => const HealthSummaryDto(
        totalProducts: 0,
        urgentCount: 0,
        urgentPct: 0,
        normalCount: 0,
        normalPct: 0,
        sufficientCount: 0,
        sufficientPct: 0,
        overstockCount: 0,
        overstockPct: 0,
        recountCount: 0,
        recountPct: 0,
        totalReorderNeeded: 0,
      );

  HealthSummary toEntity() {
    return HealthSummary(
      totalProducts: totalProducts,
      urgentCount: urgentCount,
      urgentPct: urgentPct,
      normalCount: normalCount,
      normalPct: normalPct,
      sufficientCount: sufficientCount,
      sufficientPct: sufficientPct,
      overstockCount: overstockCount,
      overstockPct: overstockPct,
      recountCount: recountCount,
      recountPct: recountPct,
      totalReorderNeeded: totalReorderNeeded,
    );
  }
}

/// Category DTO
class HealthCategoryDto {
  final String categoryId;
  final String categoryName;
  final int totalProducts;
  final int urgentCount;
  final int normalCount;
  final int sufficientCount;
  final int overstockCount;
  final int recountCount;
  final int urgencyScore;
  final String urgencyLevel;

  const HealthCategoryDto({
    required this.categoryId,
    required this.categoryName,
    required this.totalProducts,
    required this.urgentCount,
    required this.normalCount,
    required this.sufficientCount,
    required this.overstockCount,
    required this.recountCount,
    required this.urgencyScore,
    required this.urgencyLevel,
  });

  factory HealthCategoryDto.fromJson(Map<String, dynamic> json) {
    return HealthCategoryDto(
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      urgentCount: (json['urgent_count'] as num?)?.toInt() ?? 0,
      normalCount: (json['normal_count'] as num?)?.toInt() ?? 0,
      sufficientCount: (json['sufficient_count'] as num?)?.toInt() ?? 0,
      overstockCount: (json['overstock_count'] as num?)?.toInt() ?? 0,
      recountCount: (json['recount_count'] as num?)?.toInt() ?? 0,
      urgencyScore: (json['urgency_score'] as num?)?.toInt() ?? 0,
      urgencyLevel: json['urgency_level'] as String? ?? 'none',
    );
  }

  HealthCategory toEntity() {
    return HealthCategory(
      categoryId: categoryId,
      categoryName: categoryName,
      totalProducts: totalProducts,
      urgentCount: urgentCount,
      normalCount: normalCount,
      sufficientCount: sufficientCount,
      overstockCount: overstockCount,
      recountCount: recountCount,
      urgencyScore: urgencyScore,
      urgencyLevel: urgencyLevel,
    );
  }
}

/// Health Product DTO (urgent/normal)
class HealthProductDto {
  final String productId;
  final String productName;
  final String? sku;
  final String? variantId;
  final String? variantName;
  final String categoryName;
  final String? brandName;
  final int currentStock;
  final double avgDailySales;
  final double daysOfInventory;
  final int leadTimeDays;
  final double daysUntilStockout;
  final DateTime? estimatedStockoutDate;
  final String urgencyReason;

  /// 주문 수량 관련 필드 (v1.2)
  final int safetyStock;
  final int reorderPoint;
  final int targetStock;
  final int recommendedOrderQty;

  const HealthProductDto({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.variantId,
    required this.variantName,
    required this.categoryName,
    required this.brandName,
    required this.currentStock,
    required this.avgDailySales,
    required this.daysOfInventory,
    required this.leadTimeDays,
    required this.daysUntilStockout,
    required this.estimatedStockoutDate,
    required this.urgencyReason,
    required this.safetyStock,
    required this.reorderPoint,
    required this.targetStock,
    required this.recommendedOrderQty,
  });

  factory HealthProductDto.fromJson(Map<String, dynamic> json) {
    DateTime? stockoutDate;
    final dateStr = json['estimated_stockout_date'];
    if (dateStr != null && dateStr is String && dateStr.isNotEmpty) {
      stockoutDate = DateTime.tryParse(dateStr);
    }

    return HealthProductDto(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      sku: json['sku'] as String?,
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      categoryName: json['category_name'] as String? ?? '',
      brandName: json['brand_name'] as String?,
      currentStock: (json['current_stock'] as num?)?.toInt() ?? 0,
      avgDailySales: (json['avg_daily_sales'] as num?)?.toDouble() ?? 0.0,
      daysOfInventory: (json['days_of_inventory'] as num?)?.toDouble() ?? 0.0,
      leadTimeDays: (json['lead_time_days'] as num?)?.toInt() ?? 0,
      daysUntilStockout:
          (json['days_until_stockout'] as num?)?.toDouble() ?? 0.0,
      estimatedStockoutDate: stockoutDate,
      urgencyReason: json['urgency_reason'] as String? ?? '',
      safetyStock: (json['safety_stock'] as num?)?.toInt() ?? 0,
      reorderPoint: (json['reorder_point'] as num?)?.toInt() ?? 0,
      targetStock: (json['target_stock'] as num?)?.toInt() ?? 0,
      recommendedOrderQty: (json['recommended_order_qty'] as num?)?.toInt() ?? 0,
    );
  }

  HealthProduct toEntity() {
    return HealthProduct(
      productId: productId,
      productName: productName,
      sku: sku,
      variantId: variantId,
      variantName: variantName,
      categoryName: categoryName,
      brandName: brandName,
      currentStock: currentStock,
      avgDailySales: avgDailySales,
      daysOfInventory: daysOfInventory,
      leadTimeDays: leadTimeDays,
      daysUntilStockout: daysUntilStockout,
      estimatedStockoutDate: estimatedStockoutDate,
      urgencyReason: urgencyReason,
      safetyStock: safetyStock,
      reorderPoint: reorderPoint,
      targetStock: targetStock,
      recommendedOrderQty: recommendedOrderQty,
    );
  }
}

/// Overstock Product DTO
class OverstockProductDto {
  final String productId;
  final String productName;
  final String? sku;
  final String? variantId;
  final String? variantName;
  final String categoryName;
  final String? brandName;
  final int currentStock;
  final double avgDailySales;
  final double daysOfInventory;
  final double monthsOfInventory;
  final String overstockReason;

  /// 주문 수량 관련 필드 (v1.2)
  final int safetyStock;
  final int targetStock;
  final int recommendedOrderQty;

  const OverstockProductDto({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.variantId,
    required this.variantName,
    required this.categoryName,
    required this.brandName,
    required this.currentStock,
    required this.avgDailySales,
    required this.daysOfInventory,
    required this.monthsOfInventory,
    required this.overstockReason,
    required this.safetyStock,
    required this.targetStock,
    required this.recommendedOrderQty,
  });

  factory OverstockProductDto.fromJson(Map<String, dynamic> json) {
    return OverstockProductDto(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      sku: json['sku'] as String?,
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      categoryName: json['category_name'] as String? ?? '',
      brandName: json['brand_name'] as String?,
      currentStock: (json['current_stock'] as num?)?.toInt() ?? 0,
      avgDailySales: (json['avg_daily_sales'] as num?)?.toDouble() ?? 0.0,
      daysOfInventory: (json['days_of_inventory'] as num?)?.toDouble() ?? 0.0,
      monthsOfInventory:
          (json['months_of_inventory'] as num?)?.toDouble() ?? 0.0,
      overstockReason: json['overstock_reason'] as String? ?? '',
      safetyStock: (json['safety_stock'] as num?)?.toInt() ?? 0,
      targetStock: (json['target_stock'] as num?)?.toInt() ?? 0,
      recommendedOrderQty: (json['recommended_order_qty'] as num?)?.toInt() ?? 0,
    );
  }

  OverstockProduct toEntity() {
    return OverstockProduct(
      productId: productId,
      productName: productName,
      sku: sku,
      variantId: variantId,
      variantName: variantName,
      categoryName: categoryName,
      brandName: brandName,
      currentStock: currentStock,
      avgDailySales: avgDailySales,
      daysOfInventory: daysOfInventory,
      monthsOfInventory: monthsOfInventory,
      overstockReason: overstockReason,
      safetyStock: safetyStock,
      targetStock: targetStock,
      recommendedOrderQty: recommendedOrderQty,
    );
  }
}

/// Recount Product DTO
class RecountProductDto {
  final String productId;
  final String productName;
  final String? sku;
  final String? variantId;
  final String? variantName;
  final String categoryName;
  final String? brandName;
  final int currentStock;
  final String recountReason;

  const RecountProductDto({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.variantId,
    required this.variantName,
    required this.categoryName,
    required this.brandName,
    required this.currentStock,
    required this.recountReason,
  });

  factory RecountProductDto.fromJson(Map<String, dynamic> json) {
    return RecountProductDto(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      sku: json['sku'] as String?,
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      categoryName: json['category_name'] as String? ?? '',
      brandName: json['brand_name'] as String?,
      currentStock: (json['current_stock'] as num?)?.toInt() ?? 0,
      recountReason: json['recount_reason'] as String? ?? '',
    );
  }

  RecountProduct toEntity() {
    return RecountProduct(
      productId: productId,
      productName: productName,
      sku: sku,
      variantId: variantId,
      variantName: variantName,
      categoryName: categoryName,
      brandName: brandName,
      currentStock: currentStock,
      recountReason: recountReason,
    );
  }
}
