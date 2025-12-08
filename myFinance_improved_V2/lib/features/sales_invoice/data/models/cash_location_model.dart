import '../../domain/entities/cash_location.dart';

/// Cash location model for data transfer
///
/// Supports get_cash_locations RPC response format:
/// {
///   "id": "uuid",
///   "name": "Location Name",
///   "type": "cash" | "bank",
///   "storeId": "uuid" | null,
///   "isCompanyWide": true | false,
///   "currencyCode": "VND" | null,
///   "bankAccount": "..." | null,
///   "bankName": "..." | null,
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
    // RPC response uses camelCase field names
    return CashLocation(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'cash',
      storeId: json['storeId']?.toString() ?? '',
      isCompanyWide: (json['isCompanyWide'] as bool?) ?? false,
      currencyCode: json['currencyCode']?.toString() ?? 'VND',
      bankAccount: json['bankAccount']?.toString(),
      bankName: json['bankName']?.toString(),
    );
  }
}
