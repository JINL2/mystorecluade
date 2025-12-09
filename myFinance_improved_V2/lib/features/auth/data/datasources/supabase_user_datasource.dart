// lib/features/auth/data/datasources/supabase_user_datasource.dart

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../models/freezed/company_dto.dart';
import '../models/freezed/store_dto.dart';
import '../models/freezed/user_dto.dart';

/// Supabase User DataSource
///
/// 🚚 배달 기사 - Supabase Database와 직접 통신하는 계층
///
/// 책임:
/// - Supabase Database 쿼리 (users, user_companies, user_stores)
/// - JSON → UserDto, CompanyDto, StoreDto 변환
/// - 사용자 프로필 및 권한 조회
///
/// 이 계층은 Supabase Database에 대한 모든 지식을 가지고 있습니다.
abstract class UserDataSource {
  /// Find user by ID
  Future<UserDto?> getUserById(String userId);

  /// Update user profile
  Future<UserDto> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });

  /// Update last login timestamp
  Future<void> updateLastLogin(String userId);

  /// Get user's companies (where user is owner or member)
  Future<List<CompanyDto>> getUserCompanies(String userId);

  /// Get user's stores (where user has access)
  Future<List<StoreDto>> getUserStores(String userId);

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

  /// Upload profile image to storage
  /// Returns the public URL of the uploaded image
  Future<String> uploadProfileImage(String userId, String filePath);
}

/// Supabase implementation of UserDataSource
class SupabaseUserDataSource implements UserDataSource {
  final SupabaseClient _client;

  SupabaseUserDataSource(this._client);

  @override
  Future<UserDto?> getUserById(String userId) async {
    try {
      final userData = await _client
          .from('users')
          .select()
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (userData == null) return null;

      return UserDto.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<UserDto> updateUserProfile({
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

      return UserDto.fromJson(updatedData);
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
  Future<List<CompanyDto>> getUserCompanies(String userId) async {
    try {
      // Get companies where user is owner
      final companiesData = await _client
          .from('companies')
          .select()
          .eq('owner_id', userId)
          .eq('is_deleted', false);

      return companiesData
          .map((data) => CompanyDto.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user companies: $e');
    }
  }

  @override
  Future<List<StoreDto>> getUserStores(String userId) async {
    try {
      // Get stores through user_stores junction table
      final userStoresData = await _client
          .from('user_stores')
          .select('store_id, stores(*)')
          .eq('user_id', userId)
          .eq('is_deleted', false);

      final stores = <StoreDto>[];
      for (final userStore in userStoresData) {
        final storeData = userStore['stores'];
        if (storeData != null && storeData is Map<String, dynamic>) {
          stores.add(StoreDto.fromJson(storeData));
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

  @override
  Future<Map<String, dynamic>> getUserCompleteData(String userId) async {
    try {
      final response = await _client.rpc(
        'get_user_companies_and_stores',
        params: {'p_user_id': userId},
      );

      if (response == null) {
        throw Exception('No user data returned');
      }

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user complete data: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(String userId, String filePath) async {
    File? compressedFile;
    try {
      final imageFile = File(filePath);

      // Compress image for optimal storage
      compressedFile = await _compressProfileImage(imageFile);

      // Upload to Supabase Storage
      final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = 'avatars/$fileName';

      await _client.storage.from('profileimage').upload(
            storagePath,
            compressedFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Get public URL
      final publicUrl = _client.storage.from('profileimage').getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    } finally {
      // Clean up temporary compressed file
      if (compressedFile != null) {
        try {
          if (await compressedFile.exists()) {
            await compressedFile.delete();
          }
        } catch (_) {
          // Cleanup error ignored
        }
      }
    }
  }

  /// Compress profile image for optimal storage and performance
  Future<File> _compressProfileImage(File originalFile) async {
    try {
      final bytes = await originalFile.readAsBytes();
      final originalSize = bytes.length;

      // Compression settings based on original size
      int quality = 50;
      int targetSize = 256;

      if (originalSize > 5 * 1024 * 1024) {
        quality = 40;
      } else if (originalSize > 2 * 1024 * 1024) {
        quality = 45;
      } else if (originalSize < 200 * 1024) {
        quality = 60;
        targetSize = 300;
      }

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        originalFile.absolute.path,
        minWidth: targetSize,
        minHeight: targetSize,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null || compressedBytes.isEmpty) {
        throw Exception('Image compression failed');
      }

      // Create compressed file
      final directory = originalFile.parent;
      final compressedPath =
          '${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);

      // If still too large, compress more aggressively
      if (compressedBytes.length > 100 * 1024 && quality > 30) {
        final moreCompressedBytes = await FlutterImageCompress.compressWithFile(
          originalFile.absolute.path,
          minWidth: 200,
          minHeight: 200,
          quality: 30,
          format: CompressFormat.jpeg,
        );

        if (moreCompressedBytes != null && moreCompressedBytes.isNotEmpty) {
          await compressedFile.writeAsBytes(moreCompressedBytes);
        }
      }

      return compressedFile;
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }
}
