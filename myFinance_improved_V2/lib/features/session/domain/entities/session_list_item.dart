/// Session list item entity from RPC response
class SessionListItem {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  final String storeId;
  final String storeName;
  final String? shipmentId;
  final String? shipmentNumber;
  final bool isActive;
  final bool isFinal;
  final int memberCount;
  final String createdBy;
  final String createdByName;
  final String? completedAt;
  final String createdAt;

  const SessionListItem({
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.storeId,
    required this.storeName,
    this.shipmentId,
    this.shipmentNumber,
    required this.isActive,
    required this.isFinal,
    required this.memberCount,
    required this.createdBy,
    required this.createdByName,
    this.completedAt,
    required this.createdAt,
  });

  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';
}

/// Response wrapper for session list
class SessionListResponse {
  final List<SessionListItem> sessions;
  final int totalCount;
  final int limit;
  final int offset;

  const SessionListResponse({
    required this.sessions,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  bool get hasMore => offset + sessions.length < totalCount;
}
