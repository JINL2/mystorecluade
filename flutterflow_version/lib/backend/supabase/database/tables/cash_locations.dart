import '../database.dart';

class CashLocationsTable extends SupabaseTable<CashLocationsRow> {
  @override
  String get tableName => 'cash_locations';

  @override
  CashLocationsRow createRow(Map<String, dynamic> data) =>
      CashLocationsRow(data);
}

class CashLocationsRow extends SupabaseDataRow {
  CashLocationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CashLocationsTable();

  String get cashLocationId => getField<String>('cash_location_id')!;
  set cashLocationId(String value) =>
      setField<String>('cash_location_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String get locationName => getField<String>('location_name')!;
  set locationName(String value) => setField<String>('location_name', value);

  String get locationType => getField<String>('location_type')!;
  set locationType(String value) => setField<String>('location_type', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get locationInfo => getField<String>('location_info');
  set locationInfo(String? value) => setField<String>('location_info', value);

  String? get currencyCode => getField<String>('currency_code');
  set currencyCode(String? value) => setField<String>('currency_code', value);

  String? get bankAccount => getField<String>('bank_account');
  set bankAccount(String? value) => setField<String>('bank_account', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  String? get bankName => getField<String>('bank_name');
  set bankName(String? value) => setField<String>('bank_name', value);

  String? get icon => getField<String>('icon');
  set icon(String? value) => setField<String>('icon', value);
}
