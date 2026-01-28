import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';

/// Response model for register_denomination_get_currency_info RPC
class CurrencyInfoResponse {
  const CurrencyInfoResponse({
    required this.companyCurrencies,
    required this.availableCurrencyTypes,
    this.baseCurrencyId,
    this.baseCurrencyCode,
    this.baseCurrencySymbol,
    this.baseCurrencyName,
    this.baseCurrencyFlagEmoji,
  });

  final List<Currency> companyCurrencies;
  final List<CurrencyType> availableCurrencyTypes;
  final String? baseCurrencyId;
  final String? baseCurrencyCode;
  final String? baseCurrencySymbol;
  final String? baseCurrencyName;
  final String? baseCurrencyFlagEmoji;
}

/// Mapper for converting register_denomination_get_currency_info RPC response
class CurrencyInfoMapper {
  CurrencyInfoMapper._();

  static const String _defaultFlagEmoji = '🏳️';

  /// Convert RPC response to CurrencyInfoResponse
  static CurrencyInfoResponse fromRpcResponse(Map<String, dynamic> response) {
    final baseCurrencyId = response['base_currency_id'] as String?;

    final companyCurrencies = _parseCompanyCurrencies(
      response['company_currencies'] as List<dynamic>? ?? [],
      baseCurrencyId,
    );

    final availableCurrencyTypes = _parseAvailableCurrencyTypes(
      response['available_currency_types'] as List<dynamic>? ?? [],
    );

    // Extract base currency details from company_currencies
    String? baseCurrencyCode;
    String? baseCurrencySymbol;
    String? baseCurrencyName;
    String? baseCurrencyFlagEmoji;

    if (baseCurrencyId != null) {
      final baseCurrency = companyCurrencies.where((c) => c.isBaseCurrency).firstOrNull;
      if (baseCurrency != null) {
        baseCurrencyCode = baseCurrency.code;
        baseCurrencySymbol = baseCurrency.symbol;
        baseCurrencyName = baseCurrency.name;
        baseCurrencyFlagEmoji = baseCurrency.flagEmoji;
      }
    }

    return CurrencyInfoResponse(
      companyCurrencies: companyCurrencies,
      availableCurrencyTypes: availableCurrencyTypes,
      baseCurrencyId: baseCurrencyId,
      baseCurrencyCode: baseCurrencyCode,
      baseCurrencySymbol: baseCurrencySymbol,
      baseCurrencyName: baseCurrencyName,
      baseCurrencyFlagEmoji: baseCurrencyFlagEmoji,
    );
  }

  /// Parse company_currencies array from RPC response
  static List<Currency> _parseCompanyCurrencies(
    List<dynamic> jsonList,
    String? baseCurrencyId,
  ) {
    return jsonList.map((json) {
      final currencyJson = json as Map<String, dynamic>;
      final denominationsJson = currencyJson['denominations'] as List<dynamic>? ?? [];
      final currencyId = currencyJson['currency_id'] as String;

      return Currency(
        id: currencyId,
        code: currencyJson['currency_code'] as String,
        name: currencyJson['currency_name'] as String? ?? '',
        fullName: currencyJson['currency_name'] as String? ?? '',
        symbol: currencyJson['symbol'] as String? ?? '',
        flagEmoji: currencyJson['flag_emoji'] as String? ?? _defaultFlagEmoji,
        companyCurrencyId: currencyJson['company_currency_id'] as String?,
        denominations: _parseDenominations(denominationsJson),
        isBaseCurrency: currencyJson['is_base_currency'] as bool? ?? (currencyId == baseCurrencyId),
        createdAt: currencyJson['created_at_utc'] != null
            ? DateTimeUtils.toLocal(currencyJson['created_at_utc'] as String)
            : null,
      );
    }).toList();
  }

  /// Parse denominations array from RPC response
  static List<Denomination> _parseDenominations(List<dynamic> jsonList) {
    return jsonList.map((json) {
      final denomJson = json as Map<String, dynamic>;
      final typeValue = denomJson['type'] as String? ?? 'bill';
      final type = typeValue == 'coin'
          ? DenominationType.coin
          : DenominationType.bill;

      return Denomination(
        id: denomJson['denomination_id'] as String,
        companyId: denomJson['company_id'] as String,
        currencyId: denomJson['currency_id'] as String,
        value: (denomJson['value'] as num).toDouble(),
        type: type,
        displayName: type == DenominationType.coin ? 'Coin' : 'Bill',
        emoji: type == DenominationType.coin ? '🪙' : '💵',
        isActive: true,
        createdAt: denomJson['created_at_utc'] != null
            ? DateTimeUtils.toLocal(denomJson['created_at_utc'] as String)
            : null,
      );
    }).toList();
  }

  /// Parse available_currency_types array from RPC response
  static List<CurrencyType> _parseAvailableCurrencyTypes(List<dynamic> jsonList) {
    return jsonList.map((json) {
      final typeJson = json as Map<String, dynamic>;

      return CurrencyType(
        currencyId: typeJson['currency_id'] as String,
        currencyCode: typeJson['currency_code'] as String,
        currencyName: typeJson['currency_name'] as String? ?? '',
        symbol: typeJson['symbol'] as String? ?? '',
        flagEmoji: typeJson['flag_emoji'] as String? ?? _defaultFlagEmoji,
        isAlreadyAdded: typeJson['is_already_added'] as bool? ?? false,
        createdAt: typeJson['created_at_utc'] != null
            ? DateTimeUtils.toLocal(typeJson['created_at_utc'] as String)
            : null,
      );
    }).toList();
  }

  /// Check if a currency is the base currency
  static bool isBaseCurrency(Map<String, dynamic> companyCurrencyJson) {
    return companyCurrencyJson['is_base_currency'] as bool? ?? false;
  }
}
