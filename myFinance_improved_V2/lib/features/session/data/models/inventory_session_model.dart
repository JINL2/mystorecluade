import '../../domain/entities/inventory_session.dart';

/// Data model for InventorySession with JSON serialization
class InventorySessionModel {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  final String storeId;
  final String storeName;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String createdBy;
  final int itemCount;
  final String? notes;

  const InventorySessionModel({
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

  InventorySession toEntity() {
    return InventorySession(
      sessionId: sessionId,
      sessionName: sessionName,
      sessionType: sessionType,
      storeId: storeId,
      storeName: storeName,
      status: status,
      createdAt: createdAt,
      completedAt: completedAt,
      createdBy: createdBy,
      itemCount: itemCount,
      notes: notes,
    );
  }
}

/// Model for CreateSessionResponse with JSON serialization
class CreateSessionResponseModel {
  final String sessionId;
  final String? sessionName;
  final String sessionType;
  final String? shipmentId;
  final String? shipmentNumber;
  final bool isActive;
  final bool isFinal;
  final String createdBy;
  final String createdAt;

  const CreateSessionResponseModel({
    required this.sessionId,
    this.sessionName,
    required this.sessionType,
    this.shipmentId,
    this.shipmentNumber,
    required this.isActive,
    required this.isFinal,
    required this.createdBy,
    required this.createdAt,
  });

  factory CreateSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateSessionResponseModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString(),
      sessionType: json['session_type']?.toString() ?? '',
      shipmentId: json['shipment_id']?.toString(),
      shipmentNumber: json['shipment_number']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      isFinal: json['is_final'] as bool? ?? false,
      createdBy: json['created_by']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  CreateSessionResponse toEntity() {
    return CreateSessionResponse(
      sessionId: sessionId,
      sessionName: sessionName,
      sessionType: sessionType,
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      isActive: isActive,
      isFinal: isFinal,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }
}
