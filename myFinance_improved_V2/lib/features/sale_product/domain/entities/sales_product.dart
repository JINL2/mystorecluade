import 'package:equatable/equatable.dart';

/// Sales product entity - represents a product available for sale
/// Supports both regular products and variant products from get_inventory_page_v6
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
  final String? categoryId;
  final String? brand;
  final String? brandId;
  final String? unit;
  final ProductAttributes attributes;
  final List<StoreStock> storeStocks;
  final StockSettings stockSettings;

  // Variant fields (from get_inventory_page_v6)
  final String? variantId;
  final String? variantName;
  final String? variantSku;
  final String? variantBarcode;

  // Display fields (combined product + variant info)
  final String? displayName;
  final String? displaySku;
  final String? displayBarcode;

  // Variant flag
  final bool hasVariants;

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
    this.categoryId,
    this.brand,
    this.brandId,
    this.unit,
    required this.attributes,
    required this.storeStocks,
    required this.stockSettings,
    // Variant fields
    this.variantId,
    this.variantName,
    this.variantSku,
    this.variantBarcode,
    this.displayName,
    this.displaySku,
    this.displayBarcode,
    this.hasVariants = false,
  });

  bool get hasAvailableStock => totalStockSummary.totalQuantityAvailable > 0;
  StoreStock? get firstStoreStock => storeStocks.isNotEmpty ? storeStocks.first : null;
  int get availableQuantity => totalStockSummary.totalQuantityAvailable;
  double? get sellingPrice => pricing.sellingPrice;

  /// Get the effective name to display (variant name if exists, otherwise product name)
  String get effectiveName => displayName ?? productName;

  /// Get the effective SKU to display (variant SKU if exists, otherwise product SKU)
  String get effectiveSku => displaySku ?? sku;

  /// Get the effective barcode to display (variant barcode if exists, otherwise product barcode)
  String get effectiveBarcode => displayBarcode ?? barcode;

  /// Returns true if this is a variant product
  bool get isVariant => variantId != null;

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
        categoryId,
        brand,
        brandId,
        unit,
        attributes,
        storeStocks,
        stockSettings,
        variantId,
        variantName,
        variantSku,
        variantBarcode,
        displayName,
        displaySku,
        displayBarcode,
        hasVariants,
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

  // Mock Factory
  static StockSettings mock() => const StockSettings(minStock: 10);
}

// ============================================
// Mock Factories (for skeleton loading)
// ============================================

extension ProductPricingMock on ProductPricing {
  static ProductPricing mock() => const ProductPricing(
        sellingPrice: 10000,
        costPrice: 8000,
        profitAmount: 2000,
        profitMargin: 20.0,
      );
}

extension TotalStockSummaryMock on TotalStockSummary {
  static TotalStockSummary mock() => const TotalStockSummary(
        storeCount: 1,
        totalValue: 100000,
        totalQuantityOnHand: 50,
        totalQuantityReserved: 5,
        totalQuantityAvailable: 45,
      );
}

extension ProductImagesMock on ProductImages {
  static ProductImages mock() => const ProductImages(additionalImages: []);
}

extension ProductStatusMock on ProductStatus {
  static ProductStatus mock() => ProductStatus(
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        isDeleted: false,
        updatedAt: DateTime(2025, 1, 1),
      );
}

extension ProductAttributesMock on ProductAttributes {
  static ProductAttributes mock() => const ProductAttributes();
}

extension StockMock on Stock {
  static Stock mock() => const Stock(
        quantityOnHand: 50,
        quantityReserved: 5,
        quantityAvailable: 45,
      );
}

extension ValuationMock on Valuation {
  static Valuation mock() => const Valuation(
        totalValue: 100000,
        averageCost: 8000,
      );
}

extension StoreStockMock on StoreStock {
  static StoreStock mock() => StoreStock(
        stock: StockMock.mock(),
        storeId: 'mock-store-id',
        valuation: ValuationMock.mock(),
        storeCode: 'STORE01',
        storeName: 'Store Name',
        stockStatus: 'normal',
      );

  static List<StoreStock> mockList([int count = 1]) =>
      List.generate(count, (_) => mock());
}

extension SalesProductMock on SalesProduct {
  static SalesProduct mock() => SalesProduct(
        productId: 'mock-product-id',
        productName: 'Product Name',
        sku: 'SKU-001',
        barcode: '1234567890123',
        productType: 'simple',
        pricing: ProductPricingMock.mock(),
        totalStockSummary: TotalStockSummaryMock.mock(),
        images: ProductImagesMock.mock(),
        status: ProductStatusMock.mock(),
        attributes: ProductAttributesMock.mock(),
        storeStocks: StoreStockMock.mockList(1),
        stockSettings: StockSettings.mock(),
      );

  static List<SalesProduct> mockList([int count = 5]) =>
      List.generate(count, (_) => mock());
}
