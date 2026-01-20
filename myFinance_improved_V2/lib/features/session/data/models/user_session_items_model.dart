import '../../domain/entities/user_session_items.dart';

/// Model for inventory_get_user_session_items_v2 RPC response
/// Returns individual item records (no grouping by product_id)

/// Individual item added by user in a session
/// Supports v6 variants with variantId and displayName
class UserSessionItemModel {
  final String itemId;
  final String productId;
  final String productName;
  final String? sku;
  final List<String>? imageUrls;
  final int quantity;
  final int quantityRejected;
  final String? notes;
  final String createdAt;
  // v6 variant fields
  final String? variantId;
  final String? displayName;

  const UserSessionItemModel({
    required this.itemId,
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrls,
    required this.quantity,
    required this.quantityRejected,
    this.notes,
    required this.createdAt,
    this.variantId,
    this.displayName,
  });

  factory UserSessionItemModel.fromJson(Map<String, dynamic> json) {
    // Parse image_urls - can be a list or null
    List<String>? imageUrls;
    final rawImageUrls = json['image_urls'];
    if (rawImageUrls is List) {
      imageUrls = rawImageUrls.map((e) => e.toString()).toList();
    }

    return UserSessionItemModel(
      itemId: json['item_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      imageUrls: imageUrls,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      // v6 variant fields
      variantId: json['variant_id']?.toString(),
      displayName: json['display_name']?.toString(),
    );
  }

  /// Get first image URL or null
  String? get imageUrl => imageUrls?.isNotEmpty == true ? imageUrls!.first : null;

  /// Convert to domain entity
  UserSessionItem toEntity() {
    return UserSessionItem(
      itemId: itemId,
      productId: productId,
      productName: productName,
      sku: sku,
      imageUrls: imageUrls,
      quantity: quantity,
      quantityRejected: quantityRejected,
      notes: notes,
      createdAt: createdAt,
      // v6 variant fields
      variantId: variantId,
      displayName: displayName,
    );
  }
}

/// Summary of user's session items (Model)
class UserSessionItemsSummaryModel {
  final int totalItems;
  final int totalProducts;
  final int totalQuantity;
  final int totalRejected;

  const UserSessionItemsSummaryModel({
    required this.totalItems,
    required this.totalProducts,
    required this.totalQuantity,
    required this.totalRejected,
  });

  factory UserSessionItemsSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSessionItemsSummaryModel(
      totalItems: (json['total_items'] as num?)?.toInt() ?? 0,
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert to domain entity
  UserSessionItemsSummary toEntity() {
    return UserSessionItemsSummary(
      totalItems: totalItems,
      totalProducts: totalProducts,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
    );
  }
}

/// Response model for inventory_get_user_session_items_v2 RPC
class UserSessionItemsResponseModel {
  final String sessionId;
  final String userId;
  final List<UserSessionItemModel> items;
  final UserSessionItemsSummaryModel summary;

  const UserSessionItemsResponseModel({
    required this.sessionId,
    required this.userId,
    required this.items,
    required this.summary,
  });

  factory UserSessionItemsResponseModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList
        .map((e) => UserSessionItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};

    return UserSessionItemsResponseModel(
      sessionId: json['session_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      items: items,
      summary: UserSessionItemsSummaryModel.fromJson(summaryJson),
    );
  }

  /// Check if user has any items
  bool get hasItems => items.isNotEmpty;

  /// Convert to domain entity
  UserSessionItemsResponse toEntity() {
    return UserSessionItemsResponse(
      sessionId: sessionId,
      userId: userId,
      items: items.map((e) => e.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }

  /// Get aggregated items by product_id + variant_id (Model version)
  /// Groups multiple item records for same product/variant into one with summed quantities
  /// For v6 variants, uses productId:variantId as key
  Map<String, AggregatedUserSessionItemModel> get aggregatedByProduct {
    final result = <String, AggregatedUserSessionItemModel>{};

    for (final item in items) {
      // Use productId:variantId as key for variants, productId for non-variants
      final key = item.variantId != null
          ? '${item.productId}:${item.variantId}'
          : item.productId;

      if (result.containsKey(key)) {
        final existing = result[key]!;
        result[key] = AggregatedUserSessionItemModel(
          productId: item.productId,
          productName: item.productName,
          sku: item.sku,
          imageUrl: item.imageUrl,
          totalQuantity: existing.totalQuantity + item.quantity,
          totalRejected: existing.totalRejected + item.quantityRejected,
          itemIds: [...existing.itemIds, item.itemId],
          variantId: item.variantId,
          displayName: item.displayName,
        );
      } else {
        result[key] = AggregatedUserSessionItemModel(
          productId: item.productId,
          productName: item.productName,
          sku: item.sku,
          imageUrl: item.imageUrl,
          totalQuantity: item.quantity,
          totalRejected: item.quantityRejected,
          itemIds: [item.itemId],
          variantId: item.variantId,
          displayName: item.displayName,
        );
      }
    }

    return result;
  }
}

/// Aggregated item (grouped by product_id + variant_id) - Model version
/// Supports v6 variants with variantId and displayName
class AggregatedUserSessionItemModel {
  final String productId;
  final String productName;
  final String? sku;
  final String? imageUrl;
  final int totalQuantity;
  final int totalRejected;
  final List<String> itemIds;
  // v6 variant fields
  final String? variantId;
  final String? displayName;

  const AggregatedUserSessionItemModel({
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrl,
    required this.totalQuantity,
    required this.totalRejected,
    required this.itemIds,
    this.variantId,
    this.displayName,
  });

  /// Unique key for grouping (productId + variantId)
  String get uniqueKey => variantId != null ? '$productId:$variantId' : productId;

  /// Convert to domain entity
  AggregatedUserSessionItem toEntity() {
    return AggregatedUserSessionItem(
      productId: productId,
      productName: productName,
      sku: sku,
      imageUrl: imageUrl,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
      itemIds: itemIds,
      // v6 variant fields
      variantId: variantId,
      displayName: displayName,
    );
  }
}
