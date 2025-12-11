enum StockStatus {
  critical, // 0-10% of reorder point
  low,      // 11-30% of reorder point
  optimal,  // 31-80% of reorder point
  excess    // 81%+ of reorder point
}

enum ProductCategory {
  electronics,
  clothing,
  accessories,
  bags,
  shoes,
  jewelry,
  food,
  beverages,
  household,
  beauty,
  sports,
  books,
  other;

  String get displayName {
    switch (this) {
      case ProductCategory.electronics:
        return 'Electronics';
      case ProductCategory.clothing:
        return 'Clothing';
      case ProductCategory.accessories:
        return 'Accessories';
      case ProductCategory.bags:
        return 'Bags';
      case ProductCategory.shoes:
        return 'Shoes';
      case ProductCategory.jewelry:
        return 'Jewelry';
      case ProductCategory.food:
        return 'Food';
      case ProductCategory.beverages:
        return 'Beverages';
      case ProductCategory.household:
        return 'Household';
      case ProductCategory.beauty:
        return 'Beauty';
      case ProductCategory.sports:
        return 'Sports';
      case ProductCategory.books:
        return 'Books';
      case ProductCategory.other:
        return 'Other';
    }
  }
}

enum ProductType {
  simple,
  variant,
  bundle,
  digital;

  String get displayName {
    switch (this) {
      case ProductType.simple:
        return 'Simple Product';
      case ProductType.variant:
        return 'Product with Variants';
      case ProductType.bundle:
        return 'Bundle Product';
      case ProductType.digital:
        return 'Digital Product';
    }
  }
}

enum MovementType {
  sale,
  purchase,
  adjustment,
  transfer,
  stockReturn;

  String get displayName {
    switch (this) {
      case MovementType.sale:
        return 'Sale';
      case MovementType.purchase:
        return 'Purchase';
      case MovementType.adjustment:
        return 'Adjustment';
      case MovementType.transfer:
        return 'Transfer';
      case MovementType.stockReturn:
        return 'Return';
    }
  }
}

class Product {
  final String id;
  final String sku;
  final String? barcode;
  final String name;
  final String? nameEn;
  final String? description;
  final List<String> images;
  final ProductCategory category;
  final ProductType productType;
  final String? brand;
  final List<String> tags;
  final String unit;
  
  // Financial
  final double costPrice;
  final double salePrice;
  final double? compareAtPrice;
  final double? minPrice;
  final double taxRate;
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

  Product({
    required this.id,
    required this.sku,
    this.barcode,
    required this.name,
    this.nameEn,
    this.description,
    List<String>? images,
    required this.category,
    required this.productType,
    this.brand,
    List<String>? tags,
    this.unit = 'piece',
    required this.costPrice,
    required this.salePrice,
    this.compareAtPrice,
    this.minPrice,
    this.taxRate = 0.10,
    this.currency = 'KRW',
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
  }) : images = images ?? [],
       tags = tags ?? [],
       available = available ?? (onHand - reserved),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  double get margin => salePrice - costPrice;
  double get marginPercentage => (margin / salePrice) * 100;
  double get inventoryValue => onHand * costPrice;
  double get potentialRevenue => available * salePrice;
  
  StockStatus get stockStatus {
    if (reorderPoint == null) return StockStatus.optimal;
    
    final ratio = onHand / reorderPoint!;
    if (ratio <= 0.1) return StockStatus.critical;
    if (ratio <= 0.3) return StockStatus.low;
    if (ratio <= 0.8) return StockStatus.optimal;
    return StockStatus.excess;
  }
  
  bool get needsReorder => reorderPoint != null && onHand <= reorderPoint!;
  
  int get daysUntilStockout {
    if (averageDailySales == null || averageDailySales! == 0) return 999;
    return (available / averageDailySales!).floor();
  }

  Product copyWith({
    String? id,
    String? sku,
    String? barcode,
    String? name,
    String? nameEn,
    String? description,
    List<String>? images,
    ProductCategory? category,
    ProductType? productType,
    String? brand,
    List<String>? tags,
    String? unit,
    double? costPrice,
    double? salePrice,
    double? compareAtPrice,
    double? minPrice,
    double? taxRate,
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
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      images: images ?? this.images,
      category: category ?? this.category,
      productType: productType ?? this.productType,
      brand: brand ?? this.brand,
      tags: tags ?? this.tags,
      unit: unit ?? this.unit,
      costPrice: costPrice ?? this.costPrice,
      salePrice: salePrice ?? this.salePrice,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      minPrice: minPrice ?? this.minPrice,
      taxRate: taxRate ?? this.taxRate,
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
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'barcode': barcode,
      'name': name,
      'name_en': nameEn,
      'description': description,
      'images': images,
      'category': category.name,
      'product_type': productType.name,
      'brand': brand,
      'tags': tags,
      'unit': unit,
      'cost_price': costPrice,
      'sale_price': salePrice,
      'compare_at_price': compareAtPrice,
      'min_price': minPrice,
      'tax_rate': taxRate,
      'currency': currency,
      'on_hand': onHand,
      'available': available,
      'reserved': reserved,
      'reorder_point': reorderPoint,
      'reorder_quantity': reorderQuantity,
      'min_stock': minStock,
      'max_stock': maxStock,
      'location': location,
      'warehouse': warehouse,
      'weight': weight,
      'average_daily_sales': averageDailySales,
      'days_on_hand': daysOnHand,
      'turnover_rate': turnoverRate,
      'last_sold': lastSold?.toIso8601String(),
      'last_received': lastReceived?.toIso8601String(),
      'last_counted': lastCounted?.toIso8601String(),
      'count_discrepancy': countDiscrepancy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'sell_in_store': sellInStore,
      'sell_online': sellOnline,
      'attributes': attributes,
    };
  }
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      sku: json['sku'],
      barcode: json['barcode'],
      name: json['name'],
      nameEn: json['name_en'],
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      category: ProductCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ProductCategory.other,
      ),
      productType: ProductType.values.firstWhere(
        (e) => e.name == json['product_type'],
        orElse: () => ProductType.simple,
      ),
      brand: json['brand'],
      tags: List<String>.from(json['tags'] ?? []),
      unit: json['unit'] ?? 'piece',
      costPrice: (json['cost_price'] ?? 0).toDouble(),
      salePrice: (json['sale_price'] ?? 0).toDouble(),
      compareAtPrice: json['compare_at_price']?.toDouble(),
      minPrice: json['min_price']?.toDouble(),
      taxRate: (json['tax_rate'] ?? 0.10).toDouble(),
      currency: json['currency'] ?? 'KRW',
      onHand: json['on_hand'] ?? 0,
      available: json['available'],
      reserved: json['reserved'] ?? 0,
      reorderPoint: json['reorder_point'],
      reorderQuantity: json['reorder_quantity'],
      minStock: json['min_stock'],
      maxStock: json['max_stock'],
      location: json['location'],
      warehouse: json['warehouse'],
      weight: json['weight']?.toDouble(),
      averageDailySales: json['average_daily_sales']?.toDouble(),
      daysOnHand: json['days_on_hand'],
      turnoverRate: json['turnover_rate']?.toDouble(),
      lastSold: json['last_sold'] != null ? DateTime.parse(json['last_sold']) : null,
      lastReceived: json['last_received'] != null ? DateTime.parse(json['last_received']) : null,
      lastCounted: json['last_counted'] != null ? DateTime.parse(json['last_counted']) : null,
      countDiscrepancy: json['count_discrepancy'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] ?? true,
      sellInStore: json['sell_in_store'] ?? true,
      sellOnline: json['sell_online'] ?? false,
      attributes: json['attributes'],
    );
  }
}

class StockMovement {
  final String id;
  final Product product;
  final MovementType movementType;
  final int quantity;
  final String? reason;
  final DateTime timestamp;
  final String? location;
  final String? reference;
  final String? user;
  final int? balanceAfter;

  StockMovement({
    required this.id,
    required this.product,
    required this.movementType,
    required this.quantity,
    this.reason,
    required this.timestamp,
    this.location,
    this.reference,
    this.user,
    this.balanceAfter,
  });

  DateTime get date => timestamp;
  String? get note => reason;
  MovementType get type => movementType;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': product.id,
      'movement_type': movementType.name,
      'quantity': quantity,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'reference': reference,
      'user': user,
      'balance_after': balanceAfter,
    };
  }

  factory StockMovement.fromJson(Map<String, dynamic> json, Product product) {
    return StockMovement(
      id: json['id'],
      product: product,
      movementType: MovementType.values.firstWhere((e) => e.name == json['movement_type']),
      quantity: json['quantity'],
      reason: json['reason'],
      timestamp: DateTime.parse(json['timestamp']),
      location: json['location'],
      reference: json['reference'],
      user: json['user'],
      balanceAfter: json['balance_after'],
    );
  }
}