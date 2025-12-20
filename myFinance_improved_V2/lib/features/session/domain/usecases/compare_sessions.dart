import '../entities/session_compare_result.dart';
import '../repositories/session_repository.dart';

/// Use case for comparing two sessions
/// Returns items that exist in one session but not the other
class CompareSessions {
  final SessionRepository _repository;

  CompareSessions(this._repository);

  Future<SessionCompareResult> call({
    required String sourceSessionId,
    required String targetSessionId,
    required String userId,
  }) async {
    return _repository.compareSessions(
      sourceSessionId: sourceSessionId,
      targetSessionId: targetSessionId,
      userId: userId,
    );
  }
}
