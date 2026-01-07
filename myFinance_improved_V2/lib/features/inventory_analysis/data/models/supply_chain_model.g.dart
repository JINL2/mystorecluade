// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply_chain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplyChainProductModel _$SupplyChainProductModelFromJson(
        Map<String, dynamic> json) =>
    SupplyChainProductModel(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      shortageDays: (json['shortage_days'] as num).toInt(),
      avgShortagePerDay: json['avg_shortage_per_day'] as num,
      totalShortage: json['total_shortage'] as num,
      errorIntegral: json['error_integral'] as num,
      riskLevel: json['risk_level'] as String,
    );

Map<String, dynamic> _$SupplyChainProductModelToJson(
        SupplyChainProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'shortage_days': instance.shortageDays,
      'avg_shortage_per_day': instance.avgShortagePerDay,
      'total_shortage': instance.totalShortage,
      'error_integral': instance.errorIntegral,
      'risk_level': instance.riskLevel,
    };

SupplyChainStatusModel _$SupplyChainStatusModelFromJson(
        Map<String, dynamic> json) =>
    SupplyChainStatusModel(
      urgentProducts: (json['urgent_products'] as List<dynamic>)
          .map((e) =>
              SupplyChainProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupplyChainStatusModelToJson(
        SupplyChainStatusModel instance) =>
    <String, dynamic>{
      'urgent_products': instance.urgentProducts,
    };
