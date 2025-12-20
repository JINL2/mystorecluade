import '../repositories/session_repository.dart';

/// Merge source session into target session
///
/// - Copies all items from source to target with source_session_id tracking
/// - Adds source's members to target (skips duplicates)
/// - Deactivates source session
/// Matches RPC: inventory_merge_sessions
class MergeSessions {
  final SessionRepository _repository;

  MergeSessions(this._repository);

  Future<void> call({
    required String targetSessionId,
    required String sourceSessionId,
    required String userId,
  }) {
    return _repository.mergeSessions(
      targetSessionId: targetSessionId,
      sourceSessionId: sourceSessionId,
      userId: userId,
    );
  }
}
