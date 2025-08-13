import '../database.dart';

class JournalLinesTable extends SupabaseTable<JournalLinesRow> {
  @override
  String get tableName => 'journal_lines';

  @override
  JournalLinesRow createRow(Map<String, dynamic> data) => JournalLinesRow(data);
}

class JournalLinesRow extends SupabaseDataRow {
  JournalLinesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => JournalLinesTable();

  String get lineId => getField<String>('line_id')!;
  set lineId(String value) => setField<String>('line_id', value);

  String get journalId => getField<String>('journal_id')!;
  set journalId(String value) => setField<String>('journal_id', value);

  String get accountId => getField<String>('account_id')!;
  set accountId(String value) => setField<String>('account_id', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double? get debit => getField<double>('debit');
  set debit(double? value) => setField<double>('debit', value);

  double? get credit => getField<double>('credit');
  set credit(double? value) => setField<double>('credit', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get counterpartyId => getField<String>('counterparty_id');
  set counterpartyId(String? value) =>
      setField<String>('counterparty_id', value);

  bool get isDeleted => getField<bool>('is_deleted')!;
  set isDeleted(bool value) => setField<bool>('is_deleted', value);

  String? get fixedAssetId => getField<String>('fixed_asset_id');
  set fixedAssetId(String? value) => setField<String>('fixed_asset_id', value);

  String? get debtId => getField<String>('debt_id');
  set debtId(String? value) => setField<String>('debt_id', value);

  String? get cashLocationId => getField<String>('cash_location_id');
  set cashLocationId(String? value) =>
      setField<String>('cash_location_id', value);
}
