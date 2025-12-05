// Currency and Payment Models for Payment Method Page

class CurrencyDenomination {
  final String denominationId;
  final int value;

  CurrencyDenomination({
    required this.denominationId,
    required this.value,
  });

  factory CurrencyDenomination.fromJson(Map<String, dynamic> json) {
    return CurrencyDenomination(
      denominationId: json['denomination_id']?.toString() ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'denomination_id': denominationId,
      'value': value,
    };
  }
}

class PaymentCurrency {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final String flagEmoji;
  final double? exchangeRateToBase;
  final String? rateDate;
  final List<CurrencyDenomination> denominations;

  PaymentCurrency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.flagEmoji,
    this.exchangeRateToBase,
    this.rateDate,
    this.denominations = const [],
  });

  factory PaymentCurrency.fromJson(Map<String, dynamic> json) {
    return PaymentCurrency(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      flagEmoji: json['flag_emoji']?.toString() ?? '',
      exchangeRateToBase: (json['exchange_rate_to_base'] as num?)?.toDouble(),
      rateDate: json['rate_date']?.toString(),
      denominations: json['denominations'] != null && json['denominations'] is List
          ? (json['denominations'] as List)
              .map((item) => CurrencyDenomination.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
      'flag_emoji': flagEmoji,
      'exchange_rate_to_base': exchangeRateToBase,
      'rate_date': rateDate,
      'denominations': denominations.map((d) => d.toJson()).toList(),
    };
  }

  String get displayName => '$flagEmoji $currencyCode';
}

class BaseCurrencyResponse {
  final PaymentCurrency baseCurrency;
  final List<PaymentCurrency> companyCurrencies;

  BaseCurrencyResponse({
    required this.baseCurrency,
    required this.companyCurrencies,
  });

  factory BaseCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return BaseCurrencyResponse(
      baseCurrency: PaymentCurrency.fromJson(json['base_currency'] as Map<String, dynamic>),
      companyCurrencies: json['company_currencies'] != null && json['company_currencies'] is List
          ? (json['company_currencies'] as List)
              .map((item) => PaymentCurrency.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_currency': baseCurrency.toJson(),
      'company_currencies': companyCurrencies.map((c) => c.toJson()).toList(),
    };
  }

  // Helper method to find currency by code
  PaymentCurrency? findCurrencyByCode(String code) {
    try {
      return companyCurrencies.firstWhere(
        (currency) => currency.currencyCode == code,
      );
    } catch (e) {
      return baseCurrency.currencyCode == code ? baseCurrency : null;
    }
  }
}
