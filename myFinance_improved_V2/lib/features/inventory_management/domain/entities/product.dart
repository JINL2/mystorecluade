// Domain Entity: Product
// Pure business logic entity without external dependencies

class Product {
  final String id;
  final String sku;
  final String? barcode;
  final String name;
  final String? nameEn;
  final String? description;
  final List<String> images;
  final String? categoryId;
  final String? categoryName;
  final String? brandId;
  final String? brandName;
  final String productType;
  final List<String> tags;
  final String unit;

  // Financial
  final double costPrice;
  final double salePrice;
  final double? compareAtPrice;
  final double? minPrice;
  final String currency;

  // Inventory
  final int onHand;
  final int available;
  final int reserved;
  final int? reorderPoint;
  final int? reorderQuantity;
  final int? minStock;
  final int? maxStock;
  final String? location;
  final String? warehouse;
  final double? weight;

  // Analytics
  final double? averageDailySales;
  final int? daysOnHand;
  final double? turnoverRate;
  final DateTime? lastSold;
  final DateTime? lastReceived;
  final DateTime? lastCounted;
  final int? countDiscrepancy;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool sellInStore;
  final bool sellOnline;
  final Map<String, dynamic>? attributes;

  // v6 variant fields
  final String? variantId;
  final String? variantName;
  final String? variantSku;
  final String? variantBarcode;
  final String? displayName;
  final String? displaySku;
  final String? displayBarcode;
  final bool hasVariants;

  Product({
    required this.id,
    required this.sku,
    this.barcode,
    required this.name,
    this.nameEn,
    this.description,
    List<String>? images,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    required this.productType,
    List<String>? tags,
    this.unit = 'piece',
    required this.costPrice,
    required this.salePrice,
    this.compareAtPrice,
    this.minPrice,
    this.currency = '',
    required this.onHand,
    int? available,
    this.reserved = 0,
    this.reorderPoint,
    this.reorderQuantity,
    this.minStock,
    this.maxStock,
    this.location,
    this.warehouse,
    this.weight,
    this.averageDailySales,
    this.daysOnHand,
    this.turnoverRate,
    this.lastSold,
    this.lastReceived,
    this.lastCounted,
    this.countDiscrepancy,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.sellInStore = true,
    this.sellOnline = false,
    this.attributes,
    // v6 variant fields
    this.variantId,
    this.variantName,
    this.variantSku,
    this.variantBarcode,
    this.displayName,
    this.displaySku,
    this.displayBarcode,
    this.hasVariants = false,
  })  : images = images ?? [],
        tags = tags ?? [],
        available = available ?? (onHand - reserved),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Business logic: Calculate margin
  double get margin => salePrice - costPrice;

  // Business logic: Calculate margin percentage
  double get marginPercentage => salePrice > 0 ? (margin / salePrice) * 100 : 0;

  // Business logic: Calculate inventory value
  double get inventoryValue => onHand * costPrice;

  // Business logic: Calculate potential revenue
  double get potentialRevenue => available * salePrice;

  // Business logic: Check if needs reorder
  bool get needsReorder => reorderPoint != null && onHand <= reorderPoint!;

  // Business logic: Calculate days until stockout
  int get daysUntilStockout {
    if (averageDailySales == null || averageDailySales! == 0) return 999;
    return (available / averageDailySales!).floor();
  }

  // Business logic: Get stock status
  StockStatus getStockStatus() {
    if (onHand == 0) return StockStatus.outOfStock;
    if (reorderPoint == null) return StockStatus.normal;

    final ratio = onHand / reorderPoint!;
    if (ratio <= 0.1) return StockStatus.critical;
    if (ratio <= 0.3) return StockStatus.low;
    if (ratio <= 0.8) return StockStatus.normal;
    return StockStatus.excess;
  }

  Product copyWith({
    String? id,
    String? sku,
    String? barcode,
    String? name,
    String? nameEn,
    String? description,
    List<String>? images,
    String? categoryId,
    String? categoryName,
    String? brandId,
    String? brandName,
    String? productType,
    List<String>? tags,
    String? unit,
    double? costPrice,
    double? salePrice,
    double? compareAtPrice,
    double? minPrice,
    String? currency,
    int? onHand,
    int? available,
    int? reserved,
    int? reorderPoint,
    int? reorderQuantity,
    int? minStock,
    int? maxStock,
    String? location,
    String? warehouse,
    double? weight,
    double? averageDailySales,
    int? daysOnHand,
    double? turnoverRate,
    DateTime? lastSold,
    DateTime? lastReceived,
    DateTime? lastCounted,
    int? countDiscrepancy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? sellInStore,
    bool? sellOnline,
    Map<String, dynamic>? attributes,
    // v6 variant fields
    String? variantId,
    String? variantName,
    String? variantSku,
    String? variantBarcode,
    String? displayName,
    String? displaySku,
    String? displayBarcode,
    bool? hasVariants,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      productType: productType ?? this.productType,
      tags: tags ?? this.tags,
      unit: unit ?? this.unit,
      costPrice: costPrice ?? this.costPrice,
      salePrice: salePrice ?? this.salePrice,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      minPrice: minPrice ?? this.minPrice,
      currency: currency ?? this.currency,
      onHand: onHand ?? this.onHand,
      available: available ?? this.available,
      reserved: reserved ?? this.reserved,
      reorderPoint: reorderPoint ?? this.reorderPoint,
      reorderQuantity: reorderQuantity ?? this.reorderQuantity,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      location: location ?? this.location,
      warehouse: warehouse ?? this.warehouse,
      weight: weight ?? this.weight,
      averageDailySales: averageDailySales ?? this.averageDailySales,
      daysOnHand: daysOnHand ?? this.daysOnHand,
      turnoverRate: turnoverRate ?? this.turnoverRate,
      lastSold: lastSold ?? this.lastSold,
      lastReceived: lastReceived ?? this.lastReceived,
      lastCounted: lastCounted ?? this.lastCounted,
      countDiscrepancy: countDiscrepancy ?? this.countDiscrepancy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      sellInStore: sellInStore ?? this.sellInStore,
      sellOnline: sellOnline ?? this.sellOnline,
      attributes: attributes ?? this.attributes,
      // v6 variant fields
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      variantSku: variantSku ?? this.variantSku,
      variantBarcode: variantBarcode ?? this.variantBarcode,
      displayName: displayName ?? this.displayName,
      displaySku: displaySku ?? this.displaySku,
      displayBarcode: displayBarcode ?? this.displayBarcode,
      hasVariants: hasVariants ?? this.hasVariants,
    );
  }
}

/// Stock Status Enum
/// Display names should be handled in Presentation layer via extension
enum StockStatus {
  outOfStock,  // 0 stock
  critical,    // 0-10% of reorder point
  low,         // 11-30% of reorder point
  normal,      // 31-80% of reorder point
  excess,      // 81%+ of reorder point
}
