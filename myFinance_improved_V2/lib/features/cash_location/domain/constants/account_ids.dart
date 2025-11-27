/// Domain Constants - Account IDs
/// These are stable account IDs used across the cash location feature
class AccountIds {
  AccountIds._(); // Private constructor - utility class

  /// Cash account ID for journal entries
  static const String cash = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';

  /// Foreign currency translation account ID
  static const String foreignCurrencyTranslation = '80b311db-f548-46e3-9854-67c5ff6766e8';

  /// Error adjustment account ID
  static const String errorAdjustment = 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf';
}
