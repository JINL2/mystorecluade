import '../../domain/entities/close_session_response.dart';

/// Model for close session RPC response
class CloseSessionResponseModel {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  final String closedAt;

  const CloseSessionResponseModel({
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.closedAt,
  });

  factory CloseSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return CloseSessionResponseModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? '',
      closedAt: json['closed_at']?.toString() ?? '',
    );
  }

  CloseSessionResponse toEntity() {
    return CloseSessionResponse(
      sessionId: sessionId,
      sessionName: sessionName,
      sessionType: sessionType,
      closedAt: closedAt,
    );
  }
}
