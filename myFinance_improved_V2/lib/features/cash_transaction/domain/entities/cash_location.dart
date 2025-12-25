import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_location.freezed.dart';

/// Domain entity representing a cash location
///
/// Maps to `cash_locations` table
/// DB columns: cash_location_id, location_name, location_type, store_id, company_id
@freezed
class CashLocation with _$CashLocation {
  const factory CashLocation({
    required String cashLocationId,
    required String locationName,
    required String locationType,
    String? storeId,
    String? companyId,
    String? accountId,
  }) = _CashLocation;

  const CashLocation._();

  /// Check if this is a cash drawer
  bool get isCash => locationType == 'cash';

  /// Check if this is a bank account
  bool get isBank => locationType == 'bank';

  /// Check if this is a vault/safe
  bool get isVault => locationType == 'vault';
}
