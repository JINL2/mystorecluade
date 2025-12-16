import '../entities/session_item.dart';
import '../repositories/session_repository.dart';

/// Get inventory products with pagination
///
/// Matches RPC: get_inventory_page_v3
class GetInventoryPage {
  final SessionRepository _repository;

  GetInventoryPage(this._repository);

  Future<ProductSearchResponse> call({
    required String companyId,
    required String storeId,
    String? search,
    int page = 1,
    int limit = 15,
  }) {
    return _repository.getInventoryPage(
      companyId: companyId,
      storeId: storeId,
      search: search,
      page: page,
      limit: limit,
    );
  }
}
