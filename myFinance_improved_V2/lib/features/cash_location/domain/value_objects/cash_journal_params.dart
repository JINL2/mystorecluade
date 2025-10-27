// Domain Layer - Cash Journal Parameters (Value Object)

class CashJournalParams {
  final String companyId;
  final String storeId;
  final String locationType;
  final int offset;
  final int limit;

  CashJournalParams({
    required this.companyId,
    required this.storeId,
    required this.locationType,
    this.offset = 0,
    this.limit = 20,
  });
}
