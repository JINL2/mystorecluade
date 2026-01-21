import '../entities/session_history_item.dart';
import '../repositories/session_repository.dart';

/// Get session history for a company
///
/// Matches RPC: inventory_get_session_history
class GetSessionHistory {
  final SessionRepository _repository;

  GetSessionHistory(this._repository);

  Future<SessionHistoryResponse> call({
    required String companyId,
    String? storeId,
    String? sessionType,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    int limit = 15,
    int offset = 0,
  }) {
    return _repository.getSessionHistory(
      companyId: companyId,
      storeId: storeId,
      sessionType: sessionType,
      isActive: isActive,
      startDate: startDate,
      endDate: endDate,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }
}
