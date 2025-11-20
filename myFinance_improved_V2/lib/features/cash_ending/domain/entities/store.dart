// lib/features/cash_ending/domain/entities/store.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';

/// Domain entity representing a store
///
/// Maps to `stores` table in database.
/// DB columns: store_id (uuid), store_name (varchar), store_code (varchar)
@freezed
class Store with _$Store {
  const factory Store({
    required String storeId,
    required String storeName,
    String? storeCode,
  }) = _Store;

  const Store._();

  /// Check if this represents the headquarter (special case)
  bool get isHeadquarter => storeId == 'headquarter';
}
