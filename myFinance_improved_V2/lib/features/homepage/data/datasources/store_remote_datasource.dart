import 'package:myfinance_improved/features/homepage/data/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for store operations
/// Handles all direct Supabase communication for store feature
abstract class StoreRemoteDataSource {
  /// Create a new store with optional operational settings
  ///
  /// Steps:
  /// 1. INSERT stores (auto-generates store_code)
  /// 2. Verify/CREATE user_stores (links user)
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

  /// Check if user has permission to create stores
  /// Checks: Owner OR store_management feature permission
  Future<bool> verifyStoreCreationPermission(String companyId);

  /// Check if store name already exists in company
  /// Used for duplicate validation
  Future<bool> checkDuplicateStoreName(String storeName, String companyId);

  /// Verify company exists and is not deleted
  Future<bool> verifyCompanyExists(String companyId);
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
    final result = await supabaseClient.rpc<Map<String, dynamic>>(
      'create_store',
      params: {
        'p_company_id': companyId,
        'p_store_name': storeName,
        'p_store_address': storeAddress,
        'p_store_phone': storePhone,
      },
    );

    if (result['success'] != true) {
      throw Exception(result['error'] ?? 'Failed to create store');
    }

    final data = result['data'] as Map<String, dynamic>;

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

  @override
  Future<bool> verifyStoreCreationPermission(String companyId) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Check if user is company owner
    final companyOwner = await supabaseClient
        .from('companies')
        .select('owner_id')
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .maybeSingle();

    if (companyOwner == null) {
      throw Exception('Company not found');
    }

    if (companyOwner['owner_id'] == userId) {
      return true;
    }

    // Check if user has store creation permissions through roles
    final userPermissions = await supabaseClient.rpc<bool>(
      'check_user_feature_permission',
      params: {
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_feature_name': 'store_management',
      },
    );

    return userPermissions == true;
  }

  @override
  Future<bool> checkDuplicateStoreName(
      String storeName, String companyId,) async {
    final response = await supabaseClient
        .from('stores')
        .select('store_id')
        .eq('company_id', companyId)
        .ilike('store_name', storeName)
        .eq('is_deleted', false);

    return (response as List).isNotEmpty;
  }

  @override
  Future<bool> verifyCompanyExists(String companyId) async {
    final response = await supabaseClient
        .from('companies')
        .select('company_id')
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .maybeSingle();

    return response != null;
  }
}
