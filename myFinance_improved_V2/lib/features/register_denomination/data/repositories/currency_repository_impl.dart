import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/repositories/currency_repository.dart';

class SupabaseCurrencyRepository implements CurrencyRepository {
  final SupabaseClient _client;

  SupabaseCurrencyRepository(this._client);
  
  // Default flag emoji for currencies without a flag
  static const String _defaultFlagEmoji = '🏳️';

  @override
  Future<List<CurrencyType>> getAvailableCurrencyTypes() async {
    try {
      final response = await _client
          .from('currency_types')
          .select('*')
          .order('currency_name');

      return (response as List)
          .map((json) => CurrencyType(
            currencyId: json['currency_id'] as String,
            currencyCode: json['currency_code'] as String,
            currencyName: json['currency_name'] as String,
            symbol: json['symbol'] as String,
            flagEmoji: json['flag_emoji'] as String? ?? _defaultFlagEmoji,
            createdAt: json['created_at'] != null ? DateTimeUtils.toLocal(json['created_at'] as String) : null,
          ),)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch available currency types: $e');
    }
  }

  @override
  Future<List<Currency>> getCompanyCurrencies(String companyId) async {
    try {
      // First get company currencies with company_currency_id (only non-deleted)
      final companyCurrencies = await _client
          .from('company_currency')
          .select('company_currency_id, currency_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false);  // Only fetch non-deleted company currencies

      if (companyCurrencies.isEmpty) return [];

      // Create a map of currency_id to company_currency_id
      final currencyIdToCompanyCurrencyId = <String, String>{};
      final currencyIds = <String>[];
      for (final cc in companyCurrencies) {
        final currencyId = cc['currency_id'] as String;
        currencyIds.add(currencyId);
        currencyIdToCompanyCurrencyId[currencyId] = cc['company_currency_id'] as String;
      }

      // Get currency details
      final currencyTypes = await _client
          .from('currency_types')
          .select('*')
          .inFilter('currency_id', currencyIds);

      // Get denominations for each currency (only non-deleted ones)
      final denominations = await _client
          .from('currency_denominations')
          .select('*')
          .eq('company_id', companyId)
          .eq('is_deleted', false)  // Only fetch non-deleted denominations
          .inFilter('currency_id', currencyIds);

      // Map denominations by currency_id
      final denominationMap = <String, List<Denomination>>{};
      for (final denom in denominations) {
        final currencyId = denom['currency_id'] as String;
        denominationMap[currencyId] ??= [];
        denominationMap[currencyId]!.add(Denomination(
          id: denom['denomination_id'] as String,
          companyId: denom['company_id'] as String,
          currencyId: currencyId,
          value: (denom['value'] as num).toDouble(),
          type: (denom['type'] as String? ?? 'bill') == 'coin' ? DenominationType.coin : DenominationType.bill,
          displayName: (denom['type'] as String? ?? 'bill') == 'coin' ? 'Coin' : 'Bill',
          emoji: (denom['type'] as String? ?? 'bill') == 'coin' ? '🪙' : '💵',
          isActive: true,
          createdAt: denom['created_at'] != null ? DateTimeUtils.toLocal(denom['created_at'] as String) : null,
        ),);
      }

      // Build Currency objects
      return (currencyTypes as List).map((ct) {
        final currencyId = ct['currency_id'] as String;
        return Currency(
          id: currencyId,
          code: ct['currency_code'] as String,
          name: ct['currency_name'] as String,
          fullName: ct['currency_name'] as String, // Use same as name since no full_name column
          symbol: ct['symbol'] as String,
          flagEmoji: ct['flag_emoji'] as String? ?? _defaultFlagEmoji,
          companyCurrencyId: currencyIdToCompanyCurrencyId[currencyId], // Include company_currency_id
          denominations: denominationMap[currencyId] ?? [],
          createdAt: ct['created_at'] != null ? DateTimeUtils.toLocal(ct['created_at'] as String) : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch company currencies: $e');
    }
  }

  @override
  Future<Currency> addCompanyCurrency(String companyId, String currencyId) async {
    try {
      // Check if currency type exists
      final currencyType = await _client
          .from('currency_types')
          .select('*')
          .eq('currency_id', currencyId)
          .maybeSingle();

      if (currencyType == null) {
        throw Exception('Currency type not found: $currencyId');
      }

      // Check if ANY entry exists for this company/currency combination
      final anyExisting = await _client
          .from('company_currency')
          .select('company_currency_id, is_deleted')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .maybeSingle();

      // Check specifically for soft-deleted entries
      final existingDeleted = anyExisting != null &&
                              (anyExisting['is_deleted'] == true ||
                               anyExisting['is_deleted'] == 'true' ||
                               anyExisting['is_deleted'] == 1)
                              ? anyExisting : null;

      // Check if currency is already active
      if (anyExisting != null &&
          (anyExisting['is_deleted'] == false ||
           anyExisting['is_deleted'] == 'false' ||
           anyExisting['is_deleted'] == 0 ||
           anyExisting['is_deleted'] == null)) {
        throw Exception('Currency is already added to your company');
      }

      String companyCurrencyId;

      if (existingDeleted != null) {
        // Reactivate the existing soft-deleted entry
        companyCurrencyId = existingDeleted['company_currency_id'] as String;

        final updateResult = await _client
            .from('company_currency')
            .update({'is_deleted': false})
            .eq('company_currency_id', companyCurrencyId)
            .eq('company_id', companyId)
            .eq('currency_id', currencyId)
            .select();

        // Verify the update was successful
        if (updateResult.isEmpty) {
          final verifyResult = await _client
              .from('company_currency')
              .select('is_deleted')
              .eq('company_currency_id', companyCurrencyId)
              .maybeSingle();

          if (verifyResult == null || verifyResult['is_deleted'] == true) {
            throw Exception('Failed to reactivate currency. Check database permissions.');
          }
        }
      } else {
        // Create new entry
        companyCurrencyId = const Uuid().v4();

        final insertResult = await _client.from('company_currency').insert({
          'company_currency_id': companyCurrencyId,
          'company_id': companyId,
          'currency_id': currencyId,
          'is_deleted': false,
          'created_at': DateTimeUtils.nowUtc(),
        }).select();

        if (insertResult.isEmpty) {
          throw Exception('Failed to insert company_currency');
        }
      }

      return Currency(
        id: currencyId,
        code: currencyType['currency_code'] as String,
        name: currencyType['currency_name'] as String,
        fullName: currencyType['currency_name'] as String,
        symbol: currencyType['symbol'] as String,
        flagEmoji: currencyType['flag_emoji'] as String? ?? _defaultFlagEmoji,
        companyCurrencyId: companyCurrencyId,
        denominations: [],
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to add currency to company: $e');
    }
  }

  @override
  Future<void> removeCompanyCurrency(String companyId, String currencyId) async {
    try {
      // First check if this is the base currency of the company
      final companyResult = await _client
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .maybeSingle();
      
      if (companyResult != null) {
        final baseCurrencyId = companyResult['base_currency_id'] as String?;
        if (baseCurrencyId == currencyId) {
          throw Exception('Cannot remove base currency. Please change the base currency first.');
        }
      }

      // Check if the currency exists and is not already deleted
      final companyCurrencyResult = await _client
          .from('company_currency')
          .select('company_currency_id')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .eq('is_deleted', false)  // Only check non-deleted currencies
          .maybeSingle();

      if (companyCurrencyResult == null) {
        throw Exception('Currency not found in company or already removed');
      }

      // Perform soft delete by updating is_deleted to true
      final result = await _client
          .from('company_currency')
          .update({'is_deleted': true})
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .select();

      if (result.isEmpty) {
        throw Exception('Failed to soft delete currency - no rows affected');
      }
    } catch (e) {
      throw Exception('Failed to remove currency: $e');
    }
  }

  @override
  Future<Currency?> getCompanyCurrency(String companyId, String currencyId) async {
    try {
      // Check if the currency is associated with the company (and not deleted)
      final companyCurrency = await _client
          .from('company_currency')
          .select('company_currency_id, currency_id')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .eq('is_deleted', false)  // Only check non-deleted company currencies
          .maybeSingle();

      if (companyCurrency == null) return null;

      final companyCurrencyId = companyCurrency['company_currency_id'] as String;

      // Get currency details
      final currencyType = await _client
          .from('currency_types')
          .select('*')
          .eq('currency_id', currencyId)
          .single();

      // Get denominations for this currency (only non-deleted ones)
      final denominations = await _client
          .from('currency_denominations')
          .select('*')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .eq('is_deleted', false)  // Only fetch non-deleted denominations
          .order('value');

      // Build denominations list
      final denominationList = (denominations as List).map((denom) {
        return Denomination(
          id: denom['denomination_id'] as String,
          companyId: denom['company_id'] as String,
          currencyId: denom['currency_id'] as String,
          value: (denom['value'] as num).toDouble(),
          type: (denom['type'] as String? ?? 'bill') == 'coin' ? DenominationType.coin : DenominationType.bill,
          displayName: (denom['type'] as String? ?? 'bill') == 'coin' ? 'Coin' : 'Bill',
          emoji: (denom['type'] as String? ?? 'bill') == 'coin' ? '🪙' : '💵',
          isActive: denom['is_active'] as bool? ?? true,
          createdAt: denom['created_at'] != null ? DateTimeUtils.toLocal(denom['created_at'] as String) : null,
        );
      }).toList();

      // Build and return Currency object
      return Currency(
        id: currencyType['currency_id'] as String,
        code: currencyType['currency_code'] as String,
        name: currencyType['currency_name'] as String,
        fullName: currencyType['currency_name'] as String,
        symbol: currencyType['symbol'] as String,
        flagEmoji: currencyType['flag_emoji'] as String? ?? _defaultFlagEmoji,
        companyCurrencyId: companyCurrencyId, // Include company_currency_id
        denominations: denominationList,
        createdAt: currencyType['created_at'] != null ? DateTimeUtils.toLocal(currencyType['created_at'] as String) : null,
      );
    } catch (e) {
      throw Exception('Failed to fetch company currency: $e');
    }
  }

  @override
  Future<Currency> updateCompanyCurrency(String companyId, String currencyId, {
    bool? isActive,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTimeUtils.nowUtc(),
      };

      // Use isActive if provided and column exists
      if (isActive != null) {
        updateData['is_active'] = isActive;
      }

      final result = await _client
          .from('company_currency')
          .update(updateData)
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .select();

      if (result.isEmpty) {
        throw Exception('Update failed - no rows affected');
      }

      // Return updated currency
      final currency = await getCompanyCurrency(companyId, currencyId);
      if (currency == null) {
        throw Exception('Currency not found after update');
      }
      return currency;
    } catch (e) {
      throw Exception('Failed to update company currency: $e');
    }
  }

  @override
  Future<List<CurrencyType>> searchCurrencyTypes(String query) async {
    try {
      // Sanitize query to prevent SQL injection
      final sanitizedQuery = query
          .replaceAll('%', r'\%')
          .replaceAll('_', r'\_');

      final response = await _client
          .from('currency_types')
          .select('*')
          .or('currency_name.ilike.%$sanitizedQuery%,currency_code.ilike.%$sanitizedQuery%')
          .order('currency_name')
          .limit(20);

      return (response as List).map((json) {
        // Validate required fields
        final currencyId = json['currency_id'] as String?;
        final currencyCode = json['currency_code'] as String?;
        final currencyName = json['currency_name'] as String?;
        final symbol = json['symbol'] as String?;

        if (currencyId == null) throw Exception('Missing currency_id in database');
        if (currencyCode == null) throw Exception('Missing currency_code in database');
        if (currencyName == null) throw Exception('Missing currency_name in database');
        if (symbol == null) throw Exception('Missing symbol in database');

        return CurrencyType(
          currencyId: currencyId,
          currencyCode: currencyCode,
          currencyName: currencyName,
          symbol: symbol,
          flagEmoji: json['flag_emoji'] as String? ?? _defaultFlagEmoji,
          createdAt: json['created_at'] != null ? DateTimeUtils.toLocal(json['created_at'] as String) : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search currency types: $e');
    }
  }

  @override
  Stream<List<Currency>> watchCompanyCurrencies(String companyId) {
    return _client
        .from('company_currency')
        .select('company_currency_id, currency_id')
        .eq('company_id', companyId)
        .eq('is_deleted', false)  // Only watch non-deleted company currencies
        .asStream()
        .asyncMap((companyCurrencyData) async {
          if (companyCurrencyData.isEmpty) return <Currency>[];

          // Create a map of currency_id to company_currency_id
          final currencyIdToCompanyCurrencyId = <String, String>{};
          final currencyIds = <String>[];
          for (final cc in companyCurrencyData) {
            final currencyId = cc['currency_id'] as String;
            currencyIds.add(currencyId);
            currencyIdToCompanyCurrencyId[currencyId] = cc['company_currency_id'] as String;
          }

          // Get currency details
          final currencyTypes = await _client
              .from('currency_types')
              .select('*')
              .inFilter('currency_id', currencyIds);

          // Get denominations for all currencies (only non-deleted ones)
          final denominations = await _client
              .from('currency_denominations')
              .select('*')
              .eq('company_id', companyId)
              .eq('is_deleted', false)  // Only fetch non-deleted denominations
              .inFilter('currency_id', currencyIds);

          // Map denominations by currency_id
          final denominationMap = <String, List<Denomination>>{};
          for (final denom in denominations) {
            final currencyId = denom['currency_id'] as String;
            denominationMap[currencyId] ??= [];
            denominationMap[currencyId]!.add(Denomination(
              id: denom['denomination_id'] as String,
              companyId: denom['company_id'] as String,
              currencyId: currencyId,
              value: (denom['value'] as num).toDouble(),
              type: (denom['type'] as String? ?? 'bill') == 'coin' ? DenominationType.coin : DenominationType.bill,
              displayName: (denom['type'] as String? ?? 'bill') == 'coin' ? 'Coin' : 'Bill',
              emoji: (denom['type'] as String? ?? 'bill') == 'coin' ? '🪙' : '💵',
              isActive: denom['is_active'] as bool? ?? true,
              createdAt: denom['created_at'] != null ? DateTimeUtils.toLocal(denom['created_at'] as String) : null,
            ),);
          }

          // Build Currency objects
          return (currencyTypes as List).map((ct) {
            final currencyId = ct['currency_id'] as String;
            return Currency(
              id: currencyId,
              code: ct['currency_code'] as String,
              name: ct['currency_name'] as String,
              fullName: ct['currency_name'] as String,
              symbol: ct['symbol'] as String,
              flagEmoji: ct['flag_emoji'] as String? ?? _defaultFlagEmoji,
              companyCurrencyId: currencyIdToCompanyCurrencyId[currencyId], // Include company_currency_id
              denominations: denominationMap[currencyId] ?? [],
              createdAt: ct['created_at'] != null ? DateTimeUtils.toLocal(ct['created_at'] as String) : null,
            );
          }).toList();
        });
  }

  @override
  Future<bool> hasDenominations(String companyId, String currencyId) async {
    try {
      // Query only non-deleted denominations for this currency
      final denominations = await _client
          .from('currency_denominations')
          .select('denomination_id')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .eq('is_deleted', false);  // Only check non-deleted denominations

      return denominations.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check denominations: $e');
    }
  }
}