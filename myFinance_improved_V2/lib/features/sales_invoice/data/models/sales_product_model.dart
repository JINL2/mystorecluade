import '../../domain/entities/sales_product.dart';

/// Sales product model for data transfer
class SalesProductModel {
  final Map<String, dynamic> json;

  SalesProductModel(this.json);

  /// Create from JSON
  factory SalesProductModel.fromJson(Map<String, dynamic> json) {
    return SalesProductModel(json);
  }

  /// Convert to domain entity
  SalesProduct toEntity() {
    final images = json['images'] as Map<String, dynamic>? ?? {};
    final status = json['status'] as Map<String, dynamic>? ?? {};
    final pricing = json['pricing'] as Map<String, dynamic>? ?? {};
    final totalStockSummary = json['total_stock_summary'] as Map<String, dynamic>? ?? {};
    final stockSettings = json['stock_settings'] as Map<String, dynamic>? ?? {};

    return SalesProduct(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode']?.toString(),
      productType: json['product_type']?.toString() ?? 'commodity',
      brand: _extractBrand(json['brand']),
      category: _extractCategory(json['category']),
      unit: json['unit']?.toString(),
      thumbnail: images['thumbnail']?.toString(),
      mainImage: images['main_image']?.toString(),
      additionalImages: _extractAdditionalImages(images['additional_images']),
      isActive: (status['is_active'] as bool?) ?? true,
      isDeleted: (status['is_deleted'] as bool?) ?? false,
      createdAt: _parseDateTime(status['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(status['updated_at']) ?? DateTime.now(),
      sellingPrice: (pricing['selling_price'] as num?)?.toDouble(),
      costPrice: (pricing['cost_price'] as num?)?.toDouble(),
      minPrice: (pricing['min_price'] as num?)?.toDouble(),
      profitAmount: (pricing['profit_amount'] as num?)?.toDouble(),
      profitMargin: (pricing['profit_margin'] as num?)?.toDouble(),
      totalQuantityOnHand: (totalStockSummary['total_quantity_on_hand'] as num?)?.toInt() ?? 0,
      totalQuantityReserved: (totalStockSummary['total_quantity_reserved'] as num?)?.toInt() ?? 0,
      totalQuantityAvailable: (totalStockSummary['total_quantity_available'] as num?)?.toInt() ?? 0,
      totalValue: (totalStockSummary['total_value'] as num?)?.toDouble() ?? 0.0,
      storeCount: (totalStockSummary['store_count'] as num?)?.toInt() ?? 0,
      minStock: (stockSettings['min_stock'] as num?)?.toInt() ?? 0,
      maxStock: (stockSettings['max_stock'] as num?)?.toInt(),
      reorderPoint: (stockSettings['reorder_point'] as num?)?.toInt(),
      reorderQuantity: (stockSettings['reorder_quantity'] as num?)?.toInt(),
    );
  }

  String? _extractBrand(dynamic brand) {
    if (brand is Map<String, dynamic>) {
      return brand['brand_name']?.toString();
    }
    return brand?.toString();
  }

  String? _extractCategory(dynamic category) {
    if (category is Map<String, dynamic>) {
      return category['category_name']?.toString();
    }
    return category?.toString();
  }

  List<String> _extractAdditionalImages(dynamic additionalImages) {
    if (additionalImages is List) {
      return additionalImages.map((item) => item.toString()).toList();
    }
    return [];
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return null;
    }
  }
}
