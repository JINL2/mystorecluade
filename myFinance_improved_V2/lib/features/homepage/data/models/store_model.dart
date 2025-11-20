import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/store.dart';

part 'store_model.freezed.dart';
part 'store_model.g.dart';

/// Data Transfer Object for Store
/// Used for create store response
@freezed
class StoreModel with _$StoreModel {
  const StoreModel._();

  const factory StoreModel({
    @JsonKey(name: 'store_id') required String id,
    @JsonKey(name: 'store_name') required String name,
    @JsonKey(name: 'store_code') required String code,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_address') String? address,
    @JsonKey(name: 'store_phone') String? phone,
    @JsonKey(name: 'huddle_time') int? huddleTime,
    @JsonKey(name: 'payment_time') int? paymentTime,
    @JsonKey(name: 'allowed_distance') int? allowedDistance,
  }) = _StoreModel;

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Store toEntity() {
    return Store(
      id: id,
      name: name,
      code: code,
      companyId: companyId,
      address: address,
      phone: phone,
      huddleTime: huddleTime,
      paymentTime: paymentTime,
      allowedDistance: allowedDistance,
    );
  }
}
