// lib/features/cash_ending/domain/entities/location.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

/// Domain entity representing a cash location (cash drawer, bank, vault)
///
/// Uses Freezed for:
/// - Immutability guarantee
/// - Auto-generated copyWith, ==, hashCode
/// - Manual JSON serialization (no .g.dart needed)
///
/// ✅ Refactored with:
/// - Removed @JsonKey warnings
/// - Manual fromJson for consistency with other entities
@freezed
class Location with _$Location {
  const Location._();

  @Assert(
    "locationType == 'cash' || locationType == 'bank' || locationType == 'vault'",
    'Invalid location type. Must be cash, bank, or vault',
  )
  const factory Location({
    required String locationId,
    required String locationName,
    required String locationType,
    String? storeId,
    String? currencyId,
    String? accountId,
  }) = _Location;

  /// Custom fromJson factory for database deserialization
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['cash_location_id']?.toString() ?? '',
      locationName: json['location_name']?.toString() ?? '',
      locationType: json['location_type']?.toString() ?? 'cash',
      storeId: json['store_id']?.toString(),
      currencyId: json['currency_id']?.toString(),
      accountId: json['account_id']?.toString(),
    );
  }

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'cash_location_id': locationId,
      'location_name': locationName,
      'location_type': locationType,
      'store_id': storeId,
      'currency_id': currencyId,
      'account_id': accountId,
    };
  }

  /// Check if this is a cash location
  bool get isCash => locationType == 'cash';

  /// Check if this is a bank location
  bool get isBank => locationType == 'bank';

  /// Check if this is a vault location
  bool get isVault => locationType == 'vault';

  /// Check if location is at headquarters (no store assigned)
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';
}
