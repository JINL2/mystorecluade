import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileDataSource {
  final _supabase = Supabase.instance.client;

  /// Get user profile from users table
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final result = await _supabase
          .from('users')
          .select('user_id, first_name, last_name, email, user_phone_number, profile_image, created_at, updated_at')
          .eq('user_id', userId)
          .maybeSingle();

      return result;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Get business dashboard data (company, store, role)
  Future<Map<String, dynamic>?> getBusinessDashboard(String userId) async {
    try {
      final response = await _supabase
          .from('user_companies')
          .select('''
            role,
            companies!inner(
              name,
              stores!inner(
                name
              )
            )
          ''')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      final companyName = (response['companies']['name'] ?? '').toString();
      final stores = response['companies']['stores'] as List;
      final storeName = stores.isNotEmpty ? (stores[0]['name'] ?? '').toString() : '';
      final userRole = (response['role'] ?? 'Employee').toString();

      return {
        'company_name': companyName,
        'store_name': storeName,
        'user_role': userRole,
        'total_employees': 0,
        'monthly_revenue': 0.0,
        'active_shifts': 0,
      };
    } catch (e) {
      throw Exception('Failed to get business dashboard: $e');
    }
  }

  /// Update user profile in users table
  Future<bool> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _supabase
          .from('users')
          .update(updates)
          .eq('user_id', userId)
          .select();

      return true;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Get user's bank account info
  Future<Map<String, dynamic>?> getUserBankAccount({
    required String userId,
    required String companyId,
  }) async {
    try {
      final result = await _supabase
          .from('users_bank_account')
          .select('user_bank_name, user_account_number, description')
          .eq('user_id', userId)
          .eq('company_id', companyId)
          .maybeSingle();

      return result;
    } catch (e) {
      return null;
    }
  }

  /// Save or update user's bank account
  Future<bool> saveUserBankAccount({
    required String userId,
    required String companyId,
    required String bankName,
    required String accountNumber,
    required String description,
  }) async {
    try {
      final existing = await _supabase
          .from('users_bank_account')
          .select('id')
          .eq('user_id', userId)
          .eq('company_id', companyId)
          .maybeSingle();

      final now = DateTime.now().toUtc().toIso8601String();

      if (existing != null) {
        await _supabase.from('users_bank_account').update({
          'user_bank_name': bankName,
          'user_account_number': accountNumber,
          'description': description,
          'updated_at': now,
        }).eq('user_id', userId).eq('company_id', companyId);
      } else {
        await _supabase.from('users_bank_account').insert({
          'user_id': userId,
          'company_id': companyId,
          'user_bank_name': bankName,
          'user_account_number': accountNumber,
          'description': description,
          'created_at': now,
          'updated_at': now,
        });
      }

      return true;
    } catch (e) {
      throw Exception('Failed to save bank account: $e');
    }
  }

  /// Get available languages
  Future<List<Map<String, dynamic>>> getLanguages() async {
    try {
      final result = await _supabase
          .from('languages')
          .select('language_id, language_code, language_name')
          .inFilter('language_code', ['ko', 'en', 'vi']);

      return List<Map<String, dynamic>>.from(result ?? []);
    } catch (e) {
      return [];
    }
  }

  /// Get user's language preference
  Future<String?> getUserLanguageId(String userId) async {
    try {
      final result = await _supabase
          .from('users')
          .select('user_language')
          .eq('user_id', userId)
          .maybeSingle();

      return result?['user_language'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Get language code by language ID
  Future<String?> getLanguageCode(String languageId) async {
    try {
      final result = await _supabase
          .from('languages')
          .select('language_code')
          .eq('language_id', languageId)
          .maybeSingle();

      return result?['language_code'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Update user's language preference
  Future<bool> updateUserLanguage({
    required String userId,
    required String languageId,
  }) async {
    try {
      await _supabase.from('users').update({
        'user_language': languageId,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('user_id', userId);

      return true;
    } catch (e) {
      throw Exception('Failed to update language: $e');
    }
  }
}
