import '../../domain/entities/session_history_item.dart';

/// Model for SessionHistoryMember
class SessionHistoryMemberModel {
  final String oderId;
  final String userName;
  final String joinedAt;
  final bool isActive;

  const SessionHistoryMemberModel({
    required this.oderId,
    required this.userName,
    required this.joinedAt,
    required this.isActive,
  });

  factory SessionHistoryMemberModel.fromJson(Map<String, dynamic> json) {
    return SessionHistoryMemberModel(
      oderId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      joinedAt: json['joined_at']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  SessionHistoryMember toEntity() {
    return SessionHistoryMember(
      oderId: oderId,
      userName: userName,
      joinedAt: joinedAt,
      isActive: isActive,
    );
  }
}

/// Model for ScannedByInfo
class ScannedByInfoModel {
  final String userId;
  final String userName;
  final int quantity;
  final int quantityRejected;

  const ScannedByInfoModel({
    required this.userId,
    required this.userName,
    required this.quantity,
    required this.quantityRejected,
  });

  factory ScannedByInfoModel.fromJson(Map<String, dynamic> json) {
    return ScannedByInfoModel(
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
    );
  }

  ScannedByInfo toEntity() {
    return ScannedByInfo(
      userId: userId,
      userName: userName,
      quantity: quantity,
      quantityRejected: quantityRejected,
    );
  }
}

/// Model for SessionHistoryItemDetail
class SessionHistoryItemDetailModel {
  final String productId;
  final String productName;
  final String? sku;
  final int scannedQuantity;
  final int scannedRejected;
  final List<ScannedByInfoModel> scannedBy;
  final int? confirmedQuantity;
  final int? confirmedRejected;
  final int? quantityExpected;
  final int? quantityDifference;

  const SessionHistoryItemDetailModel({
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

  factory SessionHistoryItemDetailModel.fromJson(Map<String, dynamic> json) {
    final scannedByList = (json['scanned_by'] as List<dynamic>? ?? [])
        .map((e) => ScannedByInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionHistoryItemDetailModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      scannedQuantity: (json['scanned_quantity'] as num?)?.toInt() ?? 0,
      scannedRejected: (json['scanned_rejected'] as num?)?.toInt() ?? 0,
      scannedBy: scannedByList,
      confirmedQuantity: (json['confirmed_quantity'] as num?)?.toInt(),
      confirmedRejected: (json['confirmed_rejected'] as num?)?.toInt(),
      quantityExpected: (json['quantity_expected'] as num?)?.toInt(),
      quantityDifference: (json['quantity_difference'] as num?)?.toInt(),
    );
  }

  SessionHistoryItemDetail toEntity() {
    return SessionHistoryItemDetail(
      productId: productId,
      productName: productName,
      sku: sku,
      scannedQuantity: scannedQuantity,
      scannedRejected: scannedRejected,
      scannedBy: scannedBy.map((e) => e.toEntity()).toList(),
      confirmedQuantity: confirmedQuantity,
      confirmedRejected: confirmedRejected,
      quantityExpected: quantityExpected,
      quantityDifference: quantityDifference,
    );
  }
}

/// Model for SessionHistoryItem
class SessionHistoryItemModel {
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
  final List<SessionHistoryMemberModel> members;
  final int memberCount;
  final List<SessionHistoryItemDetailModel> items;
  final int totalScannedQuantity;
  final int totalScannedRejected;
  final int? totalConfirmedQuantity;
  final int? totalConfirmedRejected;
  final int? totalDifference;

  const SessionHistoryItemModel({
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
      totalScannedQuantity: (json['total_scanned_quantity'] as num?)?.toInt() ?? 0,
      totalScannedRejected: (json['total_scanned_rejected'] as num?)?.toInt() ?? 0,
      totalConfirmedQuantity: (json['total_confirmed_quantity'] as num?)?.toInt(),
      totalConfirmedRejected: (json['total_confirmed_rejected'] as num?)?.toInt(),
      totalDifference: (json['total_difference'] as num?)?.toInt(),
    );
  }

  SessionHistoryItem toEntity() {
    return SessionHistoryItem(
      sessionId: sessionId,
      sessionName: sessionName,
      sessionType: sessionType,
      isActive: isActive,
      isFinal: isFinal,
      storeId: storeId,
      storeName: storeName,
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      createdAt: createdAt,
      completedAt: completedAt,
      durationMinutes: durationMinutes,
      createdBy: createdBy,
      createdByName: createdByName,
      members: members.map((e) => e.toEntity()).toList(),
      memberCount: memberCount,
      items: items.map((e) => e.toEntity()).toList(),
      totalScannedQuantity: totalScannedQuantity,
      totalScannedRejected: totalScannedRejected,
      totalConfirmedQuantity: totalConfirmedQuantity,
      totalConfirmedRejected: totalConfirmedRejected,
      totalDifference: totalDifference,
    );
  }
}

/// Model for SessionHistoryResponse
class SessionHistoryResponseModel {
  final List<SessionHistoryItemModel> sessions;
  final int totalCount;
  final int limit;
  final int offset;

  const SessionHistoryResponseModel({
    required this.sessions,
    required this.totalCount,
    required this.limit,
    required this.offset,
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

  SessionHistoryResponse toEntity() {
    return SessionHistoryResponse(
      sessions: sessions.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      limit: limit,
      offset: offset,
    );
  }
}
