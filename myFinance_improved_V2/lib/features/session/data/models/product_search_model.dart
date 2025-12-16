import '../../domain/entities/session_item.dart';

/// Model for ProductSearchResult with JSON parsing
class ProductSearchResultModel extends ProductSearchResult {
  const ProductSearchResultModel({
    required super.productId,
    required super.productName,
    super.sku,
    super.barcode,
    super.imageUrl,
    super.brandName,
    super.categoryName,
    super.sellingPrice,
    super.currentStock,
  });

  /// Parse from get_inventory_page_v3 RPC response format
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
    };
  }

  ProductSearchResult toEntity() => this;
}

/// Model for ProductSearchResponse with pagination
class ProductSearchResponseModel extends ProductSearchResponse {
  const ProductSearchResponseModel({
    required super.products,
    super.totalCount,
    super.page,
    super.limit,
    super.totalPages,
    super.hasNext,
  });

  /// Parse from get_inventory_page_v3 RPC response format
  factory ProductSearchResponseModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>? ?? [];
    final products = productsJson
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

  ProductSearchResponse toEntity() => this;
}

/// Model for AddSessionItemsResponse
class AddSessionItemsResponseModel extends AddSessionItemsResponse {
  const AddSessionItemsResponseModel({
    required super.success,
    super.message,
    super.itemsAdded,
  });

  factory AddSessionItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return AddSessionItemsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString(),
      itemsAdded: (json['items_added'] as num?)?.toInt() ?? 0,
    );
  }

  AddSessionItemsResponse toEntity() => this;
}
