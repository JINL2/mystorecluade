import '../entities/session_item.dart';
import '../repositories/session_repository.dart';

/// Add multiple items to a session
///
/// Matches RPC: inventory_add_session_items
class AddSessionItems {
  final SessionRepository _repository;

  AddSessionItems(this._repository);

  Future<AddSessionItemsResponse> call({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  }) {
    return _repository.addSessionItems(
      sessionId: sessionId,
      userId: userId,
      items: items,
    );
  }
}
