// Domain Entity: DebtCategory
// Enum for debt categories with type safety

/// Debt category types for payable/receivable accounts
///
/// Provides type-safe debt categorization with:
/// - value: Database value (snake_case)
/// - displayName: UI display text
enum DebtCategory {
  /// Promissory note
  note('note', 'Note'),

  /// Account payable/receivable
  account('account', 'Account'),

  /// Loan
  loan('loan', 'Loan'),

  /// Other debt types
  other('other', 'Other');

  const DebtCategory(this.value, this.displayName);

  /// Database value
  final String value;

  /// Display name for UI
  final String displayName;

  /// Convert from database value
  static DebtCategory? fromValue(String? value) {
    if (value == null) return null;

    try {
      return DebtCategory.values.firstWhere(
        (category) => category.value == value,
      );
    } catch (_) {
      return DebtCategory.other;
    }
  }

  /// Get all values as list
  static List<String> get allValues =>
      DebtCategory.values.map((e) => e.value).toList();
}
