import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_session_items.freezed.dart';

/// Individual item added by user in a session
@freezed
class UserSessionItem with _$UserSessionItem {
  const UserSessionItem._();

  const factory UserSessionItem({
    required String itemId,
    required String productId,
    required String productName,
    String? sku,
    List<String>? imageUrls,
    required int quantity,
    required int quantityRejected,
    String? notes,
    required String createdAt,
  }) = _UserSessionItem;

  /// Get first image URL or null
  String? get imageUrl => imageUrls?.isNotEmpty == true ? imageUrls!.first : null;
}

/// Summary of user's session items
@freezed
class UserSessionItemsSummary with _$UserSessionItemsSummary {
  const factory UserSessionItemsSummary({
    required int totalItems,
    required int totalProducts,
    required int totalQuantity,
    required int totalRejected,
  }) = _UserSessionItemsSummary;
}

/// Aggregated item (grouped by product_id)
@freezed
class AggregatedUserSessionItem with _$AggregatedUserSessionItem {
  const factory AggregatedUserSessionItem({
    required String productId,
    required String productName,
    String? sku,
    String? imageUrl,
    required int totalQuantity,
    required int totalRejected,
    required List<String> itemIds,
  }) = _AggregatedUserSessionItem;
}

/// Response entity for getting user session items
@freezed
class UserSessionItemsResponse with _$UserSessionItemsResponse {
  const UserSessionItemsResponse._();

  const factory UserSessionItemsResponse({
    required String sessionId,
    required String userId,
    required List<UserSessionItem> items,
    required UserSessionItemsSummary summary,
  }) = _UserSessionItemsResponse;

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
