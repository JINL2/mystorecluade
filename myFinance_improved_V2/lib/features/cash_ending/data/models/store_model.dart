// lib/features/cash_ending/data/models/store_model.dart

import '../../domain/entities/store.dart';

/// Data Transfer Object for Store
/// Handles JSON serialization/deserialization
class StoreModel {
  final String storeId;
  final String storeName;
  final String? storeCode;

  const StoreModel({
    required this.storeId,
    required this.storeName,
    this.storeCode,
  });

  /// Create from JSON (from database)
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      storeCode: json['store_code']?.toString(),
    );
  }

  /// Convert to JSON (to database)
  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'store_name': storeName,
      if (storeCode != null) 'store_code': storeCode,
    };
  }

  /// Convert to Domain Entity
  Store toEntity() {
    return Store(
      storeId: storeId,
      storeName: storeName,
      storeCode: storeCode,
    );
  }

  /// Create from Domain Entity
  factory StoreModel.fromEntity(Store entity) {
    return StoreModel(
      storeId: entity.storeId,
      storeName: entity.storeName,
      storeCode: entity.storeCode,
    );
  }
}
