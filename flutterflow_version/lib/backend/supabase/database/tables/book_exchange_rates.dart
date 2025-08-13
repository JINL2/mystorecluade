import '../database.dart';

class BookExchangeRatesTable extends SupabaseTable<BookExchangeRatesRow> {
  @override
  String get tableName => 'book_exchange_rates';

  @override
  BookExchangeRatesRow createRow(Map<String, dynamic> data) =>
      BookExchangeRatesRow(data);
}

class BookExchangeRatesRow extends SupabaseDataRow {
  BookExchangeRatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BookExchangeRatesTable();

  String get rateId => getField<String>('rate_id')!;
  set rateId(String value) => setField<String>('rate_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String get fromCurrencyId => getField<String>('from_currency_id')!;
  set fromCurrencyId(String value) =>
      setField<String>('from_currency_id', value);

  String get toCurrencyId => getField<String>('to_currency_id')!;
  set toCurrencyId(String value) => setField<String>('to_currency_id', value);

  double get rate => getField<double>('rate')!;
  set rate(double value) => setField<double>('rate', value);

  DateTime get rateDate => getField<DateTime>('rate_date')!;
  set rateDate(DateTime value) => setField<DateTime>('rate_date', value);

  String get createdBy => getField<String>('created_by')!;
  set createdBy(String value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
