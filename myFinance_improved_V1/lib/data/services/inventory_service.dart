import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inventory_models.dart';

class InventoryService {
  final _client = Supabase.instance.client;

  // Test connection and RPC function availability
  Future<void> testConnection() async {
    try {
      print('🔍 [INVENTORY_SERVICE] Testing Supabase connection...');
      
      // Check auth status
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth status: user=${user?.id}, session=${_client.auth.currentSession?.accessToken != null}');
      
      // Try a simple query first
      try {
        final testQuery = await _client
            .from('inventory_products')
            .select('count')
            .limit(1);
        print('✅ [INVENTORY_SERVICE] Basic query successful: $testQuery');
      } catch (e) {
        print('❌ [INVENTORY_SERVICE] Basic query failed: $e');
      }
      
      // Test if RPC functions exist
      try {
        final rpcTest = await _client.rpc('get_inventory_metadata', params: {
          'p_company_id': 'test',
          'p_store_id': 'test',
        });
        print('✅ [INVENTORY_SERVICE] RPC get_inventory_metadata callable (even if failed): $rpcTest');
      } catch (e) {
        print('❌ [INVENTORY_SERVICE] RPC get_inventory_metadata error: $e');
      }
      
      try {
        final rpcTest2 = await _client.rpc('get_inventory_page', params: {
          'p_company_id': 'test',
          'p_store_id': 'test',
          'p_page': 1,
          'p_limit': 10,
          'p_search': '',
        });
        print('✅ [INVENTORY_SERVICE] RPC get_inventory_page callable (even if failed): $rpcTest2');
      } catch (e) {
        print('❌ [INVENTORY_SERVICE] RPC get_inventory_page error: $e');
      }
      
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Connection test failed: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
    }
  }

  // Get inventory metadata for the store
  Future<InventoryMetadata?> getInventoryMetadata({
    required String companyId,
    required String storeId,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting getInventoryMetadata');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId, storeId=$storeId');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
      };
      print('📤 [INVENTORY_SERVICE] RPC params: $params');
      
      final response = await _client.rpc(
        'get_inventory_metadata',
        params: params,
      ).single();

      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response.keys.toList()}');
        
        // Check if response has a success wrapper or is direct data
        Map<String, dynamic> dataToProcess;
        
        if (response.containsKey('success')) {
          // Response is wrapped with success/data structure
          print('📦 [INVENTORY_SERVICE] Response has success wrapper');
          if (response['success'] == true) {
            print('✅ [INVENTORY_SERVICE] Success flag is true');
            dataToProcess = response['data'] ?? {};
          } else {
            print('❌ [INVENTORY_SERVICE] Success flag is false');
            if (response.containsKey('error')) {
              print('❌ [INVENTORY_SERVICE] Error in response: ${response['error']}');
            }
            return null;
          }
        } else {
          // Response is direct data (RPC returns data directly)
          print('📦 [INVENTORY_SERVICE] Response is direct data (no success wrapper)');
          dataToProcess = response;
        }
        
        print('📋 [INVENTORY_SERVICE] Data to process: ${dataToProcess.keys.toList()}');
        final metadata = InventoryMetadata.fromJson(dataToProcess);
        print('✅ [INVENTORY_SERVICE] Metadata parsed successfully');
        return metadata;
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error fetching inventory metadata: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      return null;
    }
  }

  // Get paginated inventory products
  Future<InventoryPageResult?> getInventoryPage({
    required String companyId,
    required String storeId,
    required int page,
    int limit = 10,
    String? search,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting getInventoryPage');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId, storeId=$storeId, page=$page, limit=$limit, search=$search');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      // According to the error, the function signature is:
      // get_inventory_page(p_company_id, p_limit, p_page, p_search, p_store_id)
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': page,
        'p_limit': limit,
        'p_search': search ?? '', // Required parameter, use empty string if null
      };
      print('📤 [INVENTORY_SERVICE] RPC params: $params');

      final response = await _client.rpc(
        'get_inventory_page',
        params: params,
      ).single();

      print('📥 [INVENTORY_SERVICE] Raw response received');
      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response.keys.toList()}');
        
        // Check if response has a success wrapper or is direct data
        Map<String, dynamic> dataToProcess;
        
        if (response.containsKey('success')) {
          // Response is wrapped with success/data structure
          print('📦 [INVENTORY_SERVICE] Response has success wrapper');
          if (response['success'] == true) {
            print('✅ [INVENTORY_SERVICE] Success flag is true');
            dataToProcess = response['data'] ?? {};
          } else {
            print('❌ [INVENTORY_SERVICE] Success flag is false');
            if (response.containsKey('error')) {
              print('❌ [INVENTORY_SERVICE] Error in response: ${response['error']}');
            }
            return null;
          }
        } else {
          // Response is direct data (RPC returns data directly)
          print('📦 [INVENTORY_SERVICE] Response is direct data (no success wrapper)');
          dataToProcess = response;
        }
        
        print('📋 [INVENTORY_SERVICE] Data to process: ${dataToProcess.keys.toList()}');
        
        // Ensure required fields exist with defaults
        if (!dataToProcess.containsKey('products')) {
          dataToProcess['products'] = [];
          print('⚠️ [INVENTORY_SERVICE] No products field, using empty array');
        }
        
        if (!dataToProcess.containsKey('pagination')) {
          dataToProcess['pagination'] = {
            'page': page,
            'limit': limit,
            'total': 0,
            'has_next': false,
            'total_pages': 0,
          };
          print('⚠️ [INVENTORY_SERVICE] No pagination field, using defaults');
        }
        
        if (!dataToProcess.containsKey('currency')) {
          dataToProcess['currency'] = {
            'code': null,
            'name': null,
            'symbol': null,
          };
          print('⚠️ [INVENTORY_SERVICE] No currency field, using defaults');
        }
        
        print('📦 [INVENTORY_SERVICE] Products count: ${dataToProcess['products']?.length ?? 0}');
        print('📄 [INVENTORY_SERVICE] Pagination: ${dataToProcess['pagination']}');
        
        final result = InventoryPageResult.fromJson(dataToProcess);
        print('✅ [INVENTORY_SERVICE] Page result parsed successfully');
        print('📊 [INVENTORY_SERVICE] Products loaded: ${result.products.length}');
        return result;
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null, returning empty result');
        // Return empty result instead of null
        return InventoryPageResult(
          products: [],
          pagination: Pagination(
            page: page,
            limit: limit,
            total: 0,
            hasNext: false,
            totalPages: 0,
          ),
          currency: Currency(
            code: null,
            name: null,
            symbol: null,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error fetching inventory page: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      // Return empty result on error instead of null
      return InventoryPageResult(
        products: [],
        pagination: Pagination(
          page: page,
          limit: limit,
          total: 0,
          hasNext: false,
          totalPages: 0,
        ),
        currency: Currency(
          code: null,
          name: null,
          symbol: null,
        ),
      );
    }
  }

  // Get single product details
  Future<Map<String, dynamic>?> getProductDetails({
    required String productId,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _client.rpc(
        'get_product_details',
        params: {
          'p_product_id': productId,
          'p_company_id': companyId,
          'p_store_id': storeId,
        },
      ).single();

      if (response != null && response['success'] == true) {
        return response['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching product details: $e');
      return null;
    }
  }

  // Create new product
  Future<Map<String, dynamic>?> createProduct({
    required String companyId,
    required String productName,
    required String storeId,
    String? sku,
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
      print('🔍 [INVENTORY_SERVICE] Starting createProduct');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId, productName=$productName, storeId=$storeId');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      final params = {
        'p_company_id': companyId,
        'p_product_name': productName,
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
      print('📤 [INVENTORY_SERVICE] RPC params: $params');
      
      final response = await _client.rpc(
        'inventory_create_product',
        params: params,
      ).single();

      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response.keys.toList()}');
        
        // Check if response has a success wrapper or is direct data
        if (response.containsKey('success')) {
          // Response is wrapped with success/data structure
          print('📦 [INVENTORY_SERVICE] Response has success wrapper');
          if (response['success'] == true) {
            print('✅ [INVENTORY_SERVICE] Product created successfully');
            return response['data'] ?? response;
          } else {
            print('❌ [INVENTORY_SERVICE] Product creation failed');
            if (response.containsKey('error')) {
              print('❌ [INVENTORY_SERVICE] Error in response: ${response['error']}');
            }
            return null;
          }
        } else {
          // Response is direct data (RPC returns data directly)
          print('📦 [INVENTORY_SERVICE] Response is direct data (no success wrapper)');
          return response;
        }
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error creating product: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      return null;
    }
  }

  // Edit existing product
  Future<Map<String, dynamic>?> editProduct({
    required String productId,
    required String companyId,
    required String storeId,
    required String sku,
    required String productName,
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
      print('🔍 [INVENTORY_SERVICE] Starting editProduct');
      print('📋 [INVENTORY_SERVICE] Params: productId=$productId, companyId=$companyId, storeId=$storeId');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      final params = {
        'p_product_id': productId,
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_sku': sku,
        'p_product_name': productName,
        'p_category_id': categoryId,
        'p_brand_id': brandId,
        'p_unit': unit ?? 'piece',
        'p_product_type': productType ?? 'commodity',
        'p_cost_price': costPrice,
        'p_selling_price': salePrice, // Changed from p_sale_price
        'p_new_quantity': onHand, // Changed from p_on_hand
        // Removed parameters not in the RPC function signature:
        // p_barcode, p_min_stock, p_max_stock, p_is_active, p_description
      };
      print('📤 [INVENTORY_SERVICE] RPC params: $params');
      
      final response = await _client.rpc(
        'inventory_edit_product',
        params: params,
      ).single();

      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response.keys.toList()}');
        
        // Always return the full response structure for proper error handling
        return response;
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
        // Return error response for null case
        return {
          'success': false,
          'error': {
            'code': 'NO_RESPONSE',
            'message': 'No response from server'
          }
        };
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error editing product: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      
      // Return error response for exceptions
      return {
        'success': false,
        'error': {
          'code': 'EXCEPTION',
          'message': 'Connection error: ${e.toString()}'
        }
      };
    }
  }

  // Delete products
  Future<Map<String, dynamic>?> deleteProducts({
    required List<String> productIds,
    required String companyId,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting deleteProducts');
      print('📋 [INVENTORY_SERVICE] Params: productIds=$productIds, companyId=$companyId');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      final params = {
        'p_product_ids': productIds,
        'p_company_id': companyId,
      };
      print('📤 [INVENTORY_SERVICE] RPC params: $params');
      
      final response = await _client.rpc(
        'inventory_delete_product',
        params: params,
      );

      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        
        // Check if response has a success wrapper or is direct data
        if (response is Map && response.containsKey('success')) {
          // Response is wrapped with success/data structure
          print('📦 [INVENTORY_SERVICE] Response has success wrapper');
          if (response['success'] == true) {
            print('✅ [INVENTORY_SERVICE] Products deleted successfully');
            return Map<String, dynamic>.from(response);
          } else {
            print('❌ [INVENTORY_SERVICE] Products deletion failed');
            if (response.containsKey('error')) {
              print('❌ [INVENTORY_SERVICE] Error in response: ${response['error']}');
            }
            return null;
          }
        } else {
          // Response is direct data or just a success boolean
          print('📦 [INVENTORY_SERVICE] Response is direct data');
          return {'success': true};
        }
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error deleting products: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      rethrow; // Rethrow to handle in UI
    }
  }

  // Create new category
  Future<Map<String, dynamic>?> createCategory({
    required String companyId,
    required String categoryName,
    String? parentCategoryId,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting createCategory');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId, categoryName=$categoryName, parentCategoryId=$parentCategoryId');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      final params = {
        'p_company_id': companyId,
        'p_category_name': categoryName,
        'p_parent_category_id': parentCategoryId,
      };
      print('📤 [INVENTORY_SERVICE] RPC params: $params');
      
      final response = await _client.rpc(
        'inventory_create_category',
        params: params,
      ).single();

      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response.keys.toList()}');
        
        // Check if response has a success wrapper or is direct data
        if (response.containsKey('success')) {
          // Response is wrapped with success/data structure
          print('📦 [INVENTORY_SERVICE] Response has success wrapper');
          if (response['success'] == true) {
            print('✅ [INVENTORY_SERVICE] Category created successfully');
            return response['data'] ?? response;
          } else {
            print('❌ [INVENTORY_SERVICE] Category creation failed');
            if (response.containsKey('error')) {
              print('❌ [INVENTORY_SERVICE] Error in response: ${response['error']}');
            }
            return null;
          }
        } else {
          // Response is direct data (RPC returns data directly)
          print('📦 [INVENTORY_SERVICE] Response is direct data (no success wrapper)');
          return response;
        }
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error creating category: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      return null;
    }
  }

  // Create new brand
  Future<Map<String, dynamic>?> createBrand({
    required String companyId,
    required String brandName,
    String? brandCode,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting createBrand');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId, brandName=$brandName, brandCode=$brandCode');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      final params = {
        'p_company_id': companyId,
        'p_brand_name': brandName,
        'p_brand_code': brandCode,
      };
      print('📤 [INVENTORY_SERVICE] RPC params: $params');
      
      final response = await _client.rpc(
        'inventory_create_brand',
        params: params,
      ).single();

      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response.keys.toList()}');
        
        // Check if response has a success wrapper or is direct data
        if (response.containsKey('success')) {
          // Response is wrapped with success/data structure
          print('📦 [INVENTORY_SERVICE] Response has success wrapper');
          if (response['success'] == true) {
            print('✅ [INVENTORY_SERVICE] Brand created successfully');
            return response['data'] ?? response;
          } else {
            print('❌ [INVENTORY_SERVICE] Brand creation failed');
            if (response.containsKey('error')) {
              print('❌ [INVENTORY_SERVICE] Error in response: ${response['error']}');
              // Return error details for UI to display
              return {
                'success': false,
                'error': response['error'],
              };
            }
            return {
              'success': false,
              'error': {'message': 'Unknown error occurred'},
            };
          }
        } else {
          // Response is direct data (RPC returns data directly)
          print('📦 [INVENTORY_SERVICE] Response is direct data (no success wrapper)');
          return response;
        }
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error creating brand: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      return null;
    }
  }

  // Update product stock
  Future<bool> updateProductStock({
    required String productId,
    required String companyId,
    required String storeId,
    required int newStock,
    String? reason,
  }) async {
    try {
      final response = await _client.rpc(
        'update_product_stock',
        params: {
          'p_product_id': productId,
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_new_stock': newStock,
          'p_reason': reason ?? 'Manual adjustment',
        },
      ).single();

      return response != null && response['success'] == true;
    } catch (e) {
      print('Error updating product stock: $e');
      return false;
    }
  }

  // Get inventory product list for company (for sales invoice)
  Future<Map<String, dynamic>?> getInventoryProductListCompany({
    required String companyId,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting getInventoryProductListCompany');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId');
      
      // Check Supabase client auth
      final user = _client.auth.currentUser;
      print('🔐 [INVENTORY_SERVICE] Auth user: ${user?.id}');
      
      final params = {
        'p_company_id': companyId,
      };
      print('📤 [INVENTORY_SERVICE] RPC params: $params');
      
      final response = await _client.rpc(
        'get_inventory_product_list_company',
        params: params,
      ).single();

      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response.keys.toList()}');
        
        // Log sample product structure for debugging
        if (response.containsKey('data') && response['data'] != null) {
          final data = response['data'];
          if (data.containsKey('products') && data['products'] is List && (data['products'] as List).isNotEmpty) {
            final firstProduct = (data['products'] as List).first;
            print('🔬 [INVENTORY_SERVICE] First product structure: $firstProduct');
            print('🔬 [INVENTORY_SERVICE] First product type: ${firstProduct.runtimeType}');
            if (firstProduct is Map && firstProduct.containsKey('images')) {
              print('🔬 [INVENTORY_SERVICE] Images field: ${firstProduct['images']}');
              print('🔬 [INVENTORY_SERVICE] Images type: ${firstProduct['images'].runtimeType}');
            }
          }
        }
        
        // Check if response has a success wrapper or is direct data
        if (response.containsKey('success')) {
          // Response is wrapped with success/data structure
          print('📦 [INVENTORY_SERVICE] Response has success wrapper');
          if (response['success'] == true) {
            print('✅ [INVENTORY_SERVICE] Success flag is true');
            return response['data'] ?? response;
          } else {
            print('❌ [INVENTORY_SERVICE] Success flag is false');
            if (response.containsKey('error')) {
              print('❌ [INVENTORY_SERVICE] Error in response: ${response['error']}');
            }
            return null;
          }
        } else {
          // Response is direct data (RPC returns data directly)
          print('📦 [INVENTORY_SERVICE] Response is direct data (no success wrapper)');
          return response;
        }
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error fetching inventory product list: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      return null;
    }
  }

  // Get base currency and company currencies for payment methods
  Future<Map<String, dynamic>?> getBaseCurrency({
    required String companyId,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting getBaseCurrency');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId');
      
      // Get current user
      final user = _client.auth.currentUser;
      if (user == null) {
        print('❌ [INVENTORY_SERVICE] No authenticated user');
        return null;
      }

      print('🔐 [INVENTORY_SERVICE] Auth user: ${user.id}');
      
      // Call RPC function
      final rpcParams = {
        'p_company_id': companyId,
      };
      
      print('📤 [INVENTORY_SERVICE] RPC params: $rpcParams');
      
      final response = await _client.rpc(
        'get_base_currency',
        params: rpcParams,
      ).single();
      
      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('🔍 [INVENTORY_SERVICE] Response keys: ${response is Map ? response.keys.toList() : 'Not a map'}');

        // Check if response is a map and has the expected structure
        if (response is Map<String, dynamic>) {
          // Check if it has success wrapper
          if (response.containsKey('success')) {
            print('📦 [INVENTORY_SERVICE] Response has success wrapper');
            if (response['success'] == true) {
              print('✅ [INVENTORY_SERVICE] Success flag is true');
              return response['data'] as Map<String, dynamic>? ?? response;
            } else {
              print('❌ [INVENTORY_SERVICE] Success flag is false');
              print('📝 [INVENTORY_SERVICE] Error message: ${response['message'] ?? response['error']}');
              return null;
            }
          } else {
            // Response is direct data (RPC returns data directly)
            print('📦 [INVENTORY_SERVICE] Response is direct data (no success wrapper)');
            return response;
          }
        } else {
          print('❌ [INVENTORY_SERVICE] Response is not a Map');
          return null;
        }
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error fetching base currency: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      return null;
    }
  }

  // Get cash locations for payment methods
  Future<List<Map<String, dynamic>>?> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      print('🔍 [INVENTORY_SERVICE] Starting getCashLocations');
      print('📋 [INVENTORY_SERVICE] Params: companyId=$companyId, storeId=$storeId');
      
      // Get current user
      final user = _client.auth.currentUser;
      if (user == null) {
        print('❌ [INVENTORY_SERVICE] No authenticated user');
        return null;
      }

      print('🔐 [INVENTORY_SERVICE] Auth user: ${user.id}');
      
      // Call RPC function
      final rpcParams = {
        'p_company_id': companyId,
        'p_store_id': storeId,
      };
      
      print('📤 [INVENTORY_SERVICE] RPC params: $rpcParams');
      
      final response = await _client.rpc(
        'get_cash_locations',
        params: rpcParams,
      ).select();
      
      print('📥 [INVENTORY_SERVICE] Raw response: $response');
      print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');
      
      if (response != null) {
        print('✅ [INVENTORY_SERVICE] Response is not null');
        print('📊 [INVENTORY_SERVICE] Response type: ${response.runtimeType}');

        // The RPC with .select() should return a List
        if (response is List) {
          print('📦 [INVENTORY_SERVICE] Response is a List');
          print('📋 [INVENTORY_SERVICE] Cash locations count: ${response.length}');
          
          // Convert each item to Map<String, dynamic>
          final List<Map<String, dynamic>> locations = [];
          for (var item in response) {
            if (item is Map<String, dynamic>) {
              locations.add(item);
            }
          }
          return locations;
        } else {
          print('❌ [INVENTORY_SERVICE] Unexpected response type: ${response.runtimeType}');
          print('📝 [INVENTORY_SERVICE] Response: $response');
          // Return empty list for unexpected types
          return [];
        }
      } else {
        print('❌ [INVENTORY_SERVICE] Response is null');
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_SERVICE] Error fetching cash locations: $e');
      print('📋 [INVENTORY_SERVICE] Stack trace: $stackTrace');
      return null;
    }
  }
}