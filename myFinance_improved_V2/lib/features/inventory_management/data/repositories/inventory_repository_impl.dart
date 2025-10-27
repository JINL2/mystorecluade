// Repository Implementation: Inventory Repository
// Implements domain repository interface using remote datasource

import '../../domain/entities/inventory_metadata.dart';
import '../../domain/entities/product.dart';
import '../../domain/exceptions/inventory_exceptions.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/value_objects/pagination_params.dart';
import '../../domain/value_objects/product_filter.dart';
import '../../domain/value_objects/sort_option.dart';
import '../datasources/inventory_remote_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource _remoteDataSource;

  InventoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<InventoryMetadata?> getMetadata({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final model = await _remoteDataSource.getMetadata(
        companyId: companyId,
        storeId: storeId,
      );
      return model.toEntity();
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get inventory metadata: $e',
        details: e,
      );
    }
  }

  @override
  Future<ProductPageResult?> getProducts({
    required String companyId,
    required String storeId,
    required PaginationParams pagination,
    ProductFilter? filter,
    SortOption? sortOption,
  }) async {
    try {
      final activeFilter = filter ?? const ProductFilter();
      final activeSort = sortOption ?? SortOption.defaultOption;

      final response = await _remoteDataSource.getProducts(
        companyId: companyId,
        storeId: storeId,
        page: pagination.page,
        limit: pagination.limit,
        search: activeFilter.searchQuery,
        sortBy: activeSort.field.dbFieldName,
        sortDirection: activeSort.direction.dbValue,
        categoryId: activeFilter.categoryId,
        brandId: activeFilter.brandId,
        stockStatus: activeFilter.stockStatus,
      );

      // Convert models to entities
      final products = response.products
          .map((model) => model.toEntity())
          .toList();

      // Create pagination result
      final paginationResult = PaginationResult(
        page: response.pagination.page,
        limit: response.pagination.limit,
        total: response.pagination.total,
        totalPages: response.pagination.totalPages,
        hasNext: response.pagination.hasNext,
        hasPrevious: response.pagination.page > 1,
      );

      // Create currency entity
      final currency = Currency(
        code: response.currency.code,
        name: response.currency.name,
        symbol: response.currency.symbol,
      );

      return ProductPageResult(
        products: products,
        pagination: paginationResult,
        currency: currency,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get products: $e',
        details: e,
      );
    }
  }

  @override
  Future<Product?> getProduct({
    required String productId,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final model = await _remoteDataSource.getProduct(
        productId: productId,
        companyId: companyId,
        storeId: storeId,
      );
      return model?.toEntity();
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get product: $e',
        details: e,
      );
    }
  }

  @override
  Future<Product?> createProduct({
    required String companyId,
    required String storeId,
    required String name,
    required String sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unit,
    double? costPrice,
    double? sellingPrice,
    int? initialQuantity,
    String? imageUrl,
    String? thumbnailUrl,
    List<String>? imageUrls,
  }) async {
    try {
      final model = await _remoteDataSource.createProduct(
        companyId: companyId,
        storeId: storeId,
        name: name,
        sku: sku,
        barcode: barcode,
        categoryId: categoryId,
        brandId: brandId,
        unit: unit,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        initialQuantity: initialQuantity,
        imageUrl: imageUrl,
        thumbnailUrl: thumbnailUrl,
        imageUrls: imageUrls,
      );
      return model.toEntity();
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to create product: $e',
        details: e,
      );
    }
  }

  @override
  Future<Product?> updateProduct({
    required String productId,
    required String companyId,
    required String storeId,
    required String sku,
    required String name,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unit,
    String? productType,
    double? costPrice,
    double? salePrice,
    int? onHand,
    int? minStock,
    int? maxStock,
    bool? isActive,
    String? description,
  }) async {
    try {
      final model = await _remoteDataSource.updateProduct(
        productId: productId,
        companyId: companyId,
        storeId: storeId,
        sku: sku,
        name: name,
        barcode: barcode,
        categoryId: categoryId,
        brandId: brandId,
        unit: unit,
        productType: productType,
        costPrice: costPrice,
        salePrice: salePrice,
        onHand: onHand,
        minStock: minStock,
        maxStock: maxStock,
        isActive: isActive,
        description: description,
      );
      return model.toEntity();
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to update product: $e',
        details: e,
      );
    }
  }

  @override
  Future<bool> deleteProducts({
    required List<String> productIds,
    required String companyId,
  }) async {
    try {
      return await _remoteDataSource.deleteProducts(
        productIds: productIds,
        companyId: companyId,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to delete products: $e',
        details: e,
      );
    }
  }

  @override
  Future<Category?> createCategory({
    required String companyId,
    required String categoryName,
    String? parentCategoryId,
  }) async {
    try {
      final data = await _remoteDataSource.createCategory(
        companyId: companyId,
        categoryName: categoryName,
        parentCategoryId: parentCategoryId,
      );

      return Category(
        id: (data['id'] ?? data['category_id'] ?? '') as String,
        name: (data['name'] ?? data['category_name'] ?? '') as String,
        parentId: data['parent_id'] as String?,
        productCount: data['product_count'] as int?,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to create category: $e',
        details: e,
      );
    }
  }

  @override
  Future<Brand?> createBrand({
    required String companyId,
    required String brandName,
    String? brandCode,
  }) async {
    try {
      final data = await _remoteDataSource.createBrand(
        companyId: companyId,
        brandName: brandName,
        brandCode: brandCode,
      );

      return Brand(
        id: (data['id'] ?? data['brand_id'] ?? '') as String,
        name: (data['name'] ?? data['brand_name'] ?? '') as String,
        productCount: data['product_count'] as int?,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to create brand: $e',
        details: e,
      );
    }
  }

  @override
  Future<bool> updateProductStock({
    required String productId,
    required String companyId,
    required String storeId,
    required int newStock,
    String? reason,
  }) async {
    try {
      return await _remoteDataSource.updateProductStock(
        productId: productId,
        companyId: companyId,
        storeId: storeId,
        newStock: newStock,
        reason: reason,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to update product stock: $e',
        details: e,
      );
    }
  }
}
