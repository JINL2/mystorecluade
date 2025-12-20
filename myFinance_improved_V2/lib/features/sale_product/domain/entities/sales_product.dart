import 'package:equatable/equatable.dart';

/// Sales product entity - represents a product available for sale
class SalesProduct extends Equatable {
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

  @override
  List<Object?> get props => [
        productId,
        productName,
        sku,
        barcode,
        productType,
        pricing,
        totalStockSummary,
        images,
        status,
        category,
        brand,
        unit,
        attributes,
        storeStocks,
        stockSettings,
      ];
}

/// Product pricing information
class ProductPricing extends Equatable {
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

  @override
  List<Object?> get props => [
        minPrice,
        costPrice,
        profitAmount,
        profitMargin,
        sellingPrice,
      ];
}

/// Total stock summary across all stores
class TotalStockSummary extends Equatable {
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

  @override
  List<Object?> get props => [
        storeCount,
        totalValue,
        totalQuantityOnHand,
        totalQuantityReserved,
        totalQuantityAvailable,
      ];
}

/// Product images
class ProductImages extends Equatable {
  final String? thumbnail;
  final String? mainImage;
  final List<String> additionalImages;

  const ProductImages({
    this.thumbnail,
    this.mainImage,
    required this.additionalImages,
  });

  @override
  List<Object?> get props => [thumbnail, mainImage, additionalImages];
}

/// Product status
class ProductStatus extends Equatable {
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

  @override
  List<Object?> get props => [isActive, createdAt, isDeleted, updatedAt];
}

/// Product attributes
class ProductAttributes extends Equatable {
  final String? position;
  final double? weightG;

  const ProductAttributes({
    this.position,
    this.weightG,
  });

  @override
  List<Object?> get props => [position, weightG];
}

/// Store stock information
class StoreStock extends Equatable {
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

  @override
  List<Object?> get props => [
        stock,
        storeId,
        valuation,
        storeCode,
        storeName,
        stockStatus,
      ];
}

/// Stock quantities
class Stock extends Equatable {
  final int quantityOnHand;
  final int quantityReserved;
  final int quantityAvailable;

  const Stock({
    required this.quantityOnHand,
    required this.quantityReserved,
    required this.quantityAvailable,
  });

  @override
  List<Object?> get props => [quantityOnHand, quantityReserved, quantityAvailable];
}

/// Stock valuation
class Valuation extends Equatable {
  final double totalValue;
  final double averageCost;

  const Valuation({
    required this.totalValue,
    required this.averageCost,
  });

  @override
  List<Object?> get props => [totalValue, averageCost];
}

/// Stock settings
class StockSettings extends Equatable {
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

  @override
  List<Object?> get props => [maxStock, minStock, reorderPoint, reorderQuantity];
}
