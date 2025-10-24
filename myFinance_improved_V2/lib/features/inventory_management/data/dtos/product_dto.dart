// Data Transfer Object: Product DTO
// Handles JSON serialization/deserialization for Product data

class ProductDto {
  final String id;
  final String name;
  final String? sku;
  final String? barcode;
  final double price;
  final double? cost;
  final int stock;
  final int? minStock;
  final int? maxStock;
  final String? unit;
  final String? categoryId;
  final String? categoryName;
  final String? brandId;
  final String? brandName;
  final String? productType;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final String? stockStatus;
  final int? quantityAvailable;
  final int? quantityReserved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductDto({
    required this.id,
    required this.name,
    this.sku,
    this.barcode,
    required this.price,
    this.cost,
    required this.stock,
    this.minStock,
    this.maxStock,
    this.unit,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    this.productType,
    this.description,
    this.imageUrl,
    this.isActive = true,
    this.stockStatus,
    this.quantityAvailable,
    this.quantityReserved,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON (RPC response parsing)
  factory ProductDto.fromJson(Map<String, dynamic> json) {
    // Parse price - handle both nested object and flat value
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is Map) {
        final priceMap = json['price'] as Map<String, dynamic>;
        parsedPrice = ((priceMap['selling'] ?? 0) as num).toDouble();
      } else {
        parsedPrice = (json['price'] as num).toDouble();
      }
    }

    // Parse cost - handle both nested price.cost and flat cost
    double? parsedCost;
    if (json['price'] != null && json['price'] is Map) {
      final priceMap = json['price'] as Map<String, dynamic>;
      if (priceMap['cost'] != null) {
        parsedCost = (priceMap['cost'] as num).toDouble();
      }
    } else if (json['cost'] != null) {
      parsedCost = (json['cost'] as num).toDouble();
    }

    // Parse stock - handle both nested object and flat value
    int parsedStock = 0;
    int? parsedQuantityAvailable;
    int? parsedQuantityReserved;
    if (json['stock'] != null) {
      if (json['stock'] is Map) {
        final stockMap = json['stock'] as Map<String, dynamic>;
        parsedStock = ((stockMap['quantity_on_hand'] ?? 0) as num).toInt();
        parsedQuantityAvailable = stockMap['quantity_available'] != null
            ? (stockMap['quantity_available'] as num).toInt()
            : null;
        parsedQuantityReserved = stockMap['quantity_reserved'] != null
            ? (stockMap['quantity_reserved'] as num).toInt()
            : null;
      } else {
        parsedStock = (json['stock'] as num).toInt();
      }
    } else if (json['current_stock'] != null) {
      parsedStock = (json['current_stock'] as num).toInt();
    }

    return ProductDto(
      id: (json['id'] ?? json['product_id'] ?? '') as String,
      name: (json['name'] ?? json['product_name'] ?? '') as String,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      price: parsedPrice,
      cost: parsedCost,
      stock: parsedStock,
      minStock: json['min_stock'] as int?,
      maxStock: json['max_stock'] as int?,
      unit: json['unit'] as String?,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      brandId: json['brand_id'] as String?,
      brandName: json['brand_name'] as String?,
      productType: json['product_type'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isActive: (json['is_active'] ?? true) as bool,
      stockStatus: json['stock_status'] as String?,
      quantityAvailable: parsedQuantityAvailable,
      quantityReserved: parsedQuantityReserved,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  // To JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'price': price,
      'cost': cost,
      'stock': stock,
      'min_stock': minStock,
      'max_stock': maxStock,
      'unit': unit,
      'category_id': categoryId,
      'category_name': categoryName,
      'brand_id': brandId,
      'brand_name': brandName,
      'product_type': productType,
      'description': description,
      'image_url': imageUrl,
      'is_active': isActive,
      'stock_status': stockStatus,
      'quantity_available': quantityAvailable,
      'quantity_reserved': quantityReserved,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
