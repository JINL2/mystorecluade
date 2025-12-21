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
}
