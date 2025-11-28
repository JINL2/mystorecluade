import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_currency.freezed.dart';
part 'base_currency.g.dart';

/// Base Currency Entity - from get_base_currency RPC
/// Represents the company's base currency settings
@freezed
class BaseCurrency with _$BaseCurrency {
  const BaseCurrency._();

  const factory BaseCurrency({
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_name') required String currencyName,
    @JsonKey(name: 'symbol') required String symbol,
    @JsonKey(name: 'flag_emoji') String? flagEmoji,
  }) = _BaseCurrency;

  factory BaseCurrency.fromJson(Map<String, dynamic> json) =>
      _$BaseCurrencyFromJson(json);
}
