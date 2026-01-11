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
  // Factory Constructors
  // ============================================================================

  /// Create Store from Map
  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['store_id'] as String,
      storeName: map['store_name'] as String,
      storeCode: map['store_code'] as String,
      companyId: map['company_id'] as String? ?? '',
    );
  }

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

  // ============================================================================
  // Mock Factory (for skeleton loading)
  // ============================================================================

  static Store mock() => const Store(
        id: 'mock-store-id',
        storeName: 'Mock Store',
        storeCode: 'STORE12345',
        companyId: 'mock-company-id',
      );

  static List<Store> mockList([int count = 2]) =>
      List.generate(count, (i) => Store(
            id: 'mock-store-id-$i',
            storeName: 'Mock Store $i',
            storeCode: 'STORE1234$i',
            companyId: 'mock-company-id',
          ));
}