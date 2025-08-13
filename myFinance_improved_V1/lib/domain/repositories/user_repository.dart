import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/user.dart';
import '../../presentation/pages/homepage/models/homepage_models.dart';

abstract class UserRepository {
  Future<UserWithCompanies> getUserWithCompanies(String userId);
}

// Supabase implementation
class SupabaseUserRepository implements UserRepository {
  @override
  Future<UserWithCompanies> getUserWithCompanies(String userId) async {
    try {
      // Add timestamp to force fresh data
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      print('🔥🔥🔥 API CALL: get_user_companies_and_stores');
      print('🔥 Timestamp: $timestamp');
      print('🔥 User ID: $userId');
      print('🔥 Stack trace to see who called this:');
      print(StackTrace.current.toString().split('\n').take(10).join('\n'));
      
      final response = await Supabase.instance.client
          .rpc('get_user_companies_and_stores', params: {'p_user_id': userId});
      
      print('=== REPOSITORY API RESPONSE ===');
      print('Response Type: ${response.runtimeType}');
      print('Response: $response');
      print('Response is null: ${response == null}');
      
      if (response == null) {
        throw Exception('No data returned from get_user_companies_and_stores');
      }
      
      // Debug the response structure before parsing
      if (response is List) {
        print('Response is List with ${response.length} items');
        if (response.isNotEmpty) {
          print('First item: ${response.first}');
        }
      } else if (response is Map) {
        print('Response is Map with keys: ${response.keys}');
      }
      print('=== END REPOSITORY RESPONSE ===');
      
      // Try to parse - catch errors for debugging
      try {
        return UserWithCompanies.fromJson(response as Map<String, dynamic>);
      } catch (parseError) {
        print('Parse Error: $parseError');
        print('Trying to parse as List...');
        
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