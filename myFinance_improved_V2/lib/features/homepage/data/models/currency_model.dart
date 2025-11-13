import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/currency.dart';

part 'currency_model.freezed.dart';
part 'currency_model.g.dart';

/// Data Transfer Object for Currency
@freezed
class CurrencyModel with _$CurrencyModel {
  const CurrencyModel._();

  const factory CurrencyModel({
    @JsonKey(name: 'currency_id') required String id,
    @JsonKey(name: 'currency_code') required String code,
    @JsonKey(name: 'currency_name') required String name,
    required String symbol,
  }) = _CurrencyModel;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Currency toEntity() => Currency(id: id, code: code, name: name, symbol: symbol);
}
