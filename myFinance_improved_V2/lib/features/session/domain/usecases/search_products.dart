import '../entities/session_item.dart';
import '../repositories/session_repository.dart';

/// Search products for session item selection
///
/// Matches RPC: get_inventory_page_v3
class SearchProducts {
  final SessionRepository _repository;

  SearchProducts(this._repository);

  Future<ProductSearchResponse> call({
    required String companyId,
    required String storeId,
    required String query,
    int limit = 20,
  }) {
    return _repository.searchProducts(
      companyId: companyId,
      storeId: storeId,
      query: query,
      limit: limit,
    );
  }
}
