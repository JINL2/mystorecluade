import '../database.dart';

class JournalEntriesTable extends SupabaseTable<JournalEntriesRow> {
  @override
  String get tableName => 'journal_entries';

  @override
  JournalEntriesRow createRow(Map<String, dynamic> data) =>
      JournalEntriesRow(data);
}

class JournalEntriesRow extends SupabaseDataRow {
  JournalEntriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => JournalEntriesTable();

  String get journalId => getField<String>('journal_id')!;
  set journalId(String value) => setField<String>('journal_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  DateTime get entryDate => getField<DateTime>('entry_date')!;
  set entryDate(DateTime value) => setField<DateTime>('entry_date', value);

  String? get periodId => getField<String>('period_id');
  set periodId(String? value) => setField<String>('period_id', value);

  String? get currencyId => getField<String>('currency_id');
  set currencyId(String? value) => setField<String>('currency_id', value);

  double? get exchangeRate => getField<double>('exchange_rate');
  set exchangeRate(double? value) => setField<double>('exchange_rate', value);

  double? get baseAmount => getField<double>('base_amount');
  set baseAmount(double? value) => setField<double>('base_amount', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get journalType => getField<String>('journal_type');
  set journalType(String? value) => setField<String>('journal_type', value);

  String? get counterpartyId => getField<String>('counterparty_id');
  set counterpartyId(String? value) =>
      setField<String>('counterparty_id', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  String? get approvedBy => getField<String>('approved_by');
  set approvedBy(String? value) => setField<String>('approved_by', value);

  DateTime? get approvedAt => getField<DateTime>('approved_at');
  set approvedAt(DateTime? value) => setField<DateTime>('approved_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool get isDeleted => getField<bool>('is_deleted')!;
  set isDeleted(bool value) => setField<bool>('is_deleted', value);

  bool? get isAutoCreated => getField<bool>('is_auto_created');
  set isAutoCreated(bool? value) => setField<bool>('is_auto_created', value);
}
