import '../database.dart';

class VaultAmountLineTable extends SupabaseTable<VaultAmountLineRow> {
  @override
  String get tableName => 'vault_amount_line';

  @override
  VaultAmountLineRow createRow(Map<String, dynamic> data) =>
      VaultAmountLineRow(data);
}

class VaultAmountLineRow extends SupabaseDataRow {
  VaultAmountLineRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VaultAmountLineTable();

  String get vaultAmountId => getField<String>('vault_amount_id')!;
  set vaultAmountId(String value) => setField<String>('vault_amount_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String get storeId => getField<String>('store_id')!;
  set storeId(String value) => setField<String>('store_id', value);

  String get locationId => getField<String>('location_id')!;
  set locationId(String value) => setField<String>('location_id', value);

  String get currencyId => getField<String>('currency_id')!;
  set currencyId(String value) => setField<String>('currency_id', value);

  double? get debit => getField<double>('debit');
  set debit(double? value) => setField<double>('debit', value);

  double? get credit => getField<double>('credit');
  set credit(double? value) => setField<double>('credit', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime get recordDate => getField<DateTime>('record_date')!;
  set recordDate(DateTime value) => setField<DateTime>('record_date', value);

  String get createdBy => getField<String>('created_by')!;
  set createdBy(String value) => setField<String>('created_by', value);

  String? get denominationId => getField<String>('denomination_id');
  set denominationId(String? value) =>
      setField<String>('denomination_id', value);
}
