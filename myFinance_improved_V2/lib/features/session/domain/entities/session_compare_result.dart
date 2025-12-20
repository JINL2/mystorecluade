import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_compare_result.freezed.dart';

/// Entity for compare item (product that exists in one session but not the other)
@freezed
class SessionCompareItem with _$SessionCompareItem {
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
  }) = _SessionCompareItem;
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
