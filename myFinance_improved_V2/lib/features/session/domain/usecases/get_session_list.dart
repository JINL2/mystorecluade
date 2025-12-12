import '../entities/session_list_item.dart';
import '../repositories/session_repository.dart';

/// Get session list for a company
///
/// Matches RPC: inventory_get_session_list
class GetSessionList {
  final SessionRepository _repository;

  GetSessionList(this._repository);

  Future<SessionListResponse> call({
    required String companyId,
    String? storeId,
    String? sessionType,
    String? shipmentId,
    bool? isActive,
    String? createdBy,
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.getSessionList(
      companyId: companyId,
      storeId: storeId,
      sessionType: sessionType,
      shipmentId: shipmentId,
      isActive: isActive,
      createdBy: createdBy,
      limit: limit,
      offset: offset,
    );
  }
}
