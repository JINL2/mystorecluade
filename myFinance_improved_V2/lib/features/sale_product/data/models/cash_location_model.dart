import '../../domain/entities/cash_location.dart';

/// Cash location model for data transfer
///
/// Supports get_cash_locations_v2 RPC response format:
/// {
///   "cash_location_id": "uuid",
///   "location_name": "Location Name",
///   "location_type": "cash" | "vault" | "bank",
///   "store_id": "uuid" | null,
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

  /// Convert to domain entity
  CashLocation toEntity() {
    // v2 RPC response uses snake_case field names (actual DB column names)
    return CashLocation(
      id: json['cash_location_id']?.toString() ?? '',
      name: json['location_name']?.toString() ?? '',
      type: json['location_type']?.toString() ?? 'cash',
      storeId: json['store_id']?.toString() ?? '',
      isCompanyWide: (json['is_company_wide'] as bool?) ?? false,
      currencyCode: json['currency_code']?.toString() ?? 'VND',
      bankAccount: json['bank_account']?.toString(),
      bankName: json['bank_name']?.toString(),
    );
  }
}
