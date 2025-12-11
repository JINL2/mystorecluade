import '../../domain/entities/session_list_item.dart';

/// Model for SessionListItem with JSON parsing
class SessionListItemModel extends SessionListItem {
  const SessionListItemModel({
    required super.sessionId,
    required super.sessionName,
    required super.sessionType,
    required super.storeId,
    required super.storeName,
    super.shipmentId,
    super.shipmentNumber,
    required super.isActive,
    required super.isFinal,
    required super.memberCount,
    required super.createdBy,
    required super.createdByName,
    super.completedAt,
    required super.createdAt,
  });

  factory SessionListItemModel.fromJson(Map<String, dynamic> json) {
    return SessionListItemModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      shipmentId: json['shipment_id']?.toString(),
      shipmentNumber: json['shipment_number']?.toString(),
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
      'store_id': storeId,
      'store_name': storeName,
      'shipment_id': shipmentId,
      'shipment_number': shipmentNumber,
      'is_active': isActive,
      'is_final': isFinal,
      'member_count': memberCount,
      'created_by': createdBy,
      'created_by_name': createdByName,
      'completed_at': completedAt,
      'created_at': createdAt,
    };
  }
}
