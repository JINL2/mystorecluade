import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/services/account_mapping_validator.dart';

/// Implementation of AccountMappingValidator using Supabase
class AccountMappingValidatorImpl implements AccountMappingValidator {
  final SupabaseClient _client;

  AccountMappingValidatorImpl(this._client);

  @override
  Future<bool> hasAccountMapping({
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
  }) async {
    try {
      final response = await _client
          .from('account_mappings')
          .select('mapping_id')
          .eq('my_company_id', myCompanyId)
          .eq('my_account_id', myAccountId)
          .eq('counterparty_id', counterpartyId)
          .eq('is_deleted', false)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isInternalCounterparty(String counterpartyId) async {
    try {
      final response = await _client
          .from('counterparties')
          .select('is_internal, linked_company_id')
          .eq('counterparty_id', counterpartyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (response == null) return false;
      return response['is_internal'] == true && response['linked_company_id'] != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<CounterpartyInfo?> getCounterpartyInfo(String counterpartyId) async {
    try {
      final response = await _client
          .from('counterparties')
          .select('counterparty_id, name, is_internal, linked_company_id')
          .eq('counterparty_id', counterpartyId)
          .eq('is_deleted', false)
          .maybeSingle();

      if (response == null) return null;

      return CounterpartyInfo(
        counterpartyId: response['counterparty_id'].toString(),
        linkedCompanyId: response['linked_company_id']?.toString(),
        isInternal: response['is_internal'] == true,
        name: response['name'] ?? 'Unknown',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<AccountMappingValidationError>> validateTemplateAccountMappings({
    required String companyId,
    required List<Map<String, dynamic>> templateData,
  }) async {
    final errors = <AccountMappingValidationError>[];

    for (final line in templateData) {
      final counterpartyId = line['counterparty_id']?.toString();
      final accountId = line['account_id']?.toString();
      final accountName = line['account_name']?.toString() ?? 'Unknown Account';

      // Skip if no counterparty
      if (counterpartyId == null || counterpartyId.isEmpty) continue;
      if (accountId == null || accountId.isEmpty) continue;

      // Check if counterparty is internal
      final counterpartyInfo = await getCounterpartyInfo(counterpartyId);
      if (counterpartyInfo == null) continue;

      // Only validate internal counterparties
      if (!counterpartyInfo.isInternal) continue;

      // Check if account mapping exists
      final hasMapping = await hasAccountMapping(
        myCompanyId: companyId,
        myAccountId: accountId,
        counterpartyId: counterpartyId,
      );

      if (!hasMapping) {
        errors.add(AccountMappingValidationError(
          accountId: accountId,
          accountName: accountName,
          counterpartyId: counterpartyId,
          counterpartyName: counterpartyInfo.name,
          message: 'Account mapping required: "${counterpartyInfo.name}" is an internal company. '
              'Please set up account mapping for "$accountName" in Counter Party > Account Settings.',
        ));
      }
    }

    return errors;
  }
}
