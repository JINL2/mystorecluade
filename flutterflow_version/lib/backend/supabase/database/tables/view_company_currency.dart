import '../database.dart';

class ViewCompanyCurrencyTable extends SupabaseTable<ViewCompanyCurrencyRow> {
  @override
  String get tableName => 'view_company_currency';

  @override
  ViewCompanyCurrencyRow createRow(Map<String, dynamic> data) =>
      ViewCompanyCurrencyRow(data);
}

class ViewCompanyCurrencyRow extends SupabaseDataRow {
  ViewCompanyCurrencyRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewCompanyCurrencyTable();

  String? get companyCurrencyId => getField<String>('company_currency_id');
  set companyCurrencyId(String? value) =>
      setField<String>('company_currency_id', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);

  String? get currencyId => getField<String>('currency_id');
  set currencyId(String? value) => setField<String>('currency_id', value);

  String? get currencyName => getField<String>('currency_name');
  set currencyName(String? value) => setField<String>('currency_name', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
