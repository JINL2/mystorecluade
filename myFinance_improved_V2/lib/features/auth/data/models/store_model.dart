// lib/features/auth/data/models/store_model.dart

import '../../domain/entities/store_entity.dart';

/// Store Model
///
/// 📦 택배 상자 - JSON 직렬화 가능한 데이터 모델
///
/// 책임:
/// - JSON ↔ Dart 객체 변환
/// - Database 컬럼명 매핑 (huddle_time, payment_time, allowed_distance)
/// - Entity 변환
class StoreModel {
  final String storeId;
  final String storeName;
  final String companyId;
  final String? storeCode;
  final String? storeAddress;
  final String? storePhone;
  final int? huddleTime;          // DB: huddle_time
  final int? paymentTime;         // DB: payment_time
  final int? allowedDistance;     // DB: allowed_distance
  final String createdAt;
  final String? updatedAt;
  final bool isDeleted;

  const StoreModel({
    required this.storeId,
    required this.storeName,
    required this.companyId,
    this.storeCode,
    this.storeAddress,
    this.storePhone,
    this.huddleTime,
    this.paymentTime,
    this.allowedDistance,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });

  /// Create from Supabase JSON
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      companyId: json['company_id'] as String,
      storeCode: json['store_code'] as String?,
      storeAddress: json['store_address'] as String?,
      storePhone: json['store_phone'] as String?,
      huddleTime: json['huddle_time'] as int?,
      paymentTime: json['payment_time'] as int?,
      allowedDistance: json['allowed_distance'] as int?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'store_name': storeName,
      'company_id': companyId,
      'store_code': storeCode,
      'store_address': storeAddress,
      'store_phone': storePhone,
      'huddle_time': huddleTime,
      'payment_time': paymentTime,
      'allowed_distance': allowedDistance,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_deleted': isDeleted,
    };
  }

  /// Convert to Domain Entity
  Store toEntity() {
    return Store(
      id: storeId,
      name: storeName,
      companyId: companyId,
      storeCode: storeCode,
      address: storeAddress,
      phone: storePhone,
      // 단위 변환: minutes, days, meters
      huddleTimeMinutes: huddleTime,
      paymentTimeDays: paymentTime,
      allowedDistanceMeters: allowedDistance?.toDouble(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// Create from Domain Entity
  factory StoreModel.fromEntity(Store entity) {
    return StoreModel(
      storeId: entity.id,
      storeName: entity.name,
      companyId: entity.companyId,
      storeCode: entity.storeCode,
      storeAddress: entity.address,
      storePhone: entity.phone,
      // 단위 변환: meters → integer
      huddleTime: entity.huddleTimeMinutes,
      paymentTime: entity.paymentTimeDays,
      allowedDistance: entity.allowedDistanceMeters?.toInt(),
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }

  /// Create insert map for Supabase
  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'store_name': storeName,
      'company_id': companyId,
    };

    if (storeCode != null) map['store_code'] = storeCode;
    if (storeAddress != null) map['store_address'] = storeAddress;
    if (storePhone != null) map['store_phone'] = storePhone;
    if (huddleTime != null) map['huddle_time'] = huddleTime;
    if (paymentTime != null) map['payment_time'] = paymentTime;
    if (allowedDistance != null) map['allowed_distance'] = allowedDistance;

    return map;
  }
}
