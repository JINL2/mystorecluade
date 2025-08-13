import '../database.dart';

class CurrencyTypesTable extends SupabaseTable<CurrencyTypesRow> {
  @override
  String get tableName => 'currency_types';

  @override
  CurrencyTypesRow createRow(Map<String, dynamic> data) =>
      CurrencyTypesRow(data);
}

class CurrencyTypesRow extends SupabaseDataRow {
  CurrencyTypesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CurrencyTypesTable();

  String get currencyId => getField<String>('currency_id')!;
  set currencyId(String value) => setField<String>('currency_id', value);

  String get currencyCode => getField<String>('currency_code')!;
  set currencyCode(String value) => setField<String>('currency_code', value);

  String? get currencyName => getField<String>('currency_name');
  set currencyName(String? value) => setField<String>('currency_name', value);

  String? get symbol => getField<String>('symbol');
  set symbol(String? value) => setField<String>('symbol', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
