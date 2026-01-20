import '../../domain/entities/session_list_item.dart';

/// Model for SessionListItem with JSON parsing
/// v2: Added status, supplier_id, supplier_name fields
class SessionListItemModel {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  /// Session status: 'in_progress', 'complete', 'cancelled'
  final String status;
  final String storeId;
  final String storeName;
  final String? shipmentId;
  final String? shipmentNumber;
  /// v2: Supplier info (via shipment connection)
  final String? supplierId;
  final String? supplierName;
  final bool isActive;
  final bool isFinal;
  final int memberCount;
  final String createdBy;
  final String createdByName;
  final String? completedAt;
  final String createdAt;

  const SessionListItemModel({
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.status,
    required this.storeId,
    required this.storeName,
    this.shipmentId,
    this.shipmentNumber,
    this.supplierId,
    this.supplierName,
    required this.isActive,
    required this.isFinal,
    required this.memberCount,
    required this.createdBy,
    required this.createdByName,
    this.completedAt,
    required this.createdAt,
  });

  factory SessionListItemModel.fromJson(Map<String, dynamic> json) {
    return SessionListItemModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? '',
      status: json['status']?.toString() ?? 'in_progress',
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      shipmentId: json['shipment_id']?.toString(),
      shipmentNumber: json['shipment_number']?.toString(),
      supplierId: json['supplier_id']?.toString(),
      supplierName: json['supplier_name']?.toString(),
      isActive: json['is_active'] as bool? ?? false,
      isFinal: json['is_final'] as bool? ?? false,
      memberCount: json['member_count'] as int? ?? 0,
      createdBy: json['created_by']?.toString() ?? '',
      createdByName: json['created_by_name']?.toString() ?? '',
      completedAt: json['completed_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'session_name': sessionName,
      'session_type': sessionType,
      'status': status,
      'store_id': storeId,
      'store_name': storeName,
      'shipment_id': shipmentId,
      'shipment_number': shipmentNumber,
      'supplier_id': supplierId,
      'supplier_name': supplierName,
      'is_active': isActive,
      'is_final': isFinal,
      'member_count': memberCount,
      'created_by': createdBy,
      'created_by_name': createdByName,
      'completed_at': completedAt,
      'created_at': createdAt,
    };
  }

  SessionListItem toEntity() {
    return SessionListItem(
      sessionId: sessionId,
      sessionName: sessionName,
      sessionType: sessionType,
      status: status,
      storeId: storeId,
      storeName: storeName,
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      supplierId: supplierId,
      supplierName: supplierName,
      isActive: isActive,
      isFinal: isFinal,
      memberCount: memberCount,
      createdBy: createdBy,
      createdByName: createdByName,
      completedAt: completedAt,
      createdAt: createdAt,
    );
  }
}

/// Model for SessionListResponse with JSON parsing
class SessionListResponseModel {
  final List<SessionListItemModel> sessions;
  final int totalCount;
  final int limit;
  final int offset;

  const SessionListResponseModel({
    required this.sessions,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  factory SessionListResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((e) => SessionListItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionListResponseModel(
      sessions: dataList,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );
  }

  SessionListResponse toEntity() {
    return SessionListResponse(
      sessions: sessions.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      limit: limit,
      offset: offset,
    );
  }
}
