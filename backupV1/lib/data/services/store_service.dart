import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Store service provider
final storeServiceProvider = Provider<StoreService>((ref) {
  return StoreService();
});

class StoreService {
  final _supabase = Supabase.instance.client;

  /// Create a new store for a company and return the store ID if successful
  Future<String?> createStore({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      // Generate store code
      final storeCode = _generateStoreCode(storeName);
      
      // Create the store
      final storeResponse = await _supabase
          .from('stores')
          .insert({
            'store_name': storeName,
            'store_code': storeCode,
            'company_id': companyId,
            'store_address': storeAddress ?? '',
            'store_phone': storePhone ?? '',
          })
          .select()
          .single();

      final storeId = storeResponse['store_id'];
      
      // Don't insert into user_stores - let the database trigger handle it
      print('StoreService: Store created successfully with ID: $storeId');
      print('StoreService: Database trigger will handle user_stores insertion');
      
      return storeId;
    } catch (e) {
      print('StoreService Error: Failed to create store: $e');
      return null;
    }
  }

  String _generateStoreCode(String storeName) {
    // Simple code generation - can be improved
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final prefix = storeName.replaceAll(' ', '').substring(0, 3).toUpperCase();
    return '$prefix${timestamp.substring(timestamp.length - 6)}';
  }
}