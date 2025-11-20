// lib/features/cash_ending/domain/entities/location.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

/// Domain entity representing a cash location (cash drawer, bank, vault)
///
/// Maps to `cash_locations` table in database.
/// DB columns: cash_location_id (uuid), location_name (text), location_type (text),
///             store_id (uuid), currency_id (uuid)
@freezed
class Location with _$Location {
  const factory Location({
    required String locationId,
    required String locationName,
    required String locationType, // 'cash', 'bank', or 'vault'
    String? storeId,
    String? currencyId,
    String? accountId,
  }) = _Location;

  const Location._();

  /// Check if this is a cash location
  bool get isCash => locationType == 'cash';

  /// Check if this is a bank location
  bool get isBank => locationType == 'bank';

  /// Check if this is a vault location
  bool get isVault => locationType == 'vault';

  /// Check if location is at headquarters (no store assigned)
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';
}
