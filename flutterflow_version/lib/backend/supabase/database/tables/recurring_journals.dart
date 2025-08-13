import '../database.dart';

class RecurringJournalsTable extends SupabaseTable<RecurringJournalsRow> {
  @override
  String get tableName => 'recurring_journals';

  @override
  RecurringJournalsRow createRow(Map<String, dynamic> data) =>
      RecurringJournalsRow(data);
}

class RecurringJournalsRow extends SupabaseDataRow {
  RecurringJournalsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RecurringJournalsTable();

  String get recurringId => getField<String>('recurring_id')!;
  set recurringId(String value) => setField<String>('recurring_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get repeatCycle => getField<String>('repeat_cycle');
  set repeatCycle(String? value) => setField<String>('repeat_cycle', value);

  DateTime? get nextRunDate => getField<DateTime>('next_run_date');
  set nextRunDate(DateTime? value) =>
      setField<DateTime>('next_run_date', value);

  bool? get enabled => getField<bool>('enabled');
  set enabled(bool? value) => setField<bool>('enabled', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
