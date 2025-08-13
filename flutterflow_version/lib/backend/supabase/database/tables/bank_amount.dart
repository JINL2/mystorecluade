import '../database.dart';

class BankAmountTable extends SupabaseTable<BankAmountRow> {
  @override
  String get tableName => 'bank_amount';

  @override
  BankAmountRow createRow(Map<String, dynamic> data) => BankAmountRow(data);
}

class BankAmountRow extends SupabaseDataRow {
  BankAmountRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BankAmountTable();

  String get bankAmountId => getField<String>('bank_amount_id')!;
  set bankAmountId(String value) => setField<String>('bank_amount_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String get storeId => getField<String>('store_id')!;
  set storeId(String value) => setField<String>('store_id', value);

  String get locationId => getField<String>('location_id')!;
  set locationId(String value) => setField<String>('location_id', value);

  String get currencyId => getField<String>('currency_id')!;
  set currencyId(String value) => setField<String>('currency_id', value);

  DateTime get recordDate => getField<DateTime>('record_date')!;
  set recordDate(DateTime value) => setField<DateTime>('record_date', value);

  double get totalAmount => getField<double>('total_amount')!;
  set totalAmount(double value) => setField<double>('total_amount', value);

  String get createdBy => getField<String>('created_by')!;
  set createdBy(String value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
