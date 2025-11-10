// lib/features/auth/data/datasources/supabase_user_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/exceptions/auth_exceptions.dart' as domain;

/// Supabase User DataSource (Refactored with Freezed Entities)
///
/// 🎯 Improvements:
/// - Uses Freezed entities directly (no Model layer needed)
/// - Simpler: UserModel.fromJson() → User.fromJson()
/// - Type-safe: Freezed guarantees JSON serialization
///
/// 📊 Benefits:
/// - No toEntity() conversions needed
/// - Reduced code duplication
/// - Compile-time type safety
///
/// 🔧 Migration:
/// Before: UserModel.fromJson() → userModel.toEntity()
/// After:  User.fromJson() (direct entity creation!)
abstract class UserDataSource {
  /// Find user by ID
  Future<User?> getUserById(String userId);

  /// Update user profile
  Future<User> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });

  /// Update last login timestamp
  Future<void> updateLastLogin(String userId);

  /// Get user's companies (where user is owner or member)
  Future<List<Company>> getUserCompanies(String userId);

  /// Get user's stores (where user has access)
  Future<List<Store>> getUserStores(String userId);

  /// Check if user has access to company
  Future<bool> hasCompanyAccess({
    required String userId,
    required String companyId,
  });

  /// Check if user has access to store
  Future<bool> hasStoreAccess({
    required String userId,
    required String storeId,
  });

  /// Get user's complete data including companies and stores
  /// Calls the get_user_companies_and_stores RPC function
  Future<Map<String, dynamic>> getUserCompleteData(String userId);
}

/// Supabase implementation of UserDataSource
class SupabaseUserDataSource implements UserDataSource {
  final SupabaseClient _client;

  SupabaseUserDataSource(this._client);

  @override
  Future<User?> getUserById(String userId) async {
    try {
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (userData == null) return null;

      // Direct entity creation with Freezed!
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final updatedData = await _client
          .from('users')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      // Direct entity creation!
      return User.fromJson(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateLastLogin(String userId) async {
    try {
      await _client.from('users').update({
        'last_login_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Company>> getUserCompanies(String userId) async {
    try {
      // Get companies where user is owner
      final companiesData = await _client
          .from('companies')
          .select()
          .eq('owner_id', userId)
          .eq('is_deleted', false);

      // Direct entity list creation!
      return companiesData
          .map((data) => Company.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Store>> getUserStores(String userId) async {
    try {
      // Get stores through user_stores junction table
      final userStoresData = await _client
          .from('user_stores')
          .select('store_id, stores(*)')
          .eq('user_id', userId)
          .eq('is_deleted', false);

      final stores = <Store>[];
      for (final userStore in userStoresData) {
        final storeData = userStore['stores'];
        if (storeData != null && storeData is Map<String, dynamic>) {
          // Direct entity creation!
          stores.add(Store.fromJson(storeData));
        }
      }

      return stores;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> hasCompanyAccess({
    required String userId,
    required String companyId,
  }) async {
    try {
      // Check if user is owner
      final company = await _client
          .from('companies')
          .select('owner_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (company == null) return false;

      // User is owner
      if (company['owner_id'] == userId) return true;

      // Check if user is member through user_companies table
      final membership = await _client
          .from('user_companies')
          .select('user_company_id')
          .eq('user_id', userId)
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      return membership != null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> hasStoreAccess({
    required String userId,
    required String storeId,
  }) async {
    try {
      final access = await _client
          .from('user_stores')
          .select('user_store_id')
          .eq('user_id', userId)
          .eq('store_id', storeId)
          .eq('is_deleted', false)
          .maybeSingle();

      return access != null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserCompleteData(String userId) async {
    try {
      final response = await _client.rpc(
        'get_user_companies_and_stores',
        params: {'p_user_id': userId},
      );

      if (response == null) {
        throw domain.UserNotFoundException(userId: userId);
      }

      final result = response as Map<String, dynamic>;

      // Extract companies array (stores are nested inside each company)
      final companiesList = result['companies'] as List<dynamic>? ?? [];

      // Flatten stores from all companies
      final allStores = <Map<String, dynamic>>[];
      final processedCompanies = <Map<String, dynamic>>[];

      for (final company in companiesList) {
        final companyMap = company as Map<String, dynamic>;

        // Extract stores from this company
        final stores = companyMap['stores'] as List<dynamic>? ?? [];
        for (final store in stores) {
          final storeMap = store as Map<String, dynamic>;
          // Add company_id to each store
          storeMap['company_id'] = companyMap['company_id'];
          allStores.add(storeMap);
        }

        // Remove nested stores from company (not needed in flat structure)
        final companyWithoutStores = Map<String, dynamic>.from(companyMap);
        companyWithoutStores.remove('stores');
        companyWithoutStores.remove('store_count');
        processedCompanies.add(companyWithoutStores);
      }

      // Create user object from top-level fields with correct field names
      final userMap = {
        'user_id': result['user_id'],
        'first_name': result['user_first_name'],
        'last_name': result['user_last_name'],
        'profile_image': result['profile_image'],
      };

      return {
        'user': userMap,
        'companies': processedCompanies,
        'stores': allStores,
      };
    } catch (e) {
      rethrow;
    }
  }
}
