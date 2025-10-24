/// Sales product entity - represents a product available for sale
class SalesProduct {
  final String productId;
  final String productName;
  final String sku;
  final String barcode;
  final String productType;
  final ProductPricing pricing;
  final TotalStockSummary totalStockSummary;
  final ProductImages images;
  final ProductStatus status;
  final String? category;
  final String? brand;
  final String? unit;
  final ProductAttributes attributes;
  final List<StoreStock> storeStocks;
  final StockSettings stockSettings;

  const SalesProduct({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.barcode,
    required this.productType,
    required this.pricing,
    required this.totalStockSummary,
    required this.images,
    required this.status,
    this.category,
    this.brand,
    this.unit,
    required this.attributes,
    required this.storeStocks,
    required this.stockSettings,
  });

  bool get hasAvailableStock => totalStockSummary.totalQuantityAvailable > 0;
  StoreStock? get firstStoreStock => storeStocks.isNotEmpty ? storeStocks.first : null;
  int get availableQuantity => totalStockSummary.totalQuantityAvailable;
  double? get sellingPrice => pricing.sellingPrice;
}

/// Product pricing information
class ProductPricing {
  final double? minPrice;
  final double? costPrice;
  final double? profitAmount;
  final double? profitMargin;
  final double? sellingPrice;

  const ProductPricing({
    this.minPrice,
    this.costPrice,
    this.profitAmount,
    this.profitMargin,
    this.sellingPrice,
  });
}

/// Total stock summary across all stores
class TotalStockSummary {
  final int storeCount;
  final double totalValue;
  final int totalQuantityOnHand;
  final int totalQuantityReserved;
  final int totalQuantityAvailable;

  const TotalStockSummary({
    required this.storeCount,
    required this.totalValue,
    required this.totalQuantityOnHand,
    required this.totalQuantityReserved,
    required this.totalQuantityAvailable,
  });
}

/// Product images
class ProductImages {
  final String? thumbnail;
  final String? mainImage;
  final List<String> additionalImages;

  const ProductImages({
    this.thumbnail,
    this.mainImage,
    required this.additionalImages,
  });
}

/// Product status
class ProductStatus {
  final bool isActive;
  final DateTime createdAt;
  final bool isDeleted;
  final DateTime updatedAt;

  const ProductStatus({
    required this.isActive,
    required this.createdAt,
    required this.isDeleted,
    required this.updatedAt,
  });
}

/// Product attributes
class ProductAttributes {
  final String? position;
  final double? weightG;

  const ProductAttributes({
    this.position,
    this.weightG,
  });
}

/// Store stock information
class StoreStock {
  final Stock stock;
  final String storeId;
  final Valuation valuation;
  final String storeCode;
  final String storeName;
  final String stockStatus;

  const StoreStock({
    required this.stock,
    required this.storeId,
    required this.valuation,
    required this.storeCode,
    required this.storeName,
    required this.stockStatus,
  });
}

/// Stock quantities
class Stock {
  final int quantityOnHand;
  final int quantityReserved;
  final int quantityAvailable;

  const Stock({
    required this.quantityOnHand,
    required this.quantityReserved,
    required this.quantityAvailable,
  });
}

/// Stock valuation
class Valuation {
  final double totalValue;
  final double averageCost;

  const Valuation({
    required this.totalValue,
    required this.averageCost,
  });
}

/// Stock settings
class StockSettings {
  final int? maxStock;
  final int minStock;
  final int? reorderPoint;
  final int? reorderQuantity;

  const StockSettings({
    this.maxStock,
    required this.minStock,
    this.reorderPoint,
    this.reorderQuantity,
  });
}
