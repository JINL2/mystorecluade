import '../entities/close_session_response.dart';
import '../repositories/session_repository.dart';

/// UseCase for closing a session without saving/submitting data
class CloseSession {
  final SessionRepository _repository;

  CloseSession(this._repository);

  /// Close a session
  /// Returns CloseSessionResponse on success
  /// Throws Exception on failure (SESSION_NOT_FOUND, SESSION_ALREADY_CLOSED, PERMISSION_DENIED)
  Future<CloseSessionResponse> call({
    required String sessionId,
    required String userId,
    required String companyId,
  }) {
    return _repository.closeSession(
      sessionId: sessionId,
      userId: userId,
      companyId: companyId,
    );
  }
}
