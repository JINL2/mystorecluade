import '../database.dart';

class FiscalYearsTable extends SupabaseTable<FiscalYearsRow> {
  @override
  String get tableName => 'fiscal_years';

  @override
  FiscalYearsRow createRow(Map<String, dynamic> data) => FiscalYearsRow(data);
}

class FiscalYearsRow extends SupabaseDataRow {
  FiscalYearsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FiscalYearsTable();

  String get fiscalYearId => getField<String>('fiscal_year_id')!;
  set fiscalYearId(String value) => setField<String>('fiscal_year_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  int get year => getField<int>('year')!;
  set year(int value) => setField<int>('year', value);

  DateTime get startDate => getField<DateTime>('start_date')!;
  set startDate(DateTime value) => setField<DateTime>('start_date', value);

  DateTime get endDate => getField<DateTime>('end_date')!;
  set endDate(DateTime value) => setField<DateTime>('end_date', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
