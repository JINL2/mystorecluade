/// Domain entity for user session items
/// Clean Architecture: Domain layer entity - no dependencies on Data layer

/// Individual item added by user in a session
class UserSessionItem {
  final String itemId;
  final String productId;
  final String productName;
  final String? sku;
  final List<String>? imageUrls;
  final int quantity;
  final int quantityRejected;
  final String? notes;
  final String createdAt;

  const UserSessionItem({
    required this.itemId,
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrls,
    required this.quantity,
    required this.quantityRejected,
    this.notes,
    required this.createdAt,
  });

  /// Get first image URL or null
  String? get imageUrl => imageUrls?.isNotEmpty == true ? imageUrls!.first : null;
}

/// Summary of user's session items
class UserSessionItemsSummary {
  final int totalItems;
  final int totalProducts;
  final int totalQuantity;
  final int totalRejected;

  const UserSessionItemsSummary({
    required this.totalItems,
    required this.totalProducts,
    required this.totalQuantity,
    required this.totalRejected,
  });
}

/// Response entity for getting user session items
class UserSessionItemsResponse {
  final String sessionId;
  final String userId;
  final List<UserSessionItem> items;
  final UserSessionItemsSummary summary;

  const UserSessionItemsResponse({
    required this.sessionId,
    required this.userId,
    required this.items,
    required this.summary,
  });

  /// Check if user has any items
  bool get hasItems => items.isNotEmpty;

  /// Get aggregated items by product_id
  /// Groups multiple item records for same product into one with summed quantities
  Map<String, AggregatedUserSessionItem> get aggregatedByProduct {
    final result = <String, AggregatedUserSessionItem>{};

    for (final item in items) {
      if (result.containsKey(item.productId)) {
        final existing = result[item.productId]!;
        result[item.productId] = AggregatedUserSessionItem(
          productId: item.productId,
          productName: item.productName,
          sku: item.sku,
          imageUrl: item.imageUrl,
          totalQuantity: existing.totalQuantity + item.quantity,
          totalRejected: existing.totalRejected + item.quantityRejected,
          itemIds: [...existing.itemIds, item.itemId],
        );
      } else {
        result[item.productId] = AggregatedUserSessionItem(
          productId: item.productId,
          productName: item.productName,
          sku: item.sku,
          imageUrl: item.imageUrl,
          totalQuantity: item.quantity,
          totalRejected: item.quantityRejected,
          itemIds: [item.itemId],
        );
      }
    }

    return result;
  }
}

/// Aggregated item (grouped by product_id)
class AggregatedUserSessionItem {
  final String productId;
  final String productName;
  final String? sku;
  final String? imageUrl;
  final int totalQuantity;
  final int totalRejected;
  final List<String> itemIds;

  const AggregatedUserSessionItem({
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrl,
    required this.totalQuantity,
    required this.totalRejected,
    required this.itemIds,
  });
}
