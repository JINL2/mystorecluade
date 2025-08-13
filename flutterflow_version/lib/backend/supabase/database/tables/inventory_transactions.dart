import '../database.dart';

class InventoryTransactionsTable
    extends SupabaseTable<InventoryTransactionsRow> {
  @override
  String get tableName => 'inventory_transactions';

  @override
  InventoryTransactionsRow createRow(Map<String, dynamic> data) =>
      InventoryTransactionsRow(data);
}

class InventoryTransactionsRow extends SupabaseDataRow {
  InventoryTransactionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => InventoryTransactionsTable();

  String get inventoryTxId => getField<String>('inventory_tx_id')!;
  set inventoryTxId(String value) => setField<String>('inventory_tx_id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  String? get journalLineId => getField<String>('journal_line_id');
  set journalLineId(String? value) =>
      setField<String>('journal_line_id', value);

  int get quantity => getField<int>('quantity')!;
  set quantity(int value) => setField<int>('quantity', value);

  String? get transactionType => getField<String>('transaction_type');
  set transactionType(String? value) =>
      setField<String>('transaction_type', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
