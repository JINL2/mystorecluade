import 'package:supabase_flutter/supabase_flutter.dart';

/// Account Mapping Data Source
///
/// Handles all Supabase operations for account mappings.
class AccountMappingDataSource {
  final SupabaseClient _client;

  AccountMappingDataSource(this._client);

  /// Get all account mappings for a counterparty with enriched data
  /// Uses V1 RPC: get_account_mappings_with_company
  Future<List<Map<String, dynamic>>> getAccountMappings({
    required String counterpartyId,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_account_mappings_with_company',
        params: {
          'p_counterparty_id': counterpartyId,
        },
      );

      if (response.isEmpty) return [];

      // Convert UUIDs to strings for Freezed entity
      return response.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        // Ensure all UUID fields are strings
        if (map['mapping_id'] != null) map['mapping_id'] = map['mapping_id'].toString();
        if (map['my_company_id'] != null) map['my_company_id'] = map['my_company_id'].toString();
        if (map['my_account_id'] != null) map['my_account_id'] = map['my_account_id'].toString();
        if (map['counterparty_id'] != null) map['counterparty_id'] = map['counterparty_id'].toString();
        if (map['linked_account_id'] != null) map['linked_account_id'] = map['linked_account_id'].toString();
        if (map['created_by'] != null) map['created_by'] = map['created_by'].toString();
        if (map['linked_company_id'] != null) map['linked_company_id'] = map['linked_company_id'].toString();
        return map;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch account mappings: $e');
    }
  }

  /// Create a new account mapping with perfect data integrity
  ///
  /// Logic:
  /// - Same company: create_account_mapping (single direction for internal transactions)
  /// - Different companies: insert_account_mapping_with_company (bidirectional)
  ///
  /// The bidirectional RPC ensures:
  /// 1. Counterparties are created/reused with UNIQUE constraint
  /// 2. Mappings match database UNIQUE constraint (my_company_id, my_account_id, counterparty_id, direction)
  /// 3. Reverse mapping is created automatically with opposite direction
  /// 4. All operations are atomic and handle race conditions
  Future<Map<String, dynamic>> createAccountMapping({
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
    required String linkedAccountId,
    String direction = 'bidirectional',
    String? createdBy,
  }) async {
    try {
      // Get the linked_company_id from counterparty using RPC
      final counterpartyResponse = await _client.rpc<Map<String, dynamic>>(
        'get_counterparties_v3',
        params: {
          'p_counterparty_id': counterpartyId,
          'p_mode': 'linked_info',
        },
      );

      if (counterpartyResponse['success'] != true) {
        throw Exception(counterpartyResponse['error'] ?? 'Failed to fetch counterparty info');
      }

      final linkedCompanyId = counterpartyResponse['linked_company_id'];
      final counterpartyOwnerId = counterpartyResponse['company_id'];

      // Validate counterparty data
      if (linkedCompanyId == null) {
        throw Exception('Counterparty does not have a linked company');
      }

      if (counterpartyOwnerId.toString() != myCompanyId) {
        throw Exception(
          'Counterparty does not belong to this company. '
          'Expected company: $myCompanyId, Got: $counterpartyOwnerId'
        );
      }

      // Check if it's same company (internal transaction) or different companies
      final isSameCompany = linkedCompanyId.toString() == myCompanyId;

      if (isSameCompany) {
        // Same company: Use create_account_mapping (single direction)
        final response = await _client.rpc<List<dynamic>>(
          'create_account_mapping',
          params: {
            'p_my_company_id': myCompanyId,
            'p_my_account_id': myAccountId,
            'p_counterparty_id': counterpartyId,
            'p_linked_account_id': linkedAccountId,
            'p_direction': direction,
          },
        );

        // RPC returns [{success: bool, message: string, mapping_id: uuid}]
        if (response.isEmpty) {
          throw Exception('Failed to create mapping');
        }

        final rpcResult = response.first as Map<String, dynamic>;
        if (rpcResult['success'] != true) {
          throw Exception(rpcResult['message'] ?? 'Failed to create mapping');
        }

        return {
          'mapping_id': rpcResult['mapping_id'].toString(),
          'message': rpcResult['message'] ?? 'Internal account mapping created successfully',
          'type': 'single_direction',
        };
      } else {
        // Different companies: Use insert_account_mapping_with_company (bidirectional)
        final response = await _client.rpc<String>(
          'insert_account_mapping_with_company',
          params: {
            'p_my_company_id': myCompanyId,
            'p_my_account_id': myAccountId,
            'p_counterparty_company_id': linkedCompanyId.toString(),
            'p_linked_account_id': linkedAccountId,
            'p_direction': direction,
            'p_created_by': createdBy,
          },
        );

        // This RPC returns 'inserted' or 'already_exists'
        if (response == 'already_exists') {
          throw Exception(
            'This account mapping already exists. '
            'Each counterparty can only have one mapping per account and direction.'
          );
        }

        if (response != 'inserted') {
          throw Exception('Unexpected response from RPC: $response');
        }

        // For bidirectional creation, we need to fetch the created mapping
        return {
          'status': 'bidirectional_created',
          'message': 'Account mappings created successfully (bidirectional)',
          'type': 'bidirectional',
        };
      }
    } catch (e) {
      // Enhance error messages
      if (e.toString().contains('already_exists')) {
        throw Exception('Duplicate mapping: This account combination is already mapped to this counterparty');
      }
      if (e.toString().contains('unique_violation')) {
        throw Exception('Database constraint violation: This mapping conflicts with existing data');
      }
      throw Exception('Failed to create account mapping: $e');
    }
  }

  /// Delete an account mapping
  /// Uses V1 RPC: delete_account_mapping (hard delete, not soft)
  Future<bool> deleteAccountMapping({
    required String mappingId,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'delete_account_mapping',
        params: {
          'p_mapping_id': mappingId,
        },
      );

      // V1 RPC returns: [{success: bool, message: text}]
      final result = response.first as Map<String, dynamic>;
      if (result['success'] == false) {
        throw Exception(result['message']);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to delete account mapping: $e');
    }
  }

  /// Get available debt accounts for dropdown (receivable/payable only)
  /// Uses V1 RPC: get_debt_accounts_for_company
  /// Note: Accounts are shared (company_id is NULL), so we use any company_id
  Future<List<Map<String, dynamic>>> getAvailableAccounts({
    required String companyId,
  }) async {
    try {
      // Since accounts are shared, we can use the provided company_id
      // The RPC will filter accounts based on debt_tag/category_tag
      final response = await _client.rpc<List<dynamic>>(
        'get_debt_accounts_for_company',
        params: {'p_company_id': companyId},
      );

      if (response.isEmpty) return [];

      // Convert response to list
      final List<Map<String, dynamic>> accounts = response
          .map((item) => item as Map<String, dynamic>)
          .toList();

      // Filter to only return debt accounts
      return accounts.where((account) {
        final isDebtAccount = account['is_debt_account'];
        return isDebtAccount == true;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch debt accounts: $e');
    }
  }

  /// Get linked company info from counterparty
  /// Uses RPC: get_counterparties_v3 (linked_info mode)
  Future<Map<String, dynamic>?> getLinkedCompanyInfo({
    required String counterpartyId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_counterparties_v3',
        params: {
          'p_counterparty_id': counterpartyId,
          'p_mode': 'linked_info',
        },
      );

      if (response['success'] != true) {
        // Not found is not an error, return null
        if (response['error'] == 'Counterparty not found') {
          return null;
        }
        throw Exception(response['error'] ?? 'Failed to fetch linked company info');
      }

      final linkedCompanyId = response['linked_company_id'];
      if (linkedCompanyId == null) {
        return {'linked_company_id': null};
      }

      return {
        'linked_company_id': linkedCompanyId.toString(),
      };
    } catch (e) {
      throw Exception('Failed to fetch linked company info: $e');
    }
  }
}
