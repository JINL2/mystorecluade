import '../database.dart';

class FiscalPeriodsTable extends SupabaseTable<FiscalPeriodsRow> {
  @override
  String get tableName => 'fiscal_periods';

  @override
  FiscalPeriodsRow createRow(Map<String, dynamic> data) =>
      FiscalPeriodsRow(data);
}

class FiscalPeriodsRow extends SupabaseDataRow {
  FiscalPeriodsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FiscalPeriodsTable();

  String get periodId => getField<String>('period_id')!;
  set periodId(String value) => setField<String>('period_id', value);

  String get fiscalYearId => getField<String>('fiscal_year_id')!;
  set fiscalYearId(String value) => setField<String>('fiscal_year_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  DateTime get startDate => getField<DateTime>('start_date')!;
  set startDate(DateTime value) => setField<DateTime>('start_date', value);

  DateTime get endDate => getField<DateTime>('end_date')!;
  set endDate(DateTime value) => setField<DateTime>('end_date', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
