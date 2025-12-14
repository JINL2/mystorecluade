/// Response from joining a session via RPC
class JoinSessionResponse {
  final String memberId;
  final String sessionId;
  final String userId;
  final String joinedAt;
  final String createdBy;
  final String createdByName;

  const JoinSessionResponse({
    required this.memberId,
    required this.sessionId,
    required this.userId,
    required this.joinedAt,
    required this.createdBy,
    required this.createdByName,
  });
}
