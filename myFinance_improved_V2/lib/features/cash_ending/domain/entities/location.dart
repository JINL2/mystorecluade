// lib/features/cash_ending/domain/entities/location.dart

/// Domain entity representing a cash location (cash drawer, bank, vault)
class Location {
  final String locationId;
  final String locationName;
  final String locationType; // 'cash', 'bank', or 'vault'
  final String? storeId;
  final String? currencyId;
  final String? accountId;

  Location({
    required this.locationId,
    required this.locationName,
    required this.locationType,
    this.storeId,
    this.currencyId,
    this.accountId,
  }) {
    // Simple validation
    if (locationType != 'cash' &&
        locationType != 'bank' &&
        locationType != 'vault') {
      throw ArgumentError(
        'Invalid location type: $locationType. Must be cash, bank, or vault',
      );
    }
  }

  /// Check if this is a cash location
  bool get isCash => locationType == 'cash';

  /// Check if this is a bank location
  bool get isBank => locationType == 'bank';

  /// Check if this is a vault location
  bool get isVault => locationType == 'vault';

  /// Check if location is at headquarters (no store assigned)
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';

  /// Create a copy with updated fields
  Location copyWith({
    String? locationId,
    String? locationName,
    String? locationType,
    String? storeId,
    String? currencyId,
    String? accountId,
  }) {
    return Location(
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      locationType: locationType ?? this.locationType,
      storeId: storeId ?? this.storeId,
      currencyId: currencyId ?? this.currencyId,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.locationId == locationId &&
        other.locationName == locationName &&
        other.locationType == locationType &&
        other.storeId == storeId &&
        other.currencyId == currencyId &&
        other.accountId == accountId;
  }

  @override
  int get hashCode {
    return Object.hash(
      locationId,
      locationName,
      locationType,
      storeId,
      currencyId,
      accountId,
    );
  }
}
