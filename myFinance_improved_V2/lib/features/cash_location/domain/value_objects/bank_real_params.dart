// Domain Layer - Bank Real Parameters (Value Object)

/// Parameters for querying bank real entries
class BankRealParams {
  final String companyId;
  final String storeId;
  final int offset;
  final int limit;

  BankRealParams({
    required this.companyId,
    required this.storeId,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankRealParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}
