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
  final String? imageUrl;
  final String? brand;
  final String? category;
  final int totalQuantity;
  final int totalRejected;
  final int previousStock;
  final List<ScannedByUser> scannedBy;
  /// Session type: 'counting' or 'receiving'
  /// Used to calculate newStock and stockChange differently
  final String sessionType;

  const SessionReviewItem({
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrl,
    this.brand,
    this.category,
    required this.totalQuantity,
    required this.totalRejected,
    this.previousStock = 0,
    required this.scannedBy,
    this.sessionType = 'receiving',
  });

  /// Get net quantity (total - rejected)
  int get netQuantity => totalQuantity - totalRejected;

  /// Get new stock after session
  /// Both counting and receiving add netQuantity to existing stock
  /// - Counting: previousStock + netQuantity (adding counted items to existing stock)
  /// - Receiving: previousStock + netQuantity (adding received items to existing stock)
  int get newStock => previousStock + netQuantity;

  /// Get stock change (difference between new and previous)
  int get stockChange => newStock - previousStock;
}

/// Summary of session items
class SessionReviewSummary {
  final int totalProducts;
  final int totalQuantity;
  final int totalRejected;
  final int totalParticipants;

  const SessionReviewSummary({
    required this.totalProducts,
    required this.totalQuantity,
    required this.totalRejected,
    this.totalParticipants = 0,
  });

  /// Get net quantity (total - rejected)
  int get netQuantity => totalQuantity - totalRejected;
}

/// Session participant (from inventory_get_session_items RPC)
class SessionParticipant {
  final String userId;
  final String userName;
  final String? userProfileImage;
  final int productCount;
  final int totalScanned;

  const SessionParticipant({
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.productCount,
    required this.totalScanned,
  });
}

/// Response wrapper for session review items
class SessionReviewResponse {
  final String sessionId;
  final List<SessionReviewItem> items;
  final List<SessionParticipant> participants;
  final SessionReviewSummary summary;

  const SessionReviewResponse({
    required this.sessionId,
    required this.items,
    required this.participants,
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
