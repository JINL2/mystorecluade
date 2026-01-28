import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/denomination.dart';
import '../../domain/entities/denomination_delete_result.dart';
import '../../domain/repositories/denomination_repository.dart';
import '../mappers/currency_info_mapper.dart';
import '../mappers/denomination_delete_result_mapper.dart';
import '../services/denomination_template_service.dart';

class SupabaseDenominationRepository implements DenominationRepository {
  final SupabaseClient _client;
  final DenominationTemplateService _templateService;

  SupabaseDenominationRepository(this._client, this._templateService);

  /// Fetch denominations for a specific currency using RPC
  Future<List<Denomination>> _fetchDenominationsFromRpc(
    String companyId,
    String currencyId,
  ) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'register_denomination_get_currency_info',
      params: {
        'p_company_id': companyId,
        'p_currency_id': currencyId,
      },
    );

    final result = CurrencyInfoMapper.fromRpcResponse(response);

    // Find the specific currency and return its denominations
    for (final currency in result.companyCurrencies) {
      if (currency.id == currencyId) {
        return currency.denominations;
      }
    }

    return [];
  }

  @override
  Future<List<Denomination>> getCurrencyDenominations(String companyId, String currencyId) async {
    try {
      return await _fetchDenominationsFromRpc(companyId, currencyId);
    } catch (e) {
      throw Exception('Failed to fetch currency denominations: $e');
    }
  }

  @override
  Future<Denomination> addDenomination(DenominationInput input) async {
    try {
      // Use RPC for single denomination - wraps in array format
      final response = await _client.rpc<Map<String, dynamic>>(
        'register_denomination_upsert_denomination',
        params: {
          'p_company_id': input.companyId,
          'p_currency_id': input.currencyId,
          'p_denominations': [
            {
              'value': input.value,
              'type': input.type.name,
            },
          ],
        },
      );

      if (response['success'] != true) {
        final errorCode = response['error_code'] as String?;
        final errorMessage = response['error'] as String? ?? 'Failed to add denomination';

        if (errorCode == 'CURRENCY_NOT_IN_COMPANY') {
          throw Exception('Currency is not added to your company');
        }
        throw Exception(errorMessage);
      }

      // Get the first result from results array
      final results = response['results'] as List<dynamic>;
      if (results.isEmpty) {
        throw Exception('No result returned from RPC');
      }

      final result = results.first as Map<String, dynamic>;
      final operation = result['operation'] as String?;

      // Handle already_exists case
      if (operation == 'already_exists') {
        throw Exception('This denomination already exists');
      }

      // Handle error case
      if (result['error'] != null) {
        throw Exception(result['error'] as String);
      }

      final denominationId = result['denomination_id'] as String;
      final type = input.type;

      return Denomination(
        id: denominationId,
        companyId: input.companyId,
        currencyId: input.currencyId,
        value: input.value,
        type: type,
        displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
        emoji: type == DenominationType.coin ? '🪙' : '💵',
        isActive: true,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to add denomination: $e');
    }
  }

  @override
  Future<DenominationDeleteResult> removeDenomination(String denominationId, String companyId) async {
    try {
      // Call RPC function for safe deletion with detailed blocking info
      final response = await _client.rpc<Map<String, dynamic>>(
        'safe_delete_denomination',
        params: {
          'p_denomination_id': denominationId,
          'p_company_id': companyId,
        },
      );

      // Use mapper to convert RPC response to domain entity
      return DenominationDeleteResultMapper.fromRpcResponse(response);
    } catch (e) {
      return DenominationDeleteResult(
        success: false,
        error: 'Failed to delete denomination: $e',
      );
    }
  }

  @override
  Future<List<Denomination>> applyDenominationTemplate(
    String currencyCode,
    String companyId,
    String currencyId,
  ) async {
    try {
      final template = _templateService.getTemplate(currencyCode);
      if (template.isEmpty) {
        throw Exception('No template found for currency: $currencyCode');
      }

      final inputs = template.map((templateItem) => DenominationInput(
        companyId: companyId,
        currencyId: currencyId,
        value: templateItem.value,
        type: templateItem.type,
        displayName: templateItem.displayName,
        emoji: templateItem.emoji,
      ),).toList();

      return await addBulkDenominations(inputs);
    } catch (e) {
      throw Exception('Failed to apply denomination template: $e');
    }
  }

  @override
  Future<List<Denomination>> addBulkDenominations(List<DenominationInput> inputs) async {
    if (inputs.isEmpty) return [];

    try {
      // Get companyId and currencyId from first input (all should be same)
      final companyId = inputs.first.companyId;
      final currencyId = inputs.first.currencyId;

      // Prepare denominations array for RPC
      final denominationsData = inputs
          .map(
            (input) => {
              'value': input.value,
              'type': input.type.name,
            },
          )
          .toList();

      final response = await _client.rpc<Map<String, dynamic>>(
        'register_denomination_upsert_denomination',
        params: {
          'p_company_id': companyId,
          'p_currency_id': currencyId,
          'p_denominations': denominationsData,
        },
      );

      if (response['success'] != true) {
        final errorCode = response['error_code'] as String?;
        final errorMessage = response['error'] as String? ?? 'Failed to add denominations';

        if (errorCode == 'CURRENCY_NOT_IN_COMPANY') {
          throw Exception('Currency is not added to your company');
        }
        throw Exception(errorMessage);
      }

      // Parse results from RPC response
      final results = response['results'] as List<dynamic>;
      final denominations = <Denomination>[];

      for (final result in results) {
        final resultMap = result as Map<String, dynamic>;
        final operation = resultMap['operation'] as String?;

        // Skip items that already exist or had errors
        if (operation == 'already_exists' || resultMap['error'] != null) {
          continue;
        }

        final denominationId = resultMap['denomination_id'] as String;
        final value = (resultMap['value'] as num).toDouble();
        final typeValue = resultMap['type'] as String? ?? 'bill';
        final type = typeValue == 'coin' ? DenominationType.coin : DenominationType.bill;

        denominations.add(
          Denomination(
            id: denominationId,
            companyId: companyId,
            currencyId: currencyId,
            value: value,
            type: type,
            displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
            emoji: type == DenominationType.coin ? '🪙' : '💵',
            isActive: true,
            createdAt: DateTime.now(),
          ),
        );
      }

      return denominations;
    } catch (e) {
      throw Exception('Failed to add bulk denominations: $e');
    }
  }

  @override
  Future<DenominationValidationResult> validateDenominations(
    String companyId,
    String currencyId,
    List<DenominationInput> denominations,
  ) async {
    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];

    // Check for duplicates
    final values = denominations.map((d) => d.value).toList();
    final duplicates = <double>[];
    for (var i = 0; i < values.length; i++) {
      for (var j = i + 1; j < values.length; j++) {
        if (values[i] == values[j] && !duplicates.contains(values[i])) {
          duplicates.add(values[i]);
        }
      }
    }

    if (duplicates.isNotEmpty) {
      errors.add('Duplicate denominations found: ${duplicates.join(', ')}');
    }

    // Check for logical gaps (currency-specific suggestions)
    final sortedValues = values..sort();
    if (sortedValues.isNotEmpty) {
      // Basic completeness check
      if (sortedValues.length < 5) {
        suggestions.add('Consider adding more denominations for better change-making');
      }

      // Check for missing small denominations
      if (sortedValues.first > 0.01 && sortedValues.first < 1.0) {
        warnings.add('Missing smaller denominations might affect change-making efficiency');
      }
    }

    return DenominationValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
    );
  }

  @override
  Stream<List<Denomination>> watchCurrencyDenominations(String companyId, String currencyId) {
    // Use stream as a trigger, then fetch from RPC for consistent data
    return _client
        .from('currency_denominations')
        .select('denomination_id')
        .eq('company_id', companyId)
        .eq('currency_id', currencyId)
        .eq('is_deleted', false)
        .asStream()
        .asyncMap((_) => _fetchDenominationsFromRpc(companyId, currencyId));
  }

  @override
  Future<DenominationStats> getDenominationStats(String companyId, String currencyId) async {
    try {
      final denominations = await getCurrencyDenominations(companyId, currencyId);

      if (denominations.isEmpty) {
        return const DenominationStats(
          totalCount: 0,
          coinCount: 0,
          billCount: 0,
          minValue: 0.0,
          maxValue: 0.0,
          averageValue: 0.0,
          hasDuplicates: false,
          hasGaps: false,
        );
      }

      final values = denominations.map((d) => d.value).toList()..sort();
      final coinCount = denominations.where((d) => d.type == DenominationType.coin).length;
      final billCount = denominations.where((d) => d.type == DenominationType.bill).length;

      // Check for duplicates
      final hasDuplicates = values.toSet().length != values.length;

      // Simple gap detection (gaps larger than expected)
      bool hasGaps = false;
      for (int i = 0; i < values.length - 1; i++) {
        final ratio = values[i + 1] / values[i];
        if (ratio > 10) { // Arbitrary threshold for "large gap"
          hasGaps = true;
          break;
        }
      }

      return DenominationStats(
        totalCount: denominations.length,
        coinCount: coinCount,
        billCount: billCount,
        minValue: values.first,
        maxValue: values.last,
        averageValue: values.reduce((a, b) => a + b) / values.length,
        hasDuplicates: hasDuplicates,
        hasGaps: hasGaps,
      );
    } catch (e) {
      throw Exception('Failed to get denomination stats: $e');
    }
  }
}
