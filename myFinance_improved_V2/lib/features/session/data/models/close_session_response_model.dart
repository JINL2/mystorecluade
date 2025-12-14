import '../../domain/entities/close_session_response.dart';

/// Model for close session RPC response
class CloseSessionResponseModel extends CloseSessionResponse {
  const CloseSessionResponseModel({
    required super.sessionId,
    required super.sessionName,
    required super.sessionType,
    required super.closedAt,
  });

  factory CloseSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return CloseSessionResponseModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? '',
      closedAt: json['closed_at']?.toString() ?? '',
    );
  }
}
