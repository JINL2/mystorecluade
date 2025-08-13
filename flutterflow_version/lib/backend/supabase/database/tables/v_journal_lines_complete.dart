import '../database.dart';

class VJournalLinesCompleteTable
    extends SupabaseTable<VJournalLinesCompleteRow> {
  @override
  String get tableName => 'v_journal_lines_complete';

  @override
  VJournalLinesCompleteRow createRow(Map<String, dynamic> data) =>
      VJournalLinesCompleteRow(data);
}

class VJournalLinesCompleteRow extends SupabaseDataRow {
  VJournalLinesCompleteRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VJournalLinesCompleteTable();

  String? get lineId => getField<String>('line_id');
  set lineId(String? value) => setField<String>('line_id', value);

  String? get journalId => getField<String>('journal_id');
  set journalId(String? value) => setField<String>('journal_id', value);

  String? get accountId => getField<String>('account_id');
  set accountId(String? value) => setField<String>('account_id', value);

  double? get debit => getField<double>('debit');
  set debit(double? value) => setField<double>('debit', value);

  double? get credit => getField<double>('credit');
  set credit(double? value) => setField<double>('credit', value);

  String? get lineDescription => getField<String>('line_description');
  set lineDescription(String? value) =>
      setField<String>('line_description', value);

  DateTime? get lineCreatedAt => getField<DateTime>('line_created_at');
  set lineCreatedAt(DateTime? value) =>
      setField<DateTime>('line_created_at', value);

  DateTime? get entryDate => getField<DateTime>('entry_date');
  set entryDate(DateTime? value) => setField<DateTime>('entry_date', value);

  String? get journalDescription => getField<String>('journal_description');
  set journalDescription(String? value) =>
      setField<String>('journal_description', value);

  DateTime? get journalCreatedAt => getField<DateTime>('journal_created_at');
  set journalCreatedAt(DateTime? value) =>
      setField<DateTime>('journal_created_at', value);

  String? get journalCreatedBy => getField<String>('journal_created_by');
  set journalCreatedBy(String? value) =>
      setField<String>('journal_created_by', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get accountName => getField<String>('account_name');
  set accountName(String? value) => setField<String>('account_name', value);

  String? get accountType => getField<String>('account_type');
  set accountType(String? value) => setField<String>('account_type', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get storeName => getField<String>('store_name');
  set storeName(String? value) => setField<String>('store_name', value);

  String? get cashLocationId => getField<String>('cash_location_id');
  set cashLocationId(String? value) =>
      setField<String>('cash_location_id', value);

  String? get cashLocationName => getField<String>('cash_location_name');
  set cashLocationName(String? value) =>
      setField<String>('cash_location_name', value);

  String? get finalCounterpartyId => getField<String>('final_counterparty_id');
  set finalCounterpartyId(String? value) =>
      setField<String>('final_counterparty_id', value);

  String? get counterpartyName => getField<String>('counterparty_name');
  set counterpartyName(String? value) =>
      setField<String>('counterparty_name', value);

  String? get lineCounterpartyId => getField<String>('line_counterparty_id');
  set lineCounterpartyId(String? value) =>
      setField<String>('line_counterparty_id', value);

  String? get lineCounterpartyName =>
      getField<String>('line_counterparty_name');
  set lineCounterpartyName(String? value) =>
      setField<String>('line_counterparty_name', value);

  String? get journalCounterpartyId =>
      getField<String>('journal_counterparty_id');
  set journalCounterpartyId(String? value) =>
      setField<String>('journal_counterparty_id', value);

  String? get journalCounterpartyName =>
      getField<String>('journal_counterparty_name');
  set journalCounterpartyName(String? value) =>
      setField<String>('journal_counterparty_name', value);

  String? get createdById => getField<String>('created_by_id');
  set createdById(String? value) => setField<String>('created_by_id', value);

  String? get createdByName => getField<String>('created_by_name');
  set createdByName(String? value) =>
      setField<String>('created_by_name', value);

  String? get createdByEmail => getField<String>('created_by_email');
  set createdByEmail(String? value) =>
      setField<String>('created_by_email', value);

  String? get companyName => getField<String>('company_name');
  set companyName(String? value) => setField<String>('company_name', value);
}
