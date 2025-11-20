// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_features_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryFeaturesModelImpl _$$CategoryFeaturesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryFeaturesModelImpl(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => FeatureItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CategoryFeaturesModelImplToJson(
        _$CategoryFeaturesModelImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'features': instance.features,
    };

_$FeatureItemModelImpl _$$FeatureItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FeatureItemModelImpl(
      featureId: json['feature_id'] as String,
      featureName: json['feature_name'] as String,
      featureDescription: json['feature_description'] as String?,
      route: json['route'] as String?,
      icon: json['icon'] as String?,
      iconKey: json['icon_key'] as String?,
      isShowMain: json['is_show_main'] as bool? ?? true,
    );

Map<String, dynamic> _$$FeatureItemModelImplToJson(
        _$FeatureItemModelImpl instance) =>
    <String, dynamic>{
      'feature_id': instance.featureId,
      'feature_name': instance.featureName,
      'feature_description': instance.featureDescription,
      'route': instance.route,
      'icon': instance.icon,
      'icon_key': instance.iconKey,
      'is_show_main': instance.isShowMain,
    };
