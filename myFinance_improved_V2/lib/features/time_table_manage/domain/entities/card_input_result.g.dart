// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_input_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardInputResultImpl _$$CardInputResultImplFromJson(
        Map<String, dynamic> json) =>
    _$CardInputResultImpl(
      shiftRequestId: json['shift_request_id'] as String,
      confirmedStartTime:
          DateTime.parse(json['confirmed_start_time'] as String),
      confirmedEndTime: DateTime.parse(json['confirmed_end_time'] as String),
      isLate: json['is_late'] as bool,
      isProblemSolved: json['is_problem_solved'] as bool,
      newTag: json['new_tag'] == null
          ? null
          : Tag.fromJson(json['new_tag'] as Map<String, dynamic>),
      updatedRequest: ShiftRequest.fromJson(
          json['updated_request'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$CardInputResultImplToJson(
        _$CardInputResultImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'confirmed_start_time': instance.confirmedStartTime.toIso8601String(),
      'confirmed_end_time': instance.confirmedEndTime.toIso8601String(),
      'is_late': instance.isLate,
      'is_problem_solved': instance.isProblemSolved,
      'new_tag': instance.newTag,
      'updated_request': instance.updatedRequest,
      'message': instance.message,
    };
