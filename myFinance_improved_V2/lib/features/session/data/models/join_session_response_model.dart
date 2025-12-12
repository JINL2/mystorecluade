import '../../domain/entities/join_session_response.dart';

/// Model for join session RPC response
class JoinSessionResponseModel extends JoinSessionResponse {
  const JoinSessionResponseModel({
    required super.memberId,
    required super.sessionId,
    required super.userId,
    required super.joinedAt,
    required super.createdBy,
    required super.createdByName,
  });

  factory JoinSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinSessionResponseModel(
      memberId: json['member_id']?.toString() ?? '',
      sessionId: json['session_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      joinedAt: json['joined_at']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      createdByName: json['created_by_name']?.toString() ?? '',
    );
  }
}
