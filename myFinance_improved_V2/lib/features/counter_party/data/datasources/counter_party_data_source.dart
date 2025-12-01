import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Counter Party Data Source - Direct Supabase interaction
class CounterPartyDataSource {
  final SupabaseClient _client;

  CounterPartyDataSource(this._client);

  /// Get all counter parties for a company
  Future<List<Map<String, dynamic>>> getCounterParties({
    required String companyId,
    List<String>? typeFilters,
    bool? isInternal,
    DateTime? createdAfter,
    DateTime? createdBefore,
    String sortColumn = 'is_internal',
    bool ascending = false,
  }) async {
    var query = _client
        .from('counterparties')
        .select()
        .eq('company_id', companyId)
        .eq('is_deleted', false);

    // Apply filters
    if (typeFilters != null && typeFilters.isNotEmpty) {
      query = query.inFilter('type', typeFilters);
    }

    if (isInternal != null) {
      query = query.eq('is_internal', isInternal);
    }

    if (createdAfter != null) {
      query = query.gte('created_at', DateTimeUtils.toUtc(createdAfter));
    }

    if (createdBefore != null) {
      query = query.lte('created_at', DateTimeUtils.toUtc(createdBefore));
    }

    // Apply sorting
    final response = await query.order(sortColumn, ascending: ascending);

    return List<Map<String, dynamic>>.from(response as List);
  }

  /// Get counter party by ID
  Future<Map<String, dynamic>?> getCounterPartyById(String counterpartyId) async {
    final response = await _client
        .from('counterparties')
        .select()
        .eq('counterparty_id', counterpartyId)
        .maybeSingle();

    return response;
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
  }

  /// Update counter party
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

    final response = await _client
        .from('counterparties')
        .update(updateData)
        .eq('counterparty_id', counterpartyId)
        .select()
        .single();

    return response;
  }

  /// Validate if counter party can be deleted
  /// Returns validation result with debt and transaction info
  Future<Map<String, dynamic>> validateDeletion(String counterpartyId) async {
    final response = await _client.rpc(
      'can_delete_counterparty',
      params: {'p_counterparty_id': counterpartyId},
    );

    return response as Map<String, dynamic>;
  }

  /// Soft delete counter party
  Future<void> deleteCounterParty(String counterpartyId) async {
    await _client.from('counterparties').update({
      'is_deleted': true,
      'updated_at': DateTimeUtils.nowUtc(), // ✅ UTC로 저장
    }).eq('counterparty_id', counterpartyId);
  }

  /// Get unlinked companies
  Future<List<Map<String, dynamic>>> getUnlinkedCompanies({
    required String userId,
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc('get_unlinked_companies', params: {
        'p_user_id': userId,
        'p_company_id': companyId,
      },);

      if (response == null) return [];
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
