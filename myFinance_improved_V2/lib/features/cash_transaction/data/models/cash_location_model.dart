import '../../domain/entities/cash_location.dart';

/// Data model for CashLocation
///
/// Handles JSON serialization and mapping to domain entity
class CashLocationModel {
  final String cashLocationId;
  final String locationName;
  final String locationType;
  final String? storeId;
  final String? companyId;
  final String? accountId;

  CashLocationModel({
    required this.cashLocationId,
    required this.locationName,
    required this.locationType,
    this.storeId,
    this.companyId,
    this.accountId,
  });

  /// From JSON (API/Database) → Model
  /// RPC returns camelCase fields (id, name, type, storeId)
  /// Also supports snake_case for direct table queries
  factory CashLocationModel.fromJson(Map<String, dynamic> json) {
    // Get additionalData which contains snake_case fields from raw table
    final additionalData = json['additionalData'] as Map<String, dynamic>?;

    return CashLocationModel(
      // RPC returns 'id', table returns 'cash_location_id'
      cashLocationId: (json['id'] ?? json['cash_location_id'] ?? '') as String,
      // RPC returns 'name', table returns 'location_name'
      locationName: (json['name'] ?? json['location_name'] ?? '') as String,
      // RPC returns 'type', table returns 'location_type'
      locationType: (json['type'] ?? json['location_type'] ?? '') as String,
      // RPC returns 'storeId', table/additionalData returns 'store_id'
      storeId: (json['storeId'] ?? additionalData?['store_id']) as String?,
      // RPC returns company info in additionalData
      companyId: (json['companyId'] ?? additionalData?['company_id']) as String?,
      accountId: (json['accountId'] ?? json['account_id']) as String?,
    );
  }

  /// Model → Domain Entity
  CashLocation toEntity() {
    return CashLocation(
      cashLocationId: cashLocationId,
      locationName: locationName,
      locationType: locationType,
      storeId: storeId,
      companyId: companyId,
      accountId: accountId,
    );
  }

  /// Model → JSON (for API calls)
  Map<String, dynamic> toJson() {
    return {
      'cash_location_id': cashLocationId,
      'location_name': locationName,
      'location_type': locationType,
      'store_id': storeId,
      'company_id': companyId,
      'account_id': accountId,
    };
  }
}
