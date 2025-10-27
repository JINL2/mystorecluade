// lib/features/cash_ending/data/models/location_model.dart

import '../../domain/entities/location.dart';

/// Data Transfer Object for Location
/// Handles JSON serialization/deserialization
class LocationModel {
  final String locationId;
  final String locationName;
  final String locationType;
  final String? storeId;
  final String? currencyId;
  final String? accountId;

  const LocationModel({
    required this.locationId,
    required this.locationName,
    required this.locationType,
    this.storeId,
    this.currencyId,
    this.accountId,
  });

  /// Create from JSON (from database)
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      // Database uses 'cash_location_id' not 'location_id'
      locationId: json['cash_location_id']?.toString() ?? '',
      locationName: json['location_name']?.toString() ?? '',
      locationType: json['location_type']?.toString() ?? 'cash',
      storeId: json['store_id']?.toString(),
      currencyId: json['currency_id']?.toString(),
      accountId: json['account_id']?.toString(),
    );
  }

  /// Convert to JSON (to database)
  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'location_name': locationName,
      'location_type': locationType,
      if (storeId != null) 'store_id': storeId,
      if (currencyId != null) 'currency_id': currencyId,
      if (accountId != null) 'account_id': accountId,
    };
  }

  /// Convert to Domain Entity
  Location toEntity() {
    return Location(
      locationId: locationId,
      locationName: locationName,
      locationType: locationType,
      storeId: storeId,
      currencyId: currencyId,
      accountId: accountId,
    );
  }

  /// Create from Domain Entity
  factory LocationModel.fromEntity(Location entity) {
    return LocationModel(
      locationId: entity.locationId,
      locationName: entity.locationName,
      locationType: entity.locationType,
      storeId: entity.storeId,
      currencyId: entity.currencyId,
      accountId: entity.accountId,
    );
  }
}
