import '../entities/session_list_item.dart';
import '../repositories/session_repository.dart';

/// Get session list for a company
///
/// Matches RPC: inventory_get_session_list_v2
/// v2: Replaced isActive with status, added supplier/date filters
class GetSessionList {
  final SessionRepository _repository;

  GetSessionList(this._repository);

  Future<SessionListResponse> call({
    required String companyId,
    String? storeId,
    String? sessionType,
    String? shipmentId,
    /// v2: Status filter ('in_progress', 'complete', 'cancelled')
    String? status,
    String? supplierId,
    DateTime? startDate,
    DateTime? endDate,
    String? createdBy,
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.getSessionList(
      companyId: companyId,
      storeId: storeId,
      sessionType: sessionType,
      shipmentId: shipmentId,
      status: status,
      supplierId: supplierId,
      startDate: startDate,
      endDate: endDate,
      createdBy: createdBy,
      limit: limit,
      offset: offset,
    );
  }
}
