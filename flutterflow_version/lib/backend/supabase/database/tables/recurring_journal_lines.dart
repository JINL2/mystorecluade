import '../database.dart';

class RecurringJournalLinesTable
    extends SupabaseTable<RecurringJournalLinesRow> {
  @override
  String get tableName => 'recurring_journal_lines';

  @override
  RecurringJournalLinesRow createRow(Map<String, dynamic> data) =>
      RecurringJournalLinesRow(data);
}

class RecurringJournalLinesRow extends SupabaseDataRow {
  RecurringJournalLinesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RecurringJournalLinesTable();

  String get lineId => getField<String>('line_id')!;
  set lineId(String value) => setField<String>('line_id', value);

  String get recurringId => getField<String>('recurring_id')!;
  set recurringId(String value) => setField<String>('recurring_id', value);

  String get accountId => getField<String>('account_id')!;
  set accountId(String value) => setField<String>('account_id', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double? get debit => getField<double>('debit');
  set debit(double? value) => setField<double>('debit', value);

  double? get credit => getField<double>('credit');
  set credit(double? value) => setField<double>('credit', value);

  String? get fixedAssetId => getField<String>('fixed_asset_id');
  set fixedAssetId(String? value) => setField<String>('fixed_asset_id', value);
}
