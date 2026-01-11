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
  final List<String> imageUrls;
  final bool isActive;
  final String? stockStatus;
  final int? quantityAvailable;
  final int? quantityReserved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // v6 variant fields
  final String? variantId;
  final String? variantName;
  final String? variantSku;
  final String? variantBarcode;
  final String? displayName;
  final String? displaySku;
  final String? displayBarcode;
  final bool hasVariants;

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
    this.imageUrls = const [],
    this.isActive = true,
    this.stockStatus,
    this.quantityAvailable,
    this.quantityReserved,
    this.createdAt,
    this.updatedAt,
    // v6 variant fields
    this.variantId,
    this.variantName,
    this.variantSku,
    this.variantBarcode,
    this.displayName,
    this.displaySku,
    this.displayBarcode,
    this.hasVariants = false,
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
      sku: (json['sku'] ?? json['product_sku']) as String?,
      barcode: (json['barcode'] ?? json['product_barcode']) as String?,
      price: parsedPrice,
      cost: parsedCost,
      stock: parsedStock,
      minStock: json['min_stock'] != null ? (json['min_stock'] as num).toInt() : null,
      maxStock: json['max_stock'] != null ? (json['max_stock'] as num).toInt() : null,
      unit: json['unit'] as String?,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      brandId: json['brand_id'] as String?,
      brandName: json['brand_name'] as String?,
      productType: json['product_type'] as String?,
      description: json['description'] as String?,
      imageUrls: _parseImageUrls(json),
      isActive: _parseIsActive(json),
      stockStatus: _parseStockStatus(json),
      quantityAvailable: parsedQuantityAvailable,
      quantityReserved: parsedQuantityReserved,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      // v6 variant fields
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      variantSku: json['variant_sku'] as String?,
      variantBarcode: json['variant_barcode'] as String?,
      displayName: json['display_name'] as String?,
      displaySku: json['display_sku'] as String?,
      displayBarcode: json['display_barcode'] as String?,
      hasVariants: (json['has_variants'] ?? false) as bool,
    );
  }

  // Helper: Parse DateTime with error handling
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is String) {
        return DateTime.parse(value);
      }
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return null;
    } catch (_) {
      return null;
    }
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
      'image_urls': imageUrls,
      'is_active': isActive,
      'stock_status': stockStatus,
      'quantity_available': quantityAvailable,
      'quantity_reserved': quantityReserved,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      // v6 variant fields
      'variant_id': variantId,
      'variant_name': variantName,
      'variant_sku': variantSku,
      'variant_barcode': variantBarcode,
      'display_name': displayName,
      'display_sku': displaySku,
      'display_barcode': displayBarcode,
      'has_variants': hasVariants,
    };
  }

  // Helper: Parse image_urls from RPC response
  static List<String> _parseImageUrls(Map<String, dynamic> json) {
    final imageUrls = json['image_urls'];
    if (imageUrls is List) {
      return imageUrls
          .map((e) => e?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }

    final imageUrl = json['image_url'];
    if (imageUrl is String && imageUrl.isNotEmpty) {
      return [imageUrl];
    }

    return const [];  // Use const for immutable empty list
  }

  // Helper: Parse is_active from RPC response (handles status.is_active)
  static bool _parseIsActive(Map<String, dynamic> json) {
    // Try nested status.is_active first
    if (json['status'] != null && json['status'] is Map) {
      final statusMap = json['status'] as Map<String, dynamic>;
      if (statusMap['is_active'] != null) {
        return statusMap['is_active'] as bool;
      }
    }
    // Fallback to top-level is_active
    return (json['is_active'] ?? true) as bool;
  }

  // Helper: Parse stock_status from RPC response (handles status.stock_level)
  static String? _parseStockStatus(Map<String, dynamic> json) {
    // Try nested status.stock_level first
    if (json['status'] != null && json['status'] is Map) {
      final statusMap = json['status'] as Map<String, dynamic>;
      if (statusMap['stock_level'] != null) {
        return statusMap['stock_level'] as String;
      }
    }
    // Fallback to top-level stock_status
    return json['stock_status'] as String?;
  }
}
