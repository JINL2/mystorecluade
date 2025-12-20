import '../repositories/session_repository.dart';

/// UseCase for getting product stock by store
/// Returns a map of productId -> stock quantity
class GetProductStockByStore {
  final SessionRepository _repository;

  GetProductStockByStore(this._repository);

  /// Get stock quantities for products in a specific store
  Future<Map<String, int>> call({
    required String companyId,
    required String storeId,
    required List<String> productIds,
  }) {
    return _repository.getProductStockByStore(
      companyId: companyId,
      storeId: storeId,
      productIds: productIds,
    );
  }
}
