// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_feature_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopFeatureModelImpl _$$TopFeatureModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TopFeatureModelImpl(
      featureId: json['feature_id'] as String,
      featureName: json['feature_name'] as String?,
      featureDescription: json['feature_description'] as String?,
      categoryId: json['category_id'] as String?,
      clickCount: (json['click_count'] as num?)?.toInt(),
      lastClicked: json['last_clicked'] == null
          ? null
          : DateTime.parse(json['last_clicked'] as String),
      icon: json['icon'] as String?,
      route: json['route'] as String?,
      iconKey: json['icon_key'] as String?,
    );

Map<String, dynamic> _$$TopFeatureModelImplToJson(
        _$TopFeatureModelImpl instance) =>
    <String, dynamic>{
      'feature_id': instance.featureId,
      'feature_name': instance.featureName,
      'feature_description': instance.featureDescription,
      'category_id': instance.categoryId,
      'click_count': instance.clickCount,
      'last_clicked': instance.lastClicked?.toIso8601String(),
      'icon': instance.icon,
      'route': instance.route,
      'icon_key': instance.iconKey,
    };
