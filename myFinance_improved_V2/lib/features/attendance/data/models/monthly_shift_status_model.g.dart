// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_shift_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyShiftStatusModelImpl _$$MonthlyShiftStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyShiftStatusModelImpl(
      storeId: json['store_id'] as String,
      shiftId: json['shift_id'] as String,
      requestDate: json['request_date'] as String,
      totalRegistered: (json['total_registered'] as num).toInt(),
      isRegisteredByMe: json['is_registered_by_me'] as bool,
      shiftRequestId: json['shift_request_id'] as String?,
      isApproved: json['is_approved'] as bool,
      totalOtherStaffs: (json['total_other_staffs'] as num).toInt(),
      otherStaffs: (json['other_staffs'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$MonthlyShiftStatusModelImplToJson(
        _$MonthlyShiftStatusModelImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'shift_id': instance.shiftId,
      'request_date': instance.requestDate,
      'total_registered': instance.totalRegistered,
      'is_registered_by_me': instance.isRegisteredByMe,
      'shift_request_id': instance.shiftRequestId,
      'is_approved': instance.isApproved,
      'total_other_staffs': instance.totalOtherStaffs,
      'other_staffs': instance.otherStaffs,
    };
