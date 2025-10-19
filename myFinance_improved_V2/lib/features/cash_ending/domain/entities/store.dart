// lib/features/cash_ending/domain/entities/store.dart

/// Domain entity representing a store
class Store {
  final String storeId;
  final String storeName;
  final String? storeCode;

  const Store({
    required this.storeId,
    required this.storeName,
    this.storeCode,
  });

  /// Check if this represents the headquarter (special case)
  bool get isHeadquarter => storeId == 'headquarter';

  /// Create a copy with updated fields
  Store copyWith({
    String? storeId,
    String? storeName,
    String? storeCode,
  }) {
    return Store(
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      storeCode: storeCode ?? this.storeCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Store &&
        other.storeId == storeId &&
        other.storeName == storeName &&
        other.storeCode == storeCode;
  }

  @override
  int get hashCode {
    return Object.hash(storeId, storeName, storeCode);
  }
}
