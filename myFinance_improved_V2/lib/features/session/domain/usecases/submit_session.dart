import '../entities/session_review_item.dart';
import '../repositories/session_repository.dart';

/// Submit session with confirmed items
///
/// Creates receiving record, updates inventory stock, and closes session
/// Only session creator can submit
/// Matches RPC: inventory_submit_session
class SubmitSession {
  final SessionRepository _repository;

  SubmitSession(this._repository);

  Future<SessionSubmitResponse> call({
    required String sessionId,
    required String userId,
    required List<SessionSubmitItem> items,
    bool isFinal = false,
    String? notes,
  }) {
    return _repository.submitSession(
      sessionId: sessionId,
      userId: userId,
      items: items,
      isFinal: isFinal,
      notes: notes,
    );
  }
}
