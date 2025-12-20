import '../../domain/entities/session_compare_result.dart';

/// Model for compare item (product that exists in one session but not the other)
class SessionCompareItemModel extends SessionCompareItem {
  const SessionCompareItemModel({
    required super.productId,
    required super.productName,
    super.sku,
    super.barcode,
    super.imageUrl,
    super.brand,
    super.category,
    required super.quantity,
    super.scannedByName,
  });

  factory SessionCompareItemModel.fromJson(Map<String, dynamic> json) {
    // Handle image URL from various formats
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

    return SessionCompareItemModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      barcode: json['barcode']?.toString(),
      imageUrl: imageUrl,
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      scannedByName: json['scanned_by_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'image_url': imageUrl,
      'brand': brand,
      'category': category,
      'quantity': quantity,
      'scanned_by_name': scannedByName,
    };
  }
}

/// Model for session info in compare result
class SessionCompareInfoModel extends SessionCompareInfo {
  const SessionCompareInfoModel({
    required super.sessionId,
    required super.sessionName,
    required super.storeName,
    required super.createdByName,
    required super.totalProducts,
    required super.totalQuantity,
  });

  factory SessionCompareInfoModel.fromJson(Map<String, dynamic> json) {
    return SessionCompareInfoModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      createdByName: json['created_by_name']?.toString() ?? '',
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'session_name': sessionName,
      'store_name': storeName,
      'created_by_name': createdByName,
      'total_products': totalProducts,
      'total_quantity': totalQuantity,
    };
  }
}

/// Model for SessionCompareResponse with JSON serialization
class SessionCompareResponseModel extends SessionCompareResult {
  const SessionCompareResponseModel({
    required super.sourceSession,
    required super.targetSession,
    required super.onlyInSource,
    required super.onlyInTarget,
    required super.inBoth,
  });

  factory SessionCompareResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    // Session info is at root level of data
    final sourceJson = data['session_a'] as Map<String, dynamic>? ?? {};
    final targetJson = data['session_b'] as Map<String, dynamic>? ?? {};

    // Comparison items are nested inside 'comparison' object
    final comparison = data['comparison'] as Map<String, dynamic>? ?? {};

    final onlyInSourceList = (comparison['only_in_a'] as List<dynamic>? ?? [])
        .map((e) => SessionCompareItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final onlyInTargetList = (comparison['only_in_b'] as List<dynamic>? ?? [])
        .map((e) => SessionCompareItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final inBothList = (comparison['matched'] as List<dynamic>? ?? [])
        .map((e) => SessionCompareItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionCompareResponseModel(
      sourceSession: SessionCompareInfoModel.fromJson(sourceJson),
      targetSession: SessionCompareInfoModel.fromJson(targetJson),
      onlyInSource: onlyInSourceList,
      onlyInTarget: onlyInTargetList,
      inBoth: inBothList,
    );
  }
}
