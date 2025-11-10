import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/monthly_shift_status.dart';

part 'monthly_shift_status_model.freezed.dart';
part 'monthly_shift_status_model.g.dart';

/// Monthly Shift Status Model (DTO)
///
/// Data Transfer Object for MonthlyShiftStatus entity.
/// Matches get_monthly_shift_status RPC response structure (user view)
@freezed
class MonthlyShiftStatusModel with _$MonthlyShiftStatusModel {
  const MonthlyShiftStatusModel._();

  const factory MonthlyShiftStatusModel({
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'shift_id') required String shiftId,
    @JsonKey(name: 'request_date') required String requestDate,
    @JsonKey(name: 'total_registered') required int totalRegistered,
    @JsonKey(name: 'is_registered_by_me') required bool isRegisteredByMe,
    @JsonKey(name: 'shift_request_id') String? shiftRequestId,
    @JsonKey(name: 'is_approved') required bool isApproved,
    @JsonKey(name: 'total_other_staffs') required int totalOtherStaffs,
    @JsonKey(name: 'other_staffs') required List<Map<String, dynamic>> otherStaffs,
  }) = _MonthlyShiftStatusModel;

  factory MonthlyShiftStatusModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyShiftStatusModelFromJson(json);

  /// Convert Model to Entity
  MonthlyShiftStatus toEntity() {
    return MonthlyShiftStatus(
      storeId: storeId,
      shiftId: shiftId,
      requestDate: requestDate,
      totalRegistered: totalRegistered,
      isRegisteredByMe: isRegisteredByMe,
      shiftRequestId: shiftRequestId,
      isApproved: isApproved,
      totalOtherStaffs: totalOtherStaffs,
      otherStaffs: otherStaffs,
    );
  }
}
