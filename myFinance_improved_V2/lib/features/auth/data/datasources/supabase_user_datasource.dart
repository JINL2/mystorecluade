// lib/features/auth/data/datasources/supabase_user_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user_model.dart';
import '../models/company_model.dart';
import '../models/store_model.dart';

/// Supabase User DataSource
///
/// 🚚 배달 기사 - Supabase Database와 직접 통신하는 계층
///
/// 책임:
/// - Supabase Database 쿼리 (users, user_companies, user_stores)
/// - JSON → UserModel, CompanyModel 변환
/// - 사용자 프로필 및 권한 조회
///
/// 이 계층은 Supabase Database에 대한 모든 지식을 가지고 있습니다.
abstract class UserDataSource {
  /// Find user by ID
  Future<UserModel?> getUserById(String userId);

  /// Update user profile
  Future<UserModel> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });

  /// Update last login timestamp
  Future<void> updateLastLogin(String userId);

  /// Get user's companies (where user is owner or member)
  Future<List<CompanyModel>> getUserCompanies(String userId);

  /// Get user's stores (where user has access)
  Future<List<StoreModel>> getUserStores(String userId);

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
}

/// Supabase implementation of UserDataSource
class SupabaseUserDataSource implements UserDataSource {
  final SupabaseClient _client;

  SupabaseUserDataSource(this._client);

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (userData == null) return null;

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
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

      return UserModel.fromJson(updatedData);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
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
      throw Exception('Failed to update last login: $e');
    }
  }

  @override
  Future<List<CompanyModel>> getUserCompanies(String userId) async {
    try {
      // Get companies where user is owner
      final companiesData = await _client
          .from('companies')
          .select()
          .eq('owner_id', userId)
          .eq('is_deleted', false);

      return companiesData
          .map((data) => CompanyModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user companies: $e');
    }
  }

  @override
  Future<List<StoreModel>> getUserStores(String userId) async {
    try {
      // Get stores through user_stores junction table
      final userStoresData = await _client
          .from('user_stores')
          .select('store_id, stores(*)')
          .eq('user_id', userId)
          .eq('is_deleted', false);

      final stores = <StoreModel>[];
      for (final userStore in userStoresData) {
        final storeData = userStore['stores'];
        if (storeData != null && storeData is Map<String, dynamic>) {
          stores.add(StoreModel.fromJson(storeData));
        }
      }

      return stores;
    } catch (e) {
      throw Exception('Failed to get user stores: $e');
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
      throw Exception('Failed to check company access: $e');
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
      throw Exception('Failed to check store access: $e');
    }
  }
}
