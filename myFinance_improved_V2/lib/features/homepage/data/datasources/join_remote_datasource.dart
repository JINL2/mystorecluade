import 'package:myfinance_improved/features/homepage/data/models/join_result_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for join operations
/// Communicates with Supabase RPC: join_business_by_code
abstract class JoinRemoteDataSource {
  /// Join a company or store by code using Supabase RPC
  ///
  /// Calls: `join_business_by_code(p_user_id, p_business_code)`
  ///
  /// The RPC function automatically:
  /// - Determines if code is for company or store
  /// - Validates the code exists
  /// - Checks user is not already a member
  /// - Checks employee limit based on subscription plan
  /// - Restores soft-deleted memberships (2026 best practice)
  /// - Adds user to company/store with appropriate role
  /// - Returns result with IDs and role info
  ///
  /// Error codes:
  /// - EMPLOYEE_LIMIT_REACHED: Company has reached max employees
  /// - ALREADY_MEMBER: User is already a member
  /// - OWNER_CANNOT_JOIN: Owner cannot join as employee
  /// - BUSINESS_NOT_FOUND: Invalid code
  ///
  /// Throws [PostgrestException] on database errors
  Future<JoinResultModel> joinByCode({
    required String userId,
    required String code,
  });
}

/// Implementation of JoinRemoteDataSource using Supabase
class JoinRemoteDataSourceImpl implements JoinRemoteDataSource {
  const JoinRemoteDataSourceImpl(this.supabaseClient);

  final SupabaseClient supabaseClient;

  @override
  Future<JoinResultModel> joinByCode({
    required String userId,
    required String code,
  }) async {
    // Call the advanced join_business_by_code RPC
    // Features: employee limit check, soft-delete restore, owner prevention
    final response = await supabaseClient.rpc<Map<String, dynamic>>(
      'join_business_by_code',
      params: {
        'p_user_id': userId,
        'p_business_code': code,
      },
    );

    // The RPC returns a single object with the result
    return JoinResultModel.fromJson(response);
  }
}
