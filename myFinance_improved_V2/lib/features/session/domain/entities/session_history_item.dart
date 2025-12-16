/// Member info in session history
class SessionHistoryMember {
  final String oderId;
  final String userName;
  final String joinedAt;
  final bool isActive;

  const SessionHistoryMember({
    required this.oderId,
    required this.userName,
    required this.joinedAt,
    required this.isActive,
  });
}

/// Scanned by info for item
class ScannedByInfo {
  final String userId;
  final String userName;
  final int quantity;
  final int quantityRejected;

  const ScannedByInfo({
    required this.userId,
    required this.userName,
    required this.quantity,
    required this.quantityRejected,
  });
}

/// Item info in session history
class SessionHistoryItemDetail {
  final String productId;
  final String productName;
  final String? sku;

  /// Scanned by employees (from inventory_session_items)
  final int scannedQuantity;
  final int scannedRejected;
  final List<ScannedByInfo> scannedBy;

  /// Confirmed by manager (from receiving_items or counting_items)
  /// Null if session is still active (not submitted yet)
  final int? confirmedQuantity;
  final int? confirmedRejected;

  /// Counting specific fields
  final int? quantityExpected;
  final int? quantityDifference;

  const SessionHistoryItemDetail({
    required this.productId,
    required this.productName,
    this.sku,
    required this.scannedQuantity,
    required this.scannedRejected,
    required this.scannedBy,
    this.confirmedQuantity,
    this.confirmedRejected,
    this.quantityExpected,
    this.quantityDifference,
  });

  /// Check if manager has confirmed this item
  bool get hasConfirmed => confirmedQuantity != null;

  /// Check if manager changed the quantity (edited from scanned)
  bool get wasEdited => hasConfirmed && confirmedQuantity != scannedQuantity;

  /// Get the final quantity (confirmed if available, otherwise scanned)
  int get finalQuantity => confirmedQuantity ?? scannedQuantity;

  /// Get the final rejected (confirmed if available, otherwise scanned)
  int get finalRejected => confirmedRejected ?? scannedRejected;
}

/// Session history item entity from RPC response
class SessionHistoryItem {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  final bool isActive;
  final bool isFinal;

  final String storeId;
  final String storeName;

  final String? shipmentId;
  final String? shipmentNumber;

  final String createdAt;
  final String? completedAt;
  final int? durationMinutes;

  final String createdBy;
  final String createdByName;

  final List<SessionHistoryMember> members;
  final int memberCount;

  final List<SessionHistoryItemDetail> items;

  /// Totals - Scanned by employees
  final int totalScannedQuantity;
  final int totalScannedRejected;

  /// Totals - Confirmed by manager (null if not submitted)
  final int? totalConfirmedQuantity;
  final int? totalConfirmedRejected;

  /// Counting specific - total difference from expected
  final int? totalDifference;

  const SessionHistoryItem({
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.isActive,
    required this.isFinal,
    required this.storeId,
    required this.storeName,
    this.shipmentId,
    this.shipmentNumber,
    required this.createdAt,
    this.completedAt,
    this.durationMinutes,
    required this.createdBy,
    required this.createdByName,
    required this.members,
    required this.memberCount,
    required this.items,
    required this.totalScannedQuantity,
    required this.totalScannedRejected,
    this.totalConfirmedQuantity,
    this.totalConfirmedRejected,
    this.totalDifference,
  });

  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';

  /// Check if session has been submitted/confirmed
  bool get hasConfirmed => totalConfirmedQuantity != null;

  /// Get total items count
  int get totalItemsCount => items.length;

  /// Get final quantity (confirmed if available, otherwise scanned)
  int get totalQuantity => totalConfirmedQuantity ?? totalScannedQuantity;

  /// Get final rejected (confirmed if available, otherwise scanned)
  int get totalRejected => totalConfirmedRejected ?? totalScannedRejected;
}

/// Response wrapper for session history
class SessionHistoryResponse {
  final List<SessionHistoryItem> sessions;
  final int totalCount;
  final int limit;
  final int offset;

  const SessionHistoryResponse({
    required this.sessions,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  bool get hasMore => offset + sessions.length < totalCount;
}
