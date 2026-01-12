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
/// Supports v6 variants with variantId
@freezed
class SessionItemInput with _$SessionItemInput {
  const factory SessionItemInput({
    required String productId,
    required int quantity,
    @Default(0) int quantityRejected,
    String? variantId,
  }) = _SessionItemInput;
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
/// Supports v6 variant expansion - each variant is a separate row
@freezed
class ProductSearchResult with _$ProductSearchResult {
  const ProductSearchResult._();

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
    // v6 variant fields
    String? variantId,
    String? variantName,
    String? variantSku,
    String? variantBarcode,
    String? displayName,
    String? displaySku,
    String? displayBarcode,
    @Default(false) bool hasVariants,
  }) = _ProductSearchResult;

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;

  /// Display SKU for UI - uses displaySku if available, otherwise sku
  String? get effectiveSku => displaySku ?? sku;

  /// Display barcode for UI - uses displayBarcode if available, otherwise barcode
  String? get effectiveBarcode => displayBarcode ?? barcode;
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
