import '../../domain/entities/session_history_item.dart';

/// Model for SessionHistoryMember
class SessionHistoryMemberModel extends SessionHistoryMember {
  const SessionHistoryMemberModel({
    required super.oderId,
    required super.userName,
    required super.joinedAt,
    required super.isActive,
  });

  factory SessionHistoryMemberModel.fromJson(Map<String, dynamic> json) {
    return SessionHistoryMemberModel(
      oderId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      joinedAt: json['joined_at']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}

/// Model for ScannedByInfo
class ScannedByInfoModel extends ScannedByInfo {
  const ScannedByInfoModel({
    required super.userId,
    required super.userName,
    required super.quantity,
    required super.quantityRejected,
  });

  factory ScannedByInfoModel.fromJson(Map<String, dynamic> json) {
    return ScannedByInfoModel(
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Model for SessionHistoryItemDetail
class SessionHistoryItemDetailModel extends SessionHistoryItemDetail {
  const SessionHistoryItemDetailModel({
    required super.productId,
    required super.productName,
    super.sku,
    required super.totalQuantity,
    required super.totalRejected,
    required super.scannedBy,
  });

  factory SessionHistoryItemDetailModel.fromJson(Map<String, dynamic> json) {
    final scannedByList = (json['scanned_by'] as List<dynamic>? ?? [])
        .map((e) => ScannedByInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionHistoryItemDetailModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
      scannedBy: scannedByList,
    );
  }
}

/// Model for SessionHistoryItem
class SessionHistoryItemModel extends SessionHistoryItem {
  const SessionHistoryItemModel({
    required super.sessionId,
    required super.sessionName,
    required super.sessionType,
    required super.isActive,
    required super.isFinal,
    required super.storeId,
    required super.storeName,
    super.shipmentId,
    super.shipmentNumber,
    required super.createdAt,
    super.completedAt,
    super.durationMinutes,
    required super.createdBy,
    required super.createdByName,
    required super.members,
    required super.memberCount,
    required super.items,
    required super.totalItemsCount,
    required super.totalQuantity,
    required super.totalRejected,
  });

  factory SessionHistoryItemModel.fromJson(Map<String, dynamic> json) {
    final membersList = (json['members'] as List<dynamic>? ?? [])
        .map((e) => SessionHistoryMemberModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final itemsList = (json['items'] as List<dynamic>? ?? [])
        .map((e) => SessionHistoryItemDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionHistoryItemModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? false,
      isFinal: json['is_final'] as bool? ?? false,
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      shipmentId: json['shipment_id']?.toString(),
      shipmentNumber: json['shipment_number']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      completedAt: json['completed_at']?.toString(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      createdBy: json['created_by']?.toString() ?? '',
      createdByName: json['created_by_name']?.toString() ?? '',
      members: membersList,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      items: itemsList,
      totalItemsCount: (json['total_items_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Model for SessionHistoryResponse
class SessionHistoryResponseModel extends SessionHistoryResponse {
  const SessionHistoryResponseModel({
    required super.sessions,
    required super.totalCount,
    required super.limit,
    required super.offset,
  });

  factory SessionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((e) => SessionHistoryItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionHistoryResponseModel(
      sessions: dataList,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );
  }
}
