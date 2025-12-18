// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckInResultImpl _$$CheckInResultImplFromJson(Map<String, dynamic> json) =>
    _$CheckInResultImpl(
      action: json['action'] as String,
      requestDate: json['requestDate'] as String,
      timestamp: json['timestamp'] as String,
      shiftRequestId: json['shiftRequestId'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$$CheckInResultImplToJson(_$CheckInResultImpl instance) =>
    <String, dynamic>{
      'action': instance.action,
      'requestDate': instance.requestDate,
      'timestamp': instance.timestamp,
      'shiftRequestId': instance.shiftRequestId,
      'message': instance.message,
      'success': instance.success,
    };
