import '../../domain/entities/inventory_session.dart';

/// Data model for InventorySession with JSON serialization
class InventorySessionModel extends InventorySession {
  const InventorySessionModel({
    required super.sessionId,
    required super.sessionName,
    required super.sessionType,
    required super.storeId,
    required super.storeName,
    required super.status,
    required super.createdAt,
    super.completedAt,
    required super.createdBy,
    super.itemCount,
    super.notes,
  });

  factory InventorySessionModel.fromJson(Map<String, dynamic> json) {
    return InventorySessionModel(
      sessionId: json['session_id']?.toString() ?? json['id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? json['name']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? 'counting',
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'].toString())
          : null,
      createdBy: json['created_by']?.toString() ?? '',
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'session_name': sessionName,
      'session_type': sessionType,
      'store_id': storeId,
      'store_name': storeName,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_by': createdBy,
      'item_count': itemCount,
      'notes': notes,
    };
  }

  InventorySession toEntity() => this;
}
