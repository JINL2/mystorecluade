// lib/features/auth/data/datasources/supabase_store_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store_model.dart';

/// Supabase Store DataSource
///
/// 🚚 배달 기사 - Supabase와 직접 통신하는 계층
///
/// 책임:
/// - Supabase API 호출
/// - JSON → Model 변환
/// - 네트워크 에러 처리
abstract class StoreDataSource {
  /// Create a new store
  Future<StoreModel> createStore(Map<String, dynamic> storeData);

  /// Get store by ID
  Future<StoreModel?> getStoreById(String storeId);

  /// Get stores by company ID
  Future<List<StoreModel>> getStoresByCompanyId(String companyId);

  /// Check if store code exists
  Future<bool> isStoreCodeExists({
    required String companyId,
    required String storeCode,
  });

  /// Update store
  Future<StoreModel> updateStore(String storeId, Map<String, dynamic> updateData);

  /// Delete store (soft delete)
  Future<void> deleteStore(String storeId);
}

/// Supabase implementation of StoreDataSource
class SupabaseStoreDataSource implements StoreDataSource {
  final SupabaseClient _client;

  SupabaseStoreDataSource(this._client);

  @override
  Future<StoreModel> createStore(Map<String, dynamic> storeData) async {
    try {
      // Insert store
      final createdData = await _client
          .from('stores')
          .insert(storeData)
          .select()
          .single();

      return StoreModel.fromJson(createdData);
    } catch (e) {
      throw Exception('Failed to create store: $e');
    }
  }

  @override
  Future<StoreModel?> getStoreById(String storeId) async {
    try {
      final storeData = await _client
          .from('stores')
          .select()
          .eq('store_id', storeId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (storeData == null) return null;

      return StoreModel.fromJson(storeData);
    } catch (e) {
      throw Exception('Failed to get store: $e');
    }
  }

  @override
  Future<List<StoreModel>> getStoresByCompanyId(String companyId) async {
    try {
      final storesData = await _client
          .from('stores')
          .select()
          .eq('company_id', companyId)
          .eq('is_deleted', false);

      return storesData
          .map((data) => StoreModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get stores: $e');
    }
  }

  @override
  Future<bool> isStoreCodeExists({
    required String companyId,
    required String storeCode,
  }) async {
    try {
      final duplicates = await _client
          .from('stores')
          .select('store_id')
          .eq('company_id', companyId)
          .eq('store_code', storeCode)
          .eq('is_deleted', false);

      return duplicates.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check store code: $e');
    }
  }

  @override
  Future<StoreModel> updateStore(
    String storeId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final updatedData = await _client
          .from('stores')
          .update({
            ...updateData,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('store_id', storeId)
          .select()
          .single();

      return StoreModel.fromJson(updatedData);
    } catch (e) {
      throw Exception('Failed to update store: $e');
    }
  }

  @override
  Future<void> deleteStore(String storeId) async {
    try {
      await _client.from('stores').update({
        'is_deleted': true,
        'deleted_at': DateTime.now().toIso8601String(),
      }).eq('store_id', storeId);
    } catch (e) {
      throw Exception('Failed to delete store: $e');
    }
  }
}
