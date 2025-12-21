// Remote DataSource: Inventory Remote DataSource
// Handles all RPC calls to Supabase for inventory management

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/inventory_exceptions.dart';
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
      // Build params - use get_inventory_page_v2 with timezone support
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': page,
        'p_limit': limit,
        'p_search': search ?? '',
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_inventory_page_v2', params: params)
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
        'p_image_urls': imageUrls,
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_create_product_v2', params: params)
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
      final params = {
        'p_product_id': productId,
        'p_company_id': companyId,
        'p_store_id': storeId,
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
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_edit_product_v2', params: params)
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
        'inventory_delete_product_v2',
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
