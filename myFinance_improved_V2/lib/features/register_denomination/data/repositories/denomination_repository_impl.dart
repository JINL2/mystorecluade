import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/entities/denomination_delete_result.dart';
import '../../domain/repositories/denomination_repository.dart';
import '../mappers/denomination_delete_result_mapper.dart';
import '../services/denomination_template_service.dart';

class SupabaseDenominationRepository implements DenominationRepository {
  final SupabaseClient _client;
  final DenominationTemplateService _templateService;
  final Uuid _uuid = const Uuid();

  SupabaseDenominationRepository(this._client, this._templateService);

  @override
  Future<List<Denomination>> getCurrencyDenominations(String companyId, String currencyId) async {
    try {
      final response = await _client
          .from('currency_denominations')
          .select('*')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .eq('is_deleted', false)  // Only fetch non-deleted denominations
          .order('value');

      return (response as List).map((json) {
        // Convert database fields to Denomination model
        // Handle NULL values by defaulting to 'bill'
        final typeValue = json['type'] as String? ?? 'bill';
        final type = typeValue == 'coin' ? DenominationType.coin : DenominationType.bill;
        return Denomination(
          id: json['denomination_id'] as String,
          companyId: json['company_id'] as String,
          currencyId: json['currency_id'] as String,
          value: (json['value'] as num).toDouble(),
          type: type,
          displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
          emoji: type == DenominationType.coin ? '🪙' : '💵',
          isActive: true,
          createdAt: json['created_at'] != null ? DateTimeUtils.toLocal(json['created_at'] as String) : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch currency denominations: $e');
    }
  }

  @override
  Future<Denomination> addDenomination(DenominationInput input) async {
    try {
      // Check if this exact denomination was previously soft deleted
      final existingDeleted = await _client
          .from('currency_denominations')
          .select('denomination_id')
          .eq('company_id', input.companyId)
          .eq('currency_id', input.currencyId)
          .eq('value', input.value)
          .eq('type', input.type.name)
          .eq('is_deleted', true)
          .maybeSingle();

      String denominationId;

      if (existingDeleted != null) {
        // Reactivate the existing soft-deleted denomination
        denominationId = existingDeleted['denomination_id'] as String;

        final result = await _client
            .from('currency_denominations')
            .update({'is_deleted': false})
            .eq('denomination_id', denominationId)
            .eq('company_id', input.companyId)
            .eq('currency_id', input.currencyId)
            .select();

        if (result.isEmpty) {
          throw Exception('Failed to reactivate denomination');
        }
      } else {
        // Create new denomination
        denominationId = _uuid.v4();

        final insertData = {
          'denomination_id': denominationId,
          'company_id': input.companyId,
          'currency_id': input.currencyId,
          'value': input.value,
          'type': input.type.name,
          'is_deleted': false,
          'created_at': DateTimeUtils.nowUtc(),
        };

        await _client.from('currency_denominations').insert(insertData).select();
      }

      return Denomination(
        id: denominationId,
        companyId: input.companyId,
        currencyId: input.currencyId,
        value: input.value,
        type: input.type,
        displayName: input.type == DenominationType.coin ? 'Coin' : 'Bill',
        emoji: input.type == DenominationType.coin ? '🪙' : '💵',
        isActive: true,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to add denomination: $e');
    }
  }

  @override
  Future<Denomination> updateDenomination(String denominationId, {
    double? value,
    DenominationType? type,
    String? displayName,
    String? emoji,
    bool? isActive,
  }) async {
    try {
      // First, fetch current denomination to get company_id for safety
      final current = await getDenomination(denominationId);
      if (current == null) {
        throw Exception('Denomination not found: $denominationId');
      }

      final updateData = <String, dynamic>{};

      if (value != null) updateData['value'] = value;
      if (type != null) updateData['type'] = type.name;
      if (isActive != null) updateData['is_active'] = isActive;
      // Note: display_name and emoji don't exist in database

      if (updateData.isEmpty) {
        return current; // No updates needed
      }

      final result = await _client
          .from('currency_denominations')
          .update(updateData)
          .eq('denomination_id', denominationId)
          .eq('company_id', current.companyId) // Add safety filter
          .eq('currency_id', current.currencyId) // Additional safety
          .select();

      if (result.isEmpty) {
        throw Exception('Update failed - no rows affected');
      }

      // Fetch and return the updated denomination
      final updatedDenomination = await getDenomination(denominationId);
      if (updatedDenomination == null) {
        throw Exception('Failed to fetch updated denomination');
      }
      return updatedDenomination;
    } catch (e) {
      throw Exception('Failed to update denomination: $e');
    }
  }

  @override
  Future<bool> isDenominationInUse(String denominationId) async {
    try {
      // Check if denomination is used in cashier_amount_lines
      final cashierResult = await _client
          .from('cashier_amount_lines')
          .select('id')
          .eq('denomination_id', denominationId)
          .limit(1);

      if ((cashierResult as List).isNotEmpty) {
        return true;
      }

      // Check if denomination is used in vault_amount_line
      final vaultResult = await _client
          .from('vault_amount_line')
          .select('id')
          .eq('denomination_id', denominationId)
          .limit(1);

      if ((vaultResult as List).isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception('Failed to check denomination usage: $e');
    }
  }

  @override
  Future<DenominationDeleteResult> removeDenomination(String denominationId, String companyId) async {
    try {
      // Call RPC function for safe deletion with detailed blocking info
      final response = await _client.rpc(
        'safe_delete_denomination',
        params: {
          'p_denomination_id': denominationId,
          'p_company_id': companyId,
        },
      );

      // Use mapper to convert RPC response to domain entity
      return DenominationDeleteResultMapper.fromRpcResponse(response as Map<String, dynamic>);
    } catch (e) {
      return DenominationDeleteResult(
        success: false,
        error: 'Failed to delete denomination: $e',
      );
    }
  }

  @override
  Future<Denomination?> getDenomination(String denominationId) async {
    try {
      final response = await _client
          .from('currency_denominations')
          .select('*')
          .eq('denomination_id', denominationId)
          .eq('is_deleted', false)  // Only fetch non-deleted denominations
          .single();

      final type = response['type'] == 'coin' ? DenominationType.coin : DenominationType.bill;
      return Denomination(
        id: response['denomination_id'] as String,
        companyId: response['company_id'] as String,
        currencyId: response['currency_id'] as String,
        value: (response['value'] as num).toDouble(),
        type: type,
        displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
        emoji: type == DenominationType.coin ? '🪙' : '💵',
        isActive: true,
        createdAt: response['created_at'] != null ? DateTimeUtils.toLocal(response['created_at'] as String) : null,
      );
    } catch (e) {
      if (e.toString().contains('No rows returned')) {
        return null;
      }
      throw Exception('Failed to fetch denomination: $e');
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
    try {
      final insertData = inputs.map((input) {
        final denominationId = _uuid.v4();

        return {
          'denomination_id': denominationId,
          'company_id': input.companyId,
          'currency_id': input.currencyId,
          'value': input.value,
          'type': input.type.name,
          'is_deleted': false,  // Initialize as not deleted
          'created_at': DateTimeUtils.nowUtc(),
        };
      }).toList();

      final result = await _client
          .from('currency_denominations')
          .insert(insertData)
          .select();

      // Verify all insertions succeeded
      if (result.length != insertData.length) {
        throw Exception(
          'Failed to insert all denominations: '
          'Expected ${insertData.length}, got ${result.length}'
        );
      }

      // Return the created denominations from actual DB data
      return (result as List).map((data) {
        // Handle NULL values by defaulting to 'bill'
        final typeValue = data['type'] as String? ?? 'bill';
        final type = typeValue == 'coin' ? DenominationType.coin : DenominationType.bill;
        return Denomination(
          id: data['denomination_id'] as String,
          companyId: data['company_id'] as String,
          currencyId: data['currency_id'] as String,
          value: data['value'] as double,
          type: type,
          displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
          emoji: type == DenominationType.coin ? '🪙' : '💵',
          isActive: true,
          createdAt: DateTime.now(),
        );
      }).toList();
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
    return _client
        .from('currency_denominations')
        .select()
        .eq('company_id', companyId)
        .eq('currency_id', currencyId)
        .eq('is_deleted', false)  // Only watch non-deleted denominations
        .asStream()
        .map((data) => (data as List).map((json) {
          // Handle NULL values by defaulting to 'bill'
        final typeValue = json['type'] as String? ?? 'bill';
        final type = typeValue == 'coin' ? DenominationType.coin : DenominationType.bill;
          return Denomination(
            id: json['denomination_id'] as String,
            companyId: json['company_id'] as String,
            currencyId: json['currency_id'] as String,
            value: (json['value'] as num).toDouble(),
            type: type,
            displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
            emoji: type == DenominationType.coin ? '🪙' : '💵',
            isActive: true,
            createdAt: json['created_at'] != null ? DateTimeUtils.toLocal(json['created_at'] as String) : null,
          );
        }).toList(),);
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