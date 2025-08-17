import 'package:freezed_annotation/freezed_annotation.dart';
import 'denomination.dart';

part 'currency.freezed.dart';
part 'currency.g.dart';

@freezed
class Currency with _$Currency {
  const factory Currency({
    required String id,
    required String code,
    required String name,
    required String fullName,
    required String symbol,
    required String flagEmoji,
    @Default([]) List<Denomination> denominations,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Currency;

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
}

/// Available currency types (master data)
@freezed
class CurrencyType with _$CurrencyType {
  const factory CurrencyType({
    required String currencyId,
    required String currencyCode,
    required String currencyName,
    required String symbol,
    required String flagEmoji,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _CurrencyType;

  factory CurrencyType.fromJson(Map<String, dynamic> json) => _$CurrencyTypeFromJson(json);
}

/// Company-specific currency configuration
@freezed
class CompanyCurrency with _$CompanyCurrency {
  const factory CompanyCurrency({
    required String companyId,
    required String currencyId,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Denormalized currency info for easier querying
    String? currencyCode,
    String? currencyName,
    String? symbol,
    String? flagEmoji,
  }) = _CompanyCurrency;

  factory CompanyCurrency.fromJson(Map<String, dynamic> json) => _$CompanyCurrencyFromJson(json);
}