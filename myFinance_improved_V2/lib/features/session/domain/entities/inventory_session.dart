/// Inventory session entity for counting/receiving operations
class InventorySession {
  final String sessionId;
  final String sessionName;
  final String sessionType; // 'counting' or 'receiving'
  final String storeId;
  final String storeName;
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? completedAt;
  final String createdBy;
  final int itemCount;
  final String? notes;

  const InventorySession({
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.storeId,
    required this.storeName,
    required this.status,
    required this.createdAt,
    this.completedAt,
    required this.createdBy,
    this.itemCount = 0,
    this.notes,
  });

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';

  InventorySession copyWith({
    String? sessionId,
    String? sessionName,
    String? sessionType,
    String? storeId,
    String? storeName,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? createdBy,
    int? itemCount,
    String? notes,
  }) {
    return InventorySession(
      sessionId: sessionId ?? this.sessionId,
      sessionName: sessionName ?? this.sessionName,
      sessionType: sessionType ?? this.sessionType,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      createdBy: createdBy ?? this.createdBy,
      itemCount: itemCount ?? this.itemCount,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'InventorySession(sessionId: $sessionId, sessionName: $sessionName, sessionType: $sessionType, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InventorySession && other.sessionId == sessionId;
  }

  @override
  int get hashCode => sessionId.hashCode;
}
