import 'package:equatable/equatable.dart';

/// Sales product entity for invoice creation
class SalesProduct extends Equatable {
  final String productId;
  final String productName;
  final String sku;
  final String? barcode;
  final String productType;
  final String? brand;
  final String? category;
  final String? unit;

  // Images
  final String? thumbnail;
  final String? mainImage;
  final List<String> additionalImages;

  // Status
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Pricing
  final double? sellingPrice;
  final double? costPrice;
  final double? minPrice;
  final double? profitAmount;
  final double? profitMargin;

  // Stock
  final int totalQuantityOnHand;
  final int totalQuantityReserved;
  final int totalQuantityAvailable;
  final double totalValue;
  final int storeCount;

  // Settings
  final int minStock;
  final int? maxStock;
  final int? reorderPoint;
  final int? reorderQuantity;

  const SalesProduct({
    required this.productId,
    required this.productName,
    required this.sku,
    this.barcode,
    required this.productType,
    this.brand,
    this.category,
    this.unit,
    this.thumbnail,
    this.mainImage,
    this.additionalImages = const [],
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.sellingPrice,
    this.costPrice,
    this.minPrice,
    this.profitAmount,
    this.profitMargin,
    required this.totalQuantityOnHand,
    required this.totalQuantityReserved,
    required this.totalQuantityAvailable,
    required this.totalValue,
    required this.storeCount,
    required this.minStock,
    this.maxStock,
    this.reorderPoint,
    this.reorderQuantity,
  });

  /// Helper getters
  bool get hasAvailableStock => totalQuantityAvailable > 0;
  int get availableQuantity => totalQuantityAvailable;

  @override
  List<Object?> get props => [
        productId,
        productName,
        sku,
        barcode,
        productType,
        brand,
        category,
        unit,
        thumbnail,
        mainImage,
        additionalImages,
        isActive,
        isDeleted,
        createdAt,
        updatedAt,
        sellingPrice,
        costPrice,
        minPrice,
        profitAmount,
        profitMargin,
        totalQuantityOnHand,
        totalQuantityReserved,
        totalQuantityAvailable,
        totalValue,
        storeCount,
        minStock,
        maxStock,
        reorderPoint,
        reorderQuantity,
      ];
}
