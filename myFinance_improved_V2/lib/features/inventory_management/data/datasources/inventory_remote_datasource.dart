// Remote DataSource: Inventory Remote DataSource
// Handles all RPC calls to Supabase for inventory management

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/inventory_exceptions.dart';
import '../models/inventory_metadata_model.dart';
import '../models/product_model.dart';

class InventoryRemoteDataSource {
  final SupabaseClient _client;

  InventoryRemoteDataSource(this._client);

  /// Get inventory metadata
  Future<InventoryMetadataModel> getMetadata({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
      };

      final response = await _client
          .rpc('get_inventory_metadata', params: params)
          .single() as Map<String, dynamic>;

      // Handle success wrapper if present
      final Map<String, dynamic> dataToProcess;
      if (response.containsKey('success')) {
        if (response['success'] == true) {
          dataToProcess = response['data'] as Map<String, dynamic>? ?? {};
        } else {
          throw InventoryRepositoryException(
            message: response['error']?.toString() ?? 'Failed to fetch metadata',
            details: response['error'],
          );
        }
      } else {
        dataToProcess = response;
      }

      return InventoryMetadataModel.fromJson(dataToProcess);
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to fetch inventory metadata: $e',
        details: e,
      );
    }
  }

  /// Get paginated list of products
  Future<ProductPageResponse> getProducts({
    required String companyId,
    required String storeId,
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortDirection,
    String? categoryId,
    String? brandId,
    String? stockStatus,
  }) async {
    try {
      // Build params - only use parameters supported by the RPC function
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': page,
        'p_limit': limit,
        'p_search': search ?? '',
      };

      final response = await _client
          .rpc('get_inventory_page', params: params)
          .single() as Map<String, dynamic>;

      // Handle success wrapper if present
      final Map<String, dynamic> dataToProcess;
      if (response.containsKey('success')) {
        if (response['success'] == true) {
          dataToProcess = response['data'] as Map<String, dynamic>? ?? {};
        } else {
          throw InventoryRepositoryException(
            message: response['error']?.toString() ?? 'Failed to fetch products',
            details: response['error'],
          );
        }
      } else {
        dataToProcess = response;
      }

      // Ensure required fields exist
      dataToProcess['products'] = dataToProcess['products'] ?? [];
      dataToProcess['pagination'] = dataToProcess['pagination'] ??
          {
            'page': page,
            'limit': limit,
            'total': 0,
            'has_next': false,
            'total_pages': 0,
          };
      dataToProcess['currency'] = dataToProcess['currency'] ??
          {
            'code': null,
            'name': null,
            'symbol': null,
          };

      return ProductPageResponse.fromJson(dataToProcess);
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to fetch products: $e',
        details: e,
      );
    }
  }

  /// Get single product details
  Future<ProductModel?> getProduct({
    required String productId,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _client.rpc('get_product_details', params: {
        'p_product_id': productId,
        'p_company_id': companyId,
        'p_store_id': storeId,
      }).single() as Map<String, dynamic>;

      if (response['success'] == true) {
        return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
      }
      return null;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw ProductNotFoundException(productId: productId);
      }
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to fetch product: $e',
        details: e,
      );
    }
  }

  /// Create new product
  Future<ProductModel> createProduct({
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
      final params = {
        'p_company_id': companyId,
        'p_product_name': name,
        'p_store_id': storeId,
        'p_sku': sku,
        'p_barcode': barcode,
        'p_category_id': categoryId,
        'p_brand_id': brandId,
        'p_unit': unit,
        'p_cost_price': costPrice,
        'p_selling_price': sellingPrice,
        'p_initial_quantity': initialQuantity,
        'p_image_url': imageUrl,
        'p_thumbnail_url': thumbnailUrl,
        'p_image_urls': imageUrls,
      };

      final response = await _client
          .rpc('inventory_create_product', params: params)
          .single() as Map<String, dynamic>;

      if (response['success'] == true) {
        return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        final error = response['error'] as Map<String, dynamic>?;
        if (error?['code'] == 'DUPLICATE_SKU') {
          throw DuplicateSKUException(sku: sku);
        }
        throw InventoryRepositoryException(
          message: error?['message']?.toString() ?? 'Failed to create product',
          code: error?['code']?.toString(),
          details: error,
        );
      }
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to create product: $e',
        details: e,
      );
    }
  }

  /// Update existing product
  Future<ProductModel> updateProduct({
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
      final params = {
        'p_product_id': productId,
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_sku': sku,
        'p_product_name': name,
        'p_category_id': categoryId,
        'p_brand_id': brandId,
        'p_unit': unit ?? 'piece',
        'p_product_type': productType ?? 'commodity',
        'p_cost_price': costPrice,
        'p_selling_price': salePrice,
        'p_new_quantity': onHand,
      };

      final response = await _client
          .rpc('inventory_edit_product', params: params)
          .single() as Map<String, dynamic>;

      if (response['success'] == true) {
        return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        final error = response['error'] as Map<String, dynamic>?;
        throw InventoryRepositoryException(
          message: error?['message']?.toString() ?? 'Failed to update product',
          code: error?['code']?.toString(),
          details: error,
        );
      }
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to update product: $e',
        details: e,
      );
    }
  }

  /// Delete products
  Future<bool> deleteProducts({
    required List<String> productIds,
    required String companyId,
  }) async {
    try {
      final params = {
        'p_product_ids': productIds,
        'p_company_id': companyId,
      };

      final response = await _client.rpc(
        'inventory_delete_product',
        params: params,
      );

      if (response is Map && response['success'] == true) {
        return true;
      } else if (response is bool) {
        return response;
      }
      return true; // Assume success if no error thrown
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to delete products: $e',
        details: e,
      );
    }
  }

  /// Create new category
  Future<Map<String, dynamic>> createCategory({
    required String companyId,
    required String categoryName,
    String? parentCategoryId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_category_name': categoryName,
        'p_parent_category_id': parentCategoryId,
      };

      final response = await _client
          .rpc('inventory_create_category', params: params)
          .single() as Map<String, dynamic>;

      if (response['success'] == true) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw InventoryRepositoryException(
          message: response['error']?['message']?.toString() ?? 'Failed to create category',
          details: response['error'],
        );
      }
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to create category: $e',
        details: e,
      );
    }
  }

  /// Create new brand
  Future<Map<String, dynamic>> createBrand({
    required String companyId,
    required String brandName,
    String? brandCode,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_brand_name': brandName,
        'p_brand_code': brandCode,
      };

      final response = await _client
          .rpc('inventory_create_brand', params: params)
          .single() as Map<String, dynamic>;

      if (response['success'] == true) {
        return response['data'] as Map<String, dynamic>;
      } else {
        throw InventoryRepositoryException(
          message: response['error']?['message']?.toString() ?? 'Failed to create brand',
          details: response['error'],
        );
      }
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to create brand: $e',
        details: e,
      );
    }
  }

  /// Update product stock
  Future<bool> updateProductStock({
    required String productId,
    required String companyId,
    required String storeId,
    required int newStock,
    String? reason,
  }) async {
    try {
      final response = await _client.rpc('update_product_stock', params: {
        'p_product_id': productId,
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_new_stock': newStock,
        'p_reason': reason ?? 'Manual adjustment',
      }).single() as Map<String, dynamic>;

      return response['success'] == true;
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to update stock: $e',
        details: e,
      );
    }
  }
}

/// Product Page Response Model
class ProductPageResponse {
  final List<ProductModel> products;
  final PaginationData pagination;
  final CurrencyData currency;

  ProductPageResponse({
    required this.products,
    required this.pagination,
    required this.currency,
  });

  factory ProductPageResponse.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List? ?? [];
    final products = productsJson
        .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
        .toList();

    final paginationJson = json['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationData.fromJson(paginationJson);

    final currencyJson = json['currency'] as Map<String, dynamic>? ?? {};
    final currency = CurrencyData.fromJson(currencyJson);

    return ProductPageResponse(
      products: products,
      pagination: pagination,
      currency: currency,
    );
  }
}

class PaginationData {
  final int page;
  final int limit;
  final int total;
  final bool hasNext;
  final int totalPages;

  PaginationData({
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
    required this.totalPages,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      page: (json['page'] ?? 1) as int,
      limit: (json['limit'] ?? 10) as int,
      total: (json['total'] ?? 0) as int,
      hasNext: (json['has_next'] ?? false) as bool,
      totalPages: (json['total_pages'] ?? 1) as int,
    );
  }
}

class CurrencyData {
  final String? code;
  final String? name;
  final String? symbol;

  CurrencyData({
    this.code,
    this.name,
    this.symbol,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      code: json['code'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
    );
  }
}
