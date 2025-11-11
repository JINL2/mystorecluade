import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';

/// Data Transfer Object for Store
/// Handles JSON serialization/deserialization from Supabase
///
/// Pure DTO that does not extend domain entity
class StoreModel {
  const StoreModel({
    required this.id,
    required this.name,
    required this.code,
    required this.companyId,
    this.address,
    this.phone,
    this.huddleTime,
    this.paymentTime,
    this.allowedDistance,
  });

  final String id;
  final String name;
  final String code;
  final String companyId;
  final String? address;
  final String? phone;
  final int? huddleTime;
  final int? paymentTime;
  final int? allowedDistance;

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
