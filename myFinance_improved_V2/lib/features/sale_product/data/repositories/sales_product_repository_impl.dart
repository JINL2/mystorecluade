import '../../domain/repositories/sales_product_repository.dart';
import '../datasources/sales_product_remote_datasource.dart';

/// Implementation of [SalesProductRepository]
class SalesProductRepositoryImpl implements SalesProductRepository {
  final SalesProductRemoteDataSource _remoteDataSource;

  SalesProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProductLoadResult> loadProducts({
    required String companyId,
    required String storeId,
    int page = 1,
    int limit = 100,
    String? search,
  }) async {
    final response = await _remoteDataSource.getInventoryProducts(
      companyId: companyId,
      storeId: storeId,
      page: page,
      limit: limit,
      search: search,
    );

    return ProductLoadResult(
      products: response.products.map((model) => model.toEntity()).toList(),
      totalCount: response.totalCount,
      hasNextPage: response.hasNextPage,
    );
  }

  @override
  Future<ProductLoadResult> refreshProducts({
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
