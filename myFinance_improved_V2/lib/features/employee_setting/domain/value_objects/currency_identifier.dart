/// Domain Value Object: Currency Identifier
///
/// Represents either a currency code (e.g., "USD", "VND") or a currency UUID.
/// Provides type-safe distinction between the two formats.
///
/// - Currency Code: Short 3-letter code (e.g., "USD", "VND", "KRW")
/// - Currency UUID: 36-character unique identifier
///
/// Used by employee_remote_datasource.dart to determine whether to pass
/// currency_id or currency_code to the RPC.
class CurrencyIdentifier {
  final String value;

  const CurrencyIdentifier(this.value);

  /// Maximum length for currency codes (3 characters: USD, VND, EUR, etc.)
  static const int codeMaxLength = 3;

  /// Checks if this identifier is a currency code (e.g., "USD", "VND")
  /// Used by updateEmployee() to determine which RPC parameter to use
  bool get isCode => value.length <= codeMaxLength;
}
