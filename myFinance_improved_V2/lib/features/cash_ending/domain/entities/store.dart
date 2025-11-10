// lib/features/cash_ending/domain/entities/store.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';

/// Domain entity representing a store
///
/// Uses Freezed for:
/// - Immutability guarantee
/// - Auto-generated copyWith, ==, hashCode
/// - Manual JSON serialization (no .g.dart needed)
///
/// ✅ Refactored with:
/// - Removed @JsonKey warnings
/// - Manual fromJson for consistency with other entities
@freezed
class Store with _$Store {
  const Store._();

  const factory Store({
    required String storeId,
    required String storeName,
    String? storeCode,
  }) = _Store;

  /// Custom fromJson factory for database deserialization
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      storeCode: json['store_code']?.toString(),
    );
  }

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'store_name': storeName,
      'store_code': storeCode,
    };
  }

  /// Check if this represents the headquarter (special case)
  bool get isHeadquarter => storeId == 'headquarter';
}
