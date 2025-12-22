import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_currency.freezed.dart';

/// Base Currency Entity - from get_base_currency RPC
/// Represents the company's base currency settings
///
/// Note: JSON serialization is handled by BaseCurrencyModel in data layer
@freezed
class BaseCurrency with _$BaseCurrency {
  const BaseCurrency._();

  const factory BaseCurrency({
    required String currencyId,
    required String currencyCode,
    required String currencyName,
    required String symbol,
    String? flagEmoji,
  }) = _BaseCurrency;
}
