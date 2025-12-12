import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/pages/homepage/models/homepage_models.dart';

abstract class UserRepository {
  Future<UserWithCompanies> getUserWithCompanies(String userId);
}

// Supabase implementation
class SupabaseUserRepository implements UserRepository {
  @override
  Future<UserWithCompanies> getUserWithCompanies(String userId) async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_user_companies_and_stores', params: {'p_user_id': userId});
      
      
      if (response == null) {
        throw Exception('No data returned from get_user_companies_and_stores');
      }
      
      // Debug the response structure before parsing
      if (response is List) {
        if (response.isNotEmpty) {
        }
      } else if (response is Map) {
      }
      
      // Try to parse - catch errors for debugging
      try {
        return UserWithCompanies.fromJson(response as Map<String, dynamic>);
      } catch (parseError) {
        
        // Maybe the response is a List instead of a Map
        if (response is List && response.isNotEmpty) {
          return UserWithCompanies.fromJson(response.first as Map<String, dynamic>);
        }
        
        throw Exception('Failed to parse API response: $parseError');
      }
    } catch (e) {
      throw Exception('Failed to get user companies: $e');
    }
  }
}