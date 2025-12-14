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
  final int totalQuantity;
  final int totalRejected;
  final List<ScannedByInfo> scannedBy;

  const SessionHistoryItemDetail({
    required this.productId,
    required this.productName,
    this.sku,
    required this.totalQuantity,
    required this.totalRejected,
    required this.scannedBy,
  });
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
  final int totalItemsCount;
  final int totalQuantity;
  final int totalRejected;

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
    required this.totalItemsCount,
    required this.totalQuantity,
    required this.totalRejected,
  });

  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';
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
