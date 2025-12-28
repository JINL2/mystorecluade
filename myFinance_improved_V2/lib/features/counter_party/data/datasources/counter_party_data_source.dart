import 'package:flutter/foundation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Counter Party Data Source - Direct Supabase interaction
class CounterPartyDataSource {
  final SupabaseClient _client;

  CounterPartyDataSource(this._client);

  /// Get all counter parties for a company
  /// Includes linked company name for internal counterparties
  Future<List<Map<String, dynamic>>> getCounterParties({
    required String companyId,
    List<String>? typeFilters,
    bool? isInternal,
    DateTime? createdAfter,
    DateTime? createdBefore,
    String sortColumn = 'is_internal',
    bool ascending = false,
  }) async {
    // Join with companies table to get linked company name
    var query = _client
        .from('counterparties')
        .select('*, linked_company:linked_company_id(company_name)')
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

    // Flatten linked_company data for easier access
    final results = List<Map<String, dynamic>>.from(response as List);
    return results.map((item) {
      final linkedCompany = item['linked_company'] as Map<String, dynamic>?;
      return {
        ...item,
        'linked_company_name': linkedCompany?['company_name'],
      };
    }).toList();
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

  /// Check if internal counterparty with same linked_company_id already exists
  Future<bool> checkDuplicateInternalCounterparty({
    required String companyId,
    required String linkedCompanyId,
    String? excludeCounterpartyId,
  }) async {
    var query = _client
        .from('counterparties')
        .select('counterparty_id')
        .eq('company_id', companyId)
        .eq('linked_company_id', linkedCompanyId)
        .eq('is_deleted', false);

    // Exclude current counterparty when updating
    if (excludeCounterpartyId != null) {
      query = query.neq('counterparty_id', excludeCounterpartyId);
    }

    final response = await query.maybeSingle();
    return response != null;
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

  /// Get all linkable internal companies with linked status
  /// Shows only companies owned by the same owner as the current company
  /// (True "internal" companies - same owner, different entities)
  /// Already linked companies are sorted to the bottom
  Future<List<Map<String, dynamic>>> getUnlinkedCompanies({
    required String userId,
    required String companyId,
  }) async {
    try {
      debugPrint('🔍 [getUnlinkedCompanies] Fetching with userId: $userId, companyId: $companyId');

      // Step 1: Get the current company's owner_id
      final currentCompany = await _client
          .from('companies')
          .select('owner_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (currentCompany == null) {
        debugPrint('❌ [getUnlinkedCompanies] Current company not found');
        return [];
      }

      final ownerId = currentCompany['owner_id'] as String?;
      if (ownerId == null) {
        debugPrint('❌ [getUnlinkedCompanies] Current company has no owner');
        return [];
      }

      debugPrint('🔍 [getUnlinkedCompanies] Current company owner: $ownerId');

      // Step 2: Get all companies owned by the same owner (true internal companies)
      final ownedCompanies = await _client
          .from('companies')
          .select('company_id, company_name')
          .eq('owner_id', ownerId)
          .eq('is_deleted', false)
          .neq('company_id', companyId); // Exclude current company

      debugPrint('🔍 [getUnlinkedCompanies] Same-owner companies: ${ownedCompanies.length}');

      // Step 3: Get already linked company IDs for current company's counterparties
      final linkedCounterparties = await _client
          .from('counterparties')
          .select('linked_company_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .not('linked_company_id', 'is', null);

      final linkedIds = (linkedCounterparties as List)
          .map((cp) => cp['linked_company_id'] as String)
          .toSet();

      debugPrint('🔍 [getUnlinkedCompanies] Already linked IDs: $linkedIds');

      // Step 4: Build result with owned companies, marking linked status
      final availableCompanies = <Map<String, dynamic>>[];
      final linkedCompanies = <Map<String, dynamic>>[];

      for (final company in ownedCompanies) {
        final cid = company['company_id'] as String;
        final isAlreadyLinked = linkedIds.contains(cid);

        final companyData = {
          'company_id': cid,
          'company_name': company['company_name'] as String,
          'is_already_linked': isAlreadyLinked,
        };

        if (isAlreadyLinked) {
          linkedCompanies.add(companyData);
        } else {
          availableCompanies.add(companyData);
        }
      }

      // Sort: available companies first, then linked companies at the bottom
      final result = [...availableCompanies, ...linkedCompanies];

      debugPrint('✅ [getUnlinkedCompanies] Returning ${result.length} internal companies (${linkedCompanies.length} already linked)');
      return result;
    } catch (e, stack) {
      debugPrint('❌ [getUnlinkedCompanies] Error: $e');
      debugPrint('❌ [getUnlinkedCompanies] Stack: $stack');
      return [];
    }
  }
}
