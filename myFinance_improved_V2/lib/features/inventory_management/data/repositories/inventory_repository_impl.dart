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

      // Map stockStatus to availability for v4 RPC
      // stockStatus values: 'in_stock', 'low_stock', 'out_of_stock'
      // availability values: 'in_stock', 'out_of_stock' (v4 RPC)
      String? availability;
      if (activeFilter.stockStatus == 'out_of_stock') {
        availability = 'out_of_stock';
      } else if (activeFilter.stockStatus == 'in_stock' || activeFilter.stockStatus == 'low_stock') {
        availability = 'in_stock';
      }

      final response = await _remoteDataSource.getProducts(
        companyId: companyId,
        storeId: storeId,
        page: pagination.page,
        limit: pagination.limit,
        search: activeFilter.searchQuery,
        categoryId: activeFilter.categoryId,
        brandId: activeFilter.brandId,
        availability: availability,
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
        serverTotalValue: response.summary.totalValue,
        filteredCount: response.summary.filteredCount,
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
    required String createdBy,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unit,
    double? costPrice,
    double? sellingPrice,
    int? initialQuantity,
    int? minStock,
    int? maxStock,
    List<String>? imageUrls,
  }) async {
    try {
      final model = await _remoteDataSource.createProduct(
        companyId: companyId,
        storeId: storeId,
        createdBy: createdBy,
        name: name,
        sku: sku,
        barcode: barcode,
        categoryId: categoryId,
        brandId: brandId,
        unit: unit,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        initialQuantity: initialQuantity,
        minStock: minStock,
        maxStock: maxStock,
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
  Future<CreateCheckResult> checkCreateProduct({
    required String companyId,
    required String productName,
    String? storeId,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
  }) async {
    try {
      final result = await _remoteDataSource.checkCreateProduct(
        companyId: companyId,
        productName: productName,
        storeId: storeId,
        sku: sku,
        barcode: barcode,
        categoryId: categoryId,
        brandId: brandId,
      );

      return CreateCheckResult(
        success: result.success,
        errorCode: result.errorCode,
        errorMessage: result.errorMessage,
        sku: result.data?.sku,
        barcode: result.data?.barcode,
        skuAutoGenerated: result.data?.autoGenerated.sku ?? false,
        barcodeAutoGenerated: result.data?.autoGenerated.barcode ?? false,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to validate product creation: $e',
        details: e,
      );
    }
  }

  @override
  Future<Product?> updateProduct({
    required String productId,
    required String companyId,
    required String storeId,
    required String createdBy,
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
    bool defaultPrice = false,
  }) async {
    try {
      final model = await _remoteDataSource.updateProduct(
        productId: productId,
        companyId: companyId,
        storeId: storeId,
        createdBy: createdBy,
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
        defaultPrice: defaultPrice,
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

  @override
  Future<MoveProductResult?> moveProduct({
    required String companyId,
    required String fromStoreId,
    required String toStoreId,
    required String productId,
    required int quantity,
    required String updatedBy,
    required String notes,
  }) async {
    try {
      final result = await _remoteDataSource.moveProduct(
        companyId: companyId,
        fromStoreId: fromStoreId,
        toStoreId: toStoreId,
        productId: productId,
        quantity: quantity,
        updatedBy: updatedBy,
        notes: notes,
      );

      return MoveProductResult(
        transferId: result.transferId,
        transferNumber: result.transferNumber,
        itemsCount: result.itemsCount,
        totalQuantity: result.totalQuantity,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to move product: $e',
        details: e,
      );
    }
  }

  @override
  Future<ProductStockByStoresResult?> getProductStockByStores({
    required String companyId,
    required List<String> productIds,
  }) async {
    try {
      final result = await _remoteDataSource.getProductStockByStores(
        companyId: companyId,
        productIds: productIds,
      );

      // Convert datasource model to domain entity
      final products = result.products.map((p) => ProductStoreStock(
        productId: p.productId,
        productName: p.productName,
        sku: p.sku,
        totalQuantity: p.totalQuantity,
        stores: p.stores.map((s) => StoreStock(
          storeId: s.storeId,
          storeName: s.storeName,
          quantityOnHand: s.quantityOnHand,
        )).toList(),
      )).toList();

      return ProductStockByStoresResult(products: products);
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get product stock by stores: $e',
        details: e,
      );
    }
  }

  @override
  Future<ProductHistoryPageResult?> getProductHistory({
    required String companyId,
    required String storeId,
    required String productId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final result = await _remoteDataSource.getProductHistory(
        companyId: companyId,
        storeId: storeId,
        productId: productId,
        page: page,
        pageSize: pageSize,
      );

      // Convert datasource model to domain entity
      final entries = result.data.map((item) => ProductHistoryEntry(
        logId: item.logId,
        eventCategory: item.eventCategory,
        eventType: item.eventType,
        quantityBefore: item.quantityBefore,
        quantityAfter: item.quantityAfter,
        quantityChange: item.quantityChange,
        costBefore: item.costBefore,
        costAfter: item.costAfter,
        sellingPriceBefore: item.sellingPriceBefore,
        sellingPriceAfter: item.sellingPriceAfter,
        minPriceBefore: item.minPriceBefore,
        minPriceAfter: item.minPriceAfter,
        nameBefore: item.nameBefore,
        nameAfter: item.nameAfter,
        skuBefore: item.skuBefore,
        skuAfter: item.skuAfter,
        barcodeBefore: item.barcodeBefore,
        barcodeAfter: item.barcodeAfter,
        brandIdBefore: item.brandIdBefore,
        brandIdAfter: item.brandIdAfter,
        brandNameBefore: item.brandNameBefore,
        brandNameAfter: item.brandNameAfter,
        categoryIdBefore: item.categoryIdBefore,
        categoryIdAfter: item.categoryIdAfter,
        categoryNameBefore: item.categoryNameBefore,
        categoryNameAfter: item.categoryNameAfter,
        weightBefore: item.weightBefore,
        weightAfter: item.weightAfter,
        invoiceId: item.invoiceId,
        invoiceNumber: item.invoiceNumber,
        transferId: item.transferId,
        fromStoreId: item.fromStoreId,
        fromStoreName: item.fromStoreName,
        toStoreId: item.toStoreId,
        toStoreName: item.toStoreName,
        reason: item.reason,
        notes: item.notes,
        createdBy: item.createdBy,
        createdUser: item.createdUser,
        createdUserProfileImage: item.createdUserProfileImage,
        createdAt: item.createdAt,
      )).toList();

      return ProductHistoryPageResult(
        entries: entries,
        totalCount: result.totalCount,
        page: result.page,
        pageSize: result.pageSize,
        totalPages: result.totalPages,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get product history: $e',
        details: e,
      );
    }
  }

  @override
  Future<BaseCurrencyResult?> getBaseCurrency({
    required String companyId,
  }) async {
    try {
      final result = await _remoteDataSource.getBaseCurrency(
        companyId: companyId,
      );

      // Convert datasource model to domain entity
      final baseCurrency = BaseCurrencyInfo(
        currencyId: result.baseCurrency.currencyId,
        currencyCode: result.baseCurrency.currencyCode,
        currencyName: result.baseCurrency.currencyName,
        symbol: result.baseCurrency.symbol,
        flagEmoji: result.baseCurrency.flagEmoji,
      );

      final companyCurrencies = result.companyCurrencies.map((c) => CompanyCurrencyInfo(
        currencyId: c.currencyId,
        currencyCode: c.currencyCode,
        currencyName: c.currencyName,
        symbol: c.symbol,
        flagEmoji: c.flagEmoji,
        exchangeRateToBase: c.exchangeRateToBase,
        rateDate: c.rateDate,
      )).toList();

      return BaseCurrencyResult(
        baseCurrency: baseCurrency,
        companyCurrencies: companyCurrencies,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get base currency: $e',
        details: e,
      );
    }
  }

  @override
  Future<InventoryHistoryPageResult?> getInventoryHistory({
    required String companyId,
    required String storeId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final result = await _remoteDataSource.getInventoryHistory(
        companyId: companyId,
        storeId: storeId,
        page: page,
        pageSize: pageSize,
      );

      // Convert datasource model to domain entity
      final entries = result.data.map((item) => InventoryHistoryEntry(
        logId: item.logId,
        eventCategory: item.eventCategory,
        eventType: item.eventType,
        productId: item.productId,
        productName: item.productName,
        productSku: item.productSku,
        productImage: item.productImage,
        storeId: item.storeId,
        storeName: item.storeName,
        quantityBefore: item.quantityBefore,
        quantityAfter: item.quantityAfter,
        quantityChange: item.quantityChange,
        costBefore: item.costBefore,
        costAfter: item.costAfter,
        sellingPriceBefore: item.sellingPriceBefore,
        sellingPriceAfter: item.sellingPriceAfter,
        minPriceBefore: item.minPriceBefore,
        minPriceAfter: item.minPriceAfter,
        nameBefore: item.nameBefore,
        nameAfter: item.nameAfter,
        skuBefore: item.skuBefore,
        skuAfter: item.skuAfter,
        barcodeBefore: item.barcodeBefore,
        barcodeAfter: item.barcodeAfter,
        brandIdBefore: item.brandIdBefore,
        brandIdAfter: item.brandIdAfter,
        brandNameBefore: item.brandNameBefore,
        brandNameAfter: item.brandNameAfter,
        categoryIdBefore: item.categoryIdBefore,
        categoryIdAfter: item.categoryIdAfter,
        categoryNameBefore: item.categoryNameBefore,
        categoryNameAfter: item.categoryNameAfter,
        weightBefore: item.weightBefore,
        weightAfter: item.weightAfter,
        invoiceId: item.invoiceId,
        invoiceNumber: item.invoiceNumber,
        transferId: item.transferId,
        fromStoreId: item.fromStoreId,
        fromStoreName: item.fromStoreName,
        toStoreId: item.toStoreId,
        toStoreName: item.toStoreName,
        reason: item.reason,
        notes: item.notes,
        createdBy: item.createdBy,
        createdUser: item.createdUser,
        createdUserProfileImage: item.createdUserProfileImage,
        createdAt: item.createdAt,
      )).toList();

      return InventoryHistoryPageResult(
        entries: entries,
        totalCount: result.totalCount,
        page: result.page,
        pageSize: result.pageSize,
        totalPages: result.totalPages,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get inventory history: $e',
        details: e,
      );
    }
  }
}
