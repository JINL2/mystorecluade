import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileDataSource {
  final _supabase = Supabase.instance.client;

  /// Get complete user profile via RPC
  ///
  /// Returns user profile with:
  /// - Basic user info (user_id, first_name, last_name, email, etc.)
  /// - Bank accounts array (all companies)
  /// - Current language setting
  /// - Available languages list (ko, en, vi)
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final result = await _supabase.rpc<Map<String, dynamic>?>(
        'my_page_get_user_profile',
        params: {'p_user_id': userId},
      );

      if (result == null) return null;
      return Map<String, dynamic>.from(result as Map);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile (RPC 사용)
  ///
  /// Uses my_page_update_user_settings RPC with profile action.
  /// Supported fields: first_name, last_name, user_phone_number, date_of_birth, profile_image
  Future<bool> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _supabase.rpc<Map<String, dynamic>>(
        'my_page_update_user_settings',
        params: {
          'p_user_id': userId,
          'p_action': 'profile',
          'p_data': updates,
        },
      );

      return true;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Save or update user's bank account (RPC 사용)
  ///
  /// Uses my_page_update_user_settings RPC with bank_account action.
  /// RPC handles UPSERT logic with EXISTS check internally.
  Future<bool> saveUserBankAccount({
    required String userId,
    required String companyId,
    required String bankName,
    required String accountNumber,
    required String description,
  }) async {
    try {
      await _supabase.rpc<Map<String, dynamic>>(
        'my_page_update_user_settings',
        params: {
          'p_user_id': userId,
          'p_action': 'bank_account',
          'p_data': {
            'company_id': companyId,
            'user_bank_name': bankName,
            'user_account_number': accountNumber,
            'description': description,
          },
        },
      );

      return true;
    } catch (e) {
      throw Exception('Failed to save bank account: $e');
    }
  }

  /// Update user's language preference (RPC 사용)
  ///
  /// Uses my_page_update_user_settings RPC with language action.
  Future<bool> updateUserLanguage({
    required String userId,
    required String languageId,
  }) async {
    try {
      await _supabase.rpc<Map<String, dynamic>>(
        'my_page_update_user_settings',
        params: {
          'p_user_id': userId,
          'p_action': 'language',
          'p_data': {'language_id': languageId},
        },
      );

      return true;
    } catch (e) {
      throw Exception('Failed to update language: $e');
    }
  }
}
