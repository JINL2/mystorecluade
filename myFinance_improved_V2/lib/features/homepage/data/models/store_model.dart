import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';

/// Data Transfer Object for Store
/// Handles JSON serialization/deserialization from Supabase
class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.name,
    required super.code,
    required super.companyId,
    super.address,
    super.phone,
    super.huddleTime,
    super.paymentTime,
    super.allowedDistance,
  });

  /// Create from JSON (from Supabase response after creation)
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['store_id'] as String,
      name: json['store_name'] as String,
      code: json['store_code'] as String,
      companyId: json['company_id'] as String,
      address: json['store_address'] as String?,
      phone: json['store_phone'] as String?,
      huddleTime: json['huddle_time'] as int?,
      paymentTime: json['payment_time'] as int?,
      allowedDistance: json['allowed_distance'] as int?,
    );
  }

  /// Convert to JSON (for Supabase request)
  Map<String, dynamic> toJson() {
    return {
      'store_id': id,
      'store_name': name,
      'store_code': code,
      'company_id': companyId,
      if (address != null) 'store_address': address,
      if (phone != null) 'store_phone': phone,
      if (huddleTime != null) 'huddle_time': huddleTime,
      if (paymentTime != null) 'payment_time': paymentTime,
      if (allowedDistance != null) 'allowed_distance': allowedDistance,
    };
  }

  /// Convert to domain entity
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
