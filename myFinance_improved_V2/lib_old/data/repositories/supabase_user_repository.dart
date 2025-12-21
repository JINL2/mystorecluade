import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_profile.dart';
import '../services/supabase_service.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return UserRepository(supabaseService);
});

class UserRepository {
  final SupabaseService _supabaseService;

  UserRepository(this._supabaseService);

  /// Fetch user profile with related data
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      // First, get the user data
      final userResponse = await _supabaseService.client
          .from('users')
          .select()
          .eq('user_id', userId)
          .single();

      if (userResponse == null) {
        return null;
      }

      // Get company information through user_companies
      Map<String, dynamic>? companyData;
      try {
        final companyResponse = await _supabaseService.client
            .from('user_companies')
            .select('company_id, companies!inner(company_name)')
            .eq('user_id', userId)
            .eq('is_deleted', false)
            .limit(1)
            .maybeSingle();
        
        if (companyResponse != null) {
          companyData = companyResponse;
        }
      } catch (e) {
        // No company assigned
      }

      // Get store information through user_stores
      Map<String, dynamic>? storeData;
      try {
        final storeResponse = await _supabaseService.client
            .from('user_stores')
            .select('store_id, stores!inner(store_name)')
            .eq('user_id', userId)
            .eq('is_deleted', false)
            .limit(1)
            .maybeSingle();
        
        if (storeResponse != null) {
          storeData = storeResponse;
        }
      } catch (e) {
        // No store assigned
      }

      // Get role information through user_roles
      Map<String, dynamic>? roleData;
      try {
        final roleResponse = await _supabaseService.client
            .from('user_roles')
            .select('role_id, roles!inner(role_name)')
            .eq('user_id', userId)
            .eq('is_deleted', false)
            .limit(1)
            .maybeSingle();
        
        if (roleResponse != null) {
          roleData = roleResponse;
        }
      } catch (e) {
        // No role assigned
      }

      // Combine all data
      final profileData = {
        ...userResponse,
        'company_name': companyData?['companies']?['company_name'],
        'store_name': storeData?['stores']?['store_name'],
        'role_name': roleData?['roles']?['role_name'],
        // TODO: Add real subscription data when available
        'subscription_plan': 'Premium',
        'subscription_status': 'active',
        'subscription_expires_at': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      };

      return UserProfile.fromJson(profileData);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  /// Update user profile
  Future<UserProfile?> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? profileImage,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (firstName != null) {
        updates['first_name'] = firstName;
      }
      if (lastName != null) {
        updates['last_name'] = lastName;
      }
      if (profileImage != null) {
        updates['profile_image'] = profileImage;
      }

      await _supabaseService.client
          .from('users')
          .update(updates)
          .eq('user_id', userId);

      // Fetch and return the updated profile
      return getUserProfile(userId);
    } catch (e) {
      print('Error updating user profile: $e');
      return null;
    }
  }

  /// Upload profile image to Supabase Storage
  Future<String?> uploadProfileImage({
    required String userId,
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    try {
      final path = 'profiles/$userId/$fileName';
      
      // Upload image to Supabase Storage
      await _supabaseService.client.storage
          .from('profile-images')
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // Get the public URL
      final publicUrl = _supabaseService.client.storage
          .from('profile-images')
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  /// Delete user profile (soft delete)
  Future<bool> deleteUserProfile(String userId) async {
    try {
      await _supabaseService.client
          .from('users')
          .update({
            'is_deleted': true,
            'deleted_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('Error deleting user profile: $e');
      return false;
    }
  }
}