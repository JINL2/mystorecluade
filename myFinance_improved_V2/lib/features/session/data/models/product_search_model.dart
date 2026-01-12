import '../../domain/entities/session_item.dart';

/// Model for ProductSearchResult with JSON parsing
/// Supports get_inventory_page_v6 which returns variants expanded
class ProductSearchResultModel {
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final String? brandName;
  final String? categoryName;
  final double sellingPrice;
  final int currentStock;

  // v6 variant fields
  final String? variantId;
  final String? variantName;
  final String? variantSku;
  final String? variantBarcode;
  final String? displayName;
  final String? displaySku;
  final String? displayBarcode;
  final bool hasVariants;

  const ProductSearchResultModel({
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    this.brandName,
    this.categoryName,
    this.sellingPrice = 0,
    this.currentStock = 0,
    this.variantId,
    this.variantName,
    this.variantSku,
    this.variantBarcode,
    this.displayName,
    this.displaySku,
    this.displayBarcode,
    this.hasVariants = false,
  });

  /// Parse from get_inventory_page_v6 RPC response format
  /// v6 returns variants expanded - each variant is a separate row
  factory ProductSearchResultModel.fromJson(Map<String, dynamic> json) {
    // Parse image URL from image_urls array
    String? imageUrl;
    if (json['image_urls'] is List) {
      final urls = json['image_urls'] as List;
      if (urls.isNotEmpty) imageUrl = urls.first.toString();
    } else if (json['images'] is Map) {
      final images = json['images'] as Map<String, dynamic>;
      imageUrl = images['thumbnail']?.toString() ?? images['main_image']?.toString();
    } else {
      imageUrl = json['image_url']?.toString() ?? json['thumbnail']?.toString();
    }

    // Parse selling price from price object or direct field
    double sellingPrice = 0;
    if (json['price'] is Map) {
      final price = json['price'] as Map<String, dynamic>;
      sellingPrice = (price['selling'] as num?)?.toDouble() ?? 0;
    } else {
      sellingPrice = (json['selling_price'] as num?)?.toDouble() ?? 0;
    }

    // Parse current stock from stock object or direct field
    int currentStock = 0;
    if (json['stock'] is Map) {
      final stock = json['stock'] as Map<String, dynamic>;
      currentStock = (stock['quantity_on_hand'] as num?)?.toInt() ?? 0;
    } else {
      currentStock = (json['current_stock'] as num?)?.toInt() ?? 0;
    }

    return ProductSearchResultModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      barcode: json['barcode']?.toString(),
      imageUrl: imageUrl,
      brandName: json['brand_name']?.toString(),
      categoryName: json['category_name']?.toString(),
      sellingPrice: sellingPrice,
      currentStock: currentStock,
      // v6 variant fields
      variantId: json['variant_id']?.toString(),
      variantName: json['variant_name']?.toString(),
      variantSku: json['variant_sku']?.toString(),
      variantBarcode: json['variant_barcode']?.toString(),
      displayName: json['display_name']?.toString(),
      displaySku: json['display_sku']?.toString(),
      displayBarcode: json['display_barcode']?.toString(),
      hasVariants: json['has_variants'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'image_url': imageUrl,
      'brand_name': brandName,
      'category_name': categoryName,
      'selling_price': sellingPrice,
      'current_stock': currentStock,
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

  ProductSearchResult toEntity() {
    return ProductSearchResult(
      productId: productId,
      productName: productName,
      sku: sku,
      barcode: barcode,
      imageUrl: imageUrl,
      brandName: brandName,
      categoryName: categoryName,
      sellingPrice: sellingPrice,
      currentStock: currentStock,
      variantId: variantId,
      variantName: variantName,
      variantSku: variantSku,
      variantBarcode: variantBarcode,
      displayName: displayName,
      displaySku: displaySku,
      displayBarcode: displayBarcode,
      hasVariants: hasVariants,
    );
  }
}

/// Model for ProductSearchResponse with pagination
class ProductSearchResponseModel {
  final List<ProductSearchResultModel> products;
  final int totalCount;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;

  const ProductSearchResponseModel({
    required this.products,
    this.totalCount = 0,
    this.page = 1,
    this.limit = 20,
    this.totalPages = 1,
    this.hasNext = false,
  });

  /// Parse from get_inventory_page_v6 RPC response format
  /// v6 returns 'items' array (not 'products') with variants expanded
  factory ProductSearchResponseModel.fromJson(Map<String, dynamic> json) {
    // v6 uses 'items' key, fallback to 'products' for compatibility
    final itemsJson = json['items'] as List<dynamic>? ??
        json['products'] as List<dynamic>? ??
        [];
    final products = itemsJson
        .map((e) => ProductSearchResultModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Parse pagination info
    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

    return ProductSearchResponseModel(
      products: products,
      totalCount: (pagination['total'] as num?)?.toInt() ??
                 (json['total_count'] as num?)?.toInt() ??
                 products.length,
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      limit: (pagination['limit'] as num?)?.toInt() ?? 20,
      totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: pagination['has_next'] as bool? ?? false,
    );
  }

  ProductSearchResponse toEntity() {
    return ProductSearchResponse(
      products: products.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      page: page,
      limit: limit,
      totalPages: totalPages,
      hasNext: hasNext,
    );
  }
}

/// Model for AddSessionItemsResponse
class AddSessionItemsResponseModel {
  final bool success;
  final String? message;
  final int itemsAdded;

  const AddSessionItemsResponseModel({
    required this.success,
    this.message,
    this.itemsAdded = 0,
  });

  factory AddSessionItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return AddSessionItemsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString(),
      itemsAdded: (json['items_added'] as num?)?.toInt() ?? 0,
    );
  }

  AddSessionItemsResponse toEntity() {
    return AddSessionItemsResponse(
      success: success,
      message: message,
      itemsAdded: itemsAdded,
    );
  }
}
