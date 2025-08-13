import '../database.dart';

class CompanyCurrencyTable extends SupabaseTable<CompanyCurrencyRow> {
  @override
  String get tableName => 'company_currency';

  @override
  CompanyCurrencyRow createRow(Map<String, dynamic> data) =>
      CompanyCurrencyRow(data);
}

class CompanyCurrencyRow extends SupabaseDataRow {
  CompanyCurrencyRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CompanyCurrencyTable();

  String get companyCurrencyId => getField<String>('company_currency_id')!;
  set companyCurrencyId(String value) =>
      setField<String>('company_currency_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String get currencyId => getField<String>('currency_id')!;
  set currencyId(String value) => setField<String>('currency_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
