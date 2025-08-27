import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/repositories/denomination_repository.dart';
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
          id: json['denomination_id'],
          companyId: json['company_id'],
          currencyId: json['currency_id'],
          value: (json['value'] as num).toDouble(),
          type: type,
          displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
          emoji: type == DenominationType.coin ? '🪙' : '💵',
          isActive: true,
          createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
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
        await _client
            .from('currency_denominations')
            .update({
              'is_deleted': false,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('denomination_id', denominationId);
      } else {
        // Create new denomination
        denominationId = _uuid.v4();

        final insertData = {
          'denomination_id': denominationId,
          'company_id': input.companyId,
          'currency_id': input.currencyId,
          'value': input.value,
          'type': input.type.name, // 'coin' or 'bill'
          'is_deleted': false,  // Initialize as not deleted
          'created_at': DateTime.now().toIso8601String(),
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
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (value != null) updateData['value'] = value;
      if (type != null) updateData['type'] = type.name;
      // Note: display_name and emoji don't exist in database

      await _client
          .from('currency_denominations')
          .update(updateData)
          .eq('denomination_id', denominationId);

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
  Future<void> removeDenomination(String denominationId) async {
    try {
      print('=== DENOMINATION SOFT DELETE DEBUG ===');
      print('Attempting to soft delete denomination with ID: $denominationId');
      
      // First check if the denomination exists and is not already deleted
      final checkResult = await _client
          .from('currency_denominations')
          .select('*')
          .eq('denomination_id', denominationId)
          .eq('is_deleted', false)  // Only check non-deleted denominations
          .maybeSingle();
      
      if (checkResult == null) {
        print('Denomination not found or already deleted with ID: $denominationId');
        throw Exception('Denomination not found or already deleted');
      }
      
      print('Found denomination to soft delete: $checkResult');
      final companyId = checkResult['company_id'];
      final currencyId = checkResult['currency_id'];
      final value = checkResult['value'];
      print('Company ID: $companyId, Currency ID: $currencyId, Value: $value');
      
      // Perform soft delete by updating is_deleted to true
      print('Executing soft delete (updating is_deleted to true)...');
      final updateResult = await _client
          .from('currency_denominations')
          .update({'is_deleted': true})
          .eq('denomination_id', denominationId)
          .eq('company_id', companyId)  // Add company_id for RLS
          .eq('currency_id', currencyId)  // Add currency_id for extra safety
          .select();
      
      print('Soft delete query executed. Result: $updateResult');
      
      if (updateResult.isEmpty) {
        // Verify the update was successful
        final verifyResult = await _client
            .from('currency_denominations')
            .select('is_deleted')
            .eq('denomination_id', denominationId)
            .maybeSingle();
        
        if (verifyResult != null && verifyResult['is_deleted'] == true) {
          print('Soft delete successful (verified by checking is_deleted status)');
        } else {
          print('Failed to soft delete - is_deleted not updated. RLS or permission issue likely.');
          throw Exception('Failed to delete - check Supabase RLS policies.');
        }
      } else {
        print('Soft delete successful with returned data: $updateResult');
      }
      
      print('Successfully soft deleted denomination with ID: $denominationId');
      print('=== END SOFT DELETE DEBUG ===');
    } catch (e) {
      print('=== SOFT DELETE ERROR ===');
      print('Error soft deleting denomination: $e');
      throw Exception('Failed to remove denomination: ${e.toString().replaceAll('Exception: ', '')}');
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
        id: response['denomination_id'],
        companyId: response['company_id'],
        currencyId: response['currency_id'],
        value: (response['value'] as num).toDouble(),
        type: type,
        displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
        emoji: type == DenominationType.coin ? '🪙' : '💵',
        isActive: true,
        createdAt: response['created_at'] != null ? DateTime.parse(response['created_at']) : null,
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
      )).toList();

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
          'created_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      await _client.from('currency_denominations').insert(insertData);

      // Return the created denominations
      return insertData.map((data) {
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
            id: json['denomination_id'],
            companyId: json['company_id'],
            currencyId: json['currency_id'],
            value: (json['value'] as num).toDouble(),
            type: type,
            displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
            emoji: type == DenominationType.coin ? '🪙' : '💵',
            isActive: true,
            createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
          );
        }).toList());
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