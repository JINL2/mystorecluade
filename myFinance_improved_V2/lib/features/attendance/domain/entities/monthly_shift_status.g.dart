// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_shift_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyShiftStatusImpl _$$MonthlyShiftStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyShiftStatusImpl(
      requestDate: json['requestDate'] as String,
      totalPending: (json['totalPending'] as num?)?.toInt() ?? 0,
      totalApproved: (json['totalApproved'] as num?)?.toInt() ?? 0,
      shifts: (json['shifts'] as List<dynamic>?)
              ?.map((e) => DailyShift.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MonthlyShiftStatusImplToJson(
        _$MonthlyShiftStatusImpl instance) =>
    <String, dynamic>{
      'requestDate': instance.requestDate,
      'totalPending': instance.totalPending,
      'totalApproved': instance.totalApproved,
      'shifts': instance.shifts,
    };

_$DailyShiftImpl _$$DailyShiftImplFromJson(Map<String, dynamic> json) =>
    _$DailyShiftImpl(
      shiftId: json['shiftId'] as String,
      shiftName: json['shiftName'] as String?,
      shiftType: json['shiftType'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      pendingEmployees: (json['pendingEmployees'] as List<dynamic>?)
              ?.map((e) => EmployeeStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      approvedEmployees: (json['approvedEmployees'] as List<dynamic>?)
              ?.map((e) => EmployeeStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DailyShiftImplToJson(_$DailyShiftImpl instance) =>
    <String, dynamic>{
      'shiftId': instance.shiftId,
      'shiftName': instance.shiftName,
      'shiftType': instance.shiftType,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'pendingEmployees': instance.pendingEmployees,
      'approvedEmployees': instance.approvedEmployees,
    };

_$EmployeeStatusImpl _$$EmployeeStatusImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeStatusImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userPhone: json['userPhone'] as String?,
      profileImage: json['profileImage'] as String?,
      shiftRequestId: json['shiftRequestId'] as String?,
      requestTime: json['requestTime'] == null
          ? null
          : DateTime.parse(json['requestTime'] as String),
      isApproved: json['isApproved'] as bool?,
      approvedBy: json['approvedBy'] as String?,
    );

Map<String, dynamic> _$$EmployeeStatusImplToJson(
        _$EmployeeStatusImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
      'profileImage': instance.profileImage,
      'shiftRequestId': instance.shiftRequestId,
      'requestTime': instance.requestTime?.toIso8601String(),
      'isApproved': instance.isApproved,
      'approvedBy': instance.approvedBy,
    };
