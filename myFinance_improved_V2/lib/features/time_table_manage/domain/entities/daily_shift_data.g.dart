// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_shift_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyShiftDataImpl _$$DailyShiftDataImplFromJson(Map<String, dynamic> json) =>
    _$DailyShiftDataImpl(
      date: json['date'] as String,
      shifts: (json['shifts'] as List<dynamic>?)
              ?.map(
                  (e) => ShiftWithRequests.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$DailyShiftDataImplToJson(
        _$DailyShiftDataImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'shifts': instance.shifts,
    };

_$ShiftWithRequestsImpl _$$ShiftWithRequestsImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftWithRequestsImpl(
      shift: Shift.fromJson(json['shift'] as Map<String, dynamic>),
      pendingRequests: (json['pending_requests'] as List<dynamic>?)
              ?.map((e) => ShiftRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      approvedRequests: (json['approved_requests'] as List<dynamic>?)
              ?.map((e) => ShiftRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$$ShiftWithRequestsImplToJson(
        _$ShiftWithRequestsImpl instance) =>
    <String, dynamic>{
      'shift': instance.shift,
      'pending_requests': instance.pendingRequests,
      'approved_requests': instance.approvedRequests,
    };
