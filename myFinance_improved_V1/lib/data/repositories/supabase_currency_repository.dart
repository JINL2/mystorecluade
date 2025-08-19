import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
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
            createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
          ))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch available currency types: $e');
    }
  }

  @override
  Future<List<Currency>> getCompanyCurrencies(String companyId) async {
    try {
      // First get company currencies
      final companyCurrencies = await _client
          .from('company_currency')
          .select('currency_id')
          .eq('company_id', companyId);

      if (companyCurrencies.isEmpty) return [];

      // Extract currency IDs
      final currencyIds = (companyCurrencies as List)
          .map((cc) => cc['currency_id'] as String)
          .toList();

      // Get currency details
      final currencyTypes = await _client
          .from('currency_types')
          .select('*')
          .inFilter('currency_id', currencyIds);

      // Get denominations for each currency
      final denominations = await _client
          .from('currency_denominations')
          .select('*')
          .eq('company_id', companyId)
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
          createdAt: denom['created_at'] != null ? DateTime.parse(denom['created_at']) : null,
        ));
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
          denominations: denominationMap[currencyId] ?? [],
          createdAt: ct['created_at'] != null ? DateTime.parse(ct['created_at']) : null,
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
          .single();

      // Add to company_currency table
      await _client.from('company_currency').insert({
        'company_currency_id': const Uuid().v4(),
        'company_id': companyId,
        'currency_id': currencyId,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Return the full currency with empty denominations initially
      return Currency(
        id: currencyId,
        code: currencyType['currency_code'],
        name: currencyType['currency_name'],
        fullName: currencyType['currency_name'],
        symbol: currencyType['symbol'],
        flagEmoji: currencyType['flag_emoji'] as String? ?? _defaultFlagEmoji,
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
      // First remove all denominations for this currency
      await _client
          .from('currency_denominations')
          .delete()
          .eq('company_id', companyId)
          .eq('currency_id', currencyId);

      // Then remove the company currency association
      await _client
          .from('company_currency')
          .delete()
          .eq('company_id', companyId)
          .eq('currency_id', currencyId);
    } catch (e) {
      throw Exception('Failed to remove currency from company: $e');
    }
  }

  @override
  Future<Currency?> getCompanyCurrency(String companyId, String currencyId) async {
    try {
      // Check if the currency is associated with the company
      final companyCurrency = await _client
          .from('company_currency')
          .select('currency_id')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
          .maybeSingle();

      if (companyCurrency == null) return null;

      // Get currency details
      final currencyType = await _client
          .from('currency_types')
          .select('*')
          .eq('currency_id', currencyId)
          .single();

      // Get denominations for this currency
      final denominations = await _client
          .from('currency_denominations')
          .select('*')
          .eq('company_id', companyId)
          .eq('currency_id', currencyId)
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
          createdAt: denom['created_at'] != null ? DateTime.parse(denom['created_at']) : null,
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
        denominations: denominationList,
        createdAt: currencyType['created_at'] != null ? DateTime.parse(currencyType['created_at']) : null,
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
      await _client
          .from('company_currency')
          .update({
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('company_id', companyId)
          .eq('currency_id', currencyId);

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
      final response = await _client
          .from('currency_types')
          .select('*')
          .or('currency_name.ilike.%$query%,currency_code.ilike.%$query%')
          .order('currency_name')
          .limit(20);

      return (response as List)
          .map((json) => CurrencyType(
            currencyId: json['currency_id'] as String,
            currencyCode: json['currency_code'] as String,
            currencyName: json['currency_name'] as String,
            symbol: json['symbol'] as String,
            flagEmoji: json['flag_emoji'] as String? ?? _defaultFlagEmoji,
            createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
          ))
          .toList();
    } catch (e) {
      throw Exception('Failed to search currency types: $e');
    }
  }

  @override
  Stream<List<Currency>> watchCompanyCurrencies(String companyId) {
    return _client
        .from('company_currency')
        .select('currency_id')
        .eq('company_id', companyId)
        .asStream()
        .asyncMap((companyCurrencyData) async {
          if (companyCurrencyData.isEmpty) return <Currency>[];

          // Extract currency IDs
          final currencyIds = companyCurrencyData
              .map((cc) => cc['currency_id'] as String)
              .toList();

          // Get currency details
          final currencyTypes = await _client
              .from('currency_types')
              .select('*')
              .inFilter('currency_id', currencyIds);

          // Get denominations for all currencies
          final denominations = await _client
              .from('currency_denominations')
              .select('*')
              .eq('company_id', companyId)
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
              createdAt: denom['created_at'] != null ? DateTime.parse(denom['created_at']) : null,
            ));
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
              denominations: denominationMap[currencyId] ?? [],
              createdAt: ct['created_at'] != null ? DateTime.parse(ct['created_at']) : null,
            );
          }).toList();
        });
  }
}