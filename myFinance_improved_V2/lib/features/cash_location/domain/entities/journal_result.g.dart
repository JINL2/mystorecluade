// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalSuccessImpl _$$JournalSuccessImplFromJson(Map<String, dynamic> json) =>
    _$JournalSuccessImpl(
      journalId: json['journalId'] as String,
      message: json['message'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$JournalSuccessImplToJson(
        _$JournalSuccessImpl instance) =>
    <String, dynamic>{
      'journalId': instance.journalId,
      'message': instance.message,
      'additionalData': instance.additionalData,
      'runtimeType': instance.$type,
    };

_$JournalFailureImpl _$$JournalFailureImplFromJson(Map<String, dynamic> json) =>
    _$JournalFailureImpl(
      error: json['error'] as String,
      errorCode: json['errorCode'] as String?,
      errorDetails: json['errorDetails'] as Map<String, dynamic>?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$JournalFailureImplToJson(
        _$JournalFailureImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorCode': instance.errorCode,
      'errorDetails': instance.errorDetails,
      'runtimeType': instance.$type,
    };
