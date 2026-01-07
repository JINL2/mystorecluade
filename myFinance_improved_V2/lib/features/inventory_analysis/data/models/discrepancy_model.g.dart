// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discrepancy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDiscrepancyModel _$StoreDiscrepancyModelFromJson(
        Map<String, dynamic> json) =>
    StoreDiscrepancyModel(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      totalEvents: (json['total_events'] as num).toInt(),
      increaseCount: (json['increase_count'] as num).toInt(),
      decreaseCount: (json['decrease_count'] as num).toInt(),
      increaseValue: json['increase_value'] as num,
      decreaseValue: json['decrease_value'] as num,
      netValue: json['net_value'] as num,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$StoreDiscrepancyModelToJson(
        StoreDiscrepancyModel instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'total_events': instance.totalEvents,
      'increase_count': instance.increaseCount,
      'decrease_count': instance.decreaseCount,
      'increase_value': instance.increaseValue,
      'decrease_value': instance.decreaseValue,
      'net_value': instance.netValue,
      'status': instance.status,
    };

DiscrepancyOverviewModel _$DiscrepancyOverviewModelFromJson(
        Map<String, dynamic> json) =>
    DiscrepancyOverviewModel(
      status: json['status'] as String,
      message: json['message'] as String?,
      minRequired: json['min_required'] as String?,
      totalIncreaseValue: json['total_increase_value'] as num?,
      totalDecreaseValue: json['total_decrease_value'] as num?,
      netValue: json['net_value'] as num?,
      totalStores: (json['total_stores'] as num?)?.toInt(),
      totalEvents: (json['total_events'] as num?)?.toInt(),
      stores: (json['stores'] as List<dynamic>?)
          ?.map(
              (e) => StoreDiscrepancyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiscrepancyOverviewModelToJson(
        DiscrepancyOverviewModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'min_required': instance.minRequired,
      'total_increase_value': instance.totalIncreaseValue,
      'total_decrease_value': instance.totalDecreaseValue,
      'net_value': instance.netValue,
      'total_stores': instance.totalStores,
      'total_events': instance.totalEvents,
      'stores': instance.stores,
    };
