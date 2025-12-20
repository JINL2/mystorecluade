/// Entity for compare item (product that exists in one session but not the other)
class SessionCompareItem {
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final String? brand;
  final String? category;
  final int quantity;
  final String? scannedByName;

  const SessionCompareItem({
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    this.brand,
    this.category,
    required this.quantity,
    this.scannedByName,
  });
}

/// Entity for session info in compare result
class SessionCompareInfo {
  final String sessionId;
  final String sessionName;
  final String storeName;
  final String createdByName;
  final int totalProducts;
  final int totalQuantity;

  const SessionCompareInfo({
    required this.sessionId,
    required this.sessionName,
    required this.storeName,
    required this.createdByName,
    required this.totalProducts,
    required this.totalQuantity,
  });
}

/// Entity for session compare result
class SessionCompareResult {
  final SessionCompareInfo sourceSession;
  final SessionCompareInfo targetSession;
  final List<SessionCompareItem> onlyInSource;
  final List<SessionCompareItem> onlyInTarget;
  final List<SessionCompareItem> inBoth;

  const SessionCompareResult({
    required this.sourceSession,
    required this.targetSession,
    required this.onlyInSource,
    required this.onlyInTarget,
    required this.inBoth,
  });

  /// Items that exist in target but not in source (items to potentially merge)
  int get itemsToMergeCount => onlyInTarget.length;

  /// Total quantity of items only in target
  int get quantityToMerge =>
      onlyInTarget.fold(0, (sum, item) => sum + item.quantity);
}
