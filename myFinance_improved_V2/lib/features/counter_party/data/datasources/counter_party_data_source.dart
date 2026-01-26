import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Counter Party Data Source - Direct Supabase interaction
/// Uses get_counterparties_v3 RPC for all READ operations
/// Uses counter_party_manage_counter_party RPC for all WRITE operations (insert, update, delete)
class CounterPartyDataSource {
  final SupabaseClient _client;

  CounterPartyDataSource(this._client);

  /// Get all counter parties for a company
  /// Uses RPC mode: 'list'
  Future<List<Map<String, dynamic>>> getCounterParties({
    required String companyId,
    List<String>? typeFilters,
    bool? isInternal,
    DateTime? createdAfter,
    DateTime? createdBefore,
    String sortColumn = 'is_internal',
    bool ascending = false,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_counterparties_v3',
      params: {
        'p_company_id': companyId,
        'p_counterparty_types': typeFilters,
        'p_is_internal': isInternal,
        'p_created_after': createdAfter != null ? DateTimeUtils.toUtc(createdAfter) : null,
        'p_created_before': createdBefore != null ? DateTimeUtils.toUtc(createdBefore) : null,
        'p_sort_column': sortColumn,
        'p_sort_ascending': ascending,
        'p_mode': 'list',
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to fetch counterparties');
    }

    return List<Map<String, dynamic>>.from(response['data'] as List);
  }

  /// Get counter party by ID
  /// Uses RPC mode: 'single'
  Future<Map<String, dynamic>?> getCounterPartyById(String counterpartyId) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_counterparties_v3',
      params: {
        'p_counterparty_id': counterpartyId,
        'p_mode': 'single',
      },
    );

    if (response['success'] != true) {
      // Not found is not an error, return null
      if (response['error'] == 'Counterparty not found') {
        return null;
      }
      throw Exception(response['error'] ?? 'Failed to fetch counterparty');
    }

    return response['data'] as Map<String, dynamic>;
  }

  /// Check if internal counterparty with same linked_company_id already exists
  /// Uses RPC mode: 'duplicate_check'
  Future<bool> checkDuplicateInternalCounterparty({
    required String companyId,
    required String linkedCompanyId,
    String? excludeCounterpartyId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_counterparties_v3',
      params: {
        'p_company_id': companyId,
        'p_linked_company_id': linkedCompanyId,
        'p_counterparty_id': excludeCounterpartyId,
        'p_mode': 'duplicate_check',
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to check duplicate');
    }

    return response['exists'] as bool;
  }

  /// Get linked company IDs for a company's counterparties
  /// Uses RPC mode: 'linked_ids'
  Future<Set<String>> getLinkedCompanyIds({
    required String companyId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_counterparties_v3',
      params: {
        'p_company_id': companyId,
        'p_mode': 'linked_ids',
      },
    );

    if (response['success'] != true) {
      throw Exception(response['error'] ?? 'Failed to fetch linked IDs');
    }

    final data = response['data'] as List;
    return data.map((id) => id.toString()).toSet();
  }

  /// Create counter party
  /// Uses RPC: counter_party_manage_counter_party (mode: 'insert')
  Future<Map<String, dynamic>> createCounterParty({
    required String companyId,
    required String name,
    required String type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    bool isInternal = false,
    String? linkedCompanyId,
    String? createdBy,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'counter_party_manage_counter_party',
      params: {
        'p_mode': 'insert',
        'p_company_id': companyId,
        'p_name': name,
        'p_type': type,
        'p_email': email,
        'p_phone': phone,
        'p_address': address,
        'p_notes': notes,
        'p_is_internal': isInternal,
        'p_linked_company_id': linkedCompanyId,
        'p_created_by': createdBy,
      },
    );

    if (response['success'] != true) {
      final error = response['error'] as String?;
      // Convert error codes to user-friendly messages
      switch (error) {
        case 'DUPLICATE_LINKED':
          throw Exception(
            'This internal company is already registered as a counterparty. '
            'Each company can only have one counterparty linked to the same internal company.'
          );
        case 'MISSING_NAME':
          throw Exception('Counterparty name is required.');
        case 'MISSING_COMPANY_ID':
          throw Exception('Company ID is required.');
        case 'MISSING_LINKED_COMPANY':
          throw Exception('Linked company ID is required for internal counterparties.');
        default:
          throw Exception(error ?? 'Failed to create counterparty');
      }
    }

    return response['data'] as Map<String, dynamic>;
  }

  /// Update counter party
  /// Uses RPC: counter_party_manage_counter_party (mode: 'update')
  Future<Map<String, dynamic>> updateCounterParty({
    required String counterpartyId,
    required String name,
    required String type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    bool isInternal = false,
    String? linkedCompanyId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'counter_party_manage_counter_party',
      params: {
        'p_mode': 'update',
        'p_counterparty_id': counterpartyId,
        'p_name': name,
        'p_type': type,
        'p_email': email,
        'p_phone': phone,
        'p_address': address,
        'p_notes': notes,
        'p_is_internal': isInternal,
        'p_linked_company_id': linkedCompanyId,
      },
    );

    if (response['success'] != true) {
      final error = response['error'] as String?;
      // Convert error codes to user-friendly messages
      switch (error) {
        case 'DUPLICATE_LINKED':
          throw Exception(
            'This internal company is already registered as a counterparty. '
            'Each company can only have one counterparty linked to the same internal company.'
          );
        case 'NOT_FOUND':
          throw Exception('Counterparty not found.');
        case 'ALREADY_DELETED':
          throw Exception('This counterparty has already been deleted.');
        case 'INTERNAL_NO_MODIFY':
          throw Exception('Cannot modify internal status of system-managed counterparties.');
        case 'MISSING_COUNTERPARTY_ID':
          throw Exception('Counterparty ID is required.');
        default:
          throw Exception(error ?? 'Failed to update counterparty');
      }
    }

    return response['data'] as Map<String, dynamic>;
  }

  /// Validate if counter party can be deleted
  /// Uses RPC: can_delete_counterparty
  /// Returns validation result with debt and transaction info
  Future<Map<String, dynamic>> validateDeletion(String counterpartyId) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'can_delete_counterparty',
      params: {'p_counterparty_id': counterpartyId},
    );

    return response;
  }

  /// Soft delete counter party
  /// Uses RPC: counter_party_manage_counter_party (mode: 'delete')
  Future<void> deleteCounterParty(String counterpartyId) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'counter_party_manage_counter_party',
      params: {
        'p_mode': 'delete',
        'p_counterparty_id': counterpartyId,
      },
    );

    if (response['success'] != true) {
      final error = response['error'] as String?;
      // Convert error codes to user-friendly messages
      switch (error) {
        case 'NOT_FOUND':
          throw Exception('Counterparty not found.');
        case 'ALREADY_DELETED':
          throw Exception('This counterparty has already been deleted.');
        case 'INTERNAL_NO_DELETE':
          throw Exception('Internal counterparties are system-managed and cannot be deleted.');
        case 'MISSING_COUNTERPARTY_ID':
          throw Exception('Counterparty ID is required.');
        default:
          throw Exception(error ?? 'Failed to delete counterparty');
      }
    }
  }

}
