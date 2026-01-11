import 'package:equatable/equatable.dart';

/// Payment currency entity
class PaymentCurrency extends Equatable {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final String flagEmoji;
  final double? exchangeRateToBase;
  final String? rateDate;

  const PaymentCurrency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.flagEmoji,
    this.exchangeRateToBase,
    this.rateDate,
  });

  // NOTE: displayName moved to presentation/extensions/payment_currency_display_extension.dart
  // UI formatting is a Presentation concern, not Domain

  @override
  List<Object?> get props => [
        currencyId,
        currencyCode,
        currencyName,
        symbol,
        flagEmoji,
        exchangeRateToBase,
        rateDate,
      ];
}
