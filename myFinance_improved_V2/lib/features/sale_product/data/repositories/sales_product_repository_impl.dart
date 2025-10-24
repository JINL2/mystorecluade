import '../../domain/entities/sales_product.dart';
import '../../domain/repositories/sales_product_repository.dart';
import '../datasources/sales_product_remote_datasource.dart';

/// Implementation of [SalesProductRepository]
class SalesProductRepositoryImpl implements SalesProductRepository {
  final SalesProductRemoteDataSource _remoteDataSource;

  SalesProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<SalesProduct>> loadProducts({
    required String companyId,
    required String storeId,
    int page = 1,
    int limit = 100,
    String? search,
  }) async {
    try {
      final products = await _remoteDataSource.getInventoryProducts(
        companyId: companyId,
        storeId: storeId,
        page: page,
        limit: limit,
        search: search,
      );

      return products.map((model) => model.toEntity()).toList();
    } catch (e) {
      print('❌ [SALES_REPOSITORY] Error loading products: $e');
      rethrow;
    }
  }

  @override
  Future<List<SalesProduct>> refreshProducts({
    required String companyId,
    required String storeId,
  }) async {
    return loadProducts(
      companyId: companyId,
      storeId: storeId,
      page: 1,
      limit: 100,
    );
  }
}
