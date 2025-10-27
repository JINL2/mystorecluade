import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';

/// Currency value object
@freezed
class Currency with _$Currency {
  const factory Currency({
    required String code,
    required String symbol,
  }) = _Currency;

  const Currency._();

  /// Default currency (KRW)
  factory Currency.krw() => const Currency(code: 'KRW', symbol: '₩');
}
