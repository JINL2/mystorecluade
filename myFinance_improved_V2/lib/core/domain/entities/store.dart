/// Store entity representing a business location
///
/// Rich Domain Model with business logic and rules
class Store {
  const Store({
    required this.id,
    required this.storeName,
    required this.storeCode,
    required this.companyId,
  });

  final String id;
  final String storeName;
  final String storeCode;
  final String companyId;

  // ============================================================================
  // Computed Properties (Business Logic)
  // ============================================================================

  /// Check if store code is valid format
  ///
  /// Valid format: "STORE" prefix + 5 digits (e.g., "STORE12345")
  bool get hasValidCode =>
      storeCode.isNotEmpty &&
      storeCode.startsWith('STORE') &&
      storeCode.length == 10;

  /// Check if store name is long
  ///
  /// Long names may need special handling in UI
  bool get hasLongName => storeName.length > 40;

  /// Get display name for UI
  ///
  /// Truncates long names with ellipsis
  String get displayName => storeName.length > 25
      ? '${storeName.substring(0, 22)}...'
      : storeName;

  /// Get short name for compact UI
  ///
  /// Uses first word or truncates to 15 characters
  String get shortName {
    final firstWord = storeName.split(' ').first;
    if (firstWord.length <= 15) {
      return firstWord;
    }
    return storeName.length > 15
        ? '${storeName.substring(0, 12)}...'
        : storeName;
  }
}