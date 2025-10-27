// Domain Layer - Stock Flow Parameters (Value Object)

class StockFlowParams {
  final String companyId;
  final String storeId;
  final String cashLocationId;
  final int offset;
  final int limit;

  StockFlowParams({
    required this.companyId,
    required this.storeId,
    required this.cashLocationId,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockFlowParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          cashLocationId == other.cashLocationId &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      cashLocationId.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}
