// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homepage_alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomepageAlertModelImpl _$$HomepageAlertModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HomepageAlertModelImpl(
      isShow: json['is_show'] as bool? ?? false,
      isChecked: json['is_checked'] as bool? ?? false,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$$HomepageAlertModelImplToJson(
        _$HomepageAlertModelImpl instance) =>
    <String, dynamic>{
      'is_show': instance.isShow,
      'is_checked': instance.isChecked,
      'content': instance.content,
    };
