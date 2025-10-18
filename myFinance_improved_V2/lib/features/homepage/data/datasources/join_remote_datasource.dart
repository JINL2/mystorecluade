import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/features/homepage/data/models/join_result_model.dart';

/// Remote data source for join operations
/// Communicates with Supabase RPC: join_user_by_code
abstract class JoinRemoteDataSource {
  /// Join a company or store by code using Supabase RPC
  ///
  /// Calls: `join_user_by_code(p_user_id, p_code)`
  ///
  /// The RPC function automatically:
  /// - Determines if code is for company or store
  /// - Validates the code exists
  /// - Checks user is not already a member
  /// - Adds user to company/store with appropriate role
  /// - Returns result with IDs and role info
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
    // Call the Supabase RPC function
    // This unified RPC handles both company and store codes
    final response = await supabaseClient.rpc<Map<String, dynamic>>(
      'join_user_by_code',
      params: {
        'p_user_id': userId,
        'p_code': code,
      },
    );

    // The RPC returns a single object with the result
    return JoinResultModel.fromJson(response);
  }
}
