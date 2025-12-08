// Repository Implementation: Inventory Repository
// Implements domain repository interface using remote datasource

import '../../domain/entities/inventory_metadata.dart';
import '../../domain/entities/product.dart';
import '../../domain/exceptions/inventory_exceptions.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/value_objects/image_file.dart';
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
      // Note: sortOption is kept in interface for future RPC support
      // Currently sorting is handled client-side in Presentation layer

      final response = await _remoteDataSource.getProducts(
        companyId: companyId,
        storeId: storeId,
        page: pagination.page,
        limit: pagination.limit,
        search: activeFilter.searchQuery,
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
  Future<Product?> createProduct({
    required String companyId,
    required String storeId,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unit,
    double? costPrice,
    double? sellingPrice,
    int? initialQuantity,
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
  Future<EditCheckResult> checkEditProduct({
    required String productId,
    required String companyId,
    String? sku,
    String? productName,
  }) async {
    try {
      final result = await _remoteDataSource.checkEditProduct(
        productId: productId,
        companyId: companyId,
        sku: sku,
        productName: productName,
      );

      return EditCheckResult(
        success: result.success,
        errorCode: result.error?.code,
        errorMessage: result.error?.message,
        productExists: result.validations.productExists,
        nameAvailable: result.validations.nameAvailable,
        skuAvailable: result.validations.skuAvailable,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to validate product edit: $e',
        details: e,
      );
    }
  }

  @override
  Future<Product?> updateProduct({
    required String productId,
    required String companyId,
    required String storeId,
    String? sku,
    String? name,
    String? categoryId,
    String? brandId,
    String? unit,
    String? productType,
    double? costPrice,
    double? salePrice,
    int? onHand,
    String? flowType,
    List<String>? imageUrls,
  }) async {
    try {
      final model = await _remoteDataSource.updateProduct(
        productId: productId,
        companyId: companyId,
        storeId: storeId,
        sku: sku,
        name: name,
        categoryId: categoryId,
        brandId: brandId,
        unit: unit,
        productType: productType,
        costPrice: costPrice,
        salePrice: salePrice,
        onHand: onHand,
        flowType: flowType,
        imageUrls: imageUrls,
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
  Future<List<String>> uploadProductImages({
    required String companyId,
    required List<ImageFile> images,
  }) async {
    try {
      return await _remoteDataSource.uploadProductImages(
        companyId: companyId,
        images: images,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to upload images: $e',
        details: e,
      );
    }
  }
}
