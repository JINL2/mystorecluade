/// Response from closing a session via RPC
class CloseSessionResponse {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  final String closedAt;

  const CloseSessionResponse({
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.closedAt,
  });
}
