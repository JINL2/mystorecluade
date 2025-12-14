// Remote DataSource: Inventory Remote DataSource
// Handles all RPC calls to Supabase for inventory management

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/inventory_exceptions.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/value_objects/image_file.dart';
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
          .single();

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
  /// Note: Sorting is handled client-side as RPC does not support sort parameters
  Future<ProductPageResponse> getProducts({
    required String companyId,
    required String storeId,
    required int page,
    required int limit,
    String? search,
    String? categoryId,
    String? brandId,
    String? stockStatus,
  }) async {
    try {
      // Build params - use get_inventory_page_v3 with timezone support
      // Note: categoryId, brandId, stockStatus are not supported by RPC
      // Filtering is handled client-side in the presentation layer
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': page,
        'p_limit': limit,
        'p_search': search ?? '',
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_inventory_page_v3', params: params)
          .single();

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

  /// Create new product
  Future<ProductModel> createProduct({
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
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_created_by': createdBy,
        'p_product_name': name,
        'p_sku': sku,
        'p_barcode': barcode,
        'p_category_id': categoryId,
        'p_brand_id': brandId,
        'p_unit': unit,
        'p_cost_price': costPrice,
        'p_selling_price': sellingPrice,
        'p_initial_quantity': initialQuantity,
        'p_min_stock': minStock,
        'p_max_stock': maxStock,
        'p_image_urls': imageUrls,
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_create_product_v3', params: params)
          .single();

      if (response['success'] == true) {
        return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        final error = response['error'] as Map<String, dynamic>?;
        if (error?['code'] == 'DUPLICATE_SKU') {
          throw DuplicateSKUException(sku: sku ?? '');
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

  /// Check if product edit is valid (validates before actual update)
  Future<EditValidationResult> checkEditProduct({
    required String productId,
    required String companyId,
    String? sku,
    String? productName,
  }) async {
    try {
      final params = {
        'p_product_id': productId,
        'p_company_id': companyId,
        'p_sku': sku,
        'p_product_name': productName,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_check_edit', params: params)
          .single();

      return EditValidationResult.fromJson(response);
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to validate product edit: $e',
        details: e,
      );
    }
  }

  /// Update existing product
  Future<ProductModel> updateProduct({
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
      final params = {
        'p_product_id': productId,
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_created_by': createdBy,
        'p_sku': sku,
        'p_product_name': name,
        'p_category_id': categoryId,
        'p_brand_id': brandId,
        'p_unit': unit,
        'p_product_type': productType,
        'p_cost_price': costPrice,
        'p_selling_price': salePrice,
        'p_new_quantity': onHand,
        'p_flow_type': flowType,
        'p_image_urls': imageUrls,
        'p_default_price': defaultPrice,
        'p_updated_at': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_edit_product_v4', params: params)
          .single();

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
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client.rpc<Map<String, dynamic>>(
        'inventory_delete_product_v3',
        params: params,
      ).single();

      return response['success'] == true;
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
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_create_category_v2', params: params)
          .single();

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
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_create_brand_v2', params: params)
          .single();

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

  /// Upload product images to Supabase Storage
  /// Returns list of public URLs for uploaded images
  Future<List<String>> uploadProductImages({
    required String companyId,
    required List<ImageFile> images,
  }) async {
    if (images.isEmpty) return [];

    final List<String> uploadedUrls = [];
    const uuid = Uuid();
    const bucketName = 'inventory_image';

    try {
      for (final image in images) {
        // Generate unique filename with timestamp and UUID
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final uniqueId = uuid.v4().substring(0, 8);
        final extension = image.path.split('.').last.toLowerCase();
        final fileName = '${timestamp}_$uniqueId.$extension';

        // Path: inventory_image/{company_id}/{filename}
        final storagePath = '$companyId/$fileName';

        // Read file bytes
        final bytes = await image.readAsBytes();

        // Determine correct MIME type (jpg -> jpeg for standard compliance)
        final mimeType = _getMimeType(extension);

        // Upload to Supabase Storage
        await _client.storage.from(bucketName).uploadBinary(
              storagePath,
              bytes,
              fileOptions: FileOptions(
                contentType: mimeType,
                upsert: false,
              ),
            );

        // Get public URL
        final publicUrl =
            _client.storage.from(bucketName).getPublicUrl(storagePath);

        uploadedUrls.add(publicUrl);
      }

      return uploadedUrls;
    } on StorageException catch (e) {
      throw InventoryRepositoryException(
        message: 'Failed to upload images: ${e.message}',
        code: e.statusCode,
        details: e,
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to upload images: $e',
        details: e,
      );
    }
  }

  /// Move product between stores
  /// Calls inventory_move_product_v3 RPC
  Future<MoveProductResult> moveProduct({
    required String companyId,
    required String fromStoreId,
    required String toStoreId,
    required String productId,
    required int quantity,
    required String updatedBy,
    required String notes,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_from_store_id': fromStoreId,
        'p_to_store_id': toStoreId,
        'p_items': [
          {
            'product_id': productId,
            'quantity': quantity,
          },
        ],
        'p_updated_by': updatedBy,
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_notes': notes,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_move_product_v3', params: params)
          .single();

      if (response['success'] == true) {
        return MoveProductResult.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        final error = response['error'] as Map<String, dynamic>?;
        throw InventoryRepositoryException(
          message: error?['message']?.toString() ?? 'Failed to move product',
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
        message: 'Failed to move product: $e',
        details: e,
      );
    }
  }

  /// Get product stock by stores
  /// Calls inventory_product_stock_stores RPC
  Future<ProductStockStoresResult> getProductStockByStores({
    required String companyId,
    required List<String> productIds,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_product_ids': productIds,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_product_stock_stores', params: params)
          .single();

      if (response['success'] == true) {
        return ProductStockStoresResult.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        final error = response['error'] as Map<String, dynamic>?;
        throw InventoryRepositoryException(
          message: error?['message']?.toString() ?? 'Failed to get product stock',
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
        message: 'Failed to get product stock by stores: $e',
        details: e,
      );
    }
  }

  /// Get product history
  /// Calls inventory_product_history RPC
  Future<ProductHistoryResult> getProductHistory({
    required String companyId,
    required String storeId,
    required String productId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_product_id': productId,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_page': page,
        'p_page_size': pageSize,
      };

      // ignore: avoid_print
      print('[InventoryDatasource] getProductHistory params: $params');

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_product_history', params: params)
          .single();

      // ignore: avoid_print
      print('[InventoryDatasource] getProductHistory response: $response');

      if (response['success'] == true) {
        return ProductHistoryResult.fromJson(response);
      } else {
        final error = response['error'] as Map<String, dynamic>?;
        throw InventoryRepositoryException(
          message: error?['message']?.toString() ?? 'Failed to get product history',
          code: error?['code']?.toString(),
          details: error,
        );
      }
    } on PostgrestException catch (e) {
      // ignore: avoid_print
      print('[InventoryDatasource] PostgrestException: ${e.message}');
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      // ignore: avoid_print
      print('[InventoryDatasource] Exception: $e');
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get product history: $e',
        details: e,
      );
    }
  }

  /// Get correct MIME type for image extension
  /// Handles jpg -> jpeg conversion for standard compliance
  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      default:
        return 'image/$extension';
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

/// Edit Validation Result from inventory_check_edit RPC
class EditValidationResult {
  final bool success;
  final String? message;
  final EditValidationError? error;
  final EditValidations validations;

  EditValidationResult({
    required this.success,
    this.message,
    this.error,
    required this.validations,
  });

  factory EditValidationResult.fromJson(Map<String, dynamic> json) {
    return EditValidationResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      error: json['error'] != null
          ? EditValidationError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
      validations: EditValidations.fromJson(
        json['validations'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Error details from validation
class EditValidationError {
  final String code;
  final String message;
  final String? details;

  EditValidationError({
    required this.code,
    required this.message,
    this.details,
  });

  factory EditValidationError.fromJson(Map<String, dynamic> json) {
    return EditValidationError(
      code: json['code'] as String? ?? 'UNKNOWN_ERROR',
      message: json['message'] as String? ?? 'Unknown error occurred',
      details: json['details'] as String?,
    );
  }
}

/// Validation flags from check
class EditValidations {
  final bool productExists;
  final bool nameAvailable;
  final bool skuAvailable;

  EditValidations({
    required this.productExists,
    required this.nameAvailable,
    required this.skuAvailable,
  });

  factory EditValidations.fromJson(Map<String, dynamic> json) {
    return EditValidations(
      productExists: json['product_exists'] as bool? ?? false,
      nameAvailable: json['name_available'] as bool? ?? true,
      skuAvailable: json['sku_available'] as bool? ?? true,
    );
  }
}

/// Result from inventory_product_stock_stores RPC
class ProductStockStoresResult {
  final List<ProductStockInfo> products;
  final ProductStockSummary summary;

  ProductStockStoresResult({
    required this.products,
    required this.summary,
  });

  factory ProductStockStoresResult.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>? ?? [];
    return ProductStockStoresResult(
      products: productsJson
          .map((p) => ProductStockInfo.fromJson(p as Map<String, dynamic>))
          .toList(),
      summary: ProductStockSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Product stock info with stores
class ProductStockInfo {
  final String productId;
  final String productName;
  final String sku;
  final int totalQuantity;
  final int storesWithStock;
  final List<StoreStockInfo> stores;

  ProductStockInfo({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.totalQuantity,
    required this.storesWithStock,
    required this.stores,
  });

  factory ProductStockInfo.fromJson(Map<String, dynamic> json) {
    final storesJson = json['stores'] as List<dynamic>? ?? [];
    return ProductStockInfo(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      storesWithStock: (json['stores_with_stock'] as num?)?.toInt() ?? 0,
      stores: storesJson
          .map((s) => StoreStockInfo.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Store stock info
class StoreStockInfo {
  final String storeId;
  final String storeName;
  final String storeCode;
  final int quantityOnHand;
  final int quantityAvailable;
  final int quantityReserved;

  StoreStockInfo({
    required this.storeId,
    required this.storeName,
    required this.storeCode,
    required this.quantityOnHand,
    required this.quantityAvailable,
    required this.quantityReserved,
  });

  factory StoreStockInfo.fromJson(Map<String, dynamic> json) {
    return StoreStockInfo(
      storeId: json['store_id'] as String? ?? '',
      storeName: json['store_name'] as String? ?? '',
      storeCode: json['store_code'] as String? ?? '',
      quantityOnHand: (json['quantity_on_hand'] as num?)?.toInt() ?? 0,
      quantityAvailable: (json['quantity_available'] as num?)?.toInt() ?? 0,
      quantityReserved: (json['quantity_reserved'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Summary of product stock query
class ProductStockSummary {
  final int totalProductsRequested;
  final int totalProductsFound;
  final int totalStores;
  final int grandTotalQuantity;

  ProductStockSummary({
    required this.totalProductsRequested,
    required this.totalProductsFound,
    required this.totalStores,
    required this.grandTotalQuantity,
  });

  factory ProductStockSummary.fromJson(Map<String, dynamic> json) {
    return ProductStockSummary(
      totalProductsRequested: (json['total_products_requested'] as num?)?.toInt() ?? 0,
      totalProductsFound: (json['total_products_found'] as num?)?.toInt() ?? 0,
      totalStores: (json['total_stores'] as num?)?.toInt() ?? 0,
      grandTotalQuantity: (json['grand_total_quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Result from inventory_product_history RPC
class ProductHistoryResult {
  final List<ProductHistoryItem> data;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  ProductHistoryResult({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory ProductHistoryResult.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as List<dynamic>? ?? [];
    return ProductHistoryResult(
      data: dataJson
          .map((item) => ProductHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Individual history item from product history
class ProductHistoryItem {
  final String eventType;
  final String eventDate;
  final String localEventDate;
  final int? quantityBefore;
  final int? quantityAfter;
  final int? quantityChange;
  final double? priceBefore;
  final double? priceAfter;
  final String? fromStoreName;
  final String? toStoreName;
  final String? referenceNumber;
  final String? notes;
  final String? userName;
  final String? userAvatar;

  ProductHistoryItem({
    required this.eventType,
    required this.eventDate,
    required this.localEventDate,
    this.quantityBefore,
    this.quantityAfter,
    this.quantityChange,
    this.priceBefore,
    this.priceAfter,
    this.fromStoreName,
    this.toStoreName,
    this.referenceNumber,
    this.notes,
    this.userName,
    this.userAvatar,
  });

  factory ProductHistoryItem.fromJson(Map<String, dynamic> json) {
    return ProductHistoryItem(
      eventType: json['event_type'] as String? ?? '',
      eventDate: json['event_date'] as String? ?? '',
      localEventDate: json['local_event_date'] as String? ?? '',
      quantityBefore: (json['quantity_before'] as num?)?.toInt(),
      quantityAfter: (json['quantity_after'] as num?)?.toInt(),
      quantityChange: (json['quantity_change'] as num?)?.toInt(),
      priceBefore: (json['price_before'] as num?)?.toDouble(),
      priceAfter: (json['price_after'] as num?)?.toDouble(),
      fromStoreName: json['from_store_name'] as String?,
      toStoreName: json['to_store_name'] as String?,
      referenceNumber: json['reference_number'] as String?,
      notes: json['notes'] as String?,
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
    );
  }
}
