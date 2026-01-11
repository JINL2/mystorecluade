import '../../domain/entities/payment_currency.dart';

/// Presentation extension for PaymentCurrency display formatting
///
/// displayName is a UI concern and should NOT be in Domain Entity.
extension PaymentCurrencyDisplay on PaymentCurrency {
  /// Get display name with flag emoji and currency code
  /// Example: "🇻🇳 VND", "🇺🇸 USD"
  String get displayName => '$flagEmoji $currencyCode';
}
