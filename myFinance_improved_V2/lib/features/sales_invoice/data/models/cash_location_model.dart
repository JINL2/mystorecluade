import '../../domain/entities/cash_location.dart';

/// Cash location model for data transfer
class CashLocationModel {
  final Map<String, dynamic> json;

  CashLocationModel(this.json);

  /// Create from JSON
  factory CashLocationModel.fromJson(Map<String, dynamic> json) {
    return CashLocationModel(json);
  }

  /// Convert to domain entity
  CashLocation toEntity() {
    // Support both RPC response and direct model fields
    final locationSummary = json['location_summary'] as Map<String, dynamic>?;
    final isRpcResponse = locationSummary != null;
    final data = isRpcResponse ? locationSummary : json;

    return CashLocation(
      id: data['cash_location_id']?.toString() ?? data['id']?.toString() ?? '',
      name: data['location_name']?.toString() ?? data['name']?.toString() ?? '',
      type: data['location_type']?.toString() ?? data['type']?.toString() ?? 'cash',
      storeId: data['store_id']?.toString() ?? '',
      isCompanyWide: (data['is_company_wide'] as bool?) ?? false,
      currencyCode: data['currency_code']?.toString() ?? 'VND',
      bankAccount: data['bank_account']?.toString(),
      bankName: data['bank_name']?.toString(),
    );
  }
}
