import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for joining companies using company codes
class CompanyJoinService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Join a company using a company code
  /// Returns the company details if successful, null otherwise
  Future<Map<String, dynamic>?> joinCompanyByCode({
    required String userId,
    required String companyCode,
  }) async {
    try {
      // Call the join_company_by_code RPC function (when available)
      final response = await _supabase.rpc(
        'join_company_by_code',
        params: {
          'p_user_id': userId,
          'p_code': companyCode,
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      if (response != null) {
        // Handle different response types from the RPC
        
        if (response is String) {
          // Simple string response like "joined_company"
          
          // If we got a success message, fetch the company details
          if (response == 'joined_company' || response.contains('joined') || response.contains('success')) {
            
            // Get the company details using the company code
            final companyDetails = await getCompanyByCode(companyCode);
            
            if (companyDetails != null) {
              return {
                'success': true,
                'message': response,
                'company_id': companyDetails['company_id'],
                'company_name': companyDetails['company_name'],
                'company_code': companyDetails['company_code'],
              };
            } else {
              // Join was successful but couldn't fetch company details
              return {
                'success': true,
                'message': response,
                'company_code': companyCode,
              };
            }
          } else {
            // Unknown string response
            return {
              'success': false,
              'message': response,
            };
          }
        } else if (response is List && response.isNotEmpty) {
          return response.first as Map<String, dynamic>;
        } else if (response is Map) {
          return response as Map<String, dynamic>;
        } else {
          return {'success': true, 'data': response};
        }
      }

      return null;
    } catch (error) {
      
      // Check for specific error types
      final errorStr = error.toString();
      if (errorStr.contains('duplicate') || errorStr.contains('already exists')) {
        throw Exception('You are already a member of this company');
      } else if (errorStr.contains('not found') || errorStr.contains('invalid')) {
        throw Exception('Invalid company code: $companyCode');
      } else if (errorStr.contains('permission') || errorStr.contains('denied')) {
        throw Exception('Permission denied to join this company');
      } else if (errorStr.contains('timeout')) {
        throw Exception('Request timed out. Please try again.');
      } else if (errorStr.contains('function') && errorStr.contains('not exist')) {
        // RPC function doesn't exist yet
        throw Exception('Company join by code is coming soon!');
      } else {
        throw Exception('Failed to join company: ${errorStr.split('\n').first}');
      }
    }
  }

  /// Validate a company code format
  bool isValidCompanyCode(String code) {
    // Company codes appear to be alphanumeric (similar to store codes)
    // Adjust pattern based on your actual company code format
    final pattern = RegExp(r'^[a-zA-Z0-9]{8,12}$');
    return pattern.hasMatch(code);
  }

  /// Get company details by code (for preview before joining)
  Future<Map<String, dynamic>?> getCompanyByCode(String companyCode) async {
    try {
      // First check if companies have a code field
      // If not, this query will need to be adjusted based on your schema
      final response = await _supabase
          .from('companies')
          .select('company_id, company_name')
          .eq('company_code', companyCode)
          .maybeSingle();

      if (response != null) {
        return {
          ...response,
          'company_code': companyCode,
        };
      }
      
      return null;
    } catch (error) {
      // If company_code column doesn't exist, return null
      if (error.toString().contains('column') && error.toString().contains('not exist')) {
        return null;
      }
      
      return null;
    }
  }
}