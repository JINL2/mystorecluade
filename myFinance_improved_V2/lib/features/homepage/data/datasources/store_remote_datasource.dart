import 'package:flutter/foundation.dart';
import 'package:myfinance_improved/features/homepage/data/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for store operations
/// Handles all direct Supabase communication for store feature
abstract class StoreRemoteDataSource {
  /// Create a new store using create_store RPC
  ///
  /// The RPC handles:
  /// - Store creation with auto-generated store_code
  /// - Permission validation internally
  ///
  /// Returns [StoreModel] on success
  /// Throws exception on error (PostgrestException, etc.)
  Future<StoreModel> createStore({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  });
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  StoreRemoteDataSourceImpl(this.supabaseClient);

  final SupabaseClient supabaseClient;

  @override
  Future<StoreModel> createStore({
    required String storeName,
    required String companyId,
    String? storeAddress,
    String? storePhone,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Call create_store RPC
    debugPrint('🏪 [CreateStore] Calling RPC with:');
    debugPrint('🏪 [CreateStore] p_company_id: $companyId');
    debugPrint('🏪 [CreateStore] p_store_name: $storeName');
    debugPrint('🏪 [CreateStore] p_store_address: $storeAddress');
    debugPrint('🏪 [CreateStore] p_store_phone: $storePhone');

    final result = await supabaseClient.rpc<Map<String, dynamic>>(
      'create_store',
      params: {
        'p_company_id': companyId,
        'p_store_name': storeName,
        'p_store_address': storeAddress,
        'p_store_phone': storePhone,
      },
    );

    debugPrint('🏪 [CreateStore] RPC Result: $result');

    if (result['success'] != true) {
      final errorMessage = result['message'] ?? result['error'] ?? 'Failed to create store';
      debugPrint('❌ [CreateStore] Error: $errorMessage');
      throw Exception(errorMessage);
    }

    final data = result['data'] as Map<String, dynamic>;
    debugPrint('✅ [CreateStore] Success: store_id=${data['store_id']}, store_code=${data['store_code']}');

    return StoreModel(
      id: data['store_id'] as String,
      name: data['store_name'] as String,
      code: data['store_code'] as String,
      companyId: data['company_id'] as String,
      address: data['store_address'] as String?,
      phone: data['store_phone'] as String?,
      huddleTime: huddleTime,
      paymentTime: paymentTime,
      allowedDistance: allowedDistance,
    );
  }
}
