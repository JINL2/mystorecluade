import '../../domain/entities/session_item.dart';

/// Model for ProductSearchResult with JSON parsing
class ProductSearchResultModel extends ProductSearchResult {
  const ProductSearchResultModel({
    required super.productId,
    required super.productName,
    super.sku,
    super.barcode,
    super.imageUrl,
    super.sellingPrice,
    super.currentStock,
  });

  factory ProductSearchResultModel.fromJson(Map<String, dynamic> json) {
    // Parse image URL from various formats
    String? imageUrl;
    if (json['images'] is Map) {
      final images = json['images'] as Map<String, dynamic>;
      imageUrl = images['thumbnail']?.toString() ?? images['main_image']?.toString();
    } else if (json['image_urls'] is List) {
      final urls = json['image_urls'] as List;
      if (urls.isNotEmpty) imageUrl = urls.first.toString();
    } else {
      imageUrl = json['image_url']?.toString() ?? json['thumbnail']?.toString();
    }

    return ProductSearchResultModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      barcode: json['barcode']?.toString(),
      imageUrl: imageUrl,
      sellingPrice: (json['selling_price'] as num?)?.toDouble() ?? 0,
      currentStock: (json['current_stock'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'image_url': imageUrl,
      'selling_price': sellingPrice,
      'current_stock': currentStock,
    };
  }

  ProductSearchResult toEntity() => this;
}

/// Model for ProductSearchResponse
class ProductSearchResponseModel extends ProductSearchResponse {
  const ProductSearchResponseModel({
    required super.products,
    super.totalCount,
  });

  factory ProductSearchResponseModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>? ?? [];
    final products = productsJson
        .map((e) => ProductSearchResultModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductSearchResponseModel(
      products: products,
      totalCount: (json['total_count'] as num?)?.toInt() ?? products.length,
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
