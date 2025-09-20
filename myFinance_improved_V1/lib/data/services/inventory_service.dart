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
}