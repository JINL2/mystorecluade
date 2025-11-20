// Domain Entity - Cash Location Detail
// Represents detailed cash location information for editing/viewing

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_location_detail.freezed.dart';
part 'cash_location_detail.g.dart';

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
  }) = _CashLocationDetail;

  factory CashLocationDetail.fromJson(Map<String, dynamic> json) =>
      _$CashLocationDetailFromJson(json);
}
