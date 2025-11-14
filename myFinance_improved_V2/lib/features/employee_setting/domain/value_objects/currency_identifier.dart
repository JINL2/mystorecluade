/// Domain Value Object: Currency Identifier
///
/// Represents either a currency code (e.g., "USD", "VND") or a currency UUID.
/// Provides type-safe distinction between the two formats.
///
/// - Currency Code: Short 3-letter code (e.g., "USD", "VND", "KRW")
/// - Currency UUID: 36-character unique identifier (e.g., "550e8400-e29b-41d4-a716-446655440000")
class CurrencyIdentifier {
  final String value;

  const CurrencyIdentifier(this.value);

  /// Standard UUID length including hyphens (8-4-4-4-12 = 36 characters)
  static const int uuidLength = 36;

  /// Maximum length for currency codes (3 characters: USD, VND, EUR, etc.)
  static const int codeMaxLength = 3;

  /// Checks if this identifier is a currency code (e.g., "USD", "VND")
  bool get isCode => value.length <= codeMaxLength;

  /// Checks if this identifier is a UUID
  bool get isUuid => value.length == uuidLength;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyIdentifier && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
