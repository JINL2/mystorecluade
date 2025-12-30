// Domain Layer - Cash Location Query Parameters (Value Object)

class CashLocationQueryParams {
  final String companyId;
  final String? storeId;
  final String? locationType;

  CashLocationQueryParams({
    required this.companyId,
    this.storeId,
    this.locationType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashLocationQueryParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          locationType == other.locationType;

  @override
  int get hashCode => companyId.hashCode ^ (storeId?.hashCode ?? 0) ^ (locationType?.hashCode ?? 0);
}
