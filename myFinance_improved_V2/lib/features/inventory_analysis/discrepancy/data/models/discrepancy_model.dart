import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/discrepancy_overview.dart';

part 'discrepancy_model.g.dart';

/// Store discrepancy data Model
@JsonSerializable(fieldRename: FieldRename.snake)
class StoreDiscrepancyModel {
  @JsonKey(name: 'store_id')
  final String? storeId;
  @JsonKey(name: 'store_name')
  final String storeName;
  @JsonKey(name: 'total_events')
  final int? totalEvents;
  @JsonKey(name: 'increase_count')
  final int? increaseCount;
  @JsonKey(name: 'decrease_count')
  final int? decreaseCount;
  @JsonKey(name: 'increase_value')
  final num? increaseValue;
  @JsonKey(name: 'decrease_value')
  final num? decreaseValue;
  @JsonKey(name: 'net_value')
  final num netValue;
  final String? status;

  StoreDiscrepancyModel({
    this.storeId,
    required this.storeName,
    this.totalEvents,
    this.increaseCount,
    this.decreaseCount,
    this.increaseValue,
    this.decreaseValue,
    required this.netValue,
    this.status,
  });

  factory StoreDiscrepancyModel.fromJson(Map<String, dynamic> json) =>
      _$StoreDiscrepancyModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreDiscrepancyModelToJson(this);

  StoreDiscrepancy toEntity() => StoreDiscrepancy(
        storeId: storeId ?? '',
        storeName: storeName,
        totalEvents: totalEvents ?? 0,
        increaseCount: increaseCount ?? 0,
        decreaseCount: decreaseCount ?? 0,
        increaseValue: increaseValue ?? 0,
        decreaseValue: decreaseValue ?? 0,
        netValue: netValue,
        status: status,
      );
}

/// Inventory discrepancy overview Model
/// RPC: get_discrepancy_overview response
@JsonSerializable(fieldRename: FieldRename.snake)
class DiscrepancyOverviewModel {
  final String status;
  final String? message;
  @JsonKey(name: 'min_required')
  final String? minRequired;
  @JsonKey(name: 'total_increase_value')
  final num? totalIncreaseValue;
  @JsonKey(name: 'total_decrease_value')
  final num? totalDecreaseValue;
  @JsonKey(name: 'net_value')
  final num? netValue;
  @JsonKey(name: 'total_stores')
  final int? totalStores;
  @JsonKey(name: 'total_events')
  final int? totalEvents;
  final List<StoreDiscrepancyModel>? stores;

  DiscrepancyOverviewModel({
    required this.status,
    this.message,
    this.minRequired,
    this.totalIncreaseValue,
    this.totalDecreaseValue,
    this.netValue,
    this.totalStores,
    this.totalEvents,
    this.stores,
  });

  factory DiscrepancyOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$DiscrepancyOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiscrepancyOverviewModelToJson(this);

  DiscrepancyOverview toEntity() => DiscrepancyOverview(
        status: status,
        message: message,
        minRequired: minRequired,
        totalIncreaseValue: totalIncreaseValue ?? 0,
        totalDecreaseValue: totalDecreaseValue ?? 0,
        netValue: netValue ?? 0,
        totalStores: totalStores ?? 0,
        totalEvents: totalEvents ?? 0,
        stores: stores?.map((s) => s.toEntity()).toList() ?? [],
      );
}
