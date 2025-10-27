// Domain Layer - Cash Location Query Parameters (Value Object)

class CashLocationQueryParams {
  final String companyId;
  final String storeId;

  CashLocationQueryParams({
    required this.companyId,
    required this.storeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashLocationQueryParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId;

  @override
  int get hashCode => companyId.hashCode ^ storeId.hashCode;
}
