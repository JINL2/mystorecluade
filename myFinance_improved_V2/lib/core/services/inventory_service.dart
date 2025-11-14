import 'package:supabase_flutter/supabase_flutter.dart';

/// Legacy InventoryService - Only contains methods used by sales_invoice feature
///
/// Note: This service is kept for backward compatibility with sales_invoice.
/// For new inventory management features, use the repository pattern in
/// lib/features/inventory_management/
class InventoryService {
  final _client = Supabase.instance.client;

  // Get base currency and company currencies for payment methods
  Future<Map<String, dynamic>?> getBaseCurrency({
    required String companyId,
  }) async {
    try {

      // Get current user
      final user = _client.auth.currentUser;
      if (user == null) {
        return null;
      }


      // Call RPC function
      final rpcParams = {
        'p_company_id': companyId,
      };


      final response = await _client.rpc(
        'get_base_currency',
        params: rpcParams,
      ).single();


      // Check if response is a map and has the expected structure
      // Check if it has success wrapper
      if (response.containsKey('success')) {
        if (response['success'] == true) {
          return response['data'] as Map<String, dynamic>? ?? response;
        } else {
          return null;
        }
      } else {
        // Response is direct data (RPC returns data directly)
        return response;
      }
              return null;
    } catch (e) {
      return null;
    }
  }

  // Get cash locations for payment methods
  Future<List<Map<String, dynamic>>?> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {

      // Get current user
      final user = _client.auth.currentUser;
      if (user == null) {
        return null;
      }


      // Call RPC function
      final rpcParams = {
        'p_company_id': companyId,
        'p_store_id': storeId,
      };


      final response = await _client.rpc(
        'get_cash_locations',
        params: rpcParams,
      ).select();


      // The RPC with .select() should return a List
      // Convert each item to Map<String, dynamic>
      final List<Map<String, dynamic>> locations = [];
      for (var item in response) {
        locations.add(item);
            }
      return locations;
              return null;
    } catch (e) {
      return null;
    }
  }
}
