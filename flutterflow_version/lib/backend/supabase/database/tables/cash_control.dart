import '../database.dart';

class CashControlTable extends SupabaseTable<CashControlRow> {
  @override
  String get tableName => 'cash_control';

  @override
  CashControlRow createRow(Map<String, dynamic> data) => CashControlRow(data);
}

class CashControlRow extends SupabaseDataRow {
  CashControlRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CashControlTable();

  String get controlId => getField<String>('control_id')!;
  set controlId(String value) => setField<String>('control_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String get locationId => getField<String>('location_id')!;
  set locationId(String value) => setField<String>('location_id', value);

  DateTime get recordDate => getField<DateTime>('record_date')!;
  set recordDate(DateTime value) => setField<DateTime>('record_date', value);

  double get actualAmount => getField<double>('actual_amount')!;
  set actualAmount(double value) => setField<double>('actual_amount', value);

  String get createdBy => getField<String>('created_by')!;
  set createdBy(String value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
