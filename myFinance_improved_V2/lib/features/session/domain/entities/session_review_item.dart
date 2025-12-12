/// User who scanned items in a session
class ScannedByUser {
  final String userId;
  final String userName;
  final int quantity;
  final int quantityRejected;

  const ScannedByUser({
    required this.userId,
    required this.userName,
    required this.quantity,
    required this.quantityRejected,
  });
}

/// Individual item in session review
class SessionReviewItem {
  final String productId;
  final String productName;
  final String? sku;
  final int totalQuantity;
  final int totalRejected;
  final List<ScannedByUser> scannedBy;

  const SessionReviewItem({
    required this.productId,
    required this.productName,
    this.sku,
    required this.totalQuantity,
    required this.totalRejected,
    required this.scannedBy,
  });

  /// Get net quantity (total - rejected)
  int get netQuantity => totalQuantity - totalRejected;
}

/// Summary of session items
class SessionReviewSummary {
  final int totalProducts;
  final int totalQuantity;
  final int totalRejected;

  const SessionReviewSummary({
    required this.totalProducts,
    required this.totalQuantity,
    required this.totalRejected,
  });

  /// Get net quantity (total - rejected)
  int get netQuantity => totalQuantity - totalRejected;
}

/// Response wrapper for session review items
class SessionReviewResponse {
  final String sessionId;
  final List<SessionReviewItem> items;
  final SessionReviewSummary summary;

  const SessionReviewResponse({
    required this.sessionId,
    required this.items,
    required this.summary,
  });
}

/// Item to submit in session
class SessionSubmitItem {
  final String productId;
  final int quantity;
  final int quantityRejected;

  const SessionSubmitItem({
    required this.productId,
    required this.quantity,
    this.quantityRejected = 0,
  });

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        'quantity_rejected': quantityRejected,
      };
}

/// Response from session submit
class SessionSubmitResponse {
  final String receivingId;
  final String receivingNumber;
  final String sessionId;
  final bool isFinal;
  final int itemsCount;
  final int totalQuantity;
  final int totalRejected;
  final bool stockUpdated;

  const SessionSubmitResponse({
    required this.receivingId,
    required this.receivingNumber,
    required this.sessionId,
    required this.isFinal,
    required this.itemsCount,
    required this.totalQuantity,
    required this.totalRejected,
    required this.stockUpdated,
  });
}
