import '../../domain/entities/sales_product.dart';

/// Data model for SalesProduct with JSON serialization
class SalesProductModel extends SalesProduct {
  const SalesProductModel({
    required super.productId,
    required super.productName,
    required super.sku,
    required super.barcode,
    required super.productType,
    required super.pricing,
    required super.totalStockSummary,
    required super.images,
    required super.status,
    super.category,
    super.brand,
    super.unit,
    required super.attributes,
    required super.storeStocks,
    required super.stockSettings,
  });

  /// Parse images from various RPC response formats
  static ProductImagesModel _parseImages(Map<String, dynamic> json) {
    // Format 1: 'images' object with thumbnail, main_image, additional_images
    if (json['images'] is Map) {
      return ProductImagesModel.fromJson(json['images'] as Map<String, dynamic>);
    }

    // Format 2: 'image_urls' array from get_inventory_page_v3
    if (json['image_urls'] is List) {
      final urls = (json['image_urls'] as List).map((e) => e.toString()).toList();
      return ProductImagesModel(
        thumbnail: urls.isNotEmpty ? urls.first : null,
        mainImage: urls.isNotEmpty ? urls.first : null,
        additionalImages: urls.length > 1 ? urls.sublist(1) : [],
      );
    }

    // Format 3: Direct 'image_url' or 'thumbnail' field
    final imageUrl = json['image_url']?.toString() ?? json['thumbnail']?.toString();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ProductImagesModel(
        thumbnail: imageUrl,
        mainImage: imageUrl,
        additionalImages: [],
      );
    }

    // No images found
    return const ProductImagesModel(
      thumbnail: null,
      mainImage: null,
      additionalImages: [],
    );
  }

  factory SalesProductModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'pricing' and 'price' fields from RPC response
    Map<String, dynamic> pricingData;
    if (json.containsKey('pricing') && json['pricing'] is Map) {
      pricingData = json['pricing'] as Map<String, dynamic>;
    } else if (json.containsKey('price')) {
      // Convert lib_old format: price can be Map or double
      if (json['price'] is Map) {
        pricingData = json['price'] as Map<String, dynamic>;
      } else {
        pricingData = {'selling': json['price']};
      }
    } else {
      pricingData = {};
    }

    return SalesProductModel(
      productId: json['product_id']?.toString() ?? json['id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? json['name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode']?.toString() ?? '',
      productType: json['product_type']?.toString() ?? 'commodity',
      pricing: ProductPricingModel.fromJson(pricingData),
      totalStockSummary: TotalStockSummaryModel.fromJson(
        json['total_stock_summary'] as Map<String, dynamic>? ??
        (json['stock'] is Map ? json['stock'] as Map<String, dynamic> : {}),
      ),
      images: _parseImages(json),
      status: ProductStatusModel.fromJson(
        json['status'] as Map<String, dynamic>? ?? {},
      ),
      // v3 returns brand_name/category_name directly as strings
      category: json['category_name']?.toString() ??
          (json['category'] is Map<String, dynamic>
              ? (json['category'] as Map<String, dynamic>)['category_name']?.toString()
              : json['category']?.toString()),
      brand: json['brand_name']?.toString() ??
          (json['brand'] is Map<String, dynamic>
              ? (json['brand'] as Map<String, dynamic>)['brand_name']?.toString()
              : json['brand']?.toString()),
      unit: json['unit']?.toString(),
      attributes: ProductAttributesModel.fromJson(
        json['attributes'] as Map<String, dynamic>? ?? {},
      ),
      storeStocks: json['store_stocks'] != null
          ? (json['store_stocks'] as List)
              .map((e) => StoreStockModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      stockSettings: StockSettingsModel.fromJson(
        json['stock_settings'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'product_type': productType,
      'pricing': (pricing as ProductPricingModel).toJson(),
      'total_stock_summary': (totalStockSummary as TotalStockSummaryModel).toJson(),
      'images': (images as ProductImagesModel).toJson(),
      'status': (status as ProductStatusModel).toJson(),
      'category': category,
      'brand': brand,
      'unit': unit,
      'attributes': (attributes as ProductAttributesModel).toJson(),
      'store_stocks': storeStocks.map((e) => (e as StoreStockModel).toJson()).toList(),
      'stock_settings': (stockSettings as StockSettingsModel).toJson(),
    };
  }

  SalesProduct toEntity() => this;
}

class ProductPricingModel extends ProductPricing {
  const ProductPricingModel({
    super.minPrice,
    super.costPrice,
    super.profitAmount,
    super.profitMargin,
    super.sellingPrice,
  });

  factory ProductPricingModel.fromJson(Map<String, dynamic> json) {
    // Support multiple field names from different RPC formats:
    // - 'selling' from lib_old format (price.selling)
    // - 'selling_price' from new format
    // - 'price' as fallback
    final selling = json['selling'] as num?;
    final sellingPrice = json['selling_price'] as num?;
    final price = json['price'] as num?;
    final cost = json['cost'] as num?;
    final costPrice = json['cost_price'] as num?;

    return ProductPricingModel(
      minPrice: (json['min_price'] as num?)?.toDouble(),
      costPrice: (costPrice ?? cost)?.toDouble(),
      profitAmount: (json['profit_amount'] as num?)?.toDouble(),
      profitMargin: (json['profit_margin'] as num?)?.toDouble(),
      // Priority: selling > selling_price > price
      sellingPrice: (selling ?? sellingPrice ?? price)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_price': minPrice,
      'cost_price': costPrice,
      'profit_amount': profitAmount,
      'profit_margin': profitMargin,
      'selling_price': sellingPrice,
    };
  }
}

class TotalStockSummaryModel extends TotalStockSummary {
  const TotalStockSummaryModel({
    required super.storeCount,
    required super.totalValue,
    required super.totalQuantityOnHand,
    required super.totalQuantityReserved,
    required super.totalQuantityAvailable,
  });

  factory TotalStockSummaryModel.fromJson(Map<String, dynamic> json) {
    // Support both snake_case with 'total_' prefix and without
    final quantityOnHand = json['total_quantity_on_hand'] ?? json['quantity_on_hand'];
    final quantityReserved = json['total_quantity_reserved'] ?? json['quantity_reserved'];
    final quantityAvailable = json['total_quantity_available'] ?? json['quantity_available'];

    return TotalStockSummaryModel(
      storeCount: (json['store_count'] as num?)?.toInt() ?? 1,
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      totalQuantityOnHand: (quantityOnHand as num?)?.toDouble().toInt() ?? 0,
      totalQuantityReserved: (quantityReserved as num?)?.toDouble().toInt() ?? 0,
      totalQuantityAvailable: (quantityAvailable as num?)?.toDouble().toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_count': storeCount,
      'total_value': totalValue,
      'total_quantity_on_hand': totalQuantityOnHand,
      'total_quantity_reserved': totalQuantityReserved,
      'total_quantity_available': totalQuantityAvailable,
    };
  }
}

class ProductImagesModel extends ProductImages {
  const ProductImagesModel({
    super.thumbnail,
    super.mainImage,
    required super.additionalImages,
  });

  factory ProductImagesModel.fromJson(Map<String, dynamic> json) {
    return ProductImagesModel(
      thumbnail: json['thumbnail']?.toString(),
      mainImage: json['main_image']?.toString(),
      additionalImages: json['additional_images'] != null && json['additional_images'] is List
          ? (json['additional_images'] as List).map((item) => item.toString()).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'main_image': mainImage,
      'additional_images': additionalImages,
    };
  }
}

class ProductStatusModel extends ProductStatus {
  const ProductStatusModel({
    required super.isActive,
    required super.createdAt,
    required super.isDeleted,
    required super.updatedAt,
  });

  factory ProductStatusModel.fromJson(Map<String, dynamic> json) {
    return ProductStatusModel(
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      isDeleted: (json['is_deleted'] as bool?) ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'is_deleted': isDeleted,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductAttributesModel extends ProductAttributes {
  const ProductAttributesModel({
    super.position,
    super.weightG,
  });

  factory ProductAttributesModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributesModel(
      position: json['position']?.toString(),
      weightG: (json['weight_g'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'weight_g': weightG,
    };
  }
}

class StoreStockModel extends StoreStock {
  const StoreStockModel({
    required super.stock,
    required super.storeId,
    required super.valuation,
    required super.storeCode,
    required super.storeName,
    required super.stockStatus,
  });

  factory StoreStockModel.fromJson(Map<String, dynamic> json) {
    return StoreStockModel(
      stock: StockModel.fromJson(json['stock'] as Map<String, dynamic>? ?? {}),
      storeId: json['store_id']?.toString() ?? '',
      valuation: ValuationModel.fromJson(json['valuation'] as Map<String, dynamic>? ?? {}),
      storeCode: json['store_code']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      stockStatus: json['stock_status']?.toString() ?? 'normal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stock': (stock as StockModel).toJson(),
      'store_id': storeId,
      'valuation': (valuation as ValuationModel).toJson(),
      'store_code': storeCode,
      'store_name': storeName,
      'stock_status': stockStatus,
    };
  }
}

class StockModel extends Stock {
  const StockModel({
    required super.quantityOnHand,
    required super.quantityReserved,
    required super.quantityAvailable,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      quantityOnHand: (json['quantity_on_hand'] as num?)?.toInt() ?? 0,
      quantityReserved: (json['quantity_reserved'] as num?)?.toInt() ?? 0,
      quantityAvailable: (json['quantity_available'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity_on_hand': quantityOnHand,
      'quantity_reserved': quantityReserved,
      'quantity_available': quantityAvailable,
    };
  }
}

class ValuationModel extends Valuation {
  const ValuationModel({
    required super.totalValue,
    required super.averageCost,
  });

  factory ValuationModel.fromJson(Map<String, dynamic> json) {
    return ValuationModel(
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      averageCost: (json['average_cost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_value': totalValue,
      'average_cost': averageCost,
    };
  }
}

class StockSettingsModel extends StockSettings {
  const StockSettingsModel({
    super.maxStock,
    required super.minStock,
    super.reorderPoint,
    super.reorderQuantity,
  });

  factory StockSettingsModel.fromJson(Map<String, dynamic> json) {
    return StockSettingsModel(
      maxStock: (json['max_stock'] as num?)?.toInt(),
      minStock: (json['min_stock'] as num?)?.toInt() ?? 0,
      reorderPoint: (json['reorder_point'] as num?)?.toInt(),
      reorderQuantity: (json['reorder_quantity'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_stock': maxStock,
      'min_stock': minStock,
      'reorder_point': reorderPoint,
      'reorder_quantity': reorderQuantity,
    };
  }
}
