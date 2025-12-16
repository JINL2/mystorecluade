import '../entities/session_item.dart';
import '../entities/update_session_items_response.dart';
import '../repositories/session_repository.dart';

/// UseCase for updating or inserting session items
/// Uses inventory_update_session_item RPC which:
/// - Updates existing products (consolidates multiple items into one)
/// - Inserts new products
/// - Keeps products not in items list (no deletion)
class UpdateSessionItems {
  final SessionRepository _repository;

  UpdateSessionItems(this._repository);

  Future<UpdateSessionItemsResponse> call({
    required String sessionId,
    required String userId,
    required List<SessionItemInput> items,
  }) {
    return _repository.updateSessionItems(
      sessionId: sessionId,
      userId: userId,
      items: items,
    );
  }
}
