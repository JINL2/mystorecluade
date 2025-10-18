import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/features/homepage/data/models/store_model.dart';

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

    String? storeId;

    try {
      // Prepare store data
      final storeData = <String, dynamic>{
        'store_name': storeName,
        'company_id': companyId,
      };

      if (storeAddress != null && storeAddress.isNotEmpty) {
        storeData['store_address'] = storeAddress;
      }
      if (storePhone != null && storePhone.isNotEmpty) {
        storeData['store_phone'] = storePhone;
      }
      if (huddleTime != null) {
        storeData['huddle_time'] = huddleTime;
      }
      if (paymentTime != null) {
        storeData['payment_time'] = paymentTime;
      }
      if (allowedDistance != null) {
        storeData['allowed_distance'] = allowedDistance;
      }

      // Step 1: Create the store
      final storeResponse = await supabaseClient
          .from('stores')
          .insert(storeData)
          .select('store_id, store_code, store_name, company_id')
          .single();

      storeId = storeResponse['store_id'] as String;
      final storeCode = storeResponse['store_code'] as String;

      // Step 2: The database trigger should automatically create user_stores entry
      // But let's verify it exists, and create if not
      final userStoreExists = await supabaseClient
          .from('user_stores')
          .select('user_store_id')
          .eq('user_id', userId)
          .eq('store_id', storeId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (userStoreExists == null) {
        // Create user_stores entry manually
        await supabaseClient.from('user_stores').insert({
          'user_id': userId,
          'store_id': storeId,
        });
      }

      // Return created store
      return StoreModel(
        id: storeId,
        name: storeName,
        code: storeCode,
        companyId: companyId,
        address: storeAddress,
        phone: storePhone,
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      );
    } catch (e) {
      // Rollback: Clean up created store if something fails
      if (storeId != null) {
        try {
          await supabaseClient
              .from('stores')
              .delete()
              .eq('store_id', storeId);
        } catch (rollbackError) {
          // Log rollback error but don't throw
        }
      }

      rethrow;
    }
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
      String storeName, String companyId) async {
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
