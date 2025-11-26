// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanResultImpl _$$ScanResultImplFromJson(Map<String, dynamic> json) =>
    _$ScanResultImpl(
      requestDate: json['requestDate'] as String,
      shiftRequestId: json['shiftRequestId'] as String,
      shiftStartTime: json['shiftStartTime'] as String,
      shiftEndTime: json['shiftEndTime'] as String,
      storeName: json['storeName'] as String,
      action: json['action'] as String,
      timestamp: json['timestamp'] as String,
      storeId: json['storeId'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$$ScanResultImplToJson(_$ScanResultImpl instance) =>
    <String, dynamic>{
      'requestDate': instance.requestDate,
      'shiftRequestId': instance.shiftRequestId,
      'shiftStartTime': instance.shiftStartTime,
      'shiftEndTime': instance.shiftEndTime,
      'storeName': instance.storeName,
      'action': instance.action,
      'timestamp': instance.timestamp,
      'storeId': instance.storeId,
      'userId': instance.userId,
    };
