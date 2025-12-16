import '../entities/user_session_items.dart';
import '../repositories/session_repository.dart';

/// Get individual items added by a specific user in a session
///
/// Returns each item_id separately (no grouping by product_id)
/// Matches RPC: inventory_get_user_session_items
class GetUserSessionItems {
  final SessionRepository _repository;

  GetUserSessionItems(this._repository);

  Future<UserSessionItemsResponse> call({
    required String sessionId,
    required String userId,
  }) {
    return _repository.getUserSessionItems(
      sessionId: sessionId,
      userId: userId,
    );
  }
}
