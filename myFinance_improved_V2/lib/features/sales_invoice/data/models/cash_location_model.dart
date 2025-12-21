import '../../domain/entities/cash_location.dart';

/// Cash location model for data transfer
///
/// Supports get_cash_locations_v2 RPC response format:
/// {
///   "cash_location_id": "uuid",
///   "location_name": "Location Name",
///   "location_type": "cash" | "bank" | "vault",
///   "store_id": "uuid" | null,
///   "store_name": "Store Name" | null,
///   "is_company_wide": true | false,
///   "currency_code": "VND" | null,
///   "bank_account": "..." | null,
///   "bank_name": "..." | null,
///   ...
/// }
class CashLocationModel {
  final Map<String, dynamic> json;

  CashLocationModel(this.json);

  /// Create from JSON
  factory CashLocationModel.fromJson(Map<String, dynamic> json) {
    return CashLocationModel(json);
  }

  /// Convert to domain entity (supports both v1 and v2 response formats)
  CashLocation toEntity() {
    // v2 uses snake_case, v1 uses camelCase
    return CashLocation(
      id: json['cash_location_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['location_name']?.toString() ?? json['name']?.toString() ?? '',
      type: json['location_type']?.toString() ?? json['type']?.toString() ?? 'cash',
      storeId: json['store_id']?.toString() ?? json['storeId']?.toString() ?? '',
      isCompanyWide: (json['is_company_wide'] as bool?) ?? (json['isCompanyWide'] as bool?) ?? false,
      currencyCode: json['currency_code']?.toString() ?? json['currencyCode']?.toString() ?? 'VND',
      bankAccount: json['bank_account']?.toString() ?? json['bankAccount']?.toString(),
      bankName: json['bank_name']?.toString() ?? json['bankName']?.toString(),
    );
  }
}
