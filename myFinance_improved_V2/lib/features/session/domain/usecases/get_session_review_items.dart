import '../entities/session_review_item.dart';
import '../repositories/session_repository.dart';

/// Get session items for review (aggregated by product with user breakdown)
///
/// Only session creator can call this
/// Matches RPC: inventory_get_session_review_items
class GetSessionReviewItems {
  final SessionRepository _repository;

  GetSessionReviewItems(this._repository);

  Future<SessionReviewResponse> call({
    required String sessionId,
    required String userId,
  }) {
    return _repository.getSessionReviewItems(
      sessionId: sessionId,
      userId: userId,
    );
  }
}
