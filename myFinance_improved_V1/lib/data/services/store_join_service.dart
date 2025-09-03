import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for joining stores using store codes
class StoreJoinService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Join a store using a store code
  /// Returns the store details if successful, null otherwise
  Future<Map<String, dynamic>?> joinStoreByCode({
    required String userId,
    required String storeCode,
  }) async {
    try {
      // Call the join_store_by_code RPC function (when available)
      final response = await _supabase.rpc(
        'join_store_by_code',
        params: {
          'p_user_id': userId,
          'p_code': storeCode,
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      if (response != null) {
        // Handle different response types from the RPC
        
        if (response is String) {
          // Simple string response like "joined_store"
          
          // If we got a success message, fetch the store details
          if (response == 'joined_store' || response.contains('joined') || response.contains('success')) {
            
            // Get the store details using the store code
            final storeDetails = await getStoreByCode(storeCode);
            
            if (storeDetails != null) {
              return {
                'success': true,
                'message': response,
                'store_id': storeDetails['store_id'],
                'store_name': storeDetails['store_name'],
                'store_code': storeDetails['store_code'],
                'company_id': storeDetails['company_id'],
              };
            } else {
              // Join was successful but couldn't fetch store details
              return {
                'success': true,
                'message': response,
                'store_code': storeCode,
              };
            }
          } else {
            // Unknown string response
            return {
              'success': false,
              'message': response,
            };
          }
        } else if (response is List && response.isNotEmpty) {
          return response.first as Map<String, dynamic>;
        } else if (response is Map) {
          return response as Map<String, dynamic>;
        } else {
          return {'success': true, 'data': response};
        }
      }

      return null;
    } catch (error) {
      
      // Check for specific error types
      final errorStr = error.toString();
      if (errorStr.contains('duplicate') || errorStr.contains('already exists')) {
        throw Exception('You are already a member of this store');
      } else if (errorStr.contains('not found') || errorStr.contains('invalid')) {
        throw Exception('Invalid store code: $storeCode');
      } else if (errorStr.contains('permission') || errorStr.contains('denied')) {
        throw Exception('Permission denied to join this store');
      } else if (errorStr.contains('timeout')) {
        throw Exception('Request timed out. Please try again.');
      } else if (errorStr.contains('function') && errorStr.contains('not exist')) {
        // RPC function doesn't exist yet
        throw Exception('Store join by code is coming soon!');
      } else {
        throw Exception('Failed to join store: ${errorStr.split('\n').first}');
      }
    }
  }

  /// Validate a store code format
  bool isValidStoreCode(String code) {
    // Store codes appear to be alphanumeric (similar to company codes)
    // Adjust pattern based on your actual store code format
    final pattern = RegExp(r'^[a-zA-Z0-9]{6,15}$');
    return pattern.hasMatch(code);
  }

  /// Get store details by code (for preview before joining)
  Future<Map<String, dynamic>?> getStoreByCode(String storeCode) async {
    try {
      // First check if stores have a code field
      // If not, this query will need to be adjusted based on your schema
      final response = await _supabase
          .from('stores')
          .select('store_id, store_name, company_id')
          .eq('store_code', storeCode)
          .maybeSingle();

      if (response != null) {
        return {
          ...response,
          'store_code': storeCode,
        };
      }
      
      return null;
    } catch (error) {
      // If store_code column doesn't exist, return null
      if (error.toString().contains('column') && error.toString().contains('not exist')) {
        return null;
      }
      
      return null;
    }
  }
}