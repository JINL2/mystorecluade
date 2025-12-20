import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_item.freezed.dart';

/// Item added to an inventory session
@freezed
class SessionItem with _$SessionItem {
  const SessionItem._();

  const factory SessionItem({
    required String itemId,
    required String sessionId,
    required String productId,
    required String productName,
    String? sku,
    String? barcode,
    String? imageUrl,
    required int quantity,
    double? unitPrice,
    required DateTime addedAt,
    String? notes,
  }) = _SessionItem;

  double get totalPrice => (unitPrice ?? 0) * quantity;
}

/// Input for adding items to a session
@freezed
class SessionItemInput with _$SessionItemInput {
  const SessionItemInput._();

  const factory SessionItemInput({
    required String productId,
    required int quantity,
    @Default(0) int quantityRejected,
  }) = _SessionItemInput;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        'quantity_rejected': quantityRejected,
      };
}

/// Response for adding session items
@freezed
class AddSessionItemsResponse with _$AddSessionItemsResponse {
  const factory AddSessionItemsResponse({
    required bool success,
    String? message,
    @Default(0) int itemsAdded,
  }) = _AddSessionItemsResponse;
}

/// Product search result for session
@freezed
class ProductSearchResult with _$ProductSearchResult {
  const factory ProductSearchResult({
    required String productId,
    required String productName,
    String? sku,
    String? barcode,
    String? imageUrl,
    String? brandName,
    String? categoryName,
    @Default(0) double sellingPrice,
    @Default(0) int currentStock,
  }) = _ProductSearchResult;
}

/// Response for product search with pagination
@freezed
class ProductSearchResponse with _$ProductSearchResponse {
  const factory ProductSearchResponse({
    required List<ProductSearchResult> products,
    @Default(0) int totalCount,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(1) int totalPages,
    @Default(false) bool hasNext,
  }) = _ProductSearchResponse;
}
