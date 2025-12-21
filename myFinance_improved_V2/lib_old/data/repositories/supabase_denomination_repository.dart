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
      final updateData = <String, dynamic>{};

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
      print('Attempting to soft delete denomination with ID: $denominationId');
      
      // First check if the denomination exists and is not already deleted
      final checkResult = await _client
          .from('currency_denominations')
          .select('*')
          .eq('denomination_id', denominationId)
          .eq('is_deleted', false)  // Only check non-deleted denominations
          .single();  // Use single() instead of maybeSingle() to ensure we get exactly one row
      
      print('Found denomination to soft delete: $checkResult');
      final companyId = checkResult['company_id'] as String;
      final currencyId = checkResult['currency_id'] as String;
      final value = checkResult['value'];
      print('Company ID: $companyId, Currency ID: $currencyId, Value: $value');
      
      // Perform soft delete by updating is_deleted to true with more specific targeting
      print('Executing soft delete (updating is_deleted to true) for SPECIFIC denomination...');
      
      // Use a more targeted approach - only filter by denomination_id since it should be unique
      final updateResult = await _client
          .from('currency_denominations')
          .update({
            'is_deleted': true,
          })
          .eq('denomination_id', denominationId)  // Primary filter - denomination_id should be unique
          .eq('is_deleted', false)  // Additional safety - only update if not already deleted
          .select('denomination_id, value, is_deleted');  // Return specific fields to verify update
      
      print('Soft delete query executed. Update result count: ${updateResult.length}');
      print('Updated records: $updateResult');
      
      if (updateResult.isEmpty) {
        print('No records updated - denomination may have been already deleted or not found');
        throw Exception('Denomination not found or already deleted');
      }
      
      if (updateResult.length > 1) {
        print('WARNING: Multiple records updated! This should not happen with denomination_id');
        print('Updated records: $updateResult');
        throw Exception('Multiple denominations were updated - data integrity issue');
      }
      
      // Verify the specific denomination was updated
      final updatedRecord = updateResult.first;
      if (updatedRecord['denomination_id'] != denominationId) {
        print('ERROR: Wrong denomination updated!');
        throw Exception('Wrong denomination was updated');
      }
      
      if (updatedRecord['is_deleted'] != true) {
        print('ERROR: is_deleted was not set to true');
        throw Exception('Soft delete failed - is_deleted not updated');
      }
      
    } catch (e) {
      
      // If it's a "No rows returned" error from single(), convert to more user-friendly message
      if (e.toString().contains('No rows returned')) {
        throw Exception('Denomination not found or already deleted');
      }
      
      rethrow;
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