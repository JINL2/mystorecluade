// Domain Layer - Cash Real Parameters (Value Object)

class CashRealParams {
  final String companyId;
  final String storeId;
  final String locationType;
  final int offset;
  final int limit;

  CashRealParams({
    required this.companyId,
    required this.storeId,
    required this.locationType,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashRealParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          locationType == other.locationType &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      locationType.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}
