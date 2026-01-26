import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Counter Party Data Source - Direct Supabase interaction
/// Uses get_counterparties_v3 RPC for all READ operations
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
  }) async {
    // Check for duplicate internal counterparty before insert
    if (isInternal && linkedCompanyId != null) {
      final isDuplicate = await checkDuplicateInternalCounterparty(
        companyId: companyId,
        linkedCompanyId: linkedCompanyId,
      );
      if (isDuplicate) {
        throw Exception(
          'This internal company is already registered as a counterparty. '
          'Each company can only have one counterparty linked to the same internal company.'
        );
      }
    }

    try {
      final response = await _client.from('counterparties').insert({
        'company_id': companyId,
        'name': name,
        'type': type,
        'email': email,
        'phone': phone,
        'address': address,
        'notes': notes,
        'is_internal': isInternal,
        'linked_company_id': linkedCompanyId,
        'created_at': DateTimeUtils.nowUtc(), // ✅ UTC로 저장
      }).select().single();

      return response;
    } on PostgrestException catch (e) {
      // Handle unique constraint violation
      if (e.code == '23505' && e.message.contains('counterparties_company_linked_unique')) {
        throw Exception(
          'This internal company is already registered as a counterparty. '
          'Each company can only have one counterparty linked to the same internal company.'
        );
      }
      rethrow;
    }
  }

  /// Update counter party
  Future<Map<String, dynamic>> updateCounterParty({
    required String counterpartyId,
    required String companyId,
    required String name,
    required String type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    bool isInternal = false,
    String? linkedCompanyId,
  }) async {
    // Check for duplicate internal counterparty before update
    if (isInternal && linkedCompanyId != null) {
      final isDuplicate = await checkDuplicateInternalCounterparty(
        companyId: companyId,
        linkedCompanyId: linkedCompanyId,
        excludeCounterpartyId: counterpartyId, // Exclude self
      );
      if (isDuplicate) {
        throw Exception(
          'This internal company is already registered as a counterparty. '
          'Each company can only have one counterparty linked to the same internal company.'
        );
      }
    }

    final updateData = {
      'name': name,
      'type': type,
      'email': email,
      'phone': phone,
      'address': address,
      'notes': notes,
      'is_internal': isInternal,
      'linked_company_id': linkedCompanyId,
    };

    try {
      final response = await _client
          .from('counterparties')
          .update(updateData)
          .eq('counterparty_id', counterpartyId)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      // Handle unique constraint violation
      if (e.code == '23505' && e.message.contains('counterparties_company_linked_unique')) {
        throw Exception(
          'This internal company is already registered as a counterparty. '
          'Each company can only have one counterparty linked to the same internal company.'
        );
      }
      rethrow;
    }
  }

  /// Validate if counter party can be deleted
  /// Returns validation result with debt and transaction info
  Future<Map<String, dynamic>> validateDeletion(String counterpartyId) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'can_delete_counterparty',
      params: {'p_counterparty_id': counterpartyId},
    );

    return response;
  }

  /// Soft delete counter party
  Future<void> deleteCounterParty(String counterpartyId) async {
    await _client.from('counterparties').update({
      'is_deleted': true,
      'updated_at': DateTimeUtils.nowUtc(), // ✅ UTC로 저장
    }).eq('counterparty_id', counterpartyId);
  }

}
