import '../../domain/entities/join_session_response.dart';

/// Model for join session RPC response
class JoinSessionResponseModel {
  final String memberId;
  final String sessionId;
  final String userId;
  final String joinedAt;
  final String createdBy;
  final String createdByName;

  const JoinSessionResponseModel({
    required this.memberId,
    required this.sessionId,
    required this.userId,
    required this.joinedAt,
    required this.createdBy,
    required this.createdByName,
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

  JoinSessionResponse toEntity() {
    return JoinSessionResponse(
      memberId: memberId,
      sessionId: sessionId,
      userId: userId,
      joinedAt: joinedAt,
      createdBy: createdBy,
      createdByName: createdByName,
    );
  }
}
