import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_session_items.freezed.dart';

/// Individual item added by user in a session
/// Supports v6 variants with variantId and displayName
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
    // v6 variant fields
    String? variantId,
    String? displayName,
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

/// Aggregated item (grouped by product_id + variant_id)
/// Supports v6 variants with variantId and displayName
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
    // v6 variant fields
    String? variantId,
    String? displayName,
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

  /// Get aggregated items by product_id + variant_id
  /// Groups multiple item records for same product/variant into one with summed quantities
  /// For v6 variants, uses productId:variantId as key
  Map<String, AggregatedUserSessionItem> get aggregatedByProduct {
    final result = <String, AggregatedUserSessionItem>{};

    for (final item in items) {
      // Use productId:variantId as key for variants, productId for non-variants
      final key = item.variantId != null
          ? '${item.productId}:${item.variantId}'
          : item.productId;

      if (result.containsKey(key)) {
        final existing = result[key]!;
        result[key] = AggregatedUserSessionItem(
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
        result[key] = AggregatedUserSessionItem(
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
