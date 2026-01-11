import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/supply_chain_status.dart';

part 'supply_chain_model.g.dart';

/// 공급망 문제 제품 Model
/// RPC: get_supply_chain_status 응답 item
@JsonSerializable(fieldRename: FieldRename.snake)
class SupplyChainProductModel {
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'shortage_days')
  final int shortageDays;
  @JsonKey(name: 'avg_shortage_per_day')
  final num avgShortagePerDay;
  @JsonKey(name: 'total_shortage')
  final num totalShortage;
  @JsonKey(name: 'error_integral')
  final num errorIntegral;
  @JsonKey(name: 'risk_level')
  final String riskLevel;

  SupplyChainProductModel({
    required this.productId,
    required this.productName,
    required this.shortageDays,
    required this.avgShortagePerDay,
    required this.totalShortage,
    required this.errorIntegral,
    required this.riskLevel,
  });

  factory SupplyChainProductModel.fromJson(Map<String, dynamic> json) =>
      _$SupplyChainProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplyChainProductModelToJson(this);

  SupplyChainProduct toEntity() => SupplyChainProduct(
        productId: productId,
        productName: productName,
        shortageDays: shortageDays,
        avgShortagePerDay: avgShortagePerDay,
        totalShortage: totalShortage,
        errorIntegral: errorIntegral,
        riskLevel: riskLevel,
      );
}

/// Supply chain status response Model
/// RPC: get_supply_chain_status full response
@JsonSerializable(fieldRename: FieldRename.snake)
class SupplyChainStatusModel {
  @JsonKey(name: 'urgent_products', defaultValue: [])
  final List<SupplyChainProductModel> urgentProducts;

  SupplyChainStatusModel({
    required this.urgentProducts,
  });

  factory SupplyChainStatusModel.fromJson(Map<String, dynamic> json) =>
      _$SupplyChainStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplyChainStatusModelToJson(this);

  SupplyChainStatus toEntity() => SupplyChainStatus(
        urgentProducts: urgentProducts.map((p) => p.toEntity()).toList(),
      );
}
