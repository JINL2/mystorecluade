import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_compare_result.freezed.dart';

/// Entity for compare item (product that exists in one session but not the other)
/// v2: Supports variant fields for variant-level comparison
@freezed
class SessionCompareItem with _$SessionCompareItem {
  const SessionCompareItem._();

  const factory SessionCompareItem({
    required String productId,
    required String productName,
    String? sku,
    String? barcode,
    String? imageUrl,
    String? brand,
    String? category,
    required int quantity,
    String? scannedByName,
    // v2 variant fields
    String? variantId,
    String? variantName,
    String? displayName,
    String? displaySku,
    @Default(false) bool hasVariants,
  }) = _SessionCompareItem;

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;

  /// Display SKU for UI - uses displaySku if available, otherwise sku
  String? get effectiveSku => displaySku ?? sku;
}

/// Entity for session info in compare result
@freezed
class SessionCompareInfo with _$SessionCompareInfo {
  const factory SessionCompareInfo({
    required String sessionId,
    required String sessionName,
    required String storeName,
    required String createdByName,
    required int totalProducts,
    required int totalQuantity,
  }) = _SessionCompareInfo;
}

/// Entity for session compare result
@freezed
class SessionCompareResult with _$SessionCompareResult {
  const SessionCompareResult._();

  const factory SessionCompareResult({
    required SessionCompareInfo sourceSession,
    required SessionCompareInfo targetSession,
    required List<SessionCompareItem> onlyInSource,
    required List<SessionCompareItem> onlyInTarget,
    required List<SessionCompareItem> inBoth,
  }) = _SessionCompareResult;

  /// Items that exist in target but not in source (items to potentially merge)
  int get itemsToMergeCount => onlyInTarget.length;

  /// Total quantity of items only in target
  int get quantityToMerge =>
      onlyInTarget.fold(0, (sum, item) => sum + item.quantity);
}
