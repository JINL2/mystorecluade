import '../entities/join_session_response.dart';
import '../repositories/session_repository.dart';

/// UseCase for joining an active session
class JoinSession {
  final SessionRepository _repository;

  JoinSession(this._repository);

  /// Join a session
  /// Returns JoinSessionResponse on success
  /// Throws Exception on failure (SESSION_NOT_FOUND, SESSION_CLOSED, USER_KICKED)
  Future<JoinSessionResponse> call({
    required String sessionId,
    required String userId,
  }) {
    return _repository.joinSession(
      sessionId: sessionId,
      userId: userId,
    );
  }
}
