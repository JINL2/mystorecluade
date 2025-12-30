// Domain Entity - Cash Location Detail
// Represents detailed cash location information for editing/viewing
// Note: JSON serialization is handled by data/models layer

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_location_detail.freezed.dart';

@freezed
class CashLocationDetail with _$CashLocationDetail {
  const factory CashLocationDetail({
    required String locationId,
    required String locationName,
    required String locationType,
    String? note,
    String? description,
    String? bankName,
    String? accountNumber,
    required bool isMainLocation,
    required String companyId,
    String? storeId,
    @Default(false) bool isDeleted,
    // Trade/International banking fields
    String? beneficiaryName,
    String? bankAddress,
    String? swiftCode,
    String? bankBranch,
    String? accountType,
  }) = _CashLocationDetail;
}
