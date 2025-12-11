import 'package:supabase_flutter/supabase_flutter.dart';

/// Unified service for joining companies or stores using the join_user_by_code RPC
/// Server-side intelligence determines entity type and handles join logic
class UnifiedJoinService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Join a company or store using a code
  /// Server determines entity type automatically based on code lookup
  /// Returns unified response with entity details if successful
  Future<Map<String, dynamic>?> joinByCode({
    required String userId,
    required String code,
  }) async {
    try {
      // Call the unified join_user_by_code RPC function
      final response = await _supabase.rpc(
        'join_user_by_code',
        params: {
          'p_user_id': userId,
          'p_code': code,
        },
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      if (response != null) {
        // Handle different response types from the RPC
        if (response is Map<String, dynamic>) {
          // Direct structured response
          return response;
        } else if (response is List && response.isNotEmpty) {
          // Array response, take first item
          return response.first as Map<String, dynamic>;
        } else if (response is String) {
          // Simple string response
          if (response.contains('joined') || response.contains('success')) {
            return {
              'success': true,
              'message': response,
              'code': code,
            };
          } else {
            return {
              'success': false,
              'message': response,
            };
          }
        } else {
          // Generic response
          return {'success': true, 'data': response};
        }
      }

      return null;
    } catch (error) {
      final errorStr = error.toString();
      
      // Handle specific error types with user-friendly messages
      if (errorStr.contains('duplicate') || errorStr.contains('already exists') || errorStr.contains('already member')) {
        throw Exception('You are already a member of this organization');
      } else if (errorStr.contains('not found') || errorStr.contains('invalid') || errorStr.contains('does not exist')) {
        throw Exception('Invalid code: $code');
      } else if (errorStr.contains('permission') || errorStr.contains('denied')) {
        throw Exception('Permission denied to join this organization');
      } else if (errorStr.contains('timeout')) {
        throw Exception('Request timed out. Please try again.');
      } else if (errorStr.contains('function') && errorStr.contains('not exist')) {
        // This shouldn't happen since join_user_by_code exists
        throw Exception('Join service temporarily unavailable');
      } else {
        // Clean up error message for user
        final cleanError = errorStr
            .replaceAll('Exception: ', '')
            .split('\n')
            .first
            .trim();
        throw Exception('Failed to join: $cleanError');
      }
    }
  }

  /// Validate a code format (works for both company and store codes)
  bool isValidCode(String code) {
    // Accept alphanumeric codes between 6-15 characters
    // Server will determine if it's a valid company or store code
    final pattern = RegExp(r'^[a-zA-Z0-9]{6,15}$');
    return pattern.hasMatch(code);
  }
}