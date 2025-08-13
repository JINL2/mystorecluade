import '../database.dart';

class CurrencyDenominationsTable
    extends SupabaseTable<CurrencyDenominationsRow> {
  @override
  String get tableName => 'currency_denominations';

  @override
  CurrencyDenominationsRow createRow(Map<String, dynamic> data) =>
      CurrencyDenominationsRow(data);
}

class CurrencyDenominationsRow extends SupabaseDataRow {
  CurrencyDenominationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CurrencyDenominationsTable();

  String get denominationId => getField<String>('denomination_id')!;
  set denominationId(String value) =>
      setField<String>('denomination_id', value);

  String get currencyId => getField<String>('currency_id')!;
  set currencyId(String value) => setField<String>('currency_id', value);

  double get value => getField<double>('value')!;
  set value(double value) => setField<double>('value', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get companyId => getField<String>('company_id');
  set companyId(String? value) => setField<String>('company_id', value);
}
