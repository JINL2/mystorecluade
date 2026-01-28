import '../../domain/entities/inventory_session.dart';

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
