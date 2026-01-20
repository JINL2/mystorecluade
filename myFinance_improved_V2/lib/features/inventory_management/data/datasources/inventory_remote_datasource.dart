// Remote DataSource: Inventory Remote DataSource
// Handles all RPC calls to Supabase for inventory management

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/inventory_exceptions.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/value_objects/image_file.dart';
import '../models/inventory_metadata_model.dart';
import '../models/product_model.dart';
import 'inventory_response_models.dart';

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
          .rpc('get_inventory_metadata_v2', params: params)
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

  /// Get paginated list of products (with variant expansion)
  /// Uses get_inventory_page_v6 with server-side filtering
  /// v6 expands products with variants into separate rows per variant
  Future<ProductPageResponse> getProducts({
    required String companyId,
    required String storeId,
    required int page,
    required int limit,
    String? search,
    String? categoryId,
    String? brandId,
    String? availability,
    String? sortBy,
    String? sortDirection,
  }) async {
    try {
      // Build params - use get_inventory_page_v6 with server-side filtering
      // Note: v6 does not support sortBy/sortDirection (fixed sort: product_name, variant_name)
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': page,
        'p_limit': limit,
        'p_search': search,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_availability': availability,
        'p_brand_id': brandId,
        'p_category_id': categoryId,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_inventory_page_v6', params: params)
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

      // v6 returns 'items' instead of 'products' - normalize for compatibility
      dataToProcess['products'] = dataToProcess['items'] ?? dataToProcess['products'] ?? <dynamic>[];
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
      dataToProcess['summary'] = dataToProcess['summary'] ??
          {
            'total_value': 0.0,
            'filtered_count': 0,
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

  /// Create new product with optional variant support
  /// Calls inventory_create_product_v4 RPC
  /// v4: Added p_attribute_id and p_variants for single-attribute variant support
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
    // v4: Variant support
    String? attributeId,
    List<Map<String, dynamic>>? variants,
  }) async {
    try {
      final params = <String, dynamic>{
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
        // p_image_urls expects JSONB array - pass List directly, Supabase will handle conversion
        'p_image_urls': imageUrls ?? [],
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      // v4: Add variant parameters if provided
      if (attributeId != null) {
        params['p_attribute_id'] = attributeId;
      }
      if (variants != null && variants.isNotEmpty) {
        params['p_variants'] = variants;
      }

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_create_product_v4', params: params)
          .single();

      if (response['success'] == true) {
        return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        // RPC returns error code at top level: { success: false, error: "message", code: "CODE" }
        final errorCode = response['code'] as String?;
        final errorMessage = response['error'] as String?;

        if (errorCode == 'DUPLICATE_SKU') {
          throw DuplicateSKUException(sku: sku ?? '');
        }
        if (errorCode == 'DUPLICATE_BARCODE') {
          throw InventoryRepositoryException(
            message: 'Barcode already exists',
            code: errorCode,
          );
        }
        if (errorCode == 'TOO_MANY_IMAGES') {
          throw InventoryRepositoryException(
            message: 'Maximum 3 image URLs allowed',
            code: errorCode,
          );
        }
        // v4: Variant-related errors
        if (errorCode == 'ATTRIBUTE_REQUIRED') {
          throw InventoryRepositoryException(
            message: 'Attribute is required when variants are provided',
            code: errorCode,
          );
        }
        if (errorCode == 'ATTRIBUTE_NOT_FOUND') {
          throw InventoryRepositoryException(
            message: 'Attribute not found or inactive',
            code: errorCode,
          );
        }
        if (errorCode == 'INVALID_VARIANTS_FORMAT') {
          throw InventoryRepositoryException(
            message: 'Variants must be an array',
            code: errorCode,
          );
        }
        if (errorCode == 'INVALID_VARIANT_DATA') {
          throw InventoryRepositoryException(
            message: errorMessage ?? 'Invalid variant data',
            code: errorCode,
          );
        }
        if (errorCode == 'OPTION_NOT_FOUND') {
          throw InventoryRepositoryException(
            message: errorMessage ?? 'Option not found',
            code: errorCode,
          );
        }
        if (errorCode == 'OPTION_ATTRIBUTE_MISMATCH') {
          throw InventoryRepositoryException(
            message: errorMessage ?? 'Option does not belong to the specified attribute',
            code: errorCode,
          );
        }
        throw InventoryRepositoryException(
          message: errorMessage ?? 'Failed to create product',
          code: errorCode,
          details: response,
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
  /// Supports adding variants via attributeId and addVariants parameters
  /// Uses inventory_edit_product_v5.5 which returns complete product info
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
    String? variantId,
    String? attributeId,
    List<Map<String, dynamic>>? addVariants,
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
        'p_variant_id': variantId,
        'p_attribute_id': attributeId,
        'p_add_variants': addVariants,
        'p_updated_at': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_edit_product_v5', params: params)
          .single();

      if (response['success'] == true) {
        // v5.5 returns complete product info in 'product' field
        // Falls back to 'data' for backward compatibility
        final productData = response['product'] as Map<String, dynamic>? ??
            response['data'] as Map<String, dynamic>?;
        if (productData == null) {
          throw InventoryRepositoryException(
            message: 'No product data in response',
          );
        }
        return ProductModel.fromJson(productData);
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
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        // Generate unique filename with timestamp and UUID
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final uniqueId = uuid.v4().substring(0, 8);
        final extension = image.path.split('.').last.toLowerCase();
        final fileName = '${timestamp}_$uniqueId.$extension';

        // Path: inventory_image/{company_id}/{filename}
        final storagePath = '$companyId/$fileName';

        // Debug logging
        debugPrint('📸 [Image Upload ${i + 1}/${images.length}]');
        debugPrint('   Path: ${image.path}');
        debugPrint('   Extension: $extension');
        debugPrint('   Storage path: $storagePath');

        // Read file bytes
        final bytes = await image.readAsBytes();
        debugPrint('   Bytes size: ${bytes.length}');

        // Determine correct MIME type (jpg -> jpeg for standard compliance)
        final mimeType = _getMimeType(extension);
        debugPrint('   MIME type: $mimeType');

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

        debugPrint('   ✅ Uploaded: $publicUrl');
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
  /// Calls inventory_move_product_v4 RPC (with variant support)
  /// For variant products, variantId is REQUIRED
  /// For non-variant products, variantId must be NULL
  Future<MoveProductResult> moveProduct({
    required String companyId,
    required String fromStoreId,
    required String toStoreId,
    required String productId,
    String? variantId,
    required int quantity,
    required String updatedBy,
    required String notes,
  }) async {
    try {
      // Build item with optional variant_id
      final Map<String, dynamic> item = {
        'product_id': productId,
        'quantity': quantity,
      };
      // Only include variant_id if it's not null and not empty (required for variant products)
      if (variantId != null && variantId.isNotEmpty) {
        item['variant_id'] = variantId;
      }

      final params = {
        'p_company_id': companyId,
        'p_from_store_id': fromStoreId,
        'p_to_store_id': toStoreId,
        'p_items': [item],
        'p_updated_by': updatedBy,
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_notes': notes,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_move_product_v4', params: params)
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
  /// Calls inventory_product_stock_stores_v2 RPC (supports variants)
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
          .rpc<Map<String, dynamic>>('inventory_product_stock_stores_v2', params: params)
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

  /// Get product history (v2 with variant support)
  /// Calls inventory_product_history_v2 RPC
  Future<ProductHistoryResult> getProductHistory({
    required String companyId,
    required String storeId,
    required String productId,
    String? variantId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_product_id': productId,
        'p_variant_id': variantId,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_page': page,
        'p_page_size': pageSize,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_product_history_v2', params: params)
          .single();

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
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get product history: $e',
        details: e,
      );
    }
  }

  /// Get inventory history for the entire store
  Future<InventoryHistoryResult> getInventoryHistory({
    required String companyId,
    required String storeId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_page': page,
        'p_page_size': pageSize,
      };

      // v2: Added variant support (variant_id, variant_name, display_name)
      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_history_v2', params: params)
          .single();

      if (response['success'] == true) {
        return InventoryHistoryResult.fromJson(response);
      } else {
        final error = response['error'] as Map<String, dynamic>?;
        throw InventoryRepositoryException(
          message: error?['message']?.toString() ?? 'Failed to get inventory history',
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
        message: 'Failed to get inventory history: $e',
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

  /// Check if product can be created (validates before creation)
  /// Calls inventory_check_create RPC
  ///
  /// Function signature:
  /// inventory_check_create(
  ///   p_company_id uuid,
  ///   p_product_name varchar,  -- REQUIRED
  ///   p_sku varchar DEFAULT NULL,
  ///   p_barcode varchar DEFAULT NULL,
  ///   p_category_id uuid DEFAULT NULL,
  ///   p_brand_id uuid DEFAULT NULL,
  ///   p_store_id uuid DEFAULT NULL
  /// )
  Future<CreateValidationResult> checkCreateProduct({
    required String companyId,
    required String productName,
    String? storeId,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
  }) async {
    try {
      // Build params matching actual function signature
      final params = <String, dynamic>{
        'p_company_id': companyId,
        'p_product_name': productName,
        'p_sku': (sku != null && sku.isNotEmpty) ? sku : null,
        'p_barcode': (barcode != null && barcode.isNotEmpty) ? barcode : null,
        'p_category_id': categoryId,
        'p_brand_id': brandId,
        'p_store_id': storeId,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('inventory_check_create', params: params)
          .single();

      return CreateValidationResult.fromJson(response);
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to validate product creation: $e',
        details: e,
      );
    }
  }

  /// Get base currency for company
  /// Calls get_base_currency RPC
  Future<BaseCurrencyResponse> getBaseCurrency({
    required String companyId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>('get_base_currency', params: params)
          .single();

      return BaseCurrencyResponse.fromJson(response);
    } on PostgrestException catch (e) {
      throw InventoryConnectionException(
        message: 'Database error: ${e.message}',
        details: {'code': e.code, 'details': e.details},
      );
    } catch (e) {
      if (e is InventoryException) rethrow;
      throw InventoryRepositoryException(
        message: 'Failed to get base currency: $e',
        details: e,
      );
    }
  }

  /// Create new attribute with optional options
  /// Calls inventory_create_attribute_and_option RPC
  Future<CreateAttributeResponse> createAttributeAndOption({
    required String companyId,
    required String attributeName,
    List<Map<String, dynamic>>? options,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_attribute_name': attributeName,
        'p_options': options,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>(
            'inventory_create_attribute_and_option',
            params: params,
          )
          .single();

      if (response['success'] == true) {
        return CreateAttributeResponse.fromJson(response);
      } else {
        final error = response['error']?.toString() ?? 'UNKNOWN_ERROR';
        final message =
            response['message']?.toString() ?? 'Failed to create attribute';
        throw InventoryAttributeException(
          message: message,
          errorCode: error,
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
        message: 'Failed to create attribute: $e',
        details: e,
      );
    }
  }

  /// Update attribute name and manage options (add, update, delete)
  /// Calls inventory_update_attribute_and_options RPC
  Future<UpdateAttributeResponse> updateAttributeAndOptions({
    required String companyId,
    required String attributeId,
    required String createdBy,
    String? attributeName,
    List<Map<String, dynamic>>? options,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_attribute_id': attributeId,
        'p_created_by': createdBy,
        'p_time': DateTimeUtils.formatLocalTimestamp(),
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_attribute_name': attributeName,
        'p_options': options,
      };

      final response = await _client
          .rpc<Map<String, dynamic>>(
            'inventory_update_attribute_and_options',
            params: params,
          )
          .single();

      if (response['success'] == true) {
        return UpdateAttributeResponse.fromJson(response);
      } else {
        final error = response['error']?.toString() ?? 'UNKNOWN_ERROR';
        final message =
            response['message']?.toString() ?? 'Failed to update attribute';
        throw InventoryAttributeException(
          message: message,
          errorCode: error,
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
        message: 'Failed to update attribute: $e',
        details: e,
      );
    }
  }
}
